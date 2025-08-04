import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_config.dart';
import '../config/environment.dart';
import '../services/error_handler_service.dart';
import '../services/loading_service.dart';
import '../services/secure_storage_service.dart';
import 'service_locator.dart';

class DependenciesInjection {
  static Future<void> init() async {
    // Register Core Services
    await _registerCoreServices();

    // Register Data Sources
    _registerDataSources();

    // Register Repositories
    _registerRepositories();

    // Register Use Cases
    _registerUseCases();

    // Register Providers/Controllers
    _registerProviders();

    // Register External Services
    await _registerExternalServices();

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

  static void _registerDataSources() {
    // TODO: Register your data sources here
    // Example:
    // ServiceLocator.registerSingleton<UserLocalDataSource>(
    //   UserLocalDataSourceImpl(ServiceLocator.get<HiveInterface>()),
    // );
    // ServiceLocator.registerSingleton<UserRemoteDataSource>(
    //   UserRemoteDataSourceImpl(ServiceLocator.get<Dio>()),
    // );
  }

  static void _registerRepositories() {
    // TODO: Register your repositories here
    // Example:
    // ServiceLocator.registerLazySingleton<UserRepository>(
    //   () => UserRepositoryImpl(
    //     ServiceLocator.get<UserLocalDataSource>(),
    //     ServiceLocator.get<UserRemoteDataSource>(),
    //   ),
    // );
  }

  static void _registerUseCases() {
    // TODO: Register your use cases here
    // Example:
    // ServiceLocator.registerLazySingleton<GetUserUseCase>(
    //   () => GetUserUseCase(ServiceLocator.get<UserRepository>()),
    // );
    // ServiceLocator.registerLazySingleton<CreateUserUseCase>(
    //   () => CreateUserUseCase(ServiceLocator.get<UserRepository>()),
    // );
  }

  static void _registerProviders() {
    // TODO: Register your providers/controllers here
    // Example:
    // ServiceLocator.registerFactory<UserProvider>(
    //   () => UserProvider(
    //     ServiceLocator.get<GetUserUseCase>(),
    //     ServiceLocator.get<CreateUserUseCase>(),
    //   ),
    // );
  }

  static Future<void> _registerExternalServices() async {
    // Supabase Configuration
    // TODO: Replace with your Supabase URL and Anon Key
    await Supabase.initialize(
      url: 'YOUR_SUPABASE_URL',
      anonKey: 'YOUR_SUPABASE_ANON_KEY',
      debug: EnvironmentConfig.enableLogging,
    );

    // Register Supabase client
    ServiceLocator.registerSingleton<SupabaseClient>(Supabase.instance.client);

    // Register Supabase Auth
    ServiceLocator.registerSingleton<GoTrueClient>(Supabase.instance.client.auth);

    if (EnvironmentConfig.enableLogging) {
      print('🔥 Supabase initialized');
    }
  }

  // Reset for testing
  static Future<void> reset() async {
    await ServiceLocator.reset();
  }
}
