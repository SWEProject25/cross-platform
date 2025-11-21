/// API Configuration for the application
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
