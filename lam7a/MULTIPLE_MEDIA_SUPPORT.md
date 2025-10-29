# Multiple Media Support Implementation

## Summary
Successfully updated the TweetModel, mock services, and UI widgets to support multiple images and videos per tweet, matching the exact logic of the main API service.

## Changes Made

### 1. TweetModel Updates
**File**: `lib/features/common/models/tweet_model.dart`

**New Fields**:
- `List<String> mediaImages` - Support for multiple images
- `List<String> mediaVideos` - Support for multiple videos
- Kept `String? mediaPic` and `String? mediaVideo` for backward compatibility

```dart
@freezed
abstract class TweetModel with _$TweetModel {
  const factory TweetModel({
    required String id,
    required String body,
    String? mediaPic, // Backward compatibility
    String? mediaVideo, // Backward compatibility
    @Default([]) List<String> mediaImages, // NEW: Multiple images
    @Default([]) List<String> mediaVideos, // NEW: Multiple videos
    required DateTime date,
    // ... other fields
  }) = _TweetModel;
}
```

### 2. Mock Services Updated

#### AddTweetApiServiceMock
**File**: `lib/features/add_tweet/services/add_tweet_api_service_mock.dart`

**Changes**:
- Now generates multiple mock image URLs (3 images)
- Now generates multiple mock video URLs (2 videos)
- Returns `TweetModel` with `mediaImages` and `mediaVideos` lists
- Logging matches main API service logic

**Example Output**:
```dart
mediaImages: [
  'https://picsum.photos/seed/timestamp-1/800/600',
  'https://picsum.photos/seed/timestamp-2/800/600',
  'https://picsum.photos/seed/timestamp-3/800/600',
]
mediaVideos: [
  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
  'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
]
```

#### TweetsApiServiceMock
**File**: `lib/features/tweet/services/tweet_api_service_mock.dart`

**Changes**:
- Mock tweets now have multiple images and videos
- Tweet 't1': 3 images, 0 videos
- Tweet 't2': 0 images, 2 videos
- Tweet 't3': 2 images, 1 video (mixed media)
- `addTweet()` method logging matches main service

### 3. Main API Services Updated

#### TweetsApiServiceImpl
**File**: `lib/features/tweet/services/tweet_api_service_impl.dart`

**Changes**:
- `getAllTweets()` now parses multiple media from `mediaUrls[]` array
- `getTweetById()` now parses multiple media from `mediaUrls[]` array
- Uses heuristic to detect image vs video (file extension check)
- Populates both `mediaImages` and `mediaVideos` lists
- Maintains backward compatibility with old single fields

**Detection Logic**:
```dart
// Check file extension to determine media type
if (url.endsWith('.mp4') || url.endsWith('.mov') || 
    url.endsWith('.avi') || url.endsWith('.webm') ||
    url.contains('video')) {
  videoUrls.add(url);
} else {
  imageUrls.add(url);
}
```

#### AddTweetApiServiceImpl
**File**: `lib/features/add_tweet/services/add_tweet_api_service_impl.dart`

**Changes**:
- Response parsing now handles multiple media URLs
- Creates `TweetModel` with `mediaImages` and `mediaVideos` lists
- Uses same detection logic as TweetsApiService

### 4. UI Widgets Updated

#### TweetDetailedBodyWidget
**File**: `lib/features/tweet/ui/widgets/tweet_detailed_body_widget.dart`

**Changes**:
- Now displays ALL images in `mediaImages` list (full resolution)
- Now displays ALL videos in `mediaVideos` list
- Each media item in its own Padding with proper spacing
- Maintains backward compatibility with old `mediaPic`/`mediaVideo` fields

**Features**:
- Scrollable column of images
- Scrollable column of videos
- Loading indicators for each image
- Error handling for each image
- Responsive sizing

#### TweetBodySummaryWidget
**File**: `lib/features/tweet/ui/widgets/tweet_body_summary_widget.dart`

**Changes**:
- Displays up to 2 images in summary view
- Displays up to 1 video in summary view (if no images)
- Uses `.take(n)` to limit displayed media in feed
- Maintains backward compatibility

**Summary Limits**:
```dart
post.mediaImages.take(2) // Show max 2 images
post.mediaVideos.take(1) // Show max 1 video
```

