import '../config/environment.dart' as env;
import '../services/error_handler_service.dart';
import '../services/loading_service.dart';
import 'injection.dart';

class DependenciesInjection {
  static Future<void> init() async {
    // Configure Injectable - 이제 모든 의존성이 Injectable을 통해 관리됨
    await configureDependencies();

    // Initialize services that need manual setup
    _initializeServices();

    if (env.EnvironmentConfig.enableLogging) {
      print('🔧 Dependency Injection initialized');
    }
  }

  static void _initializeServices() {
    // ErrorHandlerService는 static 메서드만 사용하므로 등록하지 않음
    // LoadingService는 singleton 패턴으로 관리됨
    
    if (env.EnvironmentConfig.enableLogging) {
      print('🔥 Core services initialized');
    }
  }

  // Reset for testing
  static Future<void> reset() async {
    await getIt.reset();
  }
}
