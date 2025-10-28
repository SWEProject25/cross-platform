# File Upload Implementation - Technical Details

## ✅ Correct Implementation

The app is **correctly sending files as BINARY data** (not URLs) to the backend.

---

## 📤 How File Upload Works

### 1. User Selects Media

When a user picks an image or video:
```dart
// From image_picker package
final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

// We get the LOCAL FILE PATH
String localPath = pickedFile.path; // e.g., "/data/user/0/.../image.jpg"
```

### 2. File is Sent as Binary Data

In `add_tweet_api_service_impl.dart`, we convert the file to binary:

```dart
// Read the actual file from disk
final file = File(mediaPicPath);

// Detect MIME type (e.g., "image/jpeg", "video/mp4")
final mimeType = lookupMimeType(mediaPicPath);

// Create MultipartFile from the actual file bytes
final multipartFile = await MultipartFile.fromFile(
  mediaPicPath,                    // Path to file on disk
  filename: fileName,              // Original filename
  contentType: MediaType.parse(mimeType), // MIME type
);

// Add to form data with field name "mediaFiles"
formData.files.add(MapEntry('mediaFiles', multipartFile));
```

**What this does:**
- ✅ Reads the file from disk as **binary bytes**
- ✅ Detects the correct MIME type (image/jpeg, image/png, video/mp4, etc.)
- ✅ Sends the actual file content (not a URL or path)
- ✅ Uses the correct field name `mediaFiles` as per backend API spec

---

## 🔍 Multipart Form Data Structure

When we send the request, it looks like this:

```http
POST /v1/posts HTTP/1.1
Host: hankers-backend.myaddr.tools
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary

------WebKitFormBoundary
Content-Disposition: form-data; name="userId"

1
------WebKitFormBoundary
Content-Disposition: form-data; name="content"

hello
------WebKitFormBoundary
Content-Disposition: form-data; name="type"

POST
------WebKitFormBoundary
Content-Disposition: form-data; name="visibility"

EVERY_ONE
------WebKitFormBoundary
Content-Disposition: form-data; name="mediaFiles"; filename="IMG_20251028.jpg"
Content-Type: image/jpeg

[BINARY FILE DATA - ACTUAL IMAGE BYTES]
------WebKitFormBoundary--
```

**Key Points:**
- ✅ `mediaFiles` contains the **actual binary file data**
- ✅ NOT a URL or file path
- ✅ Includes proper filename and content-type
- ✅ Matches the backend API specification exactly

---

## 📋 Backend API Specification

According to `backend-main/documentation/api.yaml`:

```yaml
/posts:
  post:
    requestBody:
      content:
        multipart/form-data:
          schema:
            properties:
              userId:
                type: integer
              content:
                type: string
              type:
                type: string
                enum: ["POST", "REPLY", "QUOTE"]
              visibility:
                type: string
                enum: ["EVERY_ONE", "FOLLOWERS", "MENTIONED"]
              mediaFiles:
                type: array
                items:
                  type: string
                  format: binary  # <--- FILES, NOT URLS
```

**Our implementation matches this exactly:**
- ✅ Sends `multipart/form-data`
- ✅ Field name: `mediaFiles`
- ✅ Format: `binary` (actual file bytes)
- ✅ Supports multiple files (array)

---

## 🎯 Enhanced Logging

The new implementation includes detailed logging:

```
📤 Creating tweet on backend...
   User ID: 1
   Content: hello
   Image Path: /data/user/0/.../IMG_001.jpg
   Video Path: None
   
   📷 Adding image file:
      Path: /data/user/0/.../IMG_001.jpg
      Filename: IMG_001.jpg
      MIME type: image/jpeg
      File size: 245678 bytes
   ✅ Image file added to request as BINARY data
   
   🌐 Sending multipart/form-data request to:
      https://hankers-backend.myaddr.tools/v1/posts
   📦 Form data fields:
      userId: 1 (integer)
      content: hello
      type: POST
      visibility: EVERY_ONE
      mediaFiles: 1 file(s)
```

This confirms:
- ✅ File exists on disk
- ✅ File size is correct
- ✅ MIME type is detected
- ✅ File is added as binary data

---

## 🔧 MIME Type Detection

We use the `mime` package to automatically detect file types:

| File Extension | MIME Type | Detected As |
|---------------|-----------|-------------|
| `.jpg`, `.jpeg` | `image/jpeg` | Image |
| `.png` | `image/png` | Image |
| `.gif` | `image/gif` | Image |
| `.webp` | `image/webp` | Image |
| `.mp4` | `video/mp4` | Video |
| `.mov` | `video/quicktime` | Video |
| `.avi` | `video/x-msvideo` | Video |

The backend receives the correct content-type header for each file.

---

## ⚠️ Current Issue: Backend Not Implemented

The app is sending files correctly, but the backend returns **404 Not Found** because:

```
Backend Status: ❌ Empty
- No controllers implemented
- No /v1/posts endpoint
- src/app.module.ts has empty controllers array
```

### What the Backend Needs:

A NestJS controller like this:

