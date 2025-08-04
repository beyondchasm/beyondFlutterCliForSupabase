import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // TODO: Supabase 프로젝트에서 생성한 정보로 교체하세요
  static const String supabaseUrl = 'https://your-project-id.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key';
  
  /// Supabase 초기화
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      // 선택적 설정
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce, // PKCE 플로우 사용
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );
  }

  /// Supabase 클라이언트 인스턴스
  static SupabaseClient get client => Supabase.instance.client;

  /// 인증 상태 스트림
  static Stream<AuthState> get authStateStream => client.auth.onAuthStateChange;

  /// 현재 사용자
  static User? get currentUser => client.auth.currentUser;

  /// 인증 여부
  static bool get isAuthenticated => currentUser != null;
}