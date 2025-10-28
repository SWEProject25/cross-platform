# Add Tweet Backend Integration Guide

## Overview

This document describes the backend integration for the **Add Tweet** feature in the lam7a Flutter application. The implementation allows users to create tweets with optional image and video attachments that are sent directly to the backend.

---

## 🏗️ Architecture

### Flow Diagram

```
User Input (Text + Media Files)
           ↓
  AddTweetViewModel
           ↓
  AddTweetApiService (Interface)
           ↓
   ┌──────────────────┐
   │                  │
   ↓                  ↓
Mock Service    Real Service
(Development)   (Production)
   ↓                  ↓
In-Memory      Backend API
Storage        (NestJS)
```

---

## 📁 New Files Created

### 1. **API Configuration**
- **Location:** `lib/core/api/api_config.dart`
- **Purpose:** Central configuration for API endpoints and timeouts
- **Key Settings:**
  - Development URL: `http://localhost:3000/v1`
  - Production URL: `https://api.xclone.com/v1`
  - Configurable timeout durations

### 2. **Media Upload Service (Separate Upload)**
- **Interface:** `lib/features/add_tweet/services/media_upload_service.dart`
- **Implementation:** `lib/features/add_tweet/services/media_upload_service_impl.dart`
- **Mock:** `lib/features/add_tweet/services/media_upload_service_mock.dart`
- **Purpose:** Upload media files separately and return URLs

### 3. **Add Tweet API Service (Combined Request)**
- **Interface:** `lib/features/add_tweet/services/add_tweet_api_service.dart`
- **Implementation:** `lib/features/add_tweet/services/add_tweet_api_service_impl.dart`
- **Mock:** `lib/features/add_tweet/services/add_tweet_api_service_mock.dart`
- **Purpose:** Create tweet with media files in a single multipart request

### 4. **Tweets API Service (General CRUD)**
- **Interface:** `lib/features/tweet/services/tweet_api_service.dart` (existing)
- **Implementation:** `lib/features/tweet/services/tweet_api_service_impl.dart`
- **Purpose:** General tweet operations (get, update, delete)

---

## 🔄 Backend API Integration

### Backend Endpoint: `POST /posts`

According to the backend API specification:

**Request:**
```http
POST /v1/posts
Content-Type: multipart/form-data

Fields:
- userId: integer (required)
- content: string (required, 1-280 chars)
- type: enum ["POST", "REPLY", "QUOTE"] (required)
- visibility: enum ["EVERY_ONE", "FOLLOWERS", "MENTIONED"] (required)
- mediaFiles: array of binary files (optional, max 4 files)
```

**Response:**
```json
{
  "status": "200",
  "data": {
    "postId": 12345,
    "userId": 1,
    "content": "Tweet text",
    "type": "POST",
    "visibility": "EVERY_ONE",
    "media": [
      {
        "url": "https://cdn.example.com/image1.jpg",
        "type": "image"
      }
    ],
    "createdAt": "2025-10-28T12:00:00Z"
  }
}
```

---

## 🎯 Implementation Details

### How Media Upload Works

**Current Implementation (Mock):**
1. User selects image/video from camera or gallery
2. Local file path is stored in state
3. When posting, `AddTweetApiServiceMock` generates mock URLs
4. Tweet is created with mock URLs

**Production Implementation (Real Backend):**
1. User selects image/video from camera or gallery
2. Local file path is stored in state
3. When posting, `AddTweetApiServiceImpl` creates multipart request
4. Files are uploaded to backend as part of the POST request
5. Backend stores files and returns URLs
6. Tweet is created with real URLs from backend

---

## 🚀 Switching Between Mock and Real Backend

### Current Configuration (Mock)

In `add_tweet_viewmodel.dart` (line 78):
```dart
final apiService = AddTweetApiServiceMock(); // Using mock
```

### To Use Real Backend

Change line 78 to:
```dart
final apiService = ref.read(addTweetApiServiceProvider); // Using real backend
```

**Steps to Enable Real Backend:**

1. **Update API Configuration:**
   ```dart
   // In lib/core/api/api_config.dart
   static const String baseUrl = 'http://YOUR_BACKEND_IP:3000/v1';
   ```

2. **Update ViewModel:**
   ```dart
   // In lib/features/add_tweet/ui/viewmodel/add_tweet_viewmodel.dart
   // Line 78: Replace AddTweetApiServiceMock() with:
   final apiService = ref.read(addTweetApiServiceProvider);
   ```

