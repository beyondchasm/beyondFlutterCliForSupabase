# Beyond Flutter CLI

Flutter Clean Architecture 프로젝트를 위한 강력한 CLI 도구입니다. 복잡한 보일러플레이트 코드 작성 없이 Clean Architecture 구조의 Flutter 앱을 빠르게 생성하고 개발할 수 있습니다.

## 🚀 주요 기능

- **🏗️ 프로젝트 스캐폴드**: Clean Architecture 기반의 완전한 프로젝트 구조 생성
- **🔥 다양한 백엔드 지원**: Firebase, Supabase, REST API 선택 가능
- **⚡ 즉시 실행 가능**: Splash, Home 화면이 포함된 바로 실행 가능한 앱 생성
- **🔐 내장 인증 시스템**: `--with-auth` 플래그로 완전한 로그인/회원가입 시스템 자동 생성
- **👤 사용자 프로필**: `--with-user` 플래그로 사용자 관리 기능 자동 생성
- **🧩 Feature 생성기**: Data, Domain, Presentation 레이어를 포함한 완전한 기능 모듈 생성
- **❄️ Freezed 통합**: 불변 클래스와 JSON 직렬화 자동 생성
- **🔧 자동 DI 등록**: 생성된 기능이 자동으로 의존성 주입 시스템에 등록
- **🎨 중앙집중식 관리**: 테마, 라우팅, 설정을 Core 모듈에서 통합 관리
- **🗺️ GoRouter 통합**: 선언적 라우팅과 타입 안전성 제공
- **💎 Material Design 3**: 최신 디자인 시스템 적용
- **🌙 다크 모드 지원**: 시스템 테마 감지 및 수동 전환 기능
- **⚙️ 설정 파일 관리**: YAML 기반 프로젝트 기본값 설정
- **🛡️ 스마트 프로젝트 이름 검증**: 유효하지 않은 디렉토리명을 자동으로 Dart 패키지 규칙에 맞게 변환
- **🔄 최신 Flutter 호환성**: Deprecated 옵션 제거로 최신 Flutter 버전과 완벽 호환
- **🌊 Riverpod 통합**: Provider와 Riverpod 동시 지원으로 현대적인 상태 관리 제공

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

#### 방법 1: Global Package 설치 (권장 ⭐)
```bash
# 저장소 클론
git clone https://github.com/beyondchasm/beyondFlutterCli.git
cd beyondFlutterCli

# Global 패키지로 설치
dart pub global activate --source path .
```

설치 후 간단한 명령어로 사용 가능:
```bash
beyond scaffold --backend firebase
beyond scaffold --backend supabase --with-auth --with-user
beyond feature user_profile --backend rest-api
beyond --version
```

#### 방법 2: Shell Alias 설정
```bash
# 저장소 클론
git clone https://github.com/beyondchasm/beyondFlutterCli.git
cd beyondFlutterCli
dart pub get

# Alias 자동 설치 (macOS/Linux)
./scripts/install_alias.sh
```

설치 후 `beyond` 명령어로 축약 사용:
```bash
beyond scaffold --backend firebase
beyond init
```

#### 방법 3: 직접 실행 (개발용)
```bash
git clone https://github.com/beyondchasm/beyondFlutterCli.git
cd beyondFlutterCli
dart pub get

# 직접 실행
dart run bin/beyond_flutter_cli.dart scaffold --backend firebase
```

## 🛠 사용법

### 1. 프로젝트 스캐폴드 생성

새로운 Flutter 프로젝트 디렉토리에서 백엔드 타입을 선택하여 명령어를 실행합니다:

#### 🔥 Firebase 백엔드
```bash
# Global 설치 후 (권장)
beyond scaffold --backend firebase

# 또는 직접 실행
dart run bin/beyond_flutter_cli.dart scaffold --backend firebase
```

#### 🗃️ Supabase 백엔드
```bash
# Global 설치 후 (권장)
beyond scaffold --backend supabase

# 또는 직접 실행
dart run bin/beyond_flutter_cli.dart scaffold --backend supabase
```

#### 🌐 REST API 백엔드 (기본값)
```bash
# Global 설치 후 (권장)
beyond scaffold --backend rest-api
# 또는 백엔드 옵션 생략
beyond scaffold

# 또는 직접 실행
dart run bin/beyond_flutter_cli.dart scaffold --backend rest-api
```

