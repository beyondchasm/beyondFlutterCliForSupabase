# Beyond Flutter CLI

Flutter Clean Architecture 프로젝트를 위한 강력한 CLI 도구입니다. 복잡한 보일러플레이트 코드 작성 없이 Clean Architecture 구조의 Flutter 앱을 빠르게 생성하고 개발할 수 있습니다.

## 🚀 주요 기능

- **프로젝트 스캐폴드**: Clean Architecture 기반의 완전한 프로젝트 구조 생성
- **다양한 백엔드 지원**: Firebase, Supabase, REST API 선택 가능
- **Feature 생성기**: Data, Domain, Presentation 레이어를 포함한 완전한 기능 모듈 생성
- **Freezed 통합**: 불변 클래스와 JSON 직렬화 자동 생성
- **자동 DI 등록**: 생성된 기능이 자동으로 의존성 주입 시스템에 등록
- **중앙집중식 관리**: 테마, 라우팅, 설정을 Core 모듈에서 통합 관리
- **GoRouter 통합**: 선언적 라우팅과 타입 안전성 제공
- **Material Design 3**: 최신 디자인 시스템 적용

## 📦 설치

### 필요 조건
- Flutter SDK (3.8.1 이상)
- Dart SDK (3.8.1 이상)
- Mason CLI

### Mason CLI 설치
```bash
dart pub global activate mason_cli
```

### Beyond Flutter CLI 설치
```bash
git clone https://github.com/beyondchasm/beyondFlutterCli.git
cd beyondFlutterCli
dart pub get
```

## 🛠 사용법

### 1. 프로젝트 스캐폴드 생성

새로운 Flutter 프로젝트 디렉토리에서 백엔드 타입을 선택하여 명령어를 실행합니다:

#### 🔥 Firebase 백엔드
```bash
dart run path/to/beyond_flutter_cli/bin/beyond_flutter_cli.dart scaffold --backend firebase
```

#### 🗃️ Supabase 백엔드
```bash
dart run path/to/beyond_flutter_cli/bin/beyond_flutter_cli.dart scaffold --backend supabase
```

#### 🌐 REST API 백엔드 (기본값)
```bash
dart run path/to/beyond_flutter_cli/bin/beyond_flutter_cli.dart scaffold --backend rest-api
# 또는 백엔드 옵션 생략
dart run path/to/beyond_flutter_cli/bin/beyond_flutter_cli.dart scaffold
```

이 명령어는 다음 구조를 생성합니다:

```
lib/
├── main.dart                    # 앱 진입점
├── main/
│   └── init_app.dart           # 앱 초기화 및 설정
├── core/                       # 공통 기능 모듈
│   ├── theme/                  # 테마 관리
│   │   ├── app_theme.dart
│   │   ├── theme_colors.dart
│   │   └── theme_text_styles.dart
│   ├── config/                 # 앱 설정
│   │   ├── app_config.dart
│   │   └── environment.dart
│   ├── routes/                 # 라우팅 시스템
│   │   ├── app_router.dart
│   │   └── route_names.dart
│   └── di/                     # 의존성 주입
│       ├── dependencies_injection.dart
│       └── service_locator.dart
└── features/                   # 기능별 모듈
```

### 2. Feature 생성

프로젝트에서 선택한 백엔드 타입에 맞는 기능 모듈을 생성합니다:

#### 🔥 Firebase 기능 생성
```bash
dart run path/to/beyond_flutter_cli/bin/beyond_flutter_cli.dart feature user_profile --backend firebase
```

#### 🗃️ Supabase 기능 생성
```bash
dart run path/to/beyond_flutter_cli/bin/beyond_flutter_cli.dart feature user_profile --backend supabase
```

#### 🌐 REST API 기능 생성 (기본값)
```bash
dart run path/to/beyond_flutter_cli/bin/beyond_flutter_cli.dart feature user_profile --backend rest-api
# 또는 백엔드 옵션 생략
dart run path/to/beyond_flutter_cli/bin/beyond_flutter_cli.dart feature user_profile
```

**⚠️ 중요**: Feature를 생성할 때는 반드시 프로젝트 스캐폴드와 동일한 백엔드 타입을 선택해야 합니다.

이 명령어는 Clean Architecture 패턴을 따르는 완전한 기능 모듈을 생성합니다:

```
lib/features/user_profile/
├── data/                       # 데이터 레이어
│   ├── local/
│   │   ├── data_sources/
│   │   │   ├── user_profile_local_data_source.dart
│   │   │   └── user_profile_local_data_source_impl.dart
│   │   └── models/
│   │       ├── user_profile_local_model.dart
│   │       └── freezed/         # Freezed 생성 파일
│   │           ├── user_profile_local_model.freezed.dart
│   │           └── user_profile_local_model.g.dart
│   ├── remote/
│   │   ├── data_sources/
│   │   │   ├── user_profile_remote_data_source.dart
│   │   │   └── user_profile_remote_data_source_impl.dart
│   │   └── models/
│   │       ├── user_profile_remote_model.dart
│   │       └── freezed/         # Freezed 생성 파일
│   │           ├── user_profile_remote_model.freezed.dart
│   │           └── user_profile_remote_model.g.dart
│   └── repositories/
│       └── user_profile_repository_impl.dart
├── domain/                     # 도메인 레이어
│   ├── entities/
│   │   ├── user_profile.dart
│   │   └── freezed/             # Freezed 생성 파일
│   │       ├── user_profile.freezed.dart
│   │       └── user_profile.g.dart
│   ├── repositories/
│   │   └── user_profile_repository.dart
│   └── use_cases/
│       ├── get_user_profile_usecase.dart
│       ├── create_user_profile_usecase.dart
│       ├── update_user_profile_usecase.dart
│       └── delete_user_profile_usecase.dart
└── presentation/               # 프레젠테이션 레이어
    ├── providers/
    │   └── user_profile_provider.dart
    └── screens/
        └── user_profile_screen.dart
```

### 3. 코드 생성 (Freezed)

프로젝트 생성 후에는 반드시 Freezed 코드 생성을 실행해야 합니다:

```bash
# 의존성 설치
flutter pub get

# 코드 생성 (한 번만)
dart run build_runner build

# 개발 중 자동 생성 (권장)
dart run build_runner watch

# 기존 파일 삭제 후 다시 생성
dart run build_runner build --delete-conflicting-outputs
```

### 4. 명령어 옵션

#### 전역 옵션
- `--help, -h`: 도움말 표시
- `--version`: 버전 정보 표시  
- `--verbose, -v`: 상세한 출력 정보 표시

#### 예시
```bash
# 상세 로그와 함께 스캐폴드 생성
dart run beyond_flutter_cli.dart scaffold --verbose

# 여러 기능 연속 생성
dart run beyond_flutter_cli.dart feature authentication
dart run beyond_flutter_cli.dart feature user_profile  
dart run beyond_flutter_cli.dart feature settings
```

## 🏗 아키텍처 개요

### Clean Architecture 구조

Beyond Flutter CLI는 Robert C. Martin의 Clean Architecture 원칙을 따릅니다:

```
┌─────────────────────────────────────┐
│           Presentation              │  ← UI/Providers
├─────────────────────────────────────┤
│             Domain                  │  ← Business Logic
├─────────────────────────────────────┤
│              Data                   │  ← Data Sources
└─────────────────────────────────────┘
```

### 의존성 흐름
- **Presentation → Domain**: UI가 Use Cases를 호출
- **Domain ← Data**: Use Cases가 Repository 인터페이스를 통해 데이터 접근
- **Data → Domain**: Repository 구현체가 도메인 엔티티 반환

### Core 모듈

모든 Feature가 공유하는 핵심 기능들:

- **Theme**: Material Design 3 기반 통합 테마 시스템
- **Config**: 환경별 설정 및 앱 상수 관리
- **Routes**: GoRouter 기반 선언적 라우팅
- **DI**: GetIt 기반 의존성 주입 시스템

## 🔥 백엔드 선택 가이드

### Firebase
✅ **장점**:
- Google의 강력한 클라우드 플랫폼
- 실시간 데이터베이스 (Firestore)
- 강력한 인증 시스템
- 자동 스케일링
- 오프라인 동기화 지원

📋 **설정 필요사항**:
- Firebase 프로젝트 생성
- `lib/core/config/firebase_config.dart`에서 프로젝트 정보 설정
- Android/iOS/Web 앱 등록 및 설정 파일 추가

### Supabase  
✅ **장점**:
- 오픈소스 Firebase 대안
- PostgreSQL 기반
- 실시간 구독 지원
- RESTful API 자동 생성
- Row Level Security (RLS)

