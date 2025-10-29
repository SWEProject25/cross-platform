# Media Upload Verification Guide
**Date**: October 28, 2025  
**Status**: Backend Updated - Ready for Testing

---

## ✅ Frontend Implementation Status

### Current Configuration

**API Base URL**: `https://hankers-backend.myaddr.tools/api/v1.0`  
**Posts Endpoint**: `/posts`  
**Full URL**: `https://hankers-backend.myaddr.tools/api/v1.0/posts`

### Multipart Implementation (CORRECT ✅)

The frontend correctly implements multipart/form-data with the following:

#### 1. **Form Data Structure**
```dart
FormData.fromMap({
  'userId': userIdInt,      // Sent as integer
  'content': content,       // String
  'type': 'POST',          // Enum value
  'visibility': 'EVERY_ONE', // Enum value
})
```

#### 2. **File Attachment**
```dart
// Files added with proper MIME types
final multipartFile = await MultipartFile.fromFile(
  mediaPicPath,
  filename: fileName,
  contentType: MediaType.parse(mimeType),
);
formData.files.add(MapEntry('mediaFiles', multipartFile));
```

#### 3. **Request Headers**
```dart
Options(
  contentType: 'multipart/form-data',
)
```

#### 4. **Authentication**
- ✅ Uses authenticated Dio instance
- ✅ Automatically includes cookies via CookieManager
- ✅ Proper cookie jar persistence

---

## 🎯 What Backend Should Now Handle

Since the backend has been updated, it should now:

### ✅ Parse multipart form fields correctly
- Extract `userId` as integer from form data
- Extract `content` from form data
- Extract `type` from form data
- Extract `visibility` from form data
- Extract `mediaFiles` array from file uploads

### ✅ Return proper response
```json
{
  "status": "200",
  "data": {
    "id": 123,
    "user_id": 11,
    "content": "Tweet with media",
    "type": "POST",
    "visibility": "EVERY_ONE",
    "created_at": "2025-10-28T19:00:00Z",
    "media": [
      {
        "id": 1,
        "url": "https://cdn.example.com/uploads/image.jpg",
        "type": "IMAGE"
      }
    ],
    "likes": 0,
    "repost": 0,
    "comments": 0,
    "views": 0
  }
}
```

---

## 🧪 Testing Instructions

### Test 1: Text-Only Tweet (Should Already Work)
```dart
await createTweet(
  userId: '11',
  content: 'Hello world!',
  mediaPicPath: null,
  mediaVideoPath: null,
);
```

**Expected**: ✅ 200 OK, tweet created successfully

---

### Test 2: Tweet with Image (Backend Update Should Fix This)
```dart
await createTweet(
  userId: '11',
  content: 'Check out this photo!',
  mediaPicPath: '/path/to/image.jpg',
  mediaVideoPath: null,
);
```

**Expected**: ✅ 200 OK, tweet created with image URL in response

**If it fails with 400**: Backend multipart parser still broken

---

### Test 3: Tweet with Video
```dart
await createTweet(
  userId: '11',
  content: 'Amazing video!',
  mediaPicPath: null,
  mediaVideoPath: '/path/to/video.mp4',
);
```

**Expected**: ✅ 200 OK, tweet created with video URL in response

---

## 📊 Console Log Examples

### Successful Request (What You Should See)
```
📤 Creating tweet on backend...
   User ID: 11
   Content: Check out this photo!
   Image Path: /data/user/0/.../image.jpg
   Video Path: None
   📷 Adding image file:
      Path: /data/user/0/.../image.jpg
      Filename: image.jpg
      MIME type: image/jpeg
      File size: 245632 bytes
   ✅ Image file added to request as BINARY data
   🌐 Sending multipart/form-data request to:
      https://hankers-backend.myaddr.tools/api/v1.0/posts
   📦 Form data fields:
      userId: 11
      content: Check out this photo!
      type: POST
      visibility: EVERY_ONE
      mediaFiles: 1 file(s)
   🔍 FormData contents:
      Fields: userId=11, content=Check out this photo!, type=POST, visibility=EVERY_ONE
      Files: mediaFiles=image.jpg
✅ Tweet created successfully on backend!
   Response data: {id: 123, user_id: 11, content: Check out this photo!, ...}
   Created tweet ID: 123
   Media Pic URL: https://cdn.example.com/uploads/image.jpg
   Media Video URL: None
```

### Failed Request (If Backend Still Has Issues)
```
📤 Creating tweet on backend...
   User ID: 11
   Content: Check out this photo!
   Image Path: /data/user/0/.../image.jpg
   Video Path: None
   📷 Adding image file:
      Path: /data/user/0/.../image.jpg
      Filename: image.jpg
      MIME type: image/jpeg
      File size: 245632 bytes
   ✅ Image file added to request as BINARY data
   🌐 Sending multipart/form-data request to:
      https://hankers-backend.myaddr.tools/api/v1.0/posts
   📦 Form data fields:
      userId: 11
      content: Check out this photo!
      type: POST
      visibility: EVERY_ONE
      mediaFiles: 1 file(s)
❌ Dio Error creating tweet:
   Status Code: 400
   Message: Bad Request
   Response: {message: [Content is required, Type is required, ...], error: Bad Request, statusCode: 400}
```

---

## 🔍 Debugging Backend Issues

If uploads still fail after backend update, check:

### 1. **Backend Logs**
Backend should log received fields:
```typescript
console.log('Body:', createPostDto);  // Should show: {userId: 11, content: '...', type: 'POST', ...}
console.log('Files:', files);         // Should show: {mediaFiles: [{originalname: 'image.jpg', ...}]}
```

### 2. **Backend Middleware Order**
```typescript
@Post()
@UseInterceptors(FileFieldsInterceptor([...]))  // ← Must be first
@UsePipes(new ValidationPipe({transform: true})) // ← Then validation
async createPost(...) { ... }
```

### 3. **Backend DTO Transformation**
```typescript
export class CreatePostDto {
  @Type(() => Number)  // ← Must convert string to number
  @IsInt()
  userId: number;
  // ...
}
```

---

## 🛠️ Frontend Code Locations

All media upload code is in:

**Service Implementation**:
- `lib/features/add_tweet/services/add_tweet_api_service_impl.dart` (lines 29-220)

**ViewModel**:
- `lib/features/add_tweet/ui/viewmodel/add_tweet_viewmodel.dart` (lines 62-108)

**API Configuration**:
- `lib/core/api/api_config.dart` (line 4: base URL)
- `lib/core/api/authenticated_dio_provider.dart` (authentication setup)

---

## ✅ Summary

### Frontend Status: READY ✅
- ✅ Multipart form data properly structured
- ✅ Files sent as binary with correct MIME types
- ✅ All required fields included (userId, content, type, visibility)
- ✅ Authentication via cookies working
- ✅ Detailed logging for debugging

### Backend Status: UPDATED (Needs Verification)
- ✅ Backend team updated multipart parser
- ⏳ Waiting for confirmation that media uploads work
- ⏳ Need to test with actual file uploads

### Next Steps:
1. Test text-only tweets (should work)
2. Test tweets with images (backend update should fix)
3. Test tweets with videos (backend update should fix)
4. Report any remaining issues with console logs

---

## 📞 Support

**Frontend**: All implementation complete and correct  
**Backend**: Updated to handle multipart/form-data  
**Testing**: Ready to verify end-to-end functionality

**The frontend is ready and waiting for backend confirmation!** 🚀