#### 🏢 조직 및 언어 설정
**NEW!** 이제 Flutter 프로젝트 생성 시 조직명과 개발 언어를 선택할 수 있습니다:

```bash
# 조직명 설정 (Android 패키지명에 영향)
dart run beyond_flutter_cli.dart scaffold --backend firebase --org com.mycompany

# Android 개발 언어 선택 (기본값: kotlin)
dart run beyond_flutter_cli.dart scaffold --backend firebase --android-language java

# iOS 개발 언어 선택 (기본값: swift)
dart run beyond_flutter_cli.dart scaffold --backend firebase --ios-language objc

# 모든 옵션 조합
dart run beyond_flutter_cli.dart scaffold --backend firebase --org com.mycompany --android-language java --ios-language objc --with-auth --with-user
```

**옵션 설명:**
- `--org`: 조직명 (예: com.example) - Android 패키지 구조와 iOS Bundle ID에 반영
- `--android-language`: Android 개발 언어 (java, kotlin) - 기본값: kotlin
- `--ios-language`: iOS 개발 언어 (objc, swift) - 기본값: swift

### 1-1. 📱 즉시 실행 가능한 앱 생성

**NEW!** 이제 기본 기능들과 함께 바로 실행 가능한 앱을 생성할 수 있습니다:

#### 🔐 인증 기능 포함
```bash
# Firebase + 인증
dart run beyond_flutter_cli.dart scaffold --backend firebase --with-auth

# Supabase + 인증  
dart run beyond_flutter_cli.dart scaffold --backend supabase --with-auth

# REST API + 인증
dart run beyond_flutter_cli.dart scaffold --backend rest-api --with-auth
```

#### 👤 사용자 프로필 기능 포함
```bash
# Firebase + 사용자 프로필
dart run beyond_flutter_cli.dart scaffold --backend firebase --with-user

# Supabase + 사용자 프로필  
dart run beyond_flutter_cli.dart scaffold --backend supabase --with-user

# REST API + 사용자 프로필
dart run beyond_flutter_cli.dart scaffold --backend rest-api --with-user

# 인증 + 사용자 프로필 모두 포함 (완전한 사용자 관리 시스템)
dart run beyond_flutter_cli.dart scaffold --backend firebase --with-auth --with-user
```

#### 🎨 포함되는 기본 화면들
- **Splash Screen**: 애니메이션이 포함된 로딩 화면
- **Home Screen**: 완전한 Material Design 3 홈 화면
- **Login/Register/ForgotPassword**: 인증 기능 선택 시 자동 생성
- **Profile/Edit Profile**: 사용자 기능 선택 시 자동 생성

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

### 4. 설정 파일 관리

**NEW in v0.2.0!** 이제 프로젝트 기본값을 설정 파일로 관리할 수 있습니다:

#### 설정 파일 생성
```bash
# 기본 설정 파일 생성
dart run beyond_flutter_cli.dart init

# 기존 파일 덮어쓰기
dart run beyond_flutter_cli.dart init --force
```

이 명령어는 `beyond_cli.yaml` 파일을 생성합니다:

```yaml
# Beyond Flutter CLI Configuration
# 기본 백엔드 타입 (firebase, supabase, rest-api)
backend: rest-api

# 기본 조직명 (패키지명에 사용)
org: com.example

# 기본 프로그래밍 언어
languages:
  android: kotlin  # java or kotlin
  ios: swift       # objc or swift

# 기본 기능 포함 여부
features:
  auth: false      # 인증 기능 포함
  user: false      # 사용자 프로필 기능 포함

# 개발 환경 설정
preferences:
  verbose: false           # 상세 출력 기본값
  auto_pub_get: true      # 자동 pub get 실행
  auto_build_runner: true # 자동 build_runner 실행
```

#### 설정 파일 활용
설정 파일이 있으면 명령어 옵션을 생략할 수 있습니다:

```bash
# 설정 파일의 기본값 사용
dart run beyond_flutter_cli.dart scaffold

# 설정 파일의 기본값 + 특정 옵션 추가
dart run beyond_flutter_cli.dart scaffold --with-auth --with-user
```

### 5. 명령어 옵션

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

**NEW in v0.2.0!** 다크 모드가 지원됩니다:

