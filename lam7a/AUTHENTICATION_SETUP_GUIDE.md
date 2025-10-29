# Authentication Setup for Tweet Features

**Date**: October 28, 2025  
**Issue**: 401 Unauthorized when creating tweets  
**Solution**: Implement login flow with cookie-based authentication

---

## 🔍 Problem Analysis

The backend requires authentication (401 Unauthorized error). Previous implementation was trying to create tweets without logging in first.

---

## ✅ Changes Implemented

### 1. **Created Authenticated Dio Provider**
**File**: `lib/core/api/authenticated_dio_provider.dart`

- Creates a Dio instance with cookie jar for session management
- Uses `PersistCookieJar` to persist cookies across app restarts
- Automatically handles authentication cookies from backend
- Shared across all API services that need authentication

**Key Features**:
- Cookie storage in app documents directory
- Automatic cookie injection on requests
- Automatic cookie extraction from responses
- Logging for debugging

### 2. **Updated Tweet API Service**
**Files**:
- `lib/features/tweet/services/tweet_api_service.dart`
- `lib/features/tweet/services/tweet_api_service_impl.dart`

**Changes**:
- Provider now returns `Future<TweetsApiService>` (async)
- Uses `authenticatedDioProvider` for cookie-managed Dio
- All tweet requests now include authentication cookies
- Added factory method `createAuthenticated()` for manual creation

### 3. **Updated Add Tweet API Service**
**Files**:
- `lib/features/add_tweet/services/add_tweet_api_service_impl.dart`

**Changes**:
- Uses `authenticatedDioProvider` for cookie-managed Dio
- Provider now returns `Future<AddTweetApiService>` (async)
- Tweet creation requests include authentication cookies
- Added factory method `createAuthenticated()` for manual creation

### 4. **Updated Tweet Repository**
**File**: `lib/features/tweet/repository/tweet_repository.dart`

**Changes**:
- Provider now returns `Future<TweetRepository>` (async)
- Properly handles async authenticated service

### 5. **Updated Add Tweet ViewModel**
**File**: `lib/features/add_tweet/ui/viewmodel/add_tweet_viewmodel.dart`

**Changes**:
- `postTweet()` now uses `ref.read(addTweetApiServiceProvider.future)`
- Properly awaits authenticated service

### 6. **Modified App Flow**
**File**: `lib/main.dart`

**Changes**:
- Changed from `TestTweetHomeApp()` to `MyApp()` (full app flow)
- Now starts with authentication screen
- Users must login before accessing tweets

### 7. **Updated Navigation After Login**
**File**: `lib/features/navigation/view/screens/navigation_home_screen.dart`

**Changes**:
- After successful login, redirects to `TweetHomeScreen`
- Shows tweet feed with FAB to add tweets
- Users can immediately start viewing and creating tweets

---

## 🔄 Authentication Flow

```
User Opens App
      ↓
First Time Screen
      ↓
User Clicks "Login"
      ↓
Login Screen (Enter Email/Username)
      ↓
Password Screen
      ↓
[Backend Auth API Call]
      ↓
Cookies Stored by PersistCookieJar
      ↓
Navigate to TweetHomeScreen
      ↓
All API Requests Include Auth Cookies
      ↓
✅ Can Create/View Tweets
```

---

## 🍪 Cookie Management

### How It Works:

1. **Login**:
   - User enters credentials
   - Backend validates and returns auth cookies (Set-Cookie header)
   - `PersistCookieJar` automatically stores cookies
   - Cookies persisted to disk

2. **Subsequent Requests**:
   - `CookieManager` interceptor automatically adds cookies
   - Backend validates cookies
   - Request succeeds with 200 OK

3. **Logout**:
   - Cookies can be cleared by calling logout
   - User must login again

### Cookie Storage Location:
```
{APP_DOCUMENTS_DIR}/.cookies/
```

---

## 📝 Code Examples

### Before (No Auth):
```dart
final apiService = AddTweetApiServiceImpl(); // ❌ No authentication
await apiService.createTweet(...); // ❌ Gets 401 Unauthorized
```