📋 **설정 필요사항**:
- Supabase 프로젝트 생성
- `lib/core/config/supabase_config.dart`에서 URL과 anon key 설정
- 데이터베이스 테이블 생성

### REST API
✅ **장점**:
- 기존 API와 쉬운 통합
- 완전한 제어권
- 다양한 백엔드 지원
- 표준 HTTP 통신

📋 **설정 필요사항**:
- API 서버 준비
- `lib/core/config/environment.dart`에서 baseUrl 설정
- 인증 토큰 관리 구현

## 🎨 테마 시스템

### 색상 관리
```dart
// lib/core/theme/theme_colors.dart
class ThemeColors {
  static const Color primary = Color(0xFF6750A4);
  static const Color secondary = Color(0xFF625B71);
  // ... 기타 색상들
}
```

### 텍스트 스타일
```dart
// lib/core/theme/theme_text_styles.dart
class ThemeTextStyles {
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
  );
  // ... 기타 스타일들
}
```

### 테마 적용
```dart
// 자동으로 적용됨
Text('제목', style: ThemeTextStyles.headlineLarge);
Container(color: ThemeColors.primary);
```

## 🗺 라우팅 시스템

### GoRouter 기반 선언적 라우팅

```dart
// 기본 네비게이션
AppRouter.goHome();
AppRouter.goLogin();

// 파라미터와 함께 네비게이션
AppRouter.pushNamed('userDetails', pathParameters: {'id': '123'});

// 사용자 정의 트랜지션
AppRouter.pushWithSlideTransition(MyScreen());
```

### 라우트 구조
- **Shell Routes**: 하단 네비게이션이 포함된 메인 앱 구조
- **Modal Routes**: 전체 화면 모달 (온보딩, 설정 등)
- **Auth Guard**: 인증 상태 기반 자동 리다이렉트

## 🔌 의존성 주입

### ServiceLocator 패턴
```dart
// Feature에서 자동으로 적용됨
class UserProfileProvider extends ChangeNotifier {
  late final GetUserProfileUseCase _getUserProfileUseCase;
  
  UserProfileProvider() {
    _getUserProfileUseCase = ServiceLocator.get<GetUserProfileUseCase>();
  }
}
```

### 자동 DI 등록
Feature 생성 시 자동으로 다음이 등록됩니다:
- Data Sources (Local/Remote)
- Repository Implementation
- Use Cases (CRUD)
- Provider

## 🔧 설정 관리

### 환경별 설정
```dart
// lib/core/config/environment.dart
enum Environment { development, staging, production }

// 자동으로 현재 환경 감지
EnvironmentConfig.current // Development/Staging/Production
EnvironmentConfig.baseUrl // 환경별 API URL
EnvironmentConfig.enableLogging // 환경별 로깅 설정
```

### 앱 설정
```dart
// lib/core/config/app_config.dart
class AppConfig {
  static const String appName = 'Flutter Clean Architecture';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const bool enableAnalytics = !kDebugMode;
  // ... 기타 설정들
}
```

## 📱 생성되는 화면 구조

### Provider 기반 상태 관리
```dart
class UserProfileScreen extends StatefulWidget {
  // ServiceLocator를 통한 의존성 주입
  // Core Theme 시스템 적용
  // AppRouter를 통한 네비게이션
  // 에러/로딩/빈 상태 처리
}
```

### UI 구성 요소
- **Material Design 3** 기반 컴포넌트
- **RefreshIndicator**로 Pull-to-Refresh
- **PopupMenuButton**으로 컨텍스트 메뉴
- **AlertDialog**로 삭제 확인
- **SnackBar**로 피드백 메시지

## 🔥 Freezed 시스템

### Domain Entity
```dart
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    int? id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
```

### Local Model
```dart
@freezed
class UserProfileLocalModel with _$UserProfileLocalModel {
  const factory UserProfileLocalModel({
    int? id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserProfileLocalModel;

  const UserProfileLocalModel._();

  // Entity 변환 메서드
  UserProfile toEntity() => UserProfile(
    id: id,
    name: name,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory UserProfileLocalModel.fromEntity(UserProfile entity) =>
      UserProfileLocalModel(
        id: entity.id,
        name: entity.name,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );
}
```