### 🌙 다크 모드 지원
- **시스템 테마 자동 감지**: 기기의 다크 모드 설정을 자동으로 따릅니다
- **수동 전환**: 앱 내에서 라이트/다크/시스템 모드를 선택할 수 있습니다
- **영구 저장**: SharedPreferences를 통해 테마 설정이 영구 저장됩니다
- **실시간 적용**: Provider 패턴으로 테마 변경이 즉시 반영됩니다

#### ThemeProvider 사용법
```dart
// 테마 상태 확인
final themeProvider = context.read<ThemeProvider>();
print(themeProvider.isDarkMode); // true/false
print(themeProvider.themeMode);  // ThemeMode.system/light/dark

// 테마 전환
themeProvider.setTheme(ThemeMode.dark);   // 다크 모드로 설정
themeProvider.setTheme(ThemeMode.light);  // 라이트 모드로 설정
themeProvider.setTheme(ThemeMode.system); // 시스템 설정 따르기
themeProvider.toggleTheme();              // 자동 전환
```

#### 홈 화면에 테마 토글 버튼 자동 포함
```dart
// AppBar에 자동으로 추가되는 테마 토글 버튼
Consumer<ThemeProvider>(
  builder: (context, themeProvider, child) {
    return IconButton(
      onPressed: () => themeProvider.toggleTheme(),
      icon: Icon(themeProvider.themeModeIcon),
      tooltip: '테마: ${themeProvider.themeModeText}',
    );
  },
)
```

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

### 🔐 인증 기능 (`--with-auth`)
CLI는 백엔드별로 완전한 인증 시스템을 자동 생성합니다:

#### 포함되는 화면들:
- **Login Screen**: 이메일/비밀번호 로그인, Google 로그인(Firebase)
- **Register Screen**: 회원가입 폼과 검증
- **Forgot Password Screen**: 비밀번호 재설정

#### 기능들:
- Clean Architecture 기반 완전한 인증 플로우
- 실시간 인증 상태 관리 및 스트림
- 자동 토큰 관리 (REST API)
- 에러 처리 및 사용자 피드백

### 👤 사용자 프로필 기능 (`--with-user`)
CLI는 백엔드별로 완전한 사용자 프로필 관리 시스템을 자동 생성합니다:

#### 포함되는 화면들:
- **User Profile Screen**: 프로필 정보 보기, 수정/삭제 메뉴
- **Edit Profile Screen**: 프로필 수정 폼 (이름, 전화번호, 프로필 사진)

#### 기능들:
```dart
// 사용자 프로필 엔티티
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    Map<String, dynamic>? customClaims,
    required DateTime createdAt,
    DateTime? lastSignInAt,
    DateTime? updatedAt,
  }) = _UserProfile;
}
```

#### 백엔드별 특징:
- **Firebase**: Firestore 실시간 동기화, Timestamp 자동 변환
- **Supabase**: PostgreSQL Row Level Security, 실시간 구독
- **REST API**: HTTP 기반 CRUD, 토큰 인증, 스트림 에뮬레이션

### Provider 기반 상태 관리
```dart
class UserProvider extends ChangeNotifier {
  // 실시간 사용자 프로필 스트림 구독
  // CRUD 작업: 조회/수정/삭제
  // 로딩/에러 상태 관리
  // ServiceLocator 의존성 주입
}
```

### UI 구성 요소
- **Material Design 3** 기반 컴포넌트
- **RefreshIndicator**로 Pull-to-Refresh
- **PopupMenuButton**으로 컨텍스트 메뉴
- **AlertDialog**로 삭제 확인
- **SnackBar**로 피드백 메시지
- **CircleAvatar**로 프로필 사진 표시
- **Form Validation**으로 입력 검증

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

## 🆕 최신 업데이트 (v0.2.3)

### ✨ 새로운 기능들

#### 1. 🌊 **Riverpod 통합 지원**
```yaml
dependencies:
  # 기존 Provider와 함께 Riverpod 지원
  provider: ^6.1.2
  flutter_riverpod: ^2.6.1  # 새로 추가!
```

**주요 특징:**
- 🔄 **동시 지원**: Provider와 Riverpod을 모두 사용할 수 있어 점진적 마이그레이션 가능
- ⚡ **현대적 상태 관리**: Riverpod의 타입 안전성과 성능 최적화 활용
- 🧩 **유연한 선택**: 프로젝트 요구사항에 따라 적절한 상태 관리 도구 선택 가능

