import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/config/app_config.dart';
import '../core/config/environment.dart';
import '../core/config/firebase_config.dart';
import '../core/routes/app_router.dart';
import '../core/di/dependencies_injection.dart';

class InitApp {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Print environment info
    EnvironmentConfig.printEnvironmentInfo();
    
    // Initialize Firebase
    await FirebaseConfig.initialize();
    if (AppConfig.enableLogging) {
      print('✅ Firebase initialized');
    }
    
    // Initialize Dependency Injection
    await DependenciesInjection.init();
    
    // TODO: Add additional initialization logic here
    // Examples:
    // - SharedPreferences initialization  
    // - Database initialization
    // - Permission requests
    // - Push notification setup
    // - Analytics initialization
    
    if (AppConfig.enableLogging) {
      print('✅ App initialization completed');
    }
  }

  static Widget createApp() {
    return MaterialApp.router(
      title: AppConfig.appName,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: AppConfig.isDebug,
      
      // Localization (TODO: Configure if needed)
      // locale: const Locale('en', 'US'),
      // supportedLocales: const [
      //   Locale('en', 'US'),
      //   Locale('ko', 'KR'),
      // ],
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      
      // Builder for additional wrappers (e.g., Provider, Bloc)
      builder: (context, child) {
        return MediaQuery(
          // Ensure text scale factor doesn't go beyond reasonable limits
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(context).textScaler.clamp(
              minScaleFactor: 0.8,
              maxScaleFactor: 1.3,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}