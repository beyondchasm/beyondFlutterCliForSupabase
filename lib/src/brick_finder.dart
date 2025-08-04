import 'dart:io';
import 'package:path/path.dart' as path;

/// Mason 브릭(템플릿) 파일의 경로를 찾는 유틸리티 함수
/// 
/// CLI가 전역 설치(로 실행되는지 로컬에서 실행되는지에 관계없이
/// 브릭 파일의 정확한 위치를 찾아주는 역할을 합니다.
/// 
/// [brickName]: 찾을 브릭의 이름 (예: 'auth_supabase', 'feature_supabase')
/// 반환값: 브릭 디렉토리의 절대 경로
Future<String> findBrickPath(String brickName) async {
  // 현재 실행 중인 스크립트의 경로를 가져옵니다
  final scriptPath = Platform.script.toFilePath();

  // .pub-cache가 경로에 포함되어 있으면 전역 설치로 간주
  // `dart pub global activate`로 설치된 경우
  if (scriptPath.contains('.pub-cache')) {
    return _findGlobalBrickPath(brickName);
  } else {
    // 로컬 개발 환경에서 실행되는 경우
    return _findLocalBrickPath(brickName, scriptPath);
  }
}

/// 전역 설치된 CLI에서 브릭 경로를 찾는 함수
/// 
/// pub cache 디렉토리에서 git 리포지토리를 찾고,
/// 그 안에서 beyond_flutter_cli_for_supabase 패키지를 찾아
/// 해당 브릭의 경로를 반환합니다.
Future<String> _findGlobalBrickPath(String brickName) async {
  // 사용자의 .pub-cache 디렉토리를 찾습니다
  final pubCacheDir = _findPubCacheDir();
  if (pubCacheDir == null) {
    throw Exception('Could not find .pub-cache directory.');
  }

  // .pub-cache 내의 git 디렉토리를 찾습니다
  // git 소스로 설치된 패키지들이 저장되는 곳
  final gitDir = Directory(path.join(pubCacheDir.path, 'git'));
  if (!await gitDir.exists()) {
    throw Exception('Git directory not found in .pub-cache.');
  }

  // git 디렉토리 내에서 beyond_flutter_cli_for_supabase를 포함한 디렉토리들을 찾습니다
  final beyondDirs = await gitDir
      .list()
      .where((entity) =>
          entity is Directory && entity.path.contains('beyond_flutter_cli_for_supabase'))
      .cast<Directory>()
      .toList();

  if (beyondDirs.isEmpty) {
    throw Exception(
        'beyond_flutter_cli_for_supabase git repository not found in pub-cache.');
  }

  // 가장 최근 버전을 사용 (보통 리스트의 마지막 요소)
  final packageDir = beyondDirs.last.path;
  final brickPath = path.join(packageDir, 'bricks', brickName);

  // 브릭 디렉토리가 실제로 존재하는지 확인
  if (!await Directory(brickPath).exists()) {
    throw Exception('Brick "$brickName" not found at path: $brickPath');
  }

  return brickPath;
}

/// 로컬 개발 환경에서 브릭 경로를 찾는 함수
/// 
/// 소스 코드에서 직접 실행할 때나 컴파일된 스냅샷에서 실행할 때
/// 프로젝트의 bricks 디렉토리에서 브릭을 찾습니다.
String _findLocalBrickPath(String brickName, String scriptPath) {
  String projectRoot;

  // 스크립트 경로를 기반으로 프로젝트 루트 결정
  if (scriptPath.contains('.dart_tool')) {
    // 컴파일된 스냅샷에서 실행 중 (`dart compile` 후)
    // .dart_tool 디렉토리 이전까지가 프로젝트 루트
    final dartToolIndex = scriptPath.indexOf('.dart_tool');
    projectRoot = scriptPath.substring(0, dartToolIndex);
  } else {
    // 소스에서 직접 실행 중 (`dart run`)
    // 스크립트 파일의 상위 두 단계 디렉토리가 프로젝트 루트
    projectRoot = path.dirname(path.dirname(scriptPath));
  }

  // 프로젝트 루트/bricks/brickName 경로 생성
  final brickPath = path.join(projectRoot, 'bricks', brickName);

  // 브릭 디렉토리가 실제로 존재하는지 확인
  if (!Directory(brickPath).existsSync()) {
    throw Exception('Brick "$brickName" not found at path: $brickPath');
  }

  return brickPath;
}

/// 사용자의 .pub-cache 디렉토리를 찾는 함수
/// 
/// 운영체제에 따라 다른 경로를 확인합니다:
/// - Unix/Linux/macOS: ~/.pub-cache
/// - Windows: %USERPROFILE%/AppData/Local/Pub/Cache
Directory? _findPubCacheDir() {
  // 환경 복수에서 홈 디렉토리 경로를 가져옵니다
  // HOME (Unix/Linux/macOS), USERPROFILE (Windows) 순서로 확인
  final homeDir = Platform.environment['HOME'] ??
      Platform.environment['USERPROFILE'] ??
      Directory.current.path; // 둘 다 없으면 현재 디렉토리 사용

  // 운영체제별 일반적인 .pub-cache 디렉토리 경로들
  final commonPaths = [
    path.join(homeDir, '.pub-cache'), // Unix/Linux/macOS
    path.join(homeDir, 'AppData', 'Local', 'Pub', 'Cache'), // Windows
  ];

  // 각 경로를 확인하여 존재하는 첫 번째 디렉토리를 반환
  for (final dirPath in commonPaths) {
    final dir = Directory(dirPath);
    if (dir.existsSync()) {
      return dir;
    }
  }

  // 어떤 경로에서도 .pub-cache를 찾을 수 없으면 null 반환
  return null;
}

