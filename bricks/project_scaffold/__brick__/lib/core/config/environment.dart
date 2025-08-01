import 'package:flutter/foundation.dart';

enum Environment {
  development,
  staging,
  production,
}

class EnvironmentConfig {
  static Environment get current {
    if (kDebugMode) {
      return Environment.development;
    } else if (kProfileMode) {
      return Environment.staging;
    } else {
      return Environment.production;
    }
  }

  static String get name {
    switch (current) {
      case Environment.development:
        return 'Development';
      case Environment.staging:
        return 'Staging';
      case Environment.production:
        return 'Production';
    }
  }

  static String get baseUrl {
    switch (current) {
      case Environment.development:
        return 'https://api-dev.example.com';
      case Environment.staging:
        return 'https://api-staging.example.com';
      case Environment.production:
        return 'https://api.example.com';
    }
  }

  static String get databaseName {
    switch (current) {
      case Environment.development:
        return 'app_dev.db';
      case Environment.staging:
        return 'app_staging.db';
      case Environment.production:
        return 'app.db';
    }
  }

  static bool get enableLogging {
    switch (current) {
      case Environment.development:
      case Environment.staging:
        return true;
      case Environment.production:
        return false;
    }
  }

  static bool get enableAnalytics {
    switch (current) {
      case Environment.development:
        return false;
      case Environment.staging:
      case Environment.production:
        return true;
    }
  }

  static bool get enableCrashlytics {
    switch (current) {
      case Environment.development:
        return false;
      case Environment.staging:
      case Environment.production:
        return true;
    }
  }

  static Duration get apiTimeout {
    switch (current) {
      case Environment.development:
        return const Duration(seconds: 60); // Longer timeout for debugging
      case Environment.staging:
      case Environment.production:
        return const Duration(seconds: 30);
    }
  }

  static Map<String, String> get firebaseOptions {
    switch (current) {
      case Environment.development:
        return {
          'projectId': 'your-dev-firebase-project',
          'appId': 'your-dev-firebase-app-id',
          'apiKey': 'your-dev-firebase-api-key',
          'messagingSenderId': 'your-dev-messaging-sender-id',
        };
      case Environment.staging:
        return {
          'projectId': 'your-staging-firebase-project',
          'appId': 'your-staging-firebase-app-id',
          'apiKey': 'your-staging-firebase-api-key',
          'messagingSenderId': 'your-staging-messaging-sender-id',
        };
      case Environment.production:
        return {
          'projectId': 'your-prod-firebase-project',
          'appId': 'your-prod-firebase-app-id',
          'apiKey': 'your-prod-firebase-api-key',
          'messagingSenderId': 'your-prod-messaging-sender-id',
        };
    }
  }

  static Map<String, String> get socialLoginConfig {
    switch (current) {
      case Environment.development:
        return {
          'googleClientId': 'your-dev-google-client-id',
          'facebookAppId': 'your-dev-facebook-app-id',
          'appleClientId': 'your-dev-apple-client-id',
        };
      case Environment.staging:
        return {
          'googleClientId': 'your-staging-google-client-id',
          'facebookAppId': 'your-staging-facebook-app-id',
          'appleClientId': 'your-staging-apple-client-id',
        };
      case Environment.production:
        return {
          'googleClientId': 'your-prod-google-client-id',
          'facebookAppId': 'your-prod-facebook-app-id',
          'appleClientId': 'your-prod-apple-client-id',
        };
    }
  }

  static void printEnvironmentInfo() {
    if (kDebugMode) {
      print('🔧 Environment: ${EnvironmentConfig.name}');
      print('🌐 Base URL: ${EnvironmentConfig.baseUrl}');
      print('💾 Database: ${EnvironmentConfig.databaseName}');
      print('📊 Analytics: ${EnvironmentConfig.enableAnalytics}');
      print('🐛 Crashlytics: ${EnvironmentConfig.enableCrashlytics}');
      print('📝 Logging: ${EnvironmentConfig.enableLogging}');
    }
  }
}