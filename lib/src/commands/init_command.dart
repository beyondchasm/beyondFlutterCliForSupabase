import 'dart:io';
import 'package:args/command_runner.dart';

/// CLI 설정 파일을 초기화하는 명령어 클래스
/// 
/// 이 명령어는 현재 디렉토리에 'beyond_cli.yaml' 설정 파일을 생성합니다.
/// 설정 파일에는 다음과 같은 기본값들이 포함됩니다:
/// - 조직명 (org)
/// - 사용할 프로그래밍 언어 (languages)
/// - 기본 기능 설정 (features)
class InitCommand extends Command<int> {
  @override
  final name = 'init';
  @override
  final description = 'Initializes a new configuration file.';

  /// InitCommand 생성자
  /// --force 플래그를 추가하여 기존 설정 파일을 덮어쓸 수 있도록 합니다
  InitCommand() {
    // --force 플래그 추가: 기존 설정 파일이 있어도 강제로 덮어씁니다
    argParser.addFlag('force', negatable: false, help: 'Force overwrite of existing config file.');
  }

  @override
  Future<int> run() async {
    // 명령줄 인수에서 --force 플래그 값을 가져옵니다
    final force = argResults!['force'] as bool;
    
    // 생성할 설정 파일명
    const configFileName = 'beyond_cli.yaml';
    final configFile = File(configFileName);

    // 기존 파일이 있고 --force 플래그가 없으면 오류 반환
    if (await configFile.exists() && !force) {
      print('Configuration file already exists: $configFileName');
      print('Use --force to overwrite.');
      return 1;
    }

    // 기본 설정 내용
    // YAML 형식으로 작성되며, 다음과 같은 기본값들을 포함합니다:
    // - org: 패키지명에 사용될 조직명
    // - languages: Android와 iOS에서 사용할 프로그래밍 언어
    // - features: 기본적으로 포함할 기능들 (인증, 사용자 관리)
    const configContent = '''# Beyond Flutter CLI (Supabase) Configuration

# Default organization name (used for package names)
org: com.example

# Default programming languages
languages:
  android: kotlin
  ios: swift

# Default features to include
features:
  auth: false
  user: false
''';

    // 설정 파일을 디스크에 작성
    await configFile.writeAsString(configContent);
    print('Configuration file created: $configFileName');
    return 0; // 성공 코드 반환
  }
}
