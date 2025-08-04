import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_config.dart';
import '../config/environment.dart';

final GetIt getIt = getIt.instance;

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
    getIt.registerSingleton<AppConfig>(AppConfig());

    // Environment Configuration
    getIt.registerSingleton<EnvironmentConfig>(EnvironmentConfig());

    // SharedPreferences
    final sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);

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

    getIt.registerSingleton<Dio>(dio);
  }

  static void _registerDataSources() {
    // TODO: Register your data sources here
    // Example:
    // getIt.registerSingleton<UserLocalDataSource>(
    //   UserLocalDataSourceImpl(getIt<HiveInterface>()),
    // );
    // getIt.registerSingleton<UserRemoteDataSource>(
    //   UserRemoteDataSourceImpl(getIt<Dio>()),
    // );
  }

  static void _registerRepositories() {
    // TODO: Register your repositories here
    // Example:
    // getIt.registerLazySingleton<UserRepository>(
    //   () => UserRepositoryImpl(
    //     getIt<UserLocalDataSource>(),
    //     getIt<UserRemoteDataSource>(),
    //   ),
    // );
  }

  static void _registerUseCases() {
    // TODO: Register your use cases here
    // Example:
    // getIt.registerLazySingleton<GetUserUseCase>(
    //   () => GetUserUseCase(getIt<UserRepository>()),
    // );
    // getIt.registerLazySingleton<CreateUserUseCase>(
    //   () => CreateUserUseCase(getIt<UserRepository>()),
    // );
  }

  static void _registerProviders() {
    // TODO: Register your providers/controllers here
    // Example:
    // getIt.registerFactory<UserProvider>(
    //   () => UserProvider(
    //     getIt<GetUserUseCase>(),
    //     getIt<CreateUserUseCase>(),
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
    getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);

    // Register Supabase Auth
    getIt.registerSingleton<GoTrueClient>(Supabase.instance.client.auth);

    if (EnvironmentConfig.enableLogging) {
      print('🔥 Supabase initialized');
    }
  }

  // Reset for testing
  static Future<void> reset() async {
    await getIt.reset();
  }

  // Get instance helper
  static T get<T extends Object>() => getIt.get<T>();

  // Check if registered
  static bool isRegistered<T extends Object>() => getIt.isRegistered<T>();

  // Unregister
  static Future<bool> unregister<T extends Object>() async {
    if (!getIt.isRegistered<T>()) return false;
    await getIt.unregister<T>();
    return true;
  }
}