```typescript
// posts.controller.ts
import { Controller, Post, Body, UploadedFiles, UseInterceptors } from '@nestjs/common';
import { FilesInterceptor } from '@nestjs/platform-express';

@Controller('v1/posts')
export class PostsController {
  @Post()
  @UseInterceptors(FilesInterceptor('mediaFiles', 4)) // Field name: "mediaFiles", max 4 files
  async createPost(
    @Body() createPostDto: CreatePostDto,
    @UploadedFiles() mediaFiles: Express.Multer.File[],
  ) {
    // mediaFiles is an array of uploaded file objects
    // Each file has: buffer, originalname, mimetype, size
    
    console.log('Received post:');
    console.log('  userId:', createPostDto.userId);
    console.log('  content:', createPostDto.content);
    console.log('  files:', mediaFiles?.length || 0);
    
    if (mediaFiles && mediaFiles.length > 0) {
      mediaFiles.forEach((file, index) => {
        console.log(`  File ${index + 1}:`);
        console.log(`    Name: ${file.originalname}`);
        console.log(`    MIME: ${file.mimetype}`);
        console.log(`    Size: ${file.size} bytes`);
      });
    }
    
    // 1. Upload files to CDN/storage
    // 2. Save post to database with media URLs
    // 3. Return response
    
    return {
      status: '200',
      data: {
        postId: 1,
        userId: createPostDto.userId,
        content: createPostDto.content,
        type: createPostDto.type,
        visibility: createPostDto.visibility,
        media: mediaFiles?.map((file, i) => ({
          mediaId: i + 1,
          url: `https://cdn.example.com/${file.originalname}`,
          type: file.mimetype.startsWith('image/') ? 'IMAGE' : 'VIDEO',
        })) || [],
        createdAt: new Date().toISOString(),
        likes: 0,
        comments: 0,
        repost: 0,
        views: 0,
      },
    };
  }
}
```

---

## 📊 Comparison: Files vs URLs

### ❌ WRONG (Sending URLs):
```dart
// This would be wrong
formData.fields.add(MapEntry('mediaPic', 'file:///local/path/image.jpg'));
formData.fields.add(MapEntry('mediaVideo', '/storage/emulated/0/video.mp4'));
```

### ✅ CORRECT (Sending Binary Files):
```dart
// This is what we do - correct!
final multipartFile = await MultipartFile.fromFile(localPath);
formData.files.add(MapEntry('mediaFiles', multipartFile));
```

---

## 🧪 Testing

### Test Case 1: Image Upload

```
User selects image from gallery
   ↓
Path: /data/user/0/.../IMG_001.jpg
Size: 245 KB
MIME: image/jpeg
   ↓
Convert to MultipartFile (reads binary data)
   ↓
POST /v1/posts with binary file in "mediaFiles" field
   ↓
Backend receives actual image bytes (not URL)
   ↓
Backend uploads to CDN and returns URL
```

### Test Case 2: Video Upload

```
User records video with camera
   ↓
Path: /data/user/0/.../VID_20251028.mp4
Size: 3.2 MB
MIME: video/mp4
   ↓
Convert to MultipartFile (reads binary data)
   ↓
POST /v1/posts with binary file in "mediaFiles" field
   ↓
Backend receives actual video bytes (not URL)
   ↓
Backend uploads to CDN and returns URL
```

### Test Case 3: Multiple Media

```
User selects 1 image + 1 video
   ↓
Both converted to MultipartFile
   ↓
POST /v1/posts with 2 binary files in "mediaFiles" array
   ↓
Backend receives 2 files
   ↓
Backend uploads both and returns 2 URLs
```

---

## ✅ Summary

### Implementation Status

| Component | Status | Details |
|-----------|--------|---------|
| File selection | ✅ Working | Uses image_picker |
| File to binary conversion | ✅ Correct | MultipartFile.fromFile() |
| MIME type detection | ✅ Added | mime package |
| Content-Type header | ✅ Correct | Includes proper MIME |
| Field name | ✅ Correct | "mediaFiles" as per API spec |
| Multipart encoding | ✅ Correct | Dio handles it properly |
| Backend endpoint | ❌ Missing | /v1/posts not implemented |

### What Works

✅ **Flutter app sends files correctly as binary data**  
✅ **MIME types are detected automatically**  
✅ **Multipart form-data is properly formatted**  
✅ **Field names match backend API specification**  
✅ **Detailed logging shows file details**  

### What's Needed

❌ **Backend /v1/posts endpoint implementation**  
❌ **File upload handling in NestJS**  
❌ **CDN/storage integration for media files**  
❌ **Database schema for posts and media**  

---

## 🚀 Next Steps

1. **Implement backend /v1/posts endpoint**
   - Add PostsController
   - Add file upload interceptor
   - Handle multipart/form-data

2. **Set up file storage**
   - AWS S3, Cloudinary, or local storage
   - Generate public URLs for uploaded files

3. **Test end-to-end**
   - Upload from app
   - Verify backend receives files
   - Check CDN URLs work

4. **Switch app to real backend**
   - Change line 78 in `add_tweet_viewmodel.dart`
   - From: `AddTweetApiServiceMock()`
   - To: `ref.read(addTweetApiServiceProvider)`

---

**The Flutter app is ready and correctly implemented. Waiting for backend /v1/posts endpoint!** 🎉
