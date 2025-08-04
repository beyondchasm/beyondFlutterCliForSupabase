import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_config.dart';
import '../config/environment.dart';
import '../../features/order/data/remote/data_sources/order_remote_data_source.dart';
import '../../features/order/data/remote/data_sources/order_remote_data_source_impl.dart';
import '../../features/order/data/local/data_sources/order_local_data_source.dart';
import '../../features/order/data/local/data_sources/order_local_data_source_impl.dart';
import '../../features/order/data/repositories/order_repository_impl.dart';
import '../../features/order/domain/repositories/order_repository.dart';
import '../../features/order/domain/use_cases/get_order_usecase.dart';
import '../../features/order/domain/use_cases/create_order_usecase.dart';
import '../../features/order/domain/use_cases/update_order_usecase.dart';
import '../../features/order/domain/use_cases/delete_order_usecase.dart';
import '../../features/order/presentation/providers/order_provider.dart';

final GetIt getIt = GetIt.instance;

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
    
    // order Feature Data Sources
    getIt.registerLazySingleton<OrderRemoteDataSource>(
      () => OrderRemoteDataSourceImpl(
        client: getIt<SupabaseClient>(),
      ),
    );
    
    getIt.registerLazySingleton<OrderLocalDataSource>(
      () => OrderLocalDataSourceImpl(),
    );
  
    // order Feature Repository
    getIt.registerLazySingleton<OrderRepository>(
      () => OrderRepositoryImpl(
        remoteDataSource: getIt<OrderRemoteDataSource>(),
        localDataSource: getIt<OrderLocalDataSource>(),
      ),
    );
  
    // order Feature Use Cases
    getIt.registerLazySingleton(() => GetOrderUseCase(getIt<OrderRepository>()));
    getIt.registerLazySingleton(() => CreateOrderUseCase(getIt<OrderRepository>()));
    getIt.registerLazySingleton(() => UpdateOrderUseCase(getIt<OrderRepository>()));
    getIt.registerLazySingleton(() => DeleteOrderUseCase(getIt<OrderRepository>()));
  
    // order Feature Provider
    getIt.registerFactory(() => OrderProvider(
      getOrderUseCase: getIt<GetOrderUseCase>(),
      createOrderUseCase: getIt<CreateOrderUseCase>(),
      updateOrderUseCase: getIt<UpdateOrderUseCase>(),
      deleteOrderUseCase: getIt<DeleteOrderUseCase>(),
    ));
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
    // Register Supabase client (initialized in init_app.dart)
    getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);

    // Register Supabase Auth
    getIt.registerSingleton<GoTrueClient>(Supabase.instance.client.auth);

    if (EnvironmentConfig.enableLogging) {
      print('🔥 External services registered');
    }
  }

  // Service locator helpers
  static T get<T extends Object>() => getIt.get<T>();
  static bool isRegistered<T extends Object>() => getIt.isRegistered<T>();
  
  // For testing
  static Future<void> reset() async {
    await getIt.reset();
  }
}