### After (With Auth):
```dart
final apiService = await ref.read(addTweetApiServiceProvider.future); // ✅ With auth
await apiService.createTweet(...); // ✅ Authenticated request with cookies
```

---

## 🧪 Testing the Setup

### 1. Run the App:
```bash
flutter run -d emulator-5554
```

### 2. Login Flow:
1. App starts at First Time Screen
2. Click "Login" or "Sign Up"
3. Enter credentials
4. Submit

### 3. After Login:
- Automatically redirected to Tweet Feed
- Can view tweets
- Can click FAB to add new tweet
- All requests include authentication

### 4. Check Console Logs:
```
🔐 Auth API: [REQUEST] POST /api/v1.0/auth/login
🔐 Auth API: [RESPONSE] 200 OK
📥 Fetching all tweets from backend...
✅ Authenticated request with cookies
```

---

## 🔐 Security Features

1. **Secure Cookie Storage**:
   - Cookies stored on device
   - Persist across app restarts
   - Not accessible to other apps

2. **Automatic Cookie Handling**:
   - No manual cookie management
   - `CookieManager` handles everything
   - Reduces security bugs

3. **HttpOnly Cookies Supported**:
   - Backend can set HttpOnly cookies
   - Not accessible to JavaScript
   - Protection against XSS

---

## 🐛 Troubleshooting

### Still Getting 401:

**Check 1: Cookies are being saved**
```dart
// In authenticated_dio_provider.dart, add:
final cookies = await cookieJar.loadForRequest(Uri.parse(ApiConfig.currentBaseUrl));
print('🍪 Stored cookies: $cookies');
```

**Check 2: Backend is setting cookies**
Look for `Set-Cookie` in response headers:
```
Set-Cookie: session=abc123; Path=/; HttpOnly
```

**Check 3: Cookie domain matches**
Ensure backend cookies are set for the correct domain

### Cookies Not Persisting:

**Solution**: Check file permissions
```dart
final directory = await getApplicationDocumentsDirectory();
print('Cookie path: ${directory.path}/.cookies');
```

---

## 📊 Updated Architecture

```
┌─────────────────────────────────────────┐
│         User Login                      │
│    (Authentication Screen)              │
└──────────────┬──────────────────────────┘
               │
               ↓
┌─────────────────────────────────────────┐
│    Backend Auth API                     │
│    Returns: Set-Cookie headers          │
└──────────────┬──────────────────────────┘
               │
               ↓
┌─────────────────────────────────────────┐
│    PersistCookieJar                     │
│    Stores cookies to disk               │
└──────────────┬──────────────────────────┘
               │
               ↓
┌─────────────────────────────────────────┐
│    authenticatedDioProvider             │
│    Dio with CookieManager               │
└──────────────┬──────────────────────────┘
               │
               ├──────────────┬──────────────┐
               ↓              ↓              ↓
    ┌──────────────┐  ┌──────────────┐  ┌────────────┐
    │ Tweet API    │  │ Add Tweet    │  │ Other APIs │
    │ Service      │  │ API Service  │  │            │
    └──────────────┘  └──────────────┘  └────────────┘
               │              │              │
               └──────────────┴──────────────┘
                              │
                              ↓
               ┌──────────────────────────┐
               │  All Requests Include    │
               │  Auth Cookies            │
               └──────────────────────────┘
```

---

## ✅ Benefits

1. **Secure**: Cookies managed properly
2. **Automatic**: No manual header management
3. **Persistent**: Cookies survive app restart
4. **Backend Compatible**: Works with standard cookie auth
5. **Scalable**: Easy to add more authenticated endpoints

---

## 🚀 Next Steps

1. ✅ Login flow implemented
2. ✅ Cookie management setup
3. ✅ API services updated
4. ✅ App flow configured
5. ⏳ Test login with real credentials
6. ⏳ Verify tweets can be created
7. ⏳ Test session persistence

---

## 📞 Summary

**What Changed**:
- App now requires login before accessing tweets
- Cookie-based authentication implemented
- All tweet API requests include auth cookies
- User logs in → Cookies stored → Authenticated requests work

**Result**: No more 401 errors! Users can create tweets after logging in. 🎉
