# Flutter Clean Architecture App

Beyond Flutter CLI로 생성된 Clean Architecture 기반 Flutter 앱입니다.

## 🏗 프로젝트 구조

```
lib/
├── main.dart                    # 앱 진입점
├── main/
│   └── init_app.dart           # 앱 초기화 및 설정
├── core/                       # 공통 기능 모듈
│   ├── theme/                  # 테마 관리
│   ├── config/                 # 앱 설정
│   ├── routes/                 # 라우팅 시스템
│   └── di/                     # 의존성 주입
└── features/                   # 기능별 모듈
    └── [feature_name]/
        ├── data/               # 데이터 레이어
        ├── domain/             # 도메인 레이어
        └── presentation/       # 프레젠테이션 레이어
```

## 🚀 시작하기

### 1. 의존성 설치
```bash
flutter pub get
```

### 2. 코드 생성 (Freezed)
```bash
dart run build_runner build
```

### 3. 앱 실행
```bash
flutter run
```

## 🔧 코드 생성

이 프로젝트는 Freezed를 사용하여 불변 클래스를 생성합니다.

### 새로운 변경사항 적용
```bash
# 한 번만 빌드
dart run build_runner build

# 변경사항 감지하여 자동 빌드
dart run build_runner watch

# 기존 생성 파일 삭제 후 다시 빌드
dart run build_runner build --delete-conflicting-outputs
```

## 📁 Generated Files

Freezed로 생성된 파일들은 각 모델의 `freezed/` 서브디렉토리에 저장됩니다:

- `*.freezed.dart`: Freezed 생성 파일
- `*.g.dart`: JSON serialization 생성 파일

## 🛠 개발 가이드

### 새로운 Feature 추가
Beyond Flutter CLI를 사용하여 새로운 기능을 추가할 수 있습니다:

```bash
dart run path/to/beyond_flutter_cli/bin/beyond_flutter_cli.dart feature [feature_name]
```

### Model 수정 시 주의사항
Freezed 모델을 수정한 후에는 반드시 코드 생성을 실행해야 합니다:

```bash
dart run build_runner build
```

## 🎨 테마

앱의 테마는 `lib/core/theme/` 디렉토리에서 관리됩니다:
- `app_theme.dart`: 메인 테마 설정
- `theme_colors.dart`: 색상 팔레트
- `theme_text_styles.dart`: 텍스트 스타일

## 🗺 라우팅

GoRouter를 사용한 선언적 라우팅:
- `lib/core/routes/app_router.dart`: 라우터 설정
- `lib/core/routes/route_names.dart`: 라우트 이름 상수

## 💉 의존성 주입

GetIt을 사용한 의존성 주입:
- `lib/core/di/dependencies_injection.dart`: DI 설정
- `lib/core/di/service_locator.dart`: 서비스 로케이터

## 📱 상태 관리

Provider 패턴을 사용한 상태 관리:
- 각 Feature의 `presentation/providers/` 디렉토리에 위치
- ServiceLocator를 통한 의존성 주입

## 🔍 트러블슈팅

### 빌드 오류
```bash
# 캐시 정리
flutter clean
flutter pub get
dart run build_runner clean

# 다시 빌드
dart run build_runner build --delete-conflicting-outputs
```

### IDE 오류
생성된 파일이 인식되지 않는 경우:
1. IDE 재시작
2. `dart run build_runner build` 실행
3. 프로젝트 다시 열기