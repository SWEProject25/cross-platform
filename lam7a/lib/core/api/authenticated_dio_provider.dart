import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/api/api_config.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// Provider for authenticated Dio instance with cookie management
/// This should be used by all API services that need authentication
final authenticatedDioProvider = FutureProvider<Dio>((ref) async {
  return await createAuthenticatedDio();
});

/// Creates a Dio instance with cookie jar for authentication
Future<Dio> createAuthenticatedDio() async {
  final directory = await getApplicationDocumentsDirectory();
  final cookiePath = path.join(directory.path, '.cookies');
  await Directory(cookiePath).create(recursive: true);
  
  final cookieJar = PersistCookieJar(
    storage: FileStorage(cookiePath),
  );
  
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.currentBaseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  // Ensure cookies are sent in web builds (CORS requests require credentials).
  // Also works harmlessly on mobile where withCredentials is ignored.
  dio.options.extra['withCredentials'] = true;
  
  // Add cookie manager interceptor for automatic cookie handling
  dio.interceptors.add(CookieManager(cookieJar));
  
  // Add logging interceptor
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (object) {
        print('🔐 Auth API: $object');
      },
    ),
  );
  
  return dio;
}
