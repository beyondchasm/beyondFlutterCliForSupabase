import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';
import '../core/config/app_config.dart';
import '../core/config/environment.dart';
import '../core/config/supabase_config.dart';
import '../core/routes/app_router.dart';
import '../core/di/dependencies_injection.dart';
import '../core/services/error_handler_service.dart';
import '../core/services/loading_service.dart';

class InitApp {
  // 글로벌 키들
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Print environment info
    EnvironmentConfig.printEnvironmentInfo();

    // Initialize Supabase
    await SupabaseConfig.initialize();
    if (AppConfig.enableLogging) {
      print('✅ Supabase initialized');
    }

    // Initialize Dependency Injection
    await DependenciesInjection.init();

    // 에러 핸들러 및 로딩 서비스 초기화
    _initializeGlobalServices();

    // 글로벌 에러 Zone 설정 후 앱 실행
    runZonedGuarded(() => runApp(createApp()), (error, stackTrace) {
      // 글로벌 에러 처리
      ErrorHandlerService.handleGlobalError(error, stackTrace);
    });

    if (AppConfig.enableLogging) {
      print('✅ App initialization completed');
    }
  }

  /// 글로벌 서비스들 초기화
  static void _initializeGlobalServices() {
    // 에러 핸들러 키 설정
    ErrorHandlerService.setNavigatorKey(navigatorKey);
    ErrorHandlerService.setScaffoldKey(scaffoldKey);

    // 로딩 서비스 키 설정
    LoadingService.setNavigatorKey(navigatorKey);

    if (AppConfig.enableLogging) {
      print('✅ Global services initialized');
    }
  }

  static Widget createApp() {
    return ProviderScope(child: _AppMaterialApp());
  }
}

class _AppMaterialApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStateAsync = ref.watch(themeNotifierProvider);

    return themeStateAsync.when(
      data: (themeState) => MaterialApp.router(
        title: AppConfig.appName,
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: themeState.flutterThemeMode,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: AppConfig.isDebug,

        // 글로벌 키 설정
        // navigatorKey: InitApp.navigatorKey,
        scaffoldMessengerKey: InitApp.scaffoldKey,

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
              textScaler: MediaQuery.of(
                context,
              ).textScaler.clamp(minScaleFactor: 0.8, maxScaleFactor: 1.3),
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
      loading: () => MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Theme loading error: $error'),
          ),
        ),
      ),
    );
  }
}
