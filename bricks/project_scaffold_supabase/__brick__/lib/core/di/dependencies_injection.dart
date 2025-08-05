import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:injectable/injectable.dart';
import '../config/app_config.dart';
import '../config/environment.dart';
import '../services/error_handler_service.dart';
import '../services/loading_service.dart';
import '../services/secure_storage_service.dart';
import 'service_locator.dart';
import 'injection.config.dart';

@InjectableInit()
class DependenciesInjection {
  static Future<void> init() async {
    // Register Core Services
    await _registerCoreServices();

    // Register External Services
    await _registerExternalServices();

    // Configure Injectable
    ServiceLocator.configure(Environment.prod);

    if (EnvironmentConfig.enableLogging) {
      print('🔧 Dependency Injection initialized');
    }
  }

  static Future<void> _registerCoreServices() async {
    // App Configuration
    ServiceLocator.registerSingleton<AppConfig>(AppConfig());

    // Environment Configuration
    ServiceLocator.registerSingleton<EnvironmentConfig>(EnvironmentConfig());

    // SharedPreferences
    final sharedPreferences = await SharedPreferences.getInstance();
    ServiceLocator.registerSingleton<SharedPreferences>(sharedPreferences);

    // Core Services
    ServiceLocator.registerSingleton<LoadingService>(LoadingService.instance);
    // ErrorHandlerService는 static 메서드만 사용하므로 등록하지 않음

    // Secure Storage Service
    // SecureStorageService는 static 메서드만 사용하므로 등록하지 않음

    // Dio HTTP Client (fallback for REST APIs)
    final dio = Dio();
    dio.options.baseUrl = EnvironmentConfig.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);

    // Add request/response logging in debug mode
    if (EnvironmentConfig.enableLogging) {
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

    ServiceLocator.registerSingleton<Dio>(dio);
  }


  @module
  abstract class ExternalServicesModule {
    @Named('supabaseClient')
    @singleton
    SupabaseClient get supabaseClient => Supabase.instance.client;

    @singleton
    GoTrueClient get goTrueClient => Supabase.instance.client.auth;
  }

  static Future<void> _registerExternalServices() async {
    if (EnvironmentConfig.enableLogging) {
      print('🔥 Supabase initialized');
    }
  }

  // Reset for testing
  static Future<void> reset() async {
    await ServiceLocator.reset();
  }
}
