# Tweet Views Logic vs Likes & Reposts

This document explains how **views** are handled in the Flutter app, how that differs from **likes** and **reposts**, and the exact logic used to increment and persist view counts.

> **Important:** The current backend does **not** expose a dedicated "views" endpoint or an `isViewedByMe` flag. View handling on the client is therefore partly local and only loosely synced with the backend.

---

## 1. How Likes Work

**Core pieces:**
- `TweetViewModel.handleLike`
- `PostInteractionsService.toggleLike`
- `PostInteractionsService.getLikesCount`
- `TweetsApiServiceImpl.updateInteractionFlag`

**Flow:**

1. User taps the like button.
2. `TweetViewModel.handleLike`:
   - Reads current state (tweet + `isLiked`).
   - Optimistically toggles `isLiked` and increments/decrements `likes` locally for instant UI feedback.
3. Backend sync:
   - Calls `postInteractionsService.toggleLike(tweetId)`, which hits `POST /posts/{postId}/like`.
   - Reads the backend message to decide the real `isLiked` value.
   - Calls `postInteractionsService.getLikesCount(tweetId)` to re-fetch the current likes count (length of likers list).
   - Calls `tweetsApiService.updateInteractionFlag(tweetId, 'isLikedByMe', backendIsLiked)` to persist the flag.
   - Updates local state using the backend data: `isLiked = backendIsLiked`, `likes = actualCount`.
4. On refresh / new session:
   - When the tweet is rebuilt via `TweetViewModel.build`, it reads `isLikedByMe` from the interaction flags map and uses that to populate `TweetState.isLiked`.

This means **likes are fully driven by the backend**, with short-term optimistic UI.

---

## 2. How Reposts Work

**Core pieces:**
- `TweetViewModel.handleRepost`
- `PostInteractionsService.toggleRepost`
- `PostInteractionsService.getRepostsCount`
- `TweetsApiServiceImpl.updateInteractionFlag`

**Flow:**

1. User taps the repost button for a simple repost (not a quote).
2. `TweetViewModel.handleRepost`:
   - Reads current state (tweet + `isReposted`).
   - Optimistically toggles `isReposted` and increments/decrements `repost` locally.
3. Backend sync:
   - Calls `postInteractionsService.toggleRepost(tweetId)`, which hits `POST /posts/{postId}/repost`.
   - Uses the backend message to determine `backendIsReposted`.
   - Calls `postInteractionsService.getRepostsCount(tweetId)` to get the real repost count (length of reposters list).
   - Calls `tweetsApiService.updateInteractionFlag(tweetId, 'isRepostedByMe', backendIsReposted)` to persist.
   - Updates local state with backend values.
4. On refresh / new session:
   - `TweetViewModel.build` reads `isRepostedByMe` from interaction flags and sets `TweetState.isReposted` accordingly.

Again, **reposts are backend-sourced**, with optimistic update for responsiveness.

> Note: Quote tweets are modeled as separate posts of type `QUOTE` in the backend, not as "reposts". They currently increase the backend reply/children count, not the repost count.

---

## 3. How Views Are Mapped From Backend

**Core pieces:**
- `TweetsApiServiceImpl.getAllTweets` / `getTweetById`
- `TweetModel.views`

The backend may send a `views` or `viewsCount` field in some responses. In `TweetsApiServiceImpl`, we normalize this into the `views` field on `TweetModel`:

```dart
views = parseInt(json['views'] ?? json['viewsCount'] ?? views);
```

So the **baseline** views value always comes from the server when a tweet is fetched.

However, the backend **does not**:
- Expose an `isViewedByMe` flag.
- Provide a dedicated `POST /posts/{id}/view` endpoint.
- Explicitly increment views per user.

Because of this, the client implements additional logic to:
- Increment views **once per user per tweet** when opening the detailed view.
- Avoid showing views going **down** after refresh or restart.

---

## 4. Local View Overrides & Interaction Flags

**Core pieces:**
- `TweetsApiService.getLocalViews(String tweetId)` / `setLocalViews(String tweetId, int views)`
- `TweetsApiServiceImpl._localViews` + SharedPreferences persistence
- `TweetsApiServiceImpl.getInteractionFlags` / `updateInteractionFlag`
- `TweetViewModel.build`
- `TweetViewModel.handleViews`

### 4.1 Persistent local view overrides

In `TweetsApiServiceImpl`:

- `_localViews: Map<String, int>` stores **per-tweet maximum view counts** observed locally.
- Stored in SharedPreferences under key `'tweet_views_overrides'`.
- Loaded and saved alongside `_interactionFlags`.

This gives us a **local floor** for the views count so it never decreases even if the backend is stale.

### 4.2 Applying overrides when building state

In `TweetViewModel.build`:

