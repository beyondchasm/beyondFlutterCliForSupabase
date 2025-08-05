import 'package:get_it/get_it.dart';
import 'injection.dart';

class ServiceLocator {
  static final GetIt _getIt = getIt;

  // Generic get method
  static T get<T extends Object>() {
    try {
      return _getIt.get<T>();
    } catch (e) {
      throw Exception('Service of type $T is not registered. Error: $e');
    }
  }

  // Generic get with optional fallback
  static T? getOptional<T extends Object>() {
    try {
      return _getIt.get<T>();
    } catch (e) {
      return null;
    }
  }

  // Check if service is registered
  static bool isRegistered<T extends Object>() {
    return _getIt.isRegistered<T>();
  }

  // Register singleton
  static void registerSingleton<T extends Object>(T instance) {
    if (!_getIt.isRegistered<T>()) {
      _getIt.registerSingleton<T>(instance);
    }
  }

  // Register lazy singleton
  static void registerLazySingleton<T extends Object>(T Function() factory) {
    if (!_getIt.isRegistered<T>()) {
      _getIt.registerLazySingleton<T>(factory);
    }
  }

  // Register factory
  static void registerFactory<T extends Object>(T Function() factory) {
    if (!_getIt.isRegistered<T>()) {
      _getIt.registerFactory<T>(factory);
    }
  }

  // Unregister service
  static Future<bool> unregister<T extends Object>() async {
    if (!_getIt.isRegistered<T>()) return false;
    // FutureOr<dynamic> 이므로 await 처리
    await _getIt.unregister<T>();
    return true;
  }

  // Reset all services (useful for testing)
  static Future<void> reset() async {
    await _getIt.reset();
  }

  // Get all registered services info (for debugging)
  static Map<String, dynamic> getRegisteredServices() {
    final services = <String, dynamic>{};

    // Note: GetIt doesn't provide a direct way to list all registered services
    // This is a placeholder for debugging purposes
    services['total_registered'] =
        'Use getIt.instance.allReady() for detailed info';

    return services;
  }

  // Check if all services are ready
  static Future<void> allReady() async {
    await _getIt.allReady();
  }

  // Push new scope (useful for feature-specific services)
  static void pushNewScope() {
    _getIt.pushNewScope();
  }

  // Pop scope
  static void popScope() {
    _getIt.popScope();
  }

  // Get current scope name
  static String? getCurrentScopeName() {
    return _getIt.currentScopeName;
  }
}

// Extension for easier access
extension ServiceLocatorExtension on Type {
  T getService<T extends Object>() => ServiceLocator.get<T>();

  T? getOptionalService<T extends Object>() => ServiceLocator.getOptional<T>();

  bool isServiceRegistered<T extends Object>() =>
      ServiceLocator.isRegistered<T>();
}
