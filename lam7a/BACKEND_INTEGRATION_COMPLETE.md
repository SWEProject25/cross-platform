# Backend Integration Complete - Tweet Features

## Summary
Successfully connected the Add Tweet and Tweet features to the backend API endpoints.

## Backend API Structure
- **Base URL**: `https://hankers-backend.myaddr.tools/api/v1.0`
- **API Prefix**: `api/v1.0` (from `process.env.APP_VERSION`)
- **Controller**: `PostController` at `/posts`

## Endpoints Connected

### Post/Tweet Operations
1. **Create Post**
   - Endpoint: `POST /posts`
   - Body: FormData (multipart/form-data)
   - Fields: `content`, `type`, `visibility`
   - Media: `media[]` (binary files)
   - Response: `{ status, message, data: { id, user_id, content, created_at, mediaUrls[] } }`

2. **Get All Posts**
   - Endpoint: `GET /posts`
   - Query params: `userId`, `hashtag`, `type`, `page`, `limit`
   - Response: `{ status, message, data: [...posts] }`

3. **Delete Post**
   - Endpoint: `DELETE /posts/:postId`
   - Response: `{ status, message }`

### Interaction Operations
4. **Toggle Like**
   - Endpoint: `POST /posts/:postId/like`
   - Response: `{ status, message, data: { liked: boolean, likesCount: number } }`

5. **Get Likers**
   - Endpoint: `GET /posts/:postId/likers`
   - Query params: `page`, `limit`
   - Response: `{ status, message, data: [users] }`

6. **Toggle Repost**
   - Endpoint: `POST /posts/:postId/repost`
   - Response: `{ status, message, data: { reposted: boolean } }`

7. **Get Reposters**
   - Endpoint: `GET /posts/:postId/reposters`
   - Query params: `page`, `limit`
   - Response: `{ status, message, data: [users] }`

## Files Updated

### 1. AddTweetApiServiceImpl
**File**: `lib/features/add_tweet/services/add_tweet_api_service_impl.dart`

**Changes**:
- Simplified request handling to always use FormData for consistency
- Removed unused `hasMedia` variable
- Fields sent: `userId` (int), `content`, `type: 'POST'`, `visibility: 'EVERY_ONE'`
- Media files sent as `media` field (multipart)
- Correctly parses `mediaUrls[]` from backend response

### 2. TweetsApiServiceImpl
**File**: `lib/features/tweet/services/tweet_api_service_impl.dart`

**Status**: Already correctly implemented
- Uses authenticated Dio
- Correctly maps backend response fields: `id`, `user_id`, `content`, `created_at`, `mediaUrls[]`
- Handles media URLs properly

### 3. PostInteractionsService
**File**: `lib/features/tweet/services/post_interactions_service.dart`

**Changes**:
- Fixed endpoint paths:
  - `POST /posts/:postId/like` (was `/likes`)
  - `POST /posts/:postId/repost` (was `/reposts`)
  - `GET /posts/:postId/likers` (was `/likes`)
  - `GET /posts/:postId/reposters` (was `/reposts`)
- Updated count methods to use array length (backend doesn't return total count metadata)
- Increased limit to 100 for better count approximation

## Backend Response Format

### Create Post Response
```json
{
  "status": "success",
  "message": "Post created successfully",
  "data": {
    "id": 123,
    "user_id": 1,
    "content": "Tweet content",
    "type": "POST",
    "visibility": "EVERY_ONE",
    "created_at": "2025-01-01T00:00:00.000Z",
    "is_deleted": false,
    "mediaUrls": [
      "https://storage.url/image.jpg",
      "https://storage.url/video.mp4"
    ],
    "hashtags": [...]
  }
}
```

### Get Posts Response
```json
{
  "status": "success",
  "message": "Posts retrieved successfully",
  "data": [
    {
      "id": 123,
      "user_id": 1,
      "content": "Tweet content",
      "created_at": "2025-01-01T00:00:00.000Z",
      ...
    }
  ]
}
```

### Toggle Like Response
```json
{
  "status": "success",
  "message": "Post liked successfully", // or "Post unliked successfully"
  "data": {
    "liked": true,
    "likesCount": 5
  }
}
```

## Field Mapping

| Backend Field | Frontend Field | Type |
|--------------|----------------|------|
| `id` | `id` | String |
| `user_id` | `userId` | String |
| `content` | `body` | String |
| `created_at` | `date` | DateTime |
| `mediaUrls[0]` | `mediaPic` | String? |
| `mediaUrls[1]` | `mediaVideo` | String? |

## Authentication
All endpoints use JWT authentication via cookies:
- Cookie name: `access_token`
- Handled by: `AuthenticatedDioProvider`
- Interceptor: Automatically adds cookies to requests

## Testing Notes
1. Backend is running at `https://hankers-backend.myaddr.tools`
2. CORS is configured for the frontend domain
3. Media files are uploaded to cloud storage (S3/similar)
4. All endpoints require authentication except public viewing

## Known Limitations
1. Counts (likes/reposts) are approximated from array length (max 100)
   - Backend doesn't expose total count metadata
   - Consider adding pagination or count aggregation in backend
2. Media upload size limits depend on backend configuration
3. No real-time updates - requires polling or WebSocket integration

## Next Steps (Optional Improvements)
1. Add pagination for large feed lists
2. Implement caching for frequently accessed posts
3. Add optimistic UI updates for likes/reposts
4. Implement real-time notifications for interactions
5. Add retry logic for failed requests
6. Implement offline support with local storage
