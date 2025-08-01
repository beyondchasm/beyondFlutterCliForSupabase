import 'package:get_it/get_it.dart';
import '../config/app_config.dart';
import '../config/environment.dart';

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
    }
  }

  static Future<void> _registerCoreServices() async {
    // App Configuration
    getIt.registerSingleton<AppConfig>(AppConfig());
    
    // Environment Configuration  
    getIt.registerSingleton<EnvironmentConfig>(EnvironmentConfig());
    
    // TODO: Add SharedPreferences
    // final sharedPreferences = await SharedPreferences.getInstance();
    // getIt.registerSingleton<SharedPreferences>(sharedPreferences);
    
    // TODO: Add Dio HTTP Client
    // final dio = Dio();
    // dio.options.baseUrl = EnvironmentConfig.baseUrl;
    // dio.options.connectTimeout = EnvironmentConfig.apiTimeout;
    // dio.options.receiveTimeout = EnvironmentConfig.apiTimeout;
    // getIt.registerSingleton<Dio>(dio);
    
    // TODO: Add Database (Hive, ObjectBox, etc.)
    // await Hive.initFlutter();
    // getIt.registerSingleton<HiveInterface>(Hive);
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

    // Auth Supabase Data Sources
    registerLazySingleton<SupabaseAuthRemoteDataSource>(
      () => SupabaseAuthRemoteDataSourceImpl(),
    );

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

    // Auth Repository
    registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(),
    );

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

    // Auth Use Cases
    registerLazySingleton<SignInUseCase>(() => SignInUseCase());
    registerLazySingleton<SignUpUseCase>(() => SignUpUseCase());
    registerLazySingleton<SignOutUseCase>(() => SignOutUseCase());
    registerLazySingleton<ResetPasswordUseCase>(() => ResetPasswordUseCase());
    registerLazySingleton<GetCurrentUserUseCase>(() => GetCurrentUserUseCase());

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

    // Auth Provider
    registerFactory<AuthProvider>(() => AuthProvider());

  }

  static Future<void> _registerExternalServices() async {
    // TODO: Register external services here
    // Example:
    // Firebase
    // await Firebase.initializeApp();
    // getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
    // getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
    
    // Analytics
    // if (EnvironmentConfig.enableAnalytics) {
    //   getIt.registerSingleton<FirebaseAnalytics>(FirebaseAnalytics.instance);
    // }
    
    // Crashlytics
    // if (EnvironmentConfig.enableCrashlytics) {
    //   getIt.registerSingleton<FirebaseCrashlytics>(FirebaseCrashlytics.instance);
    // }
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
  static bool unregister<T extends Object>() => getIt.unregister<T>();
}