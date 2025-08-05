import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:beyond_flutter_cli_for_supabase/src/commands/feature_command.dart';
import 'package:beyond_flutter_cli_for_supabase/src/commands/init_command.dart';
import 'package:beyond_flutter_cli_for_supabase/src/commands/scaffold_command.dart';

/// Beyond Flutter CLI for Supabase
///
/// 이 CLI는 Clean Architecture 패턴을 따르는 Flutter 프로젝트를
/// Supabase 백엔드와 함께 빠르게 생성할 수 있는 도구입니다.
///
/// 주요 기능:
/// - scaffold: 전체 프로젝트 구조 생성
/// - feature: 새로운 기능 모듈 생성
/// - init: 설정 파일 초기화
void main(List<String> args) async {
  // CommandRunner 인스턴스 생성
  // 'beyond'는 CLI 도구의 이름이고, 설명문은 help 출력 시 표시됩니다
  final runner =
      CommandRunner<int>(
          'beyond',
          'A CLI for creating Flutter projects with Supabase.',
        )
        // 각 명령어를 CommandRunner에 등록
        // 사용자가 'beyond scaffold', 'beyond feature', 'beyond init'를 실행할 수 있게 됩니다
        ..addCommand(ScaffoldCommand())
        ..addCommand(FeatureCommand())
        ..addCommand(InitCommand());

  try {
    // 명령어 실행 및 종료 코드 반환
    // args는 사용자가 입력한 명령줄 인수들입니다
    final exitCode = await runner.run(args);

    // 정상적으로 실행되었으면 종료 코드로 프로그램 종료
    // null인 경우 1(에러)로 종료
    exit(exitCode ?? 1);
  } on UsageException catch (e) {
    // 잘못된 사용법이나 명령어 오류 시 처리
    // 에러 메시지를 출력하고 64번 코드로 종료 (명령줄 사용법 오류)
    print(e);
    exit(64);
  }
}
