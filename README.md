# Beyond Flutter CLI for Supabase

> A powerful CLI tool for creating Flutter projects with Clean Architecture pattern and Supabase backend integration

[![Version](https://img.shields.io/badge/version-0.2.61-blue.svg)](https://pub.dev/packages/beyond_flutter_cli_for_supabase)
[![Dart SDK](https://img.shields.io/badge/dart-%3E%3D3.8.1-blue.svg)](https://dart.dev)
[![Flutter](https://img.shields.io/badge/flutter-%3E%3D3.8.1-blue.svg)](https://flutter.dev)

## 📋 목차

- [개요](#-개요)
- [특징](#-특징)
- [설치](#-설치)
- [빠른 시작](#-빠른-시작)
- [사용법](#-사용법)
- [프로젝트 구조](#-프로젝트-구조)
- [브릭(Bricks) 상세](#-브릭bricks-상세)
- [설정](#-설정)
- [예제](#-예제)
- [기여하기](#-기여하기)

## 🌟 개요

Beyond Flutter CLI는 Flutter 앱을 Clean Architecture 패턴과 Supabase 백엔드로 빠르게 구축할 수 있는 CLI 도구입니다. Mason CLI를 기반으로 하여 일관된 코드 구조와 최신 Flutter 개발 패턴을 제공합니다.

## ✨ 특징

- 🏗️ **Clean Architecture 패턴**: Data, Domain, Presentation 계층 분리
- 🔐 **완전한 인증 시스템**: 로그인, 회원가입, 비밀번호 재설정, 소셜 로그인
- 👤 **고급 사용자 프로필**: 이미지 업로드, 실시간 업데이트, 프로필 완성도 표시
- ⚙️ **완전한 설정 시스템**: 30+ 설정 옵션, 테마/언어/알림/보안 설정
- 🚀 **Supabase 통합**: 실시간 데이터베이스, 인증, 스토리지
- 📱 **현업 수준 UI**: Material Design 3 기반 완성된 화면들
- 🎯 **UseCase 패턴**: 비즈니스 로직의 명확한 분리
- 🎨 **테마 시스템**: 다크/라이트 모드 지원
- 📐 **상태 관리**: Provider/Riverpod 지원
- 🧭 **라우팅**: GoRouter 기반 선언적 라우팅
- 🔧 **의존성 주입**: Injectable 어노테이션 기반 자동 DI 시스템

## 📦 설치

### 전역 설치 (권장)

```bash
dart pub global activate beyond_flutter_cli_for_supabase
```

### Git에서 설치

```bash
dart pub global activate --source git https://github.com/beyondchasm/beyondFlutterCli.git
```

### 로컬 설치

```bash
git clone https://github.com/beyondchasm/beyondFlutterCli.git
cd beyond_flutter_cli_for_supabase
dart pub get
dart pub global activate --source path .
```

### 설치 확인

```bash
beyond --help
```

## 🚀 빠른 시작

### 1. 새 프로젝트 생성

```bash
# 새 디렉토리 생성 및 이동
mkdir my_awesome_app
cd my_awesome_app

# CLI 설정 초기화
beyond init

# 프로젝트 스캐폴드 생성 (인증 + 사용자 기능 포함)
beyond scaffold --org com.mycompany --with-auth --with-user
```

### 2. Supabase 설정

1. [Supabase](https://supabase.com)에서 새 프로젝트 생성
2. `lib/core/config/supabase_config.dart` 파일에서 설정 업데이트:

```dart
static const String supabaseUrl = 'https://your-project-id.supabase.co';
static const String supabaseAnonKey = 'your-anon-key';
```

### 3. 앱 실행

```bash
flutter pub get
dart run build_runner build  # Injectable DI 및 코드 생성
flutter run
```

## 📖 사용법

### 사용 가능한 명령어

#### `beyond init`
설정 파일(`beyond_cli.yaml`)을 생성합니다.

```bash
beyond init [--force]
```

**옵션:**
- `--force`: 기존 설정 파일을 덮어씁니다

#### `beyond scaffold`
새 Flutter 프로젝트의 기본 구조를 생성합니다.

```bash
beyond scaffold [--org ORG] [--with-auth] [--with-user] [--with-settings] [--with-onboarding]
```

**옵션:**
- `--org`: 조직명 (예: com.mycompany)
- `--with-auth`: 인증 기능 포함 (로그인, 회원가입, 비밀번호 재설정, 소셜 로그인)
- `--with-user`: 사용자 프로필 기능 포함 (프로필 조회, 수정, 이미지 업로드)
- `--with-settings`: 앱 설정 기능 포함 (30+ 설정 옵션, 테마/언어/알림/보안)
- `--with-onboarding`: 온보딩 화면 포함 (앱 소개 슬라이드)

#### `beyond feature`
새로운 기능 모듈을 생성합니다. **Injectable 어노테이션으로 자동 DI 등록됩니다.**

```bash
beyond feature <feature_name>
```

**예시:**
```bash
beyond feature product      # 상품 관리 기능
beyond feature order        # 주문 관리 기능
beyond feature notification # 알림 기능
beyond feature settings     # 앱 설정 기능 (완전한 설정 시스템)

# 생성되는 파일들:
# - Domain Layer: Entity, Repository, UseCases
# - Data Layer: Models, DataSources, RepositoryImpl
# - Presentation Layer: Provider, Screens
# - Injectable 어노테이션으로 자동 DI 등록
```

**🔧 Injectable 기반 DI 시스템:**
- `@LazySingleton`, `@injectable` 어노테이션 사용
- `dart run build_runner build`로 DI 코드 자동 생성
- 수동 등록 작업 완전 불필요
- 컴파일 타임 의존성 검증

### 설정 파일 (`beyond_cli.yaml`)

```yaml
# 기본 조직명
org: com.example

# 언어 설정
languages:
  android: kotlin  # java 또는 kotlin
  ios: swift       # objc 또는 swift

# 기본 기능
features:
  auth: false      # 인증 기능 포함
  user: false      # 사용자 프로필 기능 포함
```

## 🏗️ 프로젝트 구조

생성된 프로젝트는 다음과 같은 구조를 가집니다:

```
lib/
├── core/                    # 공통 기능
│   ├── config/             # 앱 설정
│   │   ├── app_config.dart
│   │   ├── environment.dart
│   │   └── supabase_config.dart
│   ├── di/                 # 의존성 주입
│   │   ├── dependencies_injection.dart  # Injectable DI 초기화
│   │   ├── service_locator.dart         # GetIt 래퍼 클래스
│   │   └── injection.config.dart        # 자동 생성 DI 코드
│   ├── routes/             # 라우팅
│   │   ├── app_router.dart
│   │   └── route_names.dart
│   ├── screens/            # 공통 화면
│   │   ├── home_screen.dart
│   │   └── splash_screen.dart
│   └── theme/              # 테마
│       ├── app_theme.dart
│       ├── theme_colors.dart
│       ├── theme_provider.dart
│       └── theme_text_styles.dart
├── features/               # 기능별 모듈
│   ├── auth/              # 인증 기능 (고급 보안, 소셜 로그인)
│   │   ├── data/
│   │   │   ├── remote/
│   │   │   │   ├── data_sources/
│   │   │   │   └── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── use_cases/
│   │   └── presentation/
│   │       ├── providers/
│   │       └── screens/
│   ├── user/              # 사용자 기능 (프로필 이미지, 완성도)
│   │   └── [similar structure]
│   └── settings/          # 설정 기능 (30+ 설정 옵션)
│       └── [similar structure]
├── main/                  # 앱 초기화
│   ├── init_app.dart
│   └── observers.dart
└── main.dart
```

## 🧱 브릭(Bricks) 상세

### 1. Project Scaffold

기본 프로젝트 구조와 필수 의존성을 생성합니다.

**포함 내용:**
- Clean Architecture 폴더 구조
- 핵심 의존성 (Provider, GoRouter, GetIt, Supabase 등)
- 테마 시스템
- 라우팅 설정
- 의존성 주입 설정

### 2. Auth Feature

완전한 인증 시스템을 제공합니다.

**포함된 화면:**
- 로그인 화면 (`LoginScreen`)
- 회원가입 화면 (`RegisterScreen`)
- 비밀번호 재설정 화면 (`ForgotPasswordScreen`)

**포함된 UseCase:**
- `SignInUseCase`: 로그인
- `SignUpUseCase`: 회원가입
- `SignOutUseCase`: 로그아웃
- `ResetPasswordUseCase`: 비밀번호 재설정
- `GetCurrentUserUseCase`: 현재 사용자 정보 조회

**고급 기능:**
- 🔐 **강화된 인증**: 이메일/비밀번호 + 소셜 로그인 (Google, Apple)
- 🛡️ **보안 강화**: 비밀번호 강도 체크, 실시간 검증
- 📧 **이메일 검증**: 회원가입 시 이메일 인증 필수
- 🔄 **자동 로그인**: 세션 관리 및 토큰 갱신
- ❌ **고급 에러 처리**: 8가지 에러 타입별 맞춤 UI
- 🎨 **전문적 UI**: Material Design 3, 다크모드 지원
- ⚡ **실시간 피드백**: 입력 검증, 로딩 상태, 진행률 표시

### 3. User Feature

사용자 프로필 관리 시스템을 제공합니다.

**포함된 화면:**
- 사용자 프로필 화면 (`UserProfileScreen`) - 프로필 완성도 표시, 상세 정보
- 고급 프로필 편집 화면 (`EnhancedEditProfileScreen`) - 15+ 필드, 실시간 검증

**포함된 UseCase:**
- `GetUserProfileUseCase`: 프로필 조회 및 실시간 스트리밍
- `CreateUserProfileUseCase`: 신규 프로필 생성
- `UpdateUserProfileUseCase`: 프로필 업데이트 with 검증
- `DeleteUserProfileUseCase`: 프로필 삭제
- `UploadProfileImageUseCase`: 프로필 이미지 업로드 (Supabase Storage)
- `SearchUserProfilesUseCase`: 사용자 검색

**고급 기능:**
- 📸 **프로필 이미지 관리**: 카메라/갤러리 선택, 업로드, 삭제
- 📊 **프로필 완성도**: 실시간 완성률 계산 및 시각적 표시
- 🔍 **사용자 검색**: 이름, 이메일 기반 사용자 검색
- ✅ **실시간 검증**: 이메일, 전화번호, URL 형식 검증
- 🎂 **개인정보**: 생년월일, 성별, 위치, 관심사, 소셜 링크
- 🔒 **프라이버시**: 공개/친구만/비공개 설정

### 4. Settings Feature

완전한 앱 설정 관리 시스템을 제공합니다.

**포함된 설정 카테고리:**
- 🎨 **외관**: 테마 모드, 언어 (8개 언어), Material You 색상
- 🔔 **알림**: 푸시/이메일/인앱 알림, 사운드, 진동 설정
- 🔒 **보안**: 생체 인증, 자동 잠금, 분석/크래시 리포팅
- 💾 **데이터**: 자동 백업, 동기화 주기, WiFi 전용, 캐시 관리
- ♿ **접근성**: 텍스트 크기, 고대비 모드, 애니메이션 줄이기
- ℹ️ **정보**: 버전, 개인정보처리방침, 고객 지원

**고급 기능:**
- 📱 **실시간 적용**: 설정 변경 시 즉시 UI 반영
- 💾 **영속 저장**: SharedPreferences 기반 로컬 저장
- 📤 **가져오기/내보내기**: JSON 포맷으로 설정 백업/복원
- 🔄 **기본값 리셋**: 한 번에 모든 설정 초기화
- 🎛️ **30+ 설정 옵션**: 완전한 앱 커스터마이징
- 🌍 **다국어 지원**: 8개 언어 + 시스템 언어 자동 감지

### 5. Generic Feature

커스텀 기능을 위한 템플릿을 제공합니다.

**생성되는 구조:**
- Data Layer (Remote/Local DataSource, Models, Repository 구현)
- Domain Layer (Entities, Repository 인터페이스, UseCases)
- Presentation Layer (Provider, Screen)

## ⚙️ 설정

### Supabase 설정

1. **프로젝트 생성**: [Supabase Dashboard](https://app.supabase.com)에서 새 프로젝트 생성

2. **API 키 획득**: Settings > API > Project URL과 anon public key 복사

3. **설정 업데이트**: `lib/core/config/supabase_config.dart` 파일 수정:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://xxxxx.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
  
  // ... 나머지 코드
}
```

4. **데이터베이스 테이블 생성** (인증 기능 사용 시):

```sql
-- 사용자 프로필 테이블
CREATE TABLE profiles (
  id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  username TEXT UNIQUE,
  full_name TEXT,
  avatar_url TEXT,
  website TEXT,

  CONSTRAINT username_length CHECK (char_length(username) >= 3)
);

-- Row Level Security 활성화
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- 정책 생성
CREATE POLICY "Public profiles are viewable by everyone." ON profiles
  FOR SELECT USING (true);

CREATE POLICY "Users can insert their own profile." ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile." ON profiles
  FOR UPDATE USING (auth.uid() = id);
```

### Injectable 기반 의존성 주입 (DI) 구조

프로젝트는 **Injectable 어노테이션**과 **GetIt**을 사용한 자동 의존성 주입 시스템을 구현합니다:

```dart
// lib/core/di/service_locator.dart - GetIt 래퍼 클래스
class ServiceLocator {
  static final GetIt _getIt = GetIt.instance;
  
  @injectableInit
  static GetIt configure(String environment) => _getIt.init(
    environmentFilter: NoEnvOrContainsAll({environment}),
  );
  
  static T get<T extends Object>() => _getIt.get<T>();
  // ... 추가 메서드들
}

// lib/core/di/dependencies_injection.dart - Injectable DI 초기화
@InjectableInit()
class DependenciesInjection {
  static Future<void> init() async {
    // 1. Core Services (SharedPreferences, Dio, etc.)
    await _registerCoreServices();
    
    // 2. External Services (Supabase 클라이언트 등록)
    await _registerExternalServices();
    
    // 3. Injectable 자동 등록
    ServiceLocator.configure(Environment.prod);
  }
}

// 클래스별 어노테이션 예시
@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository { ... }

@injectable
class UserProvider extends ChangeNotifier { ... }

@lazySingleton
class GetUserUseCase { ... }
```

**🚀 Injectable 시스템의 장점:**
- **컴파일 타임 검증**: 의존성 누락 시 빌드 에러
- **자동 코드 생성**: `dart run build_runner build`로 DI 코드 자동 생성
- **어노테이션 기반**: 클래스 선언 시점에 DI 등록 정보 명시
- **타입 안전성**: 컴파일 타임에 의존성 그래프 검증
- **개발자 경험**: 수동 등록 코드 작성 불필요
- **build.yaml 설정**: Injectable 코드 생성 자동 설정 포함

### 앱 초기화 순서

앱 초기화는 다음 순서로 진행됩니다:

```dart
// lib/main/init_app.dart
class InitApp {
  static Future<void> initialize() async {
    // 1. Flutter 바인딩 초기화
    WidgetsFlutterBinding.ensureInitialized();
    
    // 2. Supabase 초기화 (DI보다 먼저)
    await SupabaseConfig.initialize();
    
    // 3. Injectable 기반 의존성 주입 초기화
    await DependenciesInjection.init();
    
    // 4. 추가 초기화 로직
  }
}
```

**🔄 초기화 순서가 중요한 이유:**
- Supabase는 DI 등록 전에 초기화되어야 함
- Injectable이 Supabase 클라이언트를 DI 컨테이너에 자동 등록
- `injection.config.dart` 파일이 자동 생성되어 모든 의존성 관리

### Injectable 어노테이션 가이드

생성되는 코드에서 사용되는 Injectable 어노테이션들과 그 역할:

```dart
// 1. DataSource 구현체 - 인터페이스로 등록되는 Lazy Singleton
@LazySingleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final SupabaseClient supabaseClient;
  
  UserRemoteDataSourceImpl(@Named('supabaseClient') this.supabaseClient);
}

// 2. Repository 구현체 - 인터페이스로 등록되는 Lazy Singleton
@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  
  UserRepositoryImpl(this.remoteDataSource);
}

// 3. UseCase - Lazy Singleton
@lazySingleton
class GetUserUseCase {
  final UserRepository repository;
  
  GetUserUseCase(this.repository);
}

// 4. Provider - Factory (매번 새 인스턴스)
@injectable
class UserProvider extends ChangeNotifier {
  final GetUserUseCase getUserUseCase;
  
  UserProvider(this.getUserUseCase);
}

// 5. External Services - Module로 등록
@module
abstract class ExternalServicesModule {
  @Named('supabaseClient')
  @singleton
  SupabaseClient get supabaseClient => Supabase.instance.client;
}
```

**어노테이션별 설명:**
- `@LazySingleton(as: Interface)`: 인터페이스로 등록되는 지연 초기화 싱글톤
- `@lazySingleton`: 지연 초기화 싱글톤 (첫 요청 시 생성)
- `@injectable`: Factory 등록 (매번 새 인스턴스 생성)
- `@singleton`: 즉시 초기화 싱글톤
- `@Named('name')`: 같은 타입의 여러 구현체 구분
- `@module`: 외부 라이브러리나 복잡한 초기화가 필요한 객체 등록

### 환경 변수 설정

민감한 정보는 환경 변수로 관리하는 것을 권장합니다:

```dart
// lib/core/config/environment.dart
class Environment {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project-id.supabase.co',
  );
  
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key',
  );
}
```

## 💡 예제

### 완전한 프로젝트 생성 예제

```bash
# 1. 새 프로젝트 디렉토리 생성
mkdir ecommerce_app
cd ecommerce_app

# 2. CLI 초기화
beyond init

# 3. 기본 프로젝트 + 인증 + 사용자 + 설정 기능 생성
beyond scaffold --org com.mycompany.ecommerce --with-auth --with-user --with-settings

# 4. 추가 기능 생성
beyond feature product
beyond feature cart
beyond feature order

# 5. 의존성 설치 및 Injectable DI 코드 생성
flutter pub get
dart run build_runner build  # injection.config.dart 자동 생성

# 6. 앱 실행
flutter run
```

### 커스텀 기능 추가 예제

```bash
# 제품 관리 기능 추가
beyond feature product

# 생성되는 파일들:
# lib/features/product/
# ├── data/
# │   ├── local/data_sources/product_local_data_source.dart
# │   ├── remote/data_sources/product_remote_data_source.dart
# │   └── repositories/product_repository_impl.dart
# ├── domain/
# │   ├── entities/product.dart
# │   ├── repositories/product_repository.dart
# │   └── use_cases/
# │       ├── create_product_usecase.dart
# │       ├── get_product_usecase.dart
# │       ├── update_product_usecase.dart
# │       └── delete_product_usecase.dart
# └── presentation/
#     ├── providers/product_provider.dart
#     └── screens/product_screen.dart
```

## 🎨 UI/UX 특징

### Material Design 3
- 최신 Material Design 3 가이드라인 준수
- 동적 색상 시스템
- 적응형 레이아웃

### 테마 시스템
```dart
// 라이트/다크 테마 자동 전환
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    notifyListeners();
  }
}
```

### 반응형 디자인
- 모바일, 태블릿, 데스크톱 지원
- 유연한 레이아웃 시스템
- 접근성 고려

## 🔧 개발자 도구

### 코드 생성
```bash
# Injectable DI 및 Freezed 모델 생성
dart run build_runner build

# 지속적 감시 모드 (개발 중 권장)
dart run build_runner watch

# 생성되는 파일들:
# - lib/core/di/injection.config.dart (Injectable DI 코드)
# - *.freezed.dart (Freezed 모델 코드)
# - *.g.dart (JSON 직렬화 코드)
```

### 린팅
```bash
# 코드 분석
flutter analyze

# 포맷팅
dart format .
```

### 테스트
```bash
# 단위 테스트
flutter test

# 통합 테스트
flutter test integration_test/
```

## 🤝 기여하기

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

## 🆘 지원

- 📖 [문서](https://github.com/beyondchasm/beyondFlutterCli/wiki)
- 🐛 [이슈 리포트](https://github.com/beyondchasm/beyondFlutterCli/issues)
- 💬 [토론](https://github.com/beyondchasm/beyondFlutterCli/discussions)

## 🙏 감사

- [Mason CLI](https://github.com/felangel/mason) - 코드 생성 도구
- [Supabase](https://supabase.com) - 백엔드 서비스
- [Flutter](https://flutter.dev) - UI 프레임워크

---

**Beyond Flutter CLI**로 더 빠르고 일관된 Flutter 개발을 경험해보세요! 🚀