## Backend Compatibility

### Expected Backend Response
```json
{
  "status": "success",
  "message": "Post created successfully",
  "data": {
    "id": 123,
    "user_id": 1,
    "content": "Tweet content",
    "created_at": "2025-01-01T00:00:00.000Z",
    "mediaUrls": [
      "https://storage.url/image1.jpg",
      "https://storage.url/image2.jpg",
      "https://storage.url/video.mp4"
    ]
  }
}
```

### Media Type Detection
The frontend uses a simple heuristic to detect media types from URLs:

**Video Extensions**: `.mp4`, `.mov`, `.avi`, `.webm`, or contains `'video'`
**Image**: Everything else

**Note for Backend Team**: 
It would be better if the backend returns media with type information:
```json
"media": [
  { "url": "...", "type": "IMAGE" },
  { "url": "...", "type": "VIDEO" }
]
```

## Usage Examples

### Creating Tweet with Multiple Media (Mock)
```dart
final tweet = await addTweetApiService.createTweet(
  userId: '1',
  content: 'Check out these photos!',
  mediaPicPath: '/path/to/local/image.jpg',
  mediaVideoPath: null,
);

// Result:
// tweet.mediaImages = [url1, url2, url3]
// tweet.mediaVideos = []
```

### Displaying Multiple Media
```dart
// In UI - all images are displayed
for (final imageUrl in tweet.mediaImages) {
  Image.network(imageUrl);
}

// In UI - all videos are displayed
for (final videoUrl in tweet.mediaVideos) {
  VideoPlayerWidget(url: videoUrl);
}
```

## Backward Compatibility

All changes maintain backward compatibility:

1. **Old fields still exist**: `mediaPic`, `mediaVideo`
2. **Fallback logic**: If new lists are empty, old fields are checked
3. **Gradual migration**: Can use both old and new fields simultaneously

## Testing

### Mock Data Examples

**Tweet with Multiple Images**:
```dart
TweetModel(
  id: 't1',
  body: 'Multiple images demo',
  mediaImages: ['img1.jpg', 'img2.jpg', 'img3.jpg'],
  mediaVideos: [],
)
```

**Tweet with Multiple Videos**:
```dart
TweetModel(
  id: 't2',
  body: 'Multiple videos demo',
  mediaImages: [],
  mediaVideos: ['video1.mp4', 'video2.mp4'],
)
```

**Tweet with Mixed Media**:
```dart
TweetModel(
  id: 't3',
  body: 'Mixed media demo',
  mediaImages: ['img1.jpg', 'img2.jpg'],
  mediaVideos: ['video1.mp4'],
)
```

## Build Commands

After model changes, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Known Considerations

1. **Performance**: Displaying many images/videos can impact performance
   - Summary view limits to 2 images / 1 video
   - Detailed view shows all media with proper loading states

2. **Network**: Multiple media means more network requests
   - Images use loading indicators
   - Consider adding caching in the future

3. **Backend Integration**: 
   - Backend should return media in `mediaUrls[]` array
   - Frontend will auto-detect type based on file extension
   - Better: Backend should include type field for each media item

## Files Modified

1. `lib/features/common/models/tweet_model.dart`
2. `lib/features/add_tweet/services/add_tweet_api_service_mock.dart`
3. `lib/features/tweet/services/tweet_api_service_mock.dart`
4. `lib/features/tweet/services/tweet_api_service_impl.dart`
5. `lib/features/add_tweet/services/add_tweet_api_service_impl.dart`
6. `lib/features/tweet/ui/widgets/tweet_detailed_body_widget.dart`
7. `lib/features/tweet/ui/widgets/tweet_body_summary_widget.dart`

## Next Steps for Backend Team

To fully support multiple media, the backend should:

1. ✅ Return media in `mediaUrls[]` array (already working)
2. 🔄 Include type information for each media item:
   ```json
   "media": [
     { "url": "...", "type": "IMAGE" },
     { "url": "...", "type": "VIDEO" }
   ]
   ```
3. 🔄 Support multiple file uploads in the same request
4. 🔄 Add media count fields to Post model (optional)

The frontend is now ready to handle multiple media from the backend!
