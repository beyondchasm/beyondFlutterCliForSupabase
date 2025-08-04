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
- 🔐 **완전한 인증 시스템**: 로그인, 회원가입, 비밀번호 재설정
- 👤 **사용자 프로필 관리**: CRUD 기능이 포함된 사용자 관리 시스템
- 🚀 **Supabase 통합**: 실시간 데이터베이스, 인증, 스토리지
- 📱 **현업 수준 UI**: Material Design 3 기반 완성된 화면들
- 🎯 **UseCase 패턴**: 비즈니스 로직의 명확한 분리
- 🎨 **테마 시스템**: 다크/라이트 모드 지원
- 📐 **상태 관리**: Provider/Riverpod 지원
- 🧭 **라우팅**: GoRouter 기반 선언적 라우팅
- 🔧 **의존성 주입**: GetIt을 활용한 DI 컨테이너

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
dart run build_runner build
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
beyond scaffold [--org ORG] [--with-auth] [--with-user] [--with-onboarding]
```

**옵션:**
- `--org`: 조직명 (예: com.mycompany)
- `--with-auth`: 인증 기능 포함 (로그인, 회원가입, 비밀번호 재설정)
- `--with-user`: 사용자 프로필 기능 포함 (프로필 조회, 수정)
- `--with-onboarding`: 온보딩 화면 포함 (앱 소개 슬라이드)

#### `beyond feature`
새로운 기능 모듈을 생성합니다. **자동으로 의존성 주입(DI)에 등록됩니다.**

```bash
beyond feature <feature_name>
```

**예시:**
```bash
beyond feature product      # 상품 관리 기능
beyond feature order        # 주문 관리 기능
beyond feature notification # 알림 기능

# 생성되는 파일들:
# - Domain Layer: Entity, Repository, UseCases
# - Data Layer: Models, DataSources, RepositoryImpl
# - Presentation Layer: Provider, Screens
# - 자동 DI 등록 (GetIt)
```

**🔧 자동 DI 등록 기능:**
- Mason Hook을 통해 feature 생성 시 `dependencies_injection.dart` 자동 업데이트
- Import 구문, DataSource, Repository, UseCase, Provider 등록 코드 자동 생성
- 수동 등록 작업 불필요

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
│   │   └── dependencies_injection.dart  # GetIt 기반 DI 컨테이너
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
│   ├── auth/              # 인증 기능
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
│   └── user/              # 사용자 기능
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

**기능:**
- 이메일/비밀번호 로그인
- 소셜 로그인 (Google, Apple 지원 준비)
- 이메일 인증
- 비밀번호 재설정
- 자동 로그인 상태 관리

### 3. User Feature

사용자 프로필 관리 시스템을 제공합니다.

**포함된 화면:**
- 사용자 프로필 화면 (`UserProfileScreen`)
- 프로필 편집 화면 (`EditProfileScreen`)

**포함된 UseCase:**
- `GetUserProfileUseCase`: 프로필 조회
- `UpdateUserProfileUseCase`: 프로필 업데이트
- `DeleteUserProfileUseCase`: 프로필 삭제

### 4. Generic Feature

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

### 의존성 주입 (DI) 구조

프로젝트는 **GetIt**을 사용한 의존성 주입 패턴을 구현합니다:

```dart
// lib/core/di/dependencies_injection.dart
class DependenciesInjection {
  static Future<void> init() async {
    // 1. Core Services (SharedPreferences, Dio, etc.)
    await _registerCoreServices();
    
    // 2. Data Sources (Mason Hook으로 자동 등록)
    _registerDataSources();
    
    // 3. Repositories (Mason Hook으로 자동 등록)
    _registerRepositories();
    
    // 4. Use Cases (Mason Hook으로 자동 등록)
    _registerUseCases();
    
    // 5. Providers (Mason Hook으로 자동 등록)
    _registerProviders();
    
    // 6. External Services (Supabase 클라이언트 등록)
    await _registerExternalServices();
  }
}
```

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
    
    // 3. 의존성 주입 초기화
    await DependenciesInjection.init();
    
    // 4. 추가 초기화 로직
  }
}
```

**🔄 초기화 순서가 중요한 이유:**
- Supabase는 DI 등록 전에 초기화되어야 함
- Supabase 클라이언트를 DI 컨테이너에 등록하기 위해

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

# 3. 기본 프로젝트 + 인증 + 사용자 기능 생성
beyond scaffold --org com.mycompany.ecommerce --with-auth --with-user

# 4. 추가 기능 생성
beyond feature product
beyond feature cart
beyond feature order

# 5. 의존성 설치 및 코드 생성
flutter pub get
dart run build_runner build

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
# Freezed 모델 생성
dart run build_runner build

# 지속적 감시 모드
dart run build_runner watch
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
