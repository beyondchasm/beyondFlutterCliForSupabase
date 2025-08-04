/// 온보딩 페이지 정보를 담는 엔티티 클래스
/// 
/// Clean Architecture의 Domain Layer에 위치하며,
/// 온보딩 화면에서 표시될 각 페이지의 정보를 정의합니다.
class OnboardingPage {
  /// 페이지 제목
  final String title;
  
  /// 페이지 설명
  final String description;
  
  /// 이미지 경로 또는 아이콘 데이터
  final String imagePath;
  
  /// 페이지 배경색 (선택적)
  final String? backgroundColor;

  /// OnboardingPage 생성자
  /// 
  /// [title]: 페이지의 제목 텍스트
  /// [description]: 페이지의 상세 설명
  /// [imagePath]: 표시할 이미지의 경로
  /// [backgroundColor]: 페이지 배경색 (선택적, 16진수 문자열)
  const OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
    this.backgroundColor,
  });

  /// 두 OnboardingPage 객체가 같은지 비교
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingPage &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          description == other.description &&
          imagePath == other.imagePath &&
          backgroundColor == other.backgroundColor;

  /// 해시코드 생성
  @override
  int get hashCode =>
      title.hashCode ^
      description.hashCode ^
      imagePath.hashCode ^
      backgroundColor.hashCode;

  /// 디버깅을 위한 문자열 표현
  @override
  String toString() {
    return 'OnboardingPage{title: $title, description: $description, imagePath: $imagePath, backgroundColor: $backgroundColor}';
  }

  /// 객체를 복사하면서 일부 필드만 변경할 수 있는 메서드
  OnboardingPage copyWith({
    String? title,
    String? description,
    String? imagePath,
    String? backgroundColor,
  }) {
    return OnboardingPage(
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}