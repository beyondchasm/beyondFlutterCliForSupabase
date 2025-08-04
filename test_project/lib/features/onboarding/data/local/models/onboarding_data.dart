import '../../domain/entities/onboarding_page.dart';

/// 온보딩 페이지들의 기본 데이터를 제공하는 클래스
/// 
/// 실제 앱에서 사용될 온보딩 화면의 내용을 정의합니다.
/// 이 데이터는 앱의 특성에 맞게 수정하여 사용할 수 있습니다.
class OnboardingData {
  /// 기본 온보딩 페이지 목록
  /// 
  /// 3개의 페이지로 구성되어 있으며, 각각 앱의 주요 기능을 소개합니다:
  /// 1. 환영 메시지 및 앱 소개
  /// 2. 주요 기능 설명
  /// 3. 시작하기 안내
  static List<OnboardingPage> get defaultPages => [
        const OnboardingPage(
          title: '환영합니다!',
          description: '새로운 경험을 시작할 준비가 되셨나요?\n간편하고 직관적인 인터페이스로 모든 기능을 쉽게 사용할 수 있습니다.',
          imagePath: 'assets/images/onboarding_welcome.png',
          backgroundColor: '#6366F1', // Indigo 500
        ),
        const OnboardingPage(
          title: '강력한 기능들',
          description: '실시간 데이터 동기화와 안전한 인증 시스템으로\n언제나 최신 정보를 안전하게 관리하세요.',
          imagePath: 'assets/images/onboarding_features.png',
          backgroundColor: '#8B5CF6', // Violet 500
        ),
        const OnboardingPage(
          title: '지금 시작하세요',
          description: '모든 준비가 완료되었습니다.\n계정을 만들고 새로운 여정을 시작해보세요!',
          imagePath: 'assets/images/onboarding_start.png',
          backgroundColor: '#06B6D4', // Cyan 500
        ),
      ];

  /// 커스텀 온보딩 페이지를 생성하는 팩토리 메서드
  /// 
  /// 앱의 특성에 맞게 온보딩 내용을 커스터마이징할 때 사용합니다.
  /// 
  /// [customPages]: 사용자 정의 온보딩 페이지 리스트
  /// 반환값: 검증된 온보딩 페이지 리스트
  static List<OnboardingPage> createCustomPages(List<OnboardingPage> customPages) {
    // 최소 1개 이상의 페이지가 있어야 함
    if (customPages.isEmpty) {
      throw ArgumentError('온보딩 페이지는 최소 1개 이상이어야 합니다.');
    }

    // 최대 5개까지만 허용 (UX 고려)
    if (customPages.length > 5) {
      throw ArgumentError('온보딩 페이지는 최대 5개까지만 허용됩니다.');
    }

    return customPages;
  }

  /// 온보딩에서 사용할 기본 색상 팔레트
  static const List<String> defaultColors = [
    '#6366F1', // Indigo 500
    '#8B5CF6', // Violet 500
    '#06B6D4', // Cyan 500
    '#10B981', // Emerald 500
    '#F59E0B', // Amber 500
  ];

  /// 온보딩 완료 후 이동할 기본 라우트
  static const String defaultNextRoute = '/auth/login';

  /// 온보딩을 건너뛸 수 있는지 여부
  static const bool allowSkip = true;

  /// 온보딩 자동 재생 간격 (밀리초)
  /// null이면 자동 재생하지 않음
  static const int? autoPlayInterval = null;
}