# API Service Switching Guide

## How to Switch Between Mock and Real API Services

The application supports both mock (local testing) and real (backend) API services.

## Current Service Providers

### Tweet Services

**File**: `lib/features/tweet/services/tweet_api_service.dart`

```dart
// Mock Service (for local testing)
final tweetsApiServiceProvider = Provider<TweetsApiService>((ref) {
  return TweetsApiServiceMock();
});

// Real Service (for backend integration)
final tweetsApiServiceProvider = FutureProvider<TweetsApiService>((ref) async {
  return await TweetsApiServiceImpl.createAuthenticated();
});
```

### Add Tweet Services

**File**: `lib/features/add_tweet/services/add_tweet_api_service.dart`

```dart
// Mock Service (for local testing)
final addTweetApiServiceProvider = Provider<AddTweetApiService>((ref) {
  return AddTweetApiServiceMock();
});

// Real Service (for backend integration)
final addTweetApiServiceProvider = FutureProvider<AddTweetApiService>((ref) async {
  final dio = await ref.watch(authenticatedDioProvider.future);
  return AddTweetApiServiceImpl(dio: dio);
});
```

## Step-by-Step: Switching to Mock Services

### 1. Find the Provider File

Navigate to the service provider file you want to switch:
- Tweets: `lib/features/tweet/services/tweet_api_service.dart`
- Add Tweet: `lib/features/add_tweet/services/add_tweet_api_service.dart`

### 2. Comment Out Real Service, Uncomment Mock

**For Tweets Service**:

```dart
// OPTION 1: Mock Service (Local Testing - NO backend needed)
final tweetsApiServiceProvider = Provider<TweetsApiService>((ref) {
  return TweetsApiServiceMock();
});

// OPTION 2: Real Service (Backend Integration - requires backend)
// final tweetsApiServiceProvider = FutureProvider<TweetsApiService>((ref) async {
//   return await TweetsApiServiceImpl.createAuthenticated();
// });
```

**For Add Tweet Service**:

```dart
// OPTION 1: Mock Service (Local Testing - NO backend needed)
final addTweetApiServiceProvider = Provider<AddTweetApiService>((ref) {
  return AddTweetApiServiceMock();
});

// OPTION 2: Real Service (Backend Integration - requires backend)
// final addTweetApiServiceProvider = FutureProvider<AddTweetApiService>((ref) async {
//   final dio = await ref.watch(authenticatedDioProvider.future);
//   return AddTweetApiServiceImpl(dio: dio);
// });
```

### 3. Update Provider Type in Consumers

When switching between `Provider` and `FutureProvider`, you may need to update consumers.

**Mock (Provider) Usage**:
```dart
final apiService = ref.read(tweetsApiServiceProvider);
```

**Real (FutureProvider) Usage**:
```dart
final apiService = await ref.read(tweetsApiServiceProvider.future);
// or
ref.watch(tweetsApiServiceProvider).when(
  data: (service) => ...,
  loading: () => CircularProgressIndicator(),
  error: (e, s) => Text('Error: $e'),
)
```

### 4. Hot Restart

After switching, do a full app restart (not hot reload):
```bash
# Stop the app
# Then restart
flutter run
```

## Quick Switch Checklist

- [ ] Decide: Mock or Real service?
- [ ] Open the appropriate provider file
- [ ] Comment/uncomment the desired provider
- [ ] Ensure imports are correct
- [ ] Hot restart the app
- [ ] Test functionality

## When to Use Each

### Use Mock Service When:
- ✅ Backend is not available
- ✅ Working on UI/UX without backend dependency
- ✅ Testing edge cases with controlled data
- ✅ Offline development
- ✅ Demo purposes

### Use Real Service When:
- ✅ Backend is ready and running
- ✅ Integration testing
- ✅ Testing actual API responses
- ✅ Production builds
- ✅ End-to-end testing

## Mock Service Features

### TweetsApiServiceMock
- ✅ In-memory tweet storage
- ✅ Simulated network delay (300ms)
- ✅ Pre-populated with 3 sample tweets
- ✅ Supports multiple images and videos
- ✅ Add, update, delete operations
- ✅ No authentication required

