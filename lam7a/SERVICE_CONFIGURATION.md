# Current Service Configuration

## Status: MIXED MODE (Mock + Real Backend)

### Tweet Services - USING MOCK ✓
**File**: `lib/features/tweet/services/tweet_api_service.dart`

```dart
@riverpod
TweetsApiService tweetsApiService(Ref ref) {
  // SWITCHED TO MOCK: Using mock service for local testing (no backend needed)
  return TweetsApiServiceMock();
}
```

**What this means**:
- ✅ Fetching tweets uses mock data (no backend required)
- ✅ Get tweet by ID uses mock data
- ✅ Tweet interactions work offline
- ✅ 3 pre-populated sample tweets available
- ✅ All tweets have multiple images/videos

**Repository**: `lib/features/tweet/repository/tweet_repository.dart`
```dart
@riverpod
TweetRepository tweetRepository(Ref ref) {
  // Using mock API service (switched from real backend)
  final apiService = ref.read(tweetsApiServiceProvider);
  return TweetRepository(apiService);
}
```

---

### Add Tweet Services - USING REAL BACKEND ✓
**File**: `lib/features/add_tweet/services/add_tweet_api_service_impl.dart`

```dart
final addTweetApiServiceProvider = FutureProvider<AddTweetApiService>((ref) async {
  final dio = await ref.watch(authenticatedDioProvider.future);
  return AddTweetApiServiceImpl(dio: dio);
});
```

**What this means**:
- ✅ Creating tweets connects to real backend
- ✅ Media files are uploaded to backend storage
- ✅ Requires authentication (JWT cookies)
- ✅ Returns actual backend URLs
- ⚠️ Requires backend to be running at: `https://hankers-backend.myaddr.tools/api/v1.0`

---

## How It Works Now

### Viewing Tweets
```
User opens app → Fetch tweets → TweetsApiServiceMock
                                      ↓
                                Mock data returned
                                (3 sample tweets with multiple media)
```

### Creating New Tweet
```
User creates tweet → Upload → AddTweetApiServiceImpl
                                      ↓
                              Real backend API
                                      ↓
                              Backend stores files
                                      ↓
                              Returns media URLs
```

### Result
- New tweets created through backend won't show up in feed (because feed uses mock)
- To see created tweets, you need to switch tweets service to real backend too
- Or refresh the mock data after creating

---

## Why This Configuration?

This mixed mode setup is useful when:
1. ✅ Backend team is still working on GET endpoints
2. ✅ POST endpoints are ready and tested
3. ✅ You want to test tweet creation without affecting feed
4. ✅ Frontend team can work on UI with consistent mock data

---

## To Switch Back to Full Real Backend

### Option 1: Switch Tweets Service Only

**File**: `lib/features/tweet/services/tweet_api_service.dart`

```dart
@riverpod
Future<TweetsApiService> tweetsApiService(Ref ref) async {
  // SWITCHED TO REAL: Using real backend
  final dio = await ref.watch(authenticatedDioProvider.future);
  return TweetsApiServiceImpl(dio: dio);
  
  // MOCK (commented out)
  // return TweetsApiServiceMock();
}
```

**Then update repository**:

`lib/features/tweet/repository/tweet_repository.dart`
```dart
@riverpod
Future<TweetRepository> tweetRepository(Ref ref) async {
  // Using real API service
  final apiService = await ref.read(tweetsApiServiceProvider.future);
  return TweetRepository(apiService);
}
```

**Then regenerate**:
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## To Switch to Full Mock (Development Mode)

### Switch Add Tweet to Mock

**File**: `lib/features/add_tweet/services/add_tweet_api_service_impl.dart`

Comment out the real provider and add mock:
```dart
// MOCK Provider
final addTweetApiServiceProvider = Provider<AddTweetApiService>((ref) {
  return AddTweetApiServiceMock();
});

// REAL Provider (commented out)
// final addTweetApiServiceProvider = FutureProvider<AddTweetApiService>((ref) async {
//   final dio = await ref.watch(authenticatedDioProvider.future);
//   return AddTweetApiServiceImpl(dio: dio);
// });
```

---

## Current Mock Data

### Tweet 't1' (Multiple Images)
- Body: "This is a mocked tweet about Riverpod with multiple images!"
- 3 images from different sources
- 0 videos
- 23 likes, 4 reposts

### Tweet 't2' (Multiple Videos)
- Body: "Mock tweet #2 — Flutter is amazing with videos!"
- 0 images
- 2 videos (bee.mp4, butterfly.mp4)
- 54 likes, 2 reposts

### Tweet 't3' (Mixed Media)
- Body: Long text about happiness
- 2 images
- 1 video
- 999 likes, 54 reposts

---

## Backend Requirements (for Real Services)

### For Tweets Service
- GET `/posts` - Fetch all posts
- GET `/posts/:id` - Fetch single post
- Must return `mediaUrls[]` array in response
- Must be running at configured URL

### For Add Tweet Service
- POST `/posts` - Create new post
- Accept multipart/form-data
- Fields: `userId`, `content`, `type`, `visibility`
- Media: `media[]` files
- Returns created post with `mediaUrls[]`

---

## Troubleshooting

### Issue: Can't see newly created tweets
**Cause**: Tweets service using mock, add tweet using real backend

**Solution**: Either:
1. Switch tweets service to real backend
2. Or work in full mock mode
3. Or manually add created tweet to mock data

### Issue: Provider type mismatch errors
**Cause**: Didn't regenerate after changing between Future/non-Future

**Solution**: 
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Issue: Authentication errors on add tweet
**Cause**: Real backend requires JWT authentication

**Solution**:
1. Make sure you're logged in
2. Check cookies are being sent
3. Verify backend URL is correct
4. Or switch to mock for offline work

---

## Quick Commands

**Regenerate providers**:
```bash
dart run build_runner build --delete-conflicting-outputs
```

**Check service type**:
```dart
final service = ref.read(tweetsApiServiceProvider);
print('Service: ${service.runtimeType}');
// Output: TweetsApiServiceMock or TweetsApiServiceImpl
```

**Hot restart** (required after switching):
```bash
# Stop app, then
flutter run
```

---

## Summary

| Feature | Current Service | Backend Required? |
|---------|----------------|-------------------|
| View Tweets | Mock | ❌ No |
| Get Tweet Details | Mock | ❌ No |
| Create Tweet | Real | ✅ Yes |
| Like/Repost | Mock | ❌ No |

**Configuration Date**: 2025-10-29
**Modified By**: Cascade AI Assistant
**Reason**: Backend team finishing implementation - using mock for stable testing