3. **Ensure Backend is Running:**
   ```bash
   cd backend-main/backend-main
   npm install
   npm run start:dev
   ```

4. **Test the Connection:**
   - Run the Flutter app
   - Create a tweet with media
   - Check console logs for upload status
   - Verify backend receives the request

---

## 📝 Code Examples

### Creating a Tweet with Image

```dart
final apiService = AddTweetApiServiceImpl();

final tweet = await apiService.createTweet(
  userId: '1',
  content: 'Hello World!',
  mediaPicPath: '/path/to/image.jpg',
  mediaVideoPath: null,
);

print('Tweet created with ID: ${tweet.id}');
print('Image URL: ${tweet.mediaPic}');
```

### Creating a Tweet with Video

```dart
final tweet = await apiService.createTweet(
  userId: '1',
  content: 'Check out this video!',
  mediaPicPath: null,
  mediaVideoPath: '/path/to/video.mp4',
);

print('Video URL: ${tweet.mediaVideo}');
```

### Creating a Tweet with Both

```dart
final tweet = await apiService.createTweet(
  userId: '1',
  content: 'Amazing content!',
  mediaPicPath: '/path/to/image.jpg',
  mediaVideoPath: '/path/to/video.mp4',
);
```

---

## 🧪 Testing

### Testing with Mock Service (No Backend Required)

```dart
// Default configuration - no changes needed
final apiService = AddTweetApiServiceMock();
final tweet = await apiService.createTweet(
  userId: '1',
  content: 'Test tweet',
  mediaPicPath: '/local/path/image.jpg',
);
// Returns mock URLs like: https://picsum.photos/seed/123/800/600
```

### Testing with Real Backend

1. Start the backend server
2. Update the base URL in `api_config.dart`
3. Switch to real service in viewmodel
4. Create a tweet and verify:
   - Console logs show actual upload progress
   - Backend receives the request
   - Files are stored on the server
   - Real URLs are returned

---

## 🐛 Debugging

### Console Logs

The implementation includes detailed logging:

```
📤 Creating tweet on backend...
   User ID: 1
   Content: Hello World!
   Image Path: /path/to/image.jpg
   Video Path: None
   📷 Added image file to request
   🌐 Sending request to http://localhost:3000/v1/posts
✅ Tweet created successfully on backend!
   Created tweet ID: 12345
   Media Pic URL: https://cdn.example.com/image.jpg
   Media Video URL: None
```

### Common Issues

**1. Connection Refused**
```
❌ Dio Error creating tweet:
   Status Code: null
   Message: Connection refused
```
**Solution:** Ensure backend is running on the correct port

**2. File Not Found**
```
⚠️ Image file not found: /path/to/image.jpg
```
**Solution:** Verify file path is correct and file exists

**3. Invalid Response**
```
❌ Error creating tweet: type 'Null' is not a subtype of type 'String'
```
**Solution:** Backend response format doesn't match expected structure

---

## 🔐 Security Considerations

1. **Authentication:** Add JWT token to request headers when available
2. **File Validation:** Backend should validate file types and sizes
3. **Rate Limiting:** Implement rate limiting to prevent abuse
4. **HTTPS:** Use HTTPS in production for secure file transfer

---

## 📦 Dependencies

All required dependencies are already in `pubspec.yaml`:

```yaml
dependencies:
  dio: ^5.9.0              # HTTP client with multipart support
  image_picker: ^1.2.0     # Camera and gallery access
  flutter_riverpod: ^3.0.3 # State management
```

---

## 🎯 Future Enhancements

1. **Progress Indicators:** Show upload progress for large files
2. **Retry Logic:** Automatic retry on network failure
3. **Offline Support:** Queue tweets for later upload
4. **Image Compression:** Compress images before upload
5. **Multiple Media:** Support up to 4 images per tweet

---

## ✅ Summary

### What's Working Now:

✅ Mock service for development without backend  
✅ Real service ready for backend integration  
✅ Multipart file upload with Dio  
✅ Clean separation between mock and real implementations  
✅ Detailed logging for debugging  
✅ Easy switch between mock and real services  

### To Go Live:

1. Update `api_config.dart` with production URL
2. Change viewmodel to use `addTweetApiServiceProvider`
3. Add authentication tokens to requests
4. Test thoroughly with real backend
5. Deploy!

---

## 📞 Support

For questions or issues, check:
- Backend API documentation: `backend-main/documentation/api.yaml`
- Flutter implementation: `lib/features/add_tweet/`
- Console logs for detailed error messages

**The add tweet feature is now ready for backend integration!** 🎉
