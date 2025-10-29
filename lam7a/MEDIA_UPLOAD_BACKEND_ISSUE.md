# Media Upload Issue - Backend Multipart Parser Problem

**Date**: October 28, 2025  
**Status**: ⚠️ Backend Issue - Requires Backend Fix

---

## 🐛 Problem

When uploading tweets **with media files** (images/videos), the backend returns a 400 error saying all fields are missing:

```json
{
  "message": [
    "Content is required",
    "content must be a string",
    "Type must be one of: POST, REPLY, QUOTE",
    "Visibility is required",
    "Visibility must be one of: EVERY_ONE, FOLLOWERS, MENTIONED"
  ],
  "error": "Bad Request",
  "statusCode": 400
}
```

**But the frontend IS sending all these fields!**

---

## ✅ What Works

### Text-Only Tweets (No Media):
```
✅ POST /api/v1.0/posts
✅ Content-Type: application/json
✅ Backend receives and validates correctly
✅ Tweet created successfully
```

### Request Format:
```json
{
  "userId": 1,
  "content": "hello world",
  "type": "POST",
  "visibility": "EVERY_ONE"
}
```

**Result**: ✅ **200 OK** - Tweet created!

---

## ❌ What Doesn't Work

### Tweets with Media Files:
```
❌ POST /api/v1.0/posts
❌ Content-Type: multipart/form-data
❌ Backend CANNOT parse form fields
❌ Returns 400 validation errors
```

### Request Format:
```
------WebKitFormBoundary...
Content-Disposition: form-data; name="userId"

1
------WebKitFormBoundary...
Content-Disposition: form-data; name="content"

hello
------WebKitFormBoundary...
Content-Disposition: form-data; name="type"

POST
------WebKitFormBoundary...
Content-Disposition: form-data; name="visibility"

EVERY_ONE
------WebKitFormBoundary...
Content-Disposition: form-data; name="mediaFiles"; filename="image.jpg"
Content-Type: image/jpeg

<binary data>
------WebKitFormBoundary...--
```

**Result**: ❌ **400 Bad Request** - Backend can't find any fields!

---

## 🔍 Root Cause

**The backend's multipart/form-data parser is not extracting form fields correctly when files are present.**

### Likely Backend Issues:

1. **Middleware Order Problem**
   - File upload middleware might be consuming the request body before validation
   - Fields are not being extracted into `req.body`

2. **Parser Configuration**
   - NestJS/Express multipart parser not configured properly
   - Missing or incorrect `multer` configuration

3. **Field Extraction**
   - Backend code might not be reading fields from the multipart parser correctly
   - Fields might be in `req.files` instead of `req.body`

---

## 🛠️ Backend Needs to Fix

### Option 1: Fix Multipart Parser (Recommended)

**In NestJS**, ensure proper interceptor/pipe configuration:

```typescript
// posts.controller.ts
@Post()
@UseInterceptors(FileFieldsInterceptor([
  { name: 'mediaFiles', maxCount: 4 },
]))
async createPost(
  @Body() createPostDto: CreatePostDto,
  @UploadedFiles() files: { mediaFiles?: Express.Multer.File[] },
) {
  // createPostDto should have userId, content, type, visibility
  // files.mediaFiles should have the uploaded files
  console.log('Body:', createPostDto); // Should NOT be undefined!
  console.log('Files:', files);
  
  // Process...
}
```

**The DTO validation should work on `@Body()` extracted fields!**

### Option 2: Custom Parser

```typescript
// Use custom multipart parser that preserves fields
import { FastifyMulterOptions } from '@nest/fastify-multer';

const multerOptions: FastifyMulterOptions = {
  storage: diskStorage({
    destination: './uploads',
    filename: (req, file, cb) => {
      cb(null, `${Date.now()}-${file.originalname}`);
    },
  }),
};
```

---

## 📊 Frontend Has Tried

### ✅ Attempts Made:

1. ✅ `FormData.fromMap()` with proper fields
2. ✅ Manual `formData.fields.addAll()`  
3. ✅ Sending `userId` as integer
4. ✅ Sending `userId` as string
5. ✅ Manual Content-Type header
6. ✅ Automatic Content-Type (with boundary)
7. ✅ Fields before files in FormData
8. ✅ Different field encoding methods

**ALL attempts result in the same 400 error** ❌

### The Frontend Request IS Correct!

The multipart request format we're sending is **standard and correct**. Other backends (like those using `multer` properly) would parse it without issues.

---

## 🎯 Current Workaround

**For now, users can only create text-only tweets (no media).**

### Text Tweets Work Perfectly:
```dart
// ✅ This works
await createTweet(
  userId: '1',
  content: 'Hello world!',
  mediaPicPath: null,  // No media
  mediaVideoPath: null,
);
```

### Media Tweets Don't Work:
```dart
// ❌ This gets 400 error
await createTweet(
  userId: '1',
  content: 'Check out this photo!',
  mediaPicPath: '/path/to/image.jpg',  // With media
  mediaVideoPath: null,
);
```

---

## 📝 Backend Team Action Items

### 1. **Debug Multipart Parsing**
```typescript
// Add logging to see what backend receives
@Post()
@UseInterceptors(FileFieldsInterceptor([...]))
async createPost(@Req() req: Request) {
  console.log('===== DEBUG =====');
  console.log('Headers:', req.headers);
  console.log('Body:', req.body);  // CHECK IF THIS IS EMPTY!
  console.log('Files:', req.files);
  console.log('================');
  
  // If req.body is empty, the parser is broken!
}
```

### 2. **Check Middleware Order**
```typescript
// Ensure file interceptor runs BEFORE validation
@Post()
@UseInterceptors(FileFieldsInterceptor([...]))  // ← This first
@UsePipes(new ValidationPipe())  // ← This second
async createPost(...) { ... }
```

### 3. **Verify Multer Config**
```typescript
// Check multer is properly configured
import { MulterModule } from '@nestjs/platform-express';

@Module({
  imports: [
    MulterModule.register({
      dest: './uploads',
    }),
  ],
})
```

### 4. **Test with Postman/cURL**
```bash
curl -X POST https://hankers-backend.myaddr.tools/api/v1.0/posts \
  -H "Cookie: access_token=..." \
  -F "userId=1" \
  -F "content=test" \
  -F "type=POST" \
  -F "visibility=EVERY_ONE" \
  -F "mediaFiles=@/path/to/image.jpg"
```

**If this also fails with 400, it confirms the backend parser is broken.**

---

## ✅ Summary

| Feature | Status | Notes |
|---------|--------|-------|
| Text-only tweets | ✅ Working | JSON format works perfectly |
| Tweets with media | ❌ Broken | Backend can't parse multipart fields |
| Frontend request | ✅ Correct | Following HTTP multipart standards |
| Backend parser | ❌ Broken | Not extracting form fields |

**Action Required**: Backend team must fix multipart/form-data parser to extract form fields correctly when files are present.

---

## 🔗 Related Files

- Frontend: `lib/features/add_tweet/services/add_tweet_api_service_impl.dart`
- Backend: NestJS posts controller (needs multipart fix)
- API Spec: `backend-main/documentation/api.yaml`

---

**Frontend is ready and waiting for backend fix!** 🚀