1. Fetch tweet via repository (which uses `TweetsApiServiceImpl`).
2. Read interaction flags and local view override:

   ```dart
   final apiService = ref.read(tweetsApiServiceProvider);
   final interactionFlags = await apiService.getInteractionFlags(tweetId);
   final localViewsOverride = apiService.getLocalViews(tweetId);

   final bool isLiked = interactionFlags?['isLikedByMe'] ?? false;
   final bool isReposted = interactionFlags?['isRepostedByMe'] ?? false;
   final bool isViewed = interactionFlags?['isViewedByMe'] ?? false;
   ```

3. Compute the **effective** tweet used by the UI:

   ```dart
   final effectiveTweet = (localViewsOverride != null && localViewsOverride > tweet.views)
       ? tweet.copyWith(views: localViewsOverride)
       : tweet;
   ```

4. Store `effectiveTweet` in `TweetState`.

**Result:**
- On any refresh or rebuild, the app shows:

  ```text
  views_displayed = max(backend_views, localViewsOverride)
  ```

- This prevents the views count from **ever going down** for that user, while still allowing the backend to take over if it reports a higher number later.

---

## 5. Increment Logic for Views (Detailed Screen)

**Core pieces:**
- `TweetViewModel.handleViews`
- `TweetSummaryWidget.onTap` (home feed → detailed view)

### 5.1 When is `handleViews` called?

In the home feed, when the user taps a tweet to open the detailed screen, we call:

```dart
ref.read(tweetViewModelProvider(tweetId).notifier).handleViews();
```

This runs **before** navigating to the detailed `TweetScreen`.

### 5.2 Single increment per user per tweet

`handleViews` is designed to increment views only once per user:

1. Ensure state and tweet are loaded.
2. If `state.isViewed` is already `true`, **do nothing**:

   ```dart
   if (currentState.isViewed) {
     print('ℹ️ Views already recorded for this tweet, skipping increment');
     return;
   }
   ```

3. Otherwise:
   - Read `currentViews = currentTweet.views`.
   - Compute `updatedViews = currentViews + 1`.
   - Create `updatedTweet = currentTweet.copyWith(views: updatedViews)`.

4. Optimistically update local state:

   ```dart
   state = AsyncData(
     currentState.copyWith(
       isViewed: true,
       tweet: AsyncData(updatedTweet),
     ),
   );
   ```

5. Try to persist to backend:

   ```dart
   final repo = ref.read(tweetRepositoryProvider);
   await repo.updateTweet(updatedTweet);
   ```

   - This uses `TweetsApiServiceImpl.updateTweet` (PUT `/posts/{id}`), which **may or may not** be respected by the backend for the `views` field.
   - If it fails or the backend ignores `views`, the client keeps the optimistic value anyway.

6. Persist client-side flags and local override:

   ```dart
   final apiService = ref.read(tweetsApiServiceProvider);
   apiService.updateInteractionFlag(currentTweet.id, 'isViewedByMe', true);
   apiService.setLocalViews(currentTweet.id, updatedViews);
   ```

   - `isViewedByMe = true` ensures **future calls** to `handleViews` for this tweet do nothing (no double-counting per user/device).
   - `setLocalViews` stores the `updatedViews` in `_localViews` and SharedPreferences, ensuring:
     - On app restart or refresh, `build` will never display a value lower than this override.

### 5.3 Comparison to likes/reposts

- **Likes & Reposts:**
  - Optimistic local toggle.
  - Dedicated backend endpoints (`/like`, `/repost`).
  - We re-fetch counts from backend to ensure full sync.
  - Interaction flags (`isLikedByMe`, `isRepostedByMe`) are preserved across sessions.

- **Views:**
  - Optimistic single increment when opening detailed tweet.
  - No dedicated backend endpoint; we try `updateTweet` but rely mainly on local state.
  - We persist:
    - `isViewedByMe` (interaction flag) to prevent multiple increments per user/device.
    - A **local max views override** so the displayed number never decreases.

In other words, views follow the **same pattern** structurally (optimistic update + backend sync + stored flags), but because the backend does not have first-class views support, the client relies more heavily on local persistence.

---

## 6. Summary

- Views start from the backend `views/viewsCount` field.
- When the user opens a tweet detail **for the first time**:
  - `handleViews()` increments views by 1 locally.
  - Marks `isViewedByMe = true`.
  - Saves `localViewsOverride = updatedViews`.
  - Attempts to push the updated tweet to the backend.
- On subsequent opens by the same user:
  - `handleViews()` sees `isViewed == true` and does **nothing**.
- On refresh or app restart:
  - `TweetViewModel.build` re-fetches the tweet.
  - Uses `max(backendViews, localViewsOverride)` so views never go down.

This provides an X-style UX:
- **Single increment per user** when opening a detailed tweet.
- **No decrements** in view count on refresh.
- **Future compatibility** if the backend later starts honoring the `views` field or exposes a dedicated endpoint.
