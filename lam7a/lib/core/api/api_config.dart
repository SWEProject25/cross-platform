/// API Configuration for the application
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class ApiConfig {
  // Base URLs
  static const String baseUrl = 'https://api.hankers.tech/api/v1.0';
  static const String productionUrl = 'https://api.xclone.com/v1';
  
  // Use development or production
  static const bool isDevelopment = true;
  
  // Get the current base URL based on environment
  static String get currentBaseUrl => isDevelopment ? baseUrl : productionUrl;
  
  // API Endpoints
  static const String postsEndpoint = '/posts';
  static const String authEndpoint = '/auth';
  static const String usersEndpoint = '/users';
  
  // Timeout durations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}


final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: "https://your-backend.com", // <-- replace with your real API base URL
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
  ));

  return dio;
});
