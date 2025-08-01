import 'package:flutter/foundation.dart';

class AppConfig {
  static const String appName = 'Flutter Clean Architecture';
  static const String appVersion = '1.0.0';
  static const int buildNumber = 1;
  
  // Environment
  static const String environment = kDebugMode ? 'development' : 'production';
  static const bool isDebug = kDebugMode;
  static const bool isRelease = kReleaseMode;
  static const bool isProfile = kProfileMode;
  
  // API Configuration
  static const String baseUrl = kDebugMode 
      ? 'https://api-dev.example.com'
      : 'https://api.example.com';
  
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Database Configuration
  static const String databaseName = 'app_database.db';
  static const int databaseVersion = 1;
  
  // Cache Configuration
  static const Duration cacheExpiry = Duration(hours: 24);
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB
  
  // Feature Flags
  static const bool enableAnalytics = !kDebugMode;
  static const bool enableCrashlytics = !kDebugMode;
  static const bool enableLogging = kDebugMode;
  static const bool enablePerformanceMonitoring = true;
  
  // UI Configuration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashScreenDuration = Duration(seconds: 2);
  static const int maxRetryAttempts = 3;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Security
  static const Duration sessionTimeout = Duration(minutes: 30);
  static const int maxLoginAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 15);
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String settingsKey = 'app_settings';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';
  
  // Deep Linking
  static const String deepLinkScheme = 'myapp';
  static const String universalLinkDomain = 'myapp.com';
  
  // Social Login
  static const String googleClientId = kDebugMode 
      ? 'your-debug-google-client-id'
      : 'your-release-google-client-id';
  
  static const String facebookAppId = kDebugMode
      ? 'your-debug-facebook-app-id'
      : 'your-release-facebook-app-id';
  
  // Firebase Configuration
  static const String firebaseProjectId = kDebugMode
      ? 'your-debug-firebase-project'
      : 'your-release-firebase-project';
  
  // Push Notifications
  static const String fcmServerKey = 'your-fcm-server-key';
  static const String vapidKey = 'your-vapid-key';
  
  // Error Messages
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Please check your internet connection.';
  static const String timeoutErrorMessage = 'Request timed out. Please try again.';
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int maxUsernameLength = 50;
  static const int maxEmailLength = 254;
  
  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx', 'txt'];
  
  // Date/Time Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayTimeFormat = 'h:mm a';
  
  // Regular Expressions
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^\+?[1-9]\d{1,14}$';
  static const String passwordRegex = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$';
  
  // Helper Methods
  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';
  
  static String get apiUrl => baseUrl;
  static String get databasePath => databaseName;
  
  static Map<String, dynamic> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': '$appName/$appVersion',
  };
}