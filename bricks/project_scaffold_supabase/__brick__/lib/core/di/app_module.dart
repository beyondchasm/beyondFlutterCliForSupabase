import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_config.dart';
import '../config/environment.dart' as env;
import '../services/error_handler_service.dart';

@module
abstract class AppModule {
  @preResolve
  @singleton
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @singleton
  SupabaseClient get supabaseClient => Supabase.instance.client;

  @singleton
  GoTrueClient get auth => Supabase.instance.client.auth;

  @singleton
  Dio get dio {
    final dio = Dio();
    dio.options.baseUrl = env.EnvironmentConfig.baseUrl;
    dio.options.connectTimeout = AppConfig.connectTimeout;
    dio.options.receiveTimeout = AppConfig.apiTimeout;
    dio.options.sendTimeout = AppConfig.apiTimeout;
    
    // Add request/response logging in debug mode
    if (env.EnvironmentConfig.enableLogging) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
      ));
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
    
    return dio;
  }
}