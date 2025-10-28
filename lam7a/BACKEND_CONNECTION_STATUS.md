# Backend Connection Status

## ✅ What's Been Configured

### App is NOW using REAL backend services:

1. **Backend URL:** `https://hankers-backend.myaddr.tools/v1`
2. **Tweet Display Service:** Using `TweetsApiServiceImpl` (real backend)
3. **Add Tweet Service:** Using `AddTweetApiServiceImpl` (real backend)

### Endpoints Being Called:

| Feature | Method | Endpoint | Full URL |
|---------|--------|----------|----------|
| Get All Tweets | GET | `/posts` | `https://hankers-backend.myaddr.tools/v1/posts` |
| Get Tweet by ID | GET | `/posts/{id}` | `https://hankers-backend.myaddr.tools/v1/posts/{id}` |
| Create Tweet | POST | `/posts` | `https://hankers-backend.myaddr.tools/v1/posts` |
| Update Tweet | PUT | `/posts/{id}` | `https://hankers-backend.myaddr.tools/v1/posts/{id}` |
| Delete Tweet | DELETE | `/posts/{id}` | `https://hankers-backend.myaddr.tools/v1/posts/{id}` |

---

## ⚠️ Current Issue: 404 Errors

The app is trying to fetch tweets from:
```
https://hankers-backend.myaddr.tools/v1/posts
```

But receiving **404 Not Found** errors.

### Possible Causes:

1. **Backend endpoint not implemented yet**
   - The `/v1/posts` endpoint might not exist on your backend

2. **Different endpoint path**
   - Your backend might use a different path (e.g., `/api/posts`, `/tweets`, etc.)

3. **Authentication required**
   - The endpoint might require authentication headers

4. **Backend not deployed**
   - The backend server might not be running at that URL

---

## 🔍 How to Verify

### Test the backend endpoint directly:

```bash
# Test with curl
curl -X GET https://hankers-backend.myaddr.tools/v1/posts

# Test with browser
# Open: https://hankers-backend.myaddr.tools/v1/posts
```

### Expected Response (200 OK):
```json
{
  "status": "success",
  "data": [
    {
      "postId": 1,
      "userId": 1,
      "content": "Tweet text",
      "type": "POST",
      "visibility": "EVERY_ONE",
      "createdAt": "2025-10-28T10:00:00Z",
      "likes": 0,
      "comments": 0,
      "repost": 0,
      "views": 0
    }
  ],
  "metadata": {
    "page": 1,
    "limit": 20,
    "totalItems": 1,
    "totalPages": 1
  }
}
```

---

## 🛠️ Solutions

### Option 1: Backend Uses Different Endpoint Path

If your backend uses a different path, update the endpoint in the app:

**File:** `lib/core/api/api_config.dart`

```dart
// Change this line:
static const String postsEndpoint = '/posts';

// To whatever your backend uses, for example:
static const String postsEndpoint = '/api/posts';
// or
static const String postsEndpoint = '/tweets';
```

### Option 2: Backend Requires Authentication

If the endpoint requires authentication, add headers:

**File:** `lib/features/tweet/services/tweet_api_service_impl.dart`

```dart
TweetsApiServiceImpl({Dio? dio}) : _dio = dio ?? Dio(
  BaseOptions(
    baseUrl: ApiConfig.currentBaseUrl,
    headers: {
      'Authorization': 'Bearer YOUR_TOKEN_HERE',
      'Content-Type': 'application/json',
    },
    connectTimeout: ApiConfig.connectTimeout,
    receiveTimeout: ApiConfig.receiveTimeout,
    sendTimeout: ApiConfig.sendTimeout,
  ),
);
```

### Option 3: Backend Not Deployed Yet

If the backend isn't deployed, switch back to mock services temporarily:

**File:** `lib/features/tweet/services/tweet_api_service.dart`
```dart
@riverpod
TweetsApiService tweetsApiService(Ref ref) {
  return TweetsApiServiceMock(); // Use mock until backend is ready
}
```

**File:** `lib/features/add_tweet/ui/viewmodel/add_tweet_viewmodel.dart`
```dart
final apiService = AddTweetApiServiceMock(); // Use mock
```

---

## 📤 Create Tweet Request Format

When you create a tweet, the app sends:

```http
POST https://hankers-backend.myaddr.tools/v1/posts
Content-Type: multipart/form-data

Form Data:
- userId: 1
- content: "Tweet text here"
- type: "POST"
- visibility: "EVERY_ONE"
- mediaFiles: [File] (optional - binary image/video files)
```

The backend should respond with:
```json
{
  "status": "200",
  "data": {
    "postId": 123,
    "userId": 1,
    "content": "Tweet text here",
    "type": "POST",
    "visibility": "EVERY_ONE",
    "media": [
      {
        "mediaId": 1,
        "url": "https://cdn.example.com/image.jpg",
        "type": "IMAGE"
      }
    ],
    "createdAt": "2025-10-28T10:00:00Z",
    "likes": 0,
    "comments": 0,
    "repost": 0,
    "views": 0
  }
}
```

---

## 🎯 What Backend Needs to Implement

Based on the app's requirements, your backend needs these endpoints:

### 1. GET /v1/posts
- Returns list of all tweets/posts
- Supports pagination (optional)
- Returns JSend format response

### 2. POST /v1/posts
- Accepts multipart/form-data
- Required fields: userId, content, type, visibility
- Optional: mediaFiles (array of binary files)
- Uploads media files and returns URLs in response

### 3. GET /v1/posts/{id}
- Returns a single tweet by ID

### 4. PUT /v1/posts/{id}
- Updates an existing tweet

### 5. DELETE /v1/posts/{id}
- Deletes a tweet

---

## 📊 Current App Status

✅ **App compiled successfully**  
✅ **Running on Android Emulator**  
✅ **Configured to use real backend**  
✅ **Proper error handling showing 404 errors**  
⚠️ **Waiting for backend to implement /v1/posts endpoint**  

---

## 🔄 Quick Switch Back to Mock

If you need to use the app now while waiting for backend:

**Step 1:** Edit `lib/features/tweet/services/tweet_api_service.dart`:
```dart
import 'package:lam7a/features/tweet/services/tweet_api_service_mock.dart'; // Add this

@riverpod
TweetsApiService tweetsApiService(Ref ref) {
  return TweetsApiServiceMock(); // Change to mock
}
```

**Step 2:** Edit `lib/features/add_tweet/ui/viewmodel/add_tweet_viewmodel.dart`:
```dart
final apiService = AddTweetApiServiceMock(); // Change to mock
```

**Step 3:** Hot restart the app (press 'R' in terminal)

---

## ✅ Summary

The Flutter app is **fully configured and ready** to work with the backend at:
```
https://hankers-backend.myaddr.tools/v1
```

The app is correctly making requests to `/v1/posts`, but the backend is returning 404.

**Next Steps:**
1. Verify your backend has the `/v1/posts` endpoint implemented
2. Test the endpoint with curl or browser
3. Check backend logs for errors
4. Update app configuration if endpoint path is different
5. Once backend is ready, the app will work immediately!