**Sample Data**:
- Tweet 't1': 3 images, Riverpod content
- Tweet 't2': 2 videos, Flutter content
- Tweet 't3': 2 images + 1 video, mixed media

### AddTweetApiServiceMock
- ✅ Generates mock media URLs
- ✅ Simulated network delay (800ms)
- ✅ Returns multiple media URLs (3 images, 2 videos)
- ✅ Realistic URL generation
- ✅ No file upload needed
- ✅ No authentication required

## Real Service Features

### TweetsApiServiceImpl
- ✅ Connects to backend API
- ✅ JWT authentication via cookies
- ✅ Parses multiple media from backend
- ✅ Auto-detects image vs video type
- ✅ Full CRUD operations
- ✅ Error handling with backend responses

### AddTweetApiServiceImpl
- ✅ Uploads real files to backend
- ✅ Multipart form-data support
- ✅ JWT authentication via cookies
- ✅ Handles multiple media files
- ✅ Returns actual backend URLs
- ✅ Proper error handling

## Configuration

### Backend URL
**File**: `lib/core/api/api_config.dart`

```dart
class ApiConfig {
  static const String baseUrl = 'https://hankers-backend.myaddr.tools/api/v1.0';
  static const bool isDevelopment = true;
  
  static String get currentBaseUrl => isDevelopment ? baseUrl : productionUrl;
}
```

To switch between development and production backend:
```dart
static const bool isDevelopment = true;  // Use baseUrl
static const bool isDevelopment = false; // Use productionUrl
```

## Debugging Tips

### Check Which Service is Active

Add a print statement in your widget:
```dart
@override
Widget build(BuildContext context) {
  final service = ref.read(tweetsApiServiceProvider);
  print('Using service: ${service.runtimeType}');
  // Output: "Using service: TweetsApiServiceMock" or "Using service: TweetsApiServiceImpl"
  ...
}
```

### Mock Service Logs

Mock services print detailed logs:
```
📤 [MOCK] Creating tweet...
   User ID: 1
   Content: Hello World
   Image Path: /path/to/image.jpg
   📷 Generated 3 mock image URLs
      - Image 0: https://picsum.photos/...
      - Image 1: https://picsum.photos/...
      - Image 2: https://picsum.photos/...
✅ [MOCK] Tweet created successfully!
```

### Real Service Logs

Real services print API communication:
```
📤 Creating tweet on backend...
   User ID: 1
   Content: Hello World
   🌐 Sending request to backend:
      URL: https://hankers-backend.myaddr.tools/api/v1.0/posts
✅ Tweet created successfully on backend!
   📷 MediaUrls in response: 2 items
```

## Common Issues

### Issue: Provider type mismatch
**Error**: `type 'Provider<Service>' is not a subtype of type 'FutureProvider<Service>'`

**Solution**: Make sure you're using the correct provider type in your widget.

### Issue: Network error with real service
**Error**: `DioException: Connection refused`

**Solution**: 
1. Check if backend is running
2. Verify `ApiConfig.baseUrl` is correct
3. Check authentication cookies
4. Switch to mock service for offline work

### Issue: Mock data not updating
**Problem**: Changes to mock data don't reflect in UI

**Solution**: 
1. Hot restart the app (not hot reload)
2. Check if you're reading from the correct provider
3. Verify state management is set up correctly

## Best Practice

**Development Workflow**:
1. Start with Mock service
2. Build and test UI
3. Switch to Real service when backend is ready
4. Test integration
5. Keep Mock service for offline work

**Version Control**:
- Commit with Mock service enabled by default
- Document how to switch to Real service
- Use environment variables for automatic switching (advanced)

## Files to Check

When switching services, these files are involved:

1. **Provider Files**:
   - `lib/features/tweet/services/tweet_api_service.dart`
   - `lib/features/add_tweet/services/add_tweet_api_service.dart`

2. **Implementation Files**:
   - `lib/features/tweet/services/tweet_api_service_mock.dart`
   - `lib/features/tweet/services/tweet_api_service_impl.dart`
   - `lib/features/add_tweet/services/add_tweet_api_service_mock.dart`
   - `lib/features/add_tweet/services/add_tweet_api_service_impl.dart`

3. **Configuration**:
   - `lib/core/api/api_config.dart`
   - `lib/core/api/authenticated_dio_provider.dart`
