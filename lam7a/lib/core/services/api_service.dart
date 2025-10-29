import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:lam7a/core/constants/server_constant.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// part 'api_service.g.dart';


final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class ApiService {
  late Dio _dio;

  // Base URL for the APIpart 'api_service.g.dart';

  static final String _baseUrl = ServerConstant.serverURL;

  // Initialize timeout duration
  static const int _timeoutSeconds = 30;

  ApiService() {
    print("Initializing ApiService with base URL: $_baseUrl");
    _dio = _createDio();
    _dio.interceptors.add(_createErrorInterceptor());
    _dio.interceptors.add(_createLogInterceptor());
  }

  Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiService._baseUrl,
        connectTimeout: Duration(seconds: ApiService._timeoutSeconds),
        receiveTimeout: Duration(seconds: ApiService._timeoutSeconds),
        sendTimeout: Duration(seconds: ApiService._timeoutSeconds),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    return dio;
  }

  Future<void> _addInterceptorsToDio(Dio dio) async {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    final directory = await getApplicationDocumentsDirectory();
    final cookiePath = path.join(directory.path, '.cookies');
    await Directory(cookiePath).create(recursive: true);
    final cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));
    dio.interceptors.add(CookieManager(cookieJar));

    print('Cookie jar initialized at $cookiePath');
  }

  Future<void> initialize() async {
    await _addInterceptorsToDio(_dio);
  }

  // GET request
  Future<T> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        _baseUrl + endpoint,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // POST request
  Future<T> post<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        _baseUrl + endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // PUT request
  Future<T> put<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put<dynamic>(
        _baseUrl + endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // DELETE request
  Future<T> delete<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete<dynamic>(
        _baseUrl + endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // PATCH request
  Future<T> patch<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.patch<dynamic>(
        _baseUrl + endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Handle API response
  T _handleResponse<T>(
    Response<dynamic> response,
    T Function(dynamic)? fromJson,
  ) {
    if (response.data == null) {
      throw ApiException('Response data is null');
    }

    if (fromJson != null) {
      return fromJson(response.data);
    }

    return response.data as T;
  }

  // Create logging interceptor
  Interceptor _createLogInterceptor() {
    return LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (object) {
        // TODO: Replace with your preferred logging method
        print('API Log: $object');
      },
    );
  }

  // Create error interceptor
  Interceptor _createErrorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        // Handle global error scenarios
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.sendTimeout ||
            error.type == DioExceptionType.receiveTimeout) {
          // Log the error
          print('Connection timeout error: ${error.message}');
        }

        if (error.type == DioExceptionType.unknown &&
            error.error is SocketException) {
          // Log the error
          print('Network error: ${error.message}');
        }

        return handler.next(error);
      },
    );
  }

  // Handle Dio errors
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;

        switch (statusCode) {
          case 400:
            return ApiException(
              'Bad request',
              statusCode: statusCode,
              data: data,
            );
          case 401:
            return UnauthorizedException(data: data);
          case 403:
            return ForbiddenException(data: data);
          case 404:
            return NotFoundException(data: data);
          case 500:
            return ApiException(
              'Internal server error',
              statusCode: statusCode,
              data: data,
            );
          default:
            return ApiException(
              'Unknown error occurred',
              statusCode: statusCode,
              data: data,
            );
        }
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('Connection timeout');
      case DioExceptionType.cancel:
        return ApiException('Request cancelled');
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return ApiException('No internet connection');
        }
        return ApiException(error.message ?? 'Unknown error occurred');
      default:
        return ApiException(error.message ?? 'Unknown error occurred');
    }
  }
}

// Custom exceptions
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() => message;
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({dynamic data})
    : super('Unauthorized', statusCode: 401, data: data);
}

class ForbiddenException extends ApiException {
  ForbiddenException({dynamic data})
    : super('Forbidden', statusCode: 403, data: data);
}

class NotFoundException extends ApiException {
  NotFoundException({dynamic data})
    : super('Not found', statusCode: 404, data: data);
}