#### 2. 🔧 **Supabase DI 시스템 완전 구현**
```dart
// 실제 동작하는 의존성 주입 시스템
static Future<void> _registerExternalServices() async {
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
    debug: EnvironmentConfig.enableLogging,
  );
  
  getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);
  getIt.registerSingleton<GoTrueClient>(Supabase.instance.client.auth);
}
```

**개선사항:**
- ✅ **완전한 구현**: TODO 주석에서 실제 동작하는 코드로 전환
- 🏗️ **실용적 DI**: SharedPreferences, Dio, Supabase 클라이언트 자동 등록
- 🔍 **디버그 로깅**: 개발 환경에서 상세한 로그 제공
- 🛡️ **에러 처리**: 타입 안전한 서비스 조회 및 예외 처리

#### 3. 📦 **개선된 pubspec.yaml 템플릿**
모든 백엔드 타입의 프로젝트 스캐폴드에 최신 의존성 추가:
- `flutter_riverpod: ^2.6.1` 추가
- 기존 Provider와 공존하여 단계적 전환 지원
- 최신 버전의 패키지들로 업데이트

## 🐛 이전 수정 사항 (v0.2.2)

### ✅ 해결된 버그들

#### 1. 🔧 **Global 설치 시 Brick 템플릿 로딩 오류 해결**
```bash
# 이전: "Brick template not found" 오류 발생
# 현재: 모든 설치 방법에서 정상 작동
❌ Error creating scaffold
🔧 Error: Brick template not found

# 해결됨! ✅
📱 Creating Flutter project...
✅ Flutter project created successfully!
✅ Project scaffold created successfully with supabase backend!
```

**수정 내용:**
- 🎯 **설치 방법 구분**: Git 설치와 로컬 경로 설치를 정확히 구분
- 📁 **경로 해결 개선**: 스냅샷 실행 시 프로젝트 루트를 올바르게 찾도록 수정
- 🔍 **디버깅 강화**: `--verbose` 플래그로 상세한 경로 정보 제공
- ⚡ **안정성 향상**: 두 가지 설치 방법에서 모두 안정적으로 작동

**지원하는 설치 방법:**
```bash
# 방법 1: Git에서 직접 설치
dart pub global activate --source git https://github.com/beyondchasm/beyondFlutterCli.git

# 방법 2: 로컬 경로에서 설치 (개발용)
dart pub global activate --source path /path/to/beyondFlutterCli
```

#### 2. 프로젝트 이름 검증 오류 해결 (v0.2.1)
```bash
# 이전: "beyondBookLog is not a valid Dart package name" 오류 발생
# 현재: 자동으로 유효한 패키지명으로 변환
Directory: "beyondBookLog" → Package name: "beyond_book_log"
Directory: "MyApp123" → Package name: "my_app123"
Directory: "2024Project" → Package name: "app_2024_project"
```

**특징:**
- 🔄 **자동 변환**: 대소문자, 특수문자, 숫자로 시작하는 이름 모두 처리
- 📝 **사용자 알림**: 변환된 이름을 명확히 표시
- 🛡️ **예약어 처리**: Dart 예약어 충돌 방지
- ✨ **빈 이름 처리**: 빈 이름은 'flutter_app'으로 기본 설정

#### 3. Flutter 호환성 개선 (v0.2.1)
```bash
# 이전: "The ios-language option is deprecated" 경고 발생
# 현재: 최신 Flutter 버전과 완벽 호환
```

**개선사항:**
- 🗑️ **Deprecated 옵션 제거**: `--ios-language` 옵션 완전 제거
- 🔧 **최신 Flutter 지원**: Flutter 3.8.1+ 버전과 호환
- ⚡ **깔끔한 실행**: 불필요한 경고 메시지 제거

#### 4. 사용자 경험 개선
```bash
# 더 친화적인 오류 메시지와 해결 방법 제시
⚠️  Directory name "beyondBookLog" is not a valid Dart package name
🔄 Using sanitized name: "beyond_book_log"
✅ Flutter project created successfully!
```

**개선사항:**
- 💬 **명확한 피드백**: 사용자에게 무엇이 변경되었는지 명확히 알림
- 🎯 **자동 처리**: 사용자 개입 없이 자동으로 문제 해결
- 🚀 **끊김 없는 실행**: 오류로 인한 실행 중단 방지

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