### Remote Model
```dart
@freezed
class UserProfileRemoteModel with _$UserProfileRemoteModel {
  const factory UserProfileRemoteModel({
    int? id,
    required String name,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _UserProfileRemoteModel;

  const UserProfileRemoteModel._();

  // Entity 변환 메서드 (DateTime 파싱 포함)
  UserProfile toEntity() => UserProfile(
    id: id,
    name: name,
    createdAt: DateTime.parse(createdAt),
    updatedAt: DateTime.parse(updatedAt),
  );
}
```

### 생성 파일 구조
```
lib/features/user_profile/
├── domain/entities/
│   ├── user_profile.dart
│   └── freezed/
│       ├── user_profile.freezed.dart    # Freezed 생성
│       └── user_profile.g.dart          # JSON 직렬화
├── data/local/models/
│   ├── user_profile_local_model.dart
│   └── freezed/
│       ├── user_profile_local_model.freezed.dart
│       └── user_profile_local_model.g.dart
└── data/remote/models/
    ├── user_profile_remote_model.dart
    └── freezed/
        ├── user_profile_remote_model.freezed.dart
        └── user_profile_remote_model.g.dart
```

## 🛡 개발 권장사항

### 1. Feature 개발 순서
1. Domain Entity 정의 (Freezed 적용)
2. Repository 인터페이스 작성
3. Use Cases 구현
4. Data Source 인터페이스 정의
5. Local/Remote Model 정의 (Freezed 적용)
6. Repository Implementation 작성
7. Data Source Implementation 작성
8. **코드 생성 실행**: `dart run build_runner build`
9. Provider 및 화면 구현

### 2. 네이밍 컨벤션
- **snake_case**: 파일명, 변수명
- **PascalCase**: 클래스명, enum
- **camelCase**: 함수명, 메서드명

### 3. 폴더 구조 규칙
```
feature_name/
├── data/           # 외부 데이터 접근
├── domain/         # 비즈니스 로직
└── presentation/   # UI 관련
```

## 🔍 문제 해결

### 일반적인 문제들

#### 1. DI 등록 실패
```bash
# 에러: Service of type XXX is not registered
# 해결: DI 등록 확인
grep -r "registerLazySingleton<XXX>" lib/core/di/
```

#### 2. 라우트 찾을 수 없음
```bash
# 에러: Route not found
# 해결: RouteNames에 정의 확인  
lib/core/routes/route_names.dart
```

#### 3. Mason 브릭 오류
```bash
# Mason 캐시 정리
mason cache clear
mason get
```

#### 4. Freezed 코드 생성 오류
```bash
# 에러: Build failed due to import errors
# 해결: 코드 생성 실행
dart run build_runner build --delete-conflicting-outputs

# 캐시 정리 후 다시 빌드
flutter clean
flutter pub get
dart run build_runner build
```

### 디버깅 팁

#### 1. 상세 로그 활성화
```bash
dart run beyond_flutter_cli.dart feature user_profile --verbose
```

#### 2. DI 상태 확인
```dart
// 등록된 서비스 확인
ServiceLocator.isRegistered<UserProfileRepository>()
```

#### 3. 환경 정보 출력
```dart
EnvironmentConfig.printEnvironmentInfo()
```

## 🤝 기여하기

### 개발 환경 설정
1. 저장소 Fork
2. 브랜치 생성: `git checkout -b feature/new-feature`
3. 변경사항 커밋: `git commit -am 'Add new feature'`
4. 브랜치 푸시: `git push origin feature/new-feature`
5. Pull Request 생성

### 브릭 수정
브릭 파일은 `bricks/` 디렉토리에 있습니다:
- `bricks/project_scaffold/`: 프로젝트 스캐폴드 템플릿
- `bricks/feature/`: Feature 생성 템플릿

## 📝 라이선스

이 프로젝트는 MIT 라이선스를 따릅니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참고하세요.

## 🙋‍♂️ 지원

- **Issues**: [GitHub Issues](https://github.com/beyondchasm/beyondFlutterCli/issues)
- **Discussions**: [GitHub Discussions](https://github.com/beyondchasm/beyondFlutterCli/discussions)
- **Wiki**: [프로젝트 Wiki](https://github.com/beyondchasm/beyondFlutterCli/wiki)

---

**Beyond Flutter CLI**로 생산성을 높이고 일관된 코드 품질을 유지하세요! 🚀