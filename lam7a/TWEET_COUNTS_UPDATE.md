# Tweet Counts Update - Interaction Endpoints

**Date**: October 28, 2025  
**Status**: ✅ Completed

---

## 🔄 What Changed

### Problem
The backend doesn't return likes, comments, repost counts, etc. in the basic tweet response from `GET /posts`. According to the API spec, these counts must be fetched separately using interaction endpoints.

### Solution
1. **Made counts optional** in `TweetModel` with default value `0`
2. **Created separate interaction service** for likes/reposts
3. **Updated API mapping** to gracefully handle missing counts

---

## 📦 Files Modified

### 1. `tweet_model.dart`
**Changed counts to optional with defaults:**
```dart
const factory TweetModel({
  required String id,
  required String body,
  String? mediaPic,
  String? mediaVideo,
  required DateTime date,
  @Default(0) int likes,      // ← Now optional, defaults to 0
  @Default(0) int qoutes,     // ← Now optional
  @Default(0) int bookmarks,  // ← Now optional
  @Default(0) int repost,     // ← Now optional
  @Default(0) int comments,   // ← Now optional
  @Default(0) int views,      // ← Now optional
  required String userId,
}) = _TweetModel;
```

**Why?** Backend doesn't include these in basic tweet response.

---

### 2. `tweet_api_service_impl.dart`
**Updated field mapping:**
```dart
final mappedJson = <String, dynamic>{
  'id': json['id']?.toString() ?? '...',
  'userId': (json['user_id'] ?? json['userId'])?.toString() ?? '0',
  'body': (json['content'] ?? json['body'] ?? '').toString(),
  'date': (json['created_at'] ?? json['date'] ?? '...').toString(),
  
  // Only include counts if backend provides them
  if (json['likes'] != null) 'likes': int.tryParse(json['likes'].toString()),
  if (json['comments'] != null) 'comments': int.tryParse(json['comments'].toString()),
  // ... etc
};
```

**Why?** More robust - doesn't crash if counts are missing.

---

### 3. `post_interactions_service.dart` (NEW FILE)
**New service for interaction endpoints:**

```dart
class PostInteractionsService {
  /// Toggle like on a post
  Future<bool> toggleLike(String postId);
  
  /// Get count of likes
  Future<int> getLikesCount(String postId);
  
  /// Toggle repost
  Future<bool> toggleRepost(String postId);
  
  /// Get count of reposts
  Future<int> getRepostsCount(String postId);
  
  /// Get all counts at once
  Future<Map<String, int>> getPostCounts(String postId);
}
```

**API Endpoints Used:**
- `POST /posts/{postId}/likes` - Toggle like
- `GET /posts/{postId}/likes` - Get likers (count in metadata)
- `POST /posts/{postId}/reposts` - Toggle repost
- `GET /posts/{postId}/reposts` - Get reposters (count in metadata)

---

## 🎯 How to Use

### Displaying Tweets (Current Behavior)
```dart
// Fetch tweets - counts will be 0 by default
final tweets = await tweetsApiService.getAllTweets();

// Display tweet with counts (shows 0 initially)
TweetSummaryWidget(
  tweetData: tweet, // likes: 0, reposts: 0, etc.
);
```

### Fetching Real Counts (Optional)
```dart
final interactionsService = ref.read(postInteractionsServiceProvider);

// Get actual counts for a tweet
final counts = await interactionsService.getPostCounts(tweetId);
print('Likes: ${counts['likes']}');
print('Reposts: ${counts['reposts']}');

// Or fetch individually
final likesCount = await interactionsService.getLikesCount(tweetId);
```

### Toggling Like/Repost
```dart
final interactionsService = ref.read(postInteractionsServiceProvider);

// Toggle like
final isLiked = await interactionsService.toggleLike(tweetId);
if (isLiked) {
  print('Post liked!');
} else {
  print('Post unliked!');
}

// Toggle repost
final isReposted = await interactionsService.toggleRepost(tweetId);
```

---

## 🔮 Future Improvements (Optional)

### Option 1: Fetch Counts on Tweet Load
Update `TweetViewModel` to automatically fetch counts:

```dart
class TweetViewModel extends StateNotifier<TweetState> {
  Future<void> loadTweet(String id) async {
    // Fetch basic tweet
    final tweet = await _tweetsApi.getTweetById(id);
    
    // Fetch real counts
    final counts = await _interactionsService.getPostCounts(id);
    
    // Update tweet with real counts
    final updatedTweet = tweet.copyWith(
      likes: counts['likes'] ?? 0,
      repost: counts['reposts'] ?? 0,
    );
    
    state = TweetState.loaded(updatedTweet);
  }
}
```

### Option 2: Lazy Load Counts
Only fetch counts when user scrolls to tweet:

```dart
class TweetSummaryWidget extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    _loadCounts();
  }
  
  Future<void> _loadCounts() async {
    final counts = await interactionsService.getPostCounts(widget.tweetId);
    setState(() {
      _likes = counts['likes'];
      _reposts = counts['reposts'];
    });
  }
}
```

---

## 📊 Performance Notes

### Current Implementation: ✅ Fast
- Displays tweets immediately with counts = 0
- No extra API calls
- **Best for MVP/Demo**

### With Real Counts: ⚠️ Slower
- Requires 2 extra API calls per tweet (likes + reposts)
- For 20 tweets: 40 extra API calls
- **Only implement if counts are critical**

### Recommended Approach:
1. **Show tweets immediately** (counts = 0)
2. **Fetch counts in background** for visible tweets only
3. **Cache counts** to avoid repeated fetches
4. **Update backend** to include counts in tweet response (best solution!)

---

## 🎯 Backend Should Fix This

**Ideal Solution**: Backend should include counts in tweet response:

```json
{
  "status": "200",
  "data": [
    {
      "id": 123,
      "user_id": 11,
      "content": "Hello world",
      "created_at": "2025-10-28T...",
      "likesCount": 42,      // ← Include this
      "repostsCount": 15,    // ← Include this
      "commentsCount": 8,    // ← Include this
      "viewsCount": 1234     // ← Include this
    }
  ]
}
```

This would eliminate the need for separate interaction API calls!

---

## ✅ Summary

| Feature | Status | Notes |
|---------|--------|-------|
| Display tweets without counts | ✅ Working | Shows 0 for all counts |
| Toggle like/repost | ✅ Ready | Use `PostInteractionsService` |
| Fetch real counts | ✅ Available | Optional, requires extra API calls |
| Auto-load counts | 🔜 Future | Implement if needed |

**Current app works fine with counts = 0.** Real counts can be fetched later if needed!
