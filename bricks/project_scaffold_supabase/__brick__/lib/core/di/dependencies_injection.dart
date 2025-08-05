import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_config.dart';
import '../config/environment.dart' as env;
import '../services/error_handler_service.dart';
import '../services/loading_service.dart';
import '../services/secure_storage_service.dart';
import 'service_locator.dart';
import 'injection.dart';

class DependenciesInjection {
  static Future<void> init() async {
    // Register Core Services
    await _registerCoreServices();

    // Register External Services
    await _registerExternalServices();

    // Configure Injectable
    configureDependencies();

    if (env.EnvironmentConfig.enableLogging) {
      print('🔧 Dependency Injection initialized');
    }
  }

  static Future<void> _registerCoreServices() async {
    // App Configuration
    getIt.registerSingleton<AppConfig>(AppConfig());

    // Environment Configuration
    getIt.registerSingleton<env.EnvironmentConfig>(env.EnvironmentConfig());

    // SharedPreferences
    final sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);

    // Core Services
    getIt.registerSingleton<LoadingService>(LoadingService.instance);
    // ErrorHandlerService는 static 메서드만 사용하므로 등록하지 않음

    // Secure Storage Service
    // SecureStorageService는 static 메서드만 사용하므로 등록하지 않음

    // Dio HTTP Client (fallback for REST APIs)
    final dio = Dio();
    dio.options.baseUrl = env.EnvironmentConfig.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);

    // Add request/response logging in debug mode
    if (env.EnvironmentConfig.enableLogging) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
        ),
      );
    }

    // 에러 처리를 위한 Dio Interceptor 추가
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          final appError = ErrorHandlerService.convertToAppError(error);
          ErrorHandlerService.logError(appError, stackTrace: error.stackTrace);
          handler.next(error);
        },
      ),
    );

    getIt.registerSingleton<Dio>(dio);
  }


  static Future<void> _registerExternalServices() async {
    // Register Supabase client
    getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);

    // Register Supabase Auth
    getIt.registerSingleton<GoTrueClient>(
      Supabase.instance.client.auth,
    );

    if (env.EnvironmentConfig.enableLogging) {
      print('🔥 Supabase initialized');
    }
  }

  // Reset for testing
  static Future<void> reset() async {
    await getIt.reset();
  }
}
