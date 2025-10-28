# Quick Start: Connect Add Tweet to Backend

## 🚀 3-Step Setup

### Step 1: Configure Backend URL

Edit `lib/core/api/api_config.dart`:

```dart
// Change this to your backend server address
static const String baseUrl = 'http://localhost:3000/v1';

// For Android Emulator, use:
// static const String baseUrl = 'http://10.0.2.2:3000/v1';

// For Physical Device on same network, use:
// static const String baseUrl = 'http://YOUR_PC_IP:3000/v1';
```

### Step 2: Switch to Real Service

Edit `lib/features/add_tweet/ui/viewmodel/add_tweet_viewmodel.dart` (line 78):

**Before (Mock):**
```dart
final apiService = AddTweetApiServiceMock();
```

**After (Real Backend):**
```dart
final apiService = ref.read(addTweetApiServiceProvider);
```

### Step 3: Start Backend Server

```bash
cd backend-main/backend-main
npm install
npm run start:dev
```

---

## ✅ Test Your Connection

1. Run the Flutter app
2. Tap the FAB (+) button to create a tweet
3. Add text and optional image/video
4. Tap "Post"
5. Check console for success message:
   ```
   ✅ Tweet created successfully on backend!
   ```

---

## 🔄 Switch Back to Mock

To test without backend, change line 78 back to:
```dart
final apiService = AddTweetApiServiceMock();
```

---

## 📝 File Locations

```
lib/
├── core/
│   └── api/
│       └── api_config.dart                    ← EDIT: Backend URL
├── features/
│   └── add_tweet/
│       ├── services/
│       │   ├── add_tweet_api_service_impl.dart     (Real)
│       │   └── add_tweet_api_service_mock.dart     (Mock)
│       └── ui/
│           └── viewmodel/
│               └── add_tweet_viewmodel.dart    ← EDIT: Service selection
```

---

## 🌐 Network Configuration

### Android Emulator
```dart
static const String baseUrl = 'http://10.0.2.2:3000/v1';
```

### iOS Simulator / Physical Device (Same Network)
```dart
static const String baseUrl = 'http://192.168.1.X:3000/v1';
// Replace X with your PC's local IP address
```

### Find Your PC's IP Address

**Windows:**
```bash
ipconfig
# Look for "IPv4 Address"
```

**macOS/Linux:**
```bash
ifconfig | grep "inet "
# or
ip addr show
```

---

## 🐛 Troubleshooting

### Backend Not Responding
- Ensure backend is running: `npm run start:dev`
- Check firewall allows port 3000
- Verify correct IP address in `api_config.dart`

### File Upload Fails
- Check file permissions
- Verify file path is correct
- Check backend logs for errors

### Authentication Required
- Add auth token to Dio headers in `add_tweet_api_service_impl.dart`:
```dart
final _dio = Dio(
  BaseOptions(
    baseUrl: ApiConfig.currentBaseUrl,
    headers: {
      'Authorization': 'Bearer YOUR_TOKEN_HERE',
    },
  ),
);
```

---

**That's it! You're ready to go! 🎉**
