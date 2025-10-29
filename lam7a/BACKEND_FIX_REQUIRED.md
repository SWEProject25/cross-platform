# Backend Fix Required for Media Upload

**Issue**: Backend cannot parse multipart/form-data requests when files are present.

---

## 🐛 The Problem

When frontend sends a POST request to `/api/v1.0/posts` with media files, backend returns:

```json
{
  "message": [
    "Content is required",
    "Type is required", 
    "Visibility is required"
  ],
  "error": "Bad Request",
  "statusCode": 400
}
```

**BUT the frontend IS sending all these fields!** The backend's multipart parser can't extract them.

---

## ✅ What Frontend Sends (Correct)

```http
POST /api/v1.0/posts
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary...
Cookie: access_token=...

------WebKitFormBoundary...
Content-Disposition: form-data; name="userId"

11
------WebKitFormBoundary...
Content-Disposition: form-data; name="content"

hello world
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

This is **100% correct** multipart format!

---

## 🔧 Backend Needs to Fix

### File Location
`backend/src/posts/posts.controller.ts` (or similar)

### Current Code (Broken):
```typescript
@Post()
@UseInterceptors(FileFieldsInterceptor([
  { name: 'mediaFiles', maxCount: 4 },
]))
async createPost(
  @Body() createPostDto: CreatePostDto,  // ← EMPTY when files present!
  @UploadedFiles() files: { mediaFiles?: Express.Multer.File[] },
) {
  // createPostDto is undefined/empty here
  // Validation fails because it can't find userId, content, type, visibility
}
```

### Fixed Code:
```typescript
import { 
  Controller, 
  Post, 
  Body, 
  UseInterceptors, 
  UploadedFiles,
  ParseFilePipeBuilder,
  HttpStatus
} from '@nestjs/common';
import { FileFieldsInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';

@Post()
@UseInterceptors(
  FileFieldsInterceptor(
    [{ name: 'mediaFiles', maxCount: 4 }],
    {
      storage: diskStorage({
        destination: './uploads',
        filename: (req, file, cb) => {
          const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
          cb(null, `${uniqueSuffix}-${file.originalname}`);
        },
      }),
    },
  ),
)
async createPost(
  @Body() createPostDto: CreatePostDto,
  @UploadedFiles() files: { mediaFiles?: Express.Multer.File[] },
) {
  // Debug logging - REMOVE AFTER TESTING
  console.log('=== POST /posts DEBUG ===');
  console.log('Body:', createPostDto);
  console.log('Files:', files);
  console.log('========================');

  // Now createPostDto should have: userId, content, type, visibility
  // And files.mediaFiles should have the uploaded files

  if (!createPostDto.userId || !createPostDto.content) {
    throw new BadRequestException('userId and content are required');
  }

  // Process the post...
  return await this.postsService.create(createPostDto, files.mediaFiles);
}
```

---

## 🎯 Key Changes Needed

### 1. **Configure Multer Storage** (if not already done)
```typescript
// In app.module.ts or posts.module.ts
import { MulterModule } from '@nestjs/platform-express';
import { diskStorage } from 'multer';

@Module({
  imports: [
    MulterModule.register({
      storage: diskStorage({
        destination: './uploads',
        filename: (req, file, cb) => {
          const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
          cb(null, `${uniqueSuffix}-${file.originalname}`);
        },
      }),
    }),
  ],
})
export class PostsModule {}
```

### 2. **Update DTO to Accept Form Fields**
```typescript
// create-post.dto.ts
import { IsString, IsInt, IsEnum, IsOptional, MaxLength } from 'class-validator';
import { Type } from 'class-transformer';

export class CreatePostDto {
  @Type(() => Number)  // ← IMPORTANT: Convert string to number
  @IsInt()
  userId: number;

  @IsString()
  @MaxLength(500)
  content: string;

  @IsEnum(['POST', 'REPLY', 'QUOTE'])
  type: string;

  @IsEnum(['EVERY_ONE', 'FOLLOWERS', 'MENTIONED'])
  visibility: string;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  parentId?: number;
}
```

### 3. **Enable Global Validation Pipe** (if not already)
```typescript
// In main.ts
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  app.useGlobalPipes(
    new ValidationPipe({
      transform: true,  // ← Enable transformation
      whitelist: true,
    }),
  );
  
  await app.listen(3000);
}
bootstrap();
```

---

## 🧪 Testing the Fix

### Test with cURL:
```bash
curl -X POST https://hankers-backend.myaddr.tools/api/v1.0/posts \
  -H "Cookie: access_token=YOUR_TOKEN" \
  -F "userId=11" \
  -F "content=test with image" \
  -F "type=POST" \
  -F "visibility=EVERY_ONE" \
  -F "mediaFiles=@/path/to/image.jpg"
```

**Expected Response:**
```json
{
  "status": "success",
  "data": {
    "id": 123,
    "user_id": 11,
    "content": "test with image",
    "type": "POST",
    "visibility": "EVERY_ONE",
    "created_at": "2025-10-28T...",
    "media": [
      {
        "id": 1,
        "url": "https://cdn.../image.jpg",
        "type": "image"
      }
    ]
  }
}
```

---

## 📚 Additional Resources

**NestJS File Upload Documentation:**
- https://docs.nestjs.com/techniques/file-upload

**Multer Documentation:**
- https://github.com/expressjs/multer

**Common Pitfalls:**
1. **Middleware Order**: File interceptor must run BEFORE validation
2. **Type Transformation**: Enable `transform: true` in ValidationPipe
3. **Form Data Parsing**: Ensure `@Body()` extracts fields from multipart correctly

---

## ✅ Success Criteria

After the fix:
- ✅ POST with JSON (no media) works
- ✅ POST with multipart (with media) works
- ✅ Both `createPostDto` and `files` are populated correctly
- ✅ Validation works on all fields
- ✅ Files are saved and URLs returned in response

---

## 📞 Contact

If you need help implementing this fix:
- Check NestJS Discord: https://discord.gg/nestjs
- Review similar issues: https://github.com/nestjs/nest/issues
- Frontend team is ready to test once backend is fixed!
