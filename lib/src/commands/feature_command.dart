import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;
import '../brick_finder.dart';

class FeatureCommand extends Command<int> {
  @override
  final name = 'feature';
  @override
  final description = 'Creates a new feature.';

  FeatureCommand() {
    // No specific options for now
  }

  @override
  Future<int> run() async {
    if (argResults!.rest.isEmpty) {
      print('Feature name is required.');
      return 1;
    }

    final featureName = argResults!.rest.first;

    try {
      final brickName = 'feature_supabase';
      final brickPath = await findBrickPath(brickName);
      final brick = Brick.path(brickPath);
      final generator = await MasonGenerator.fromBrick(brick);
      final target = DirectoryGeneratorTarget(Directory.current);

      await generator.generate(
        target,
        vars: <String, dynamic>{'feature_name': featureName},
      );

      // Hook 실행
      await _runPostGenHook(brickPath, target.dir, <String, dynamic>{
        'feature_name': featureName,
      });

      print('Feature "$featureName" created successfully.');
      return 0;
    } catch (e) {
      print('Error creating feature: $e');
      return 1;
    }
  }

  /// post_gen Hook을 실행하는 메서드
  Future<void> _runPostGenHook(String brickPath, Directory workingDir, Map<String, dynamic> vars) async {
    try {
      final hooksDir = Directory(path.join(brickPath, 'hooks'));
      final postGenFile = File(path.join(hooksDir.path, 'post_gen.dart'));
      
      if (!await postGenFile.exists()) {
        return; // Hook 파일이 없으면 건너뛰기
      }

      // Hook 실행을 위한 임시 Dart 프로젝트 생성
      final tempDir = Directory.systemTemp.createTempSync('mason_hook_');
      final tempPubspec = File(path.join(tempDir.path, 'pubspec.yaml'));
      final tempMainFile = File(path.join(tempDir.path, 'main.dart'));

      try {
        // 임시 pubspec.yaml 생성
        await tempPubspec.writeAsString('''
name: temp_hook
environment:
  sdk: ">=3.0.0 <4.0.0"
dependencies:
  mason: any
''');

        // Hook 파일 내용을 가져와서 실행 가능한 형태로 만들기
        final hookContent = await postGenFile.readAsString();
        final mainContent = '''
import 'dart:io';
import 'package:mason/mason.dart';

${hookContent.replaceAll('void run(HookContext context)', 'Future<void> runHook(HookContext context)')}

void main() async {
  final logger = Logger();
  final vars = ${_varsToString(vars)};
  final context = HookContext(
    vars: vars,
    logger: logger,
  );
  
  Directory.current = Directory(r'${workingDir.path}');
  await runHook(context);
}
''';

        await tempMainFile.writeAsString(mainContent);

        // dart pub get 실행
        final pubGetResult = await Process.run(
          'dart',
          ['pub', 'get'],
          workingDirectory: tempDir.path,
        );

        if (pubGetResult.exitCode != 0) {
          print('Warning: Failed to get dependencies for hook: ${pubGetResult.stderr}');
          return;
        }

        // Hook 실행
        final hookResult = await Process.run(
          'dart',
          ['run', 'main.dart'],
          workingDirectory: tempDir.path,
        );

        if (hookResult.exitCode != 0) {
          print('Warning: Hook execution failed: ${hookResult.stderr}');
        } else if (hookResult.stdout.toString().isNotEmpty) {
          print(hookResult.stdout);
        }
      } finally {
        // 임시 디렉토리 정리
        await tempDir.delete(recursive: true);
      }
    } catch (e) {
      print('Warning: Failed to run post_gen hook: $e');
    }
  }

  /// Map을 Dart 코드 문자열로 변환
  String _varsToString(Map<String, dynamic> vars) {
    final buffer = StringBuffer('<String, dynamic>{');
    vars.forEach((key, value) {
      if (value is String) {
        buffer.write("'$key': r'''$value''',");
      } else {
        buffer.write("'$key': $value,");
      }
    });
    buffer.write('}');
    return buffer.toString();
  }
}
