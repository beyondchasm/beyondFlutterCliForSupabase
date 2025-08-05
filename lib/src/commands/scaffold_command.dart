import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;
import '../brick_finder.dart';

class ScaffoldCommand extends Command<int> {
  @override
  final name = 'scaffold';
  @override
  final description = 'Creates a new Flutter project with a Supabase backend.';

  /// ScaffoldCommand 생성자
  /// 스캐폴드 생성 시 사용할 수 있는 옵션들을 정의합니다
  ScaffoldCommand() {
    argParser
      // 조직명 옵션: Flutter 프로젝트의 패키지명에 사용됩니다 (예: com.example)
      ..addOption('org', help: 'The organization name (e.g., com.example)')
      // 인증 기능 포함 플래그: 로그인, 회원가입, 비밀번호 재설정 기능을 포함합니다
      ..addFlag(
        'with-auth',
        help: 'Include authentication feature (login, signup, password reset)',
      )
      // 사용자 프로필 기능 포함 플래그: 사용자 프로필 관리 기능을 포함합니다
      ..addFlag('with-user', help: 'Include user profile management feature')
      // 온보딩 기능 포함 플래그: 앱 첫 실행 시 사용자 안내 화면을 포함합니다
      ..addFlag(
        'with-onboarding',
        help: 'Include onboarding screens for first-time users',
      );
  }

  @override
  Future<int> run() async {
    // 명령줄 인수에서 옵션값들을 추출합니다
    final org = argResults?['org'] as String?;
    final withAuth = argResults?['with-auth'] as bool? ?? false;
    final withUser = argResults?['with-user'] as bool? ?? false;
    final withOnboarding = argResults?['with-onboarding'] as bool? ?? false;
    const verbose = false; // 간단히 verbose를 비활성화

    try {
      final pubspecFile = File('pubspec.yaml');
      if (!await pubspecFile.exists()) {
        print('Creating Flutter project...');
        final currentDir = path.basename(Directory.current.path);
        final validProjectName = _validateAndSanitizeProjectName(currentDir);

        final createArgs = [
          'create',
          '.',
          '--empty',
          '--project-name',
          validProjectName,
        ];
        if (org != null) createArgs.addAll(['--org', org]);

        final createResult = await Process.run('flutter', createArgs);
        if (createResult.exitCode != 0) {
          print('Failed to create Flutter project: ${createResult.stderr}');
          return createResult.exitCode;
        }
        print('Flutter project created successfully!');
      }

      final brickPath = await findBrickPath('project_scaffold_supabase');
      final brick = Brick.path(brickPath);
      final generator = await MasonGenerator.fromBrick(brick);
      final target = DirectoryGeneratorTarget(Directory.current);

      await generator.generate(
        target,
        vars: <String, dynamic>{'with_auth': withAuth, 'with_user': withUser},
      );

      print('Project scaffold created successfully with Supabase backend!');

      // 선택된 기능들을 순차적으로 생성합니다
      if (withAuth) {
        print('\n🔐 Generating authentication feature...');
        await _generateFeature('auth', verbose);
      }

      if (withUser) {
        print('\n👤 Generating user profile feature...');
        await _generateFeature('user', verbose);
      }

      if (withOnboarding) {
        print('\n🚀 Generating onboarding feature...');
        await _generateFeature('onboarding', verbose);
      }

      // 완료 메시지와 다음 단계 안내
      print('\n🎉 Project scaffold created successfully!');
      print('\n📋 Next steps:');
      print('\n1. Configure Supabase:');
      print('   - Edit lib/core/config/supabase_config.dart');
      print('   - Add your Supabase project URL and anon key');
      print('\n2. Install dependencies and generate code:');
      print('   flutter pub get');
      print('   dart run build_runner build');
      print('\n3. Run your app:');
      print('   flutter run');

      // 생성된 기능들에 대한 안내
      if (withAuth || withUser || withOnboarding) {
        print('\n✨ Generated features:');
        if (withAuth)
          print('   🔐 Authentication (login, signup, password reset)');
        if (withUser) print('   👤 User profile management');
        if (withOnboarding) print('   🚀 Onboarding screens');
      }

      return 0;
    } catch (e) {
      print('Error creating scaffold: $e');
      return 1;
    }
  }

  /// 특정 기능을 생성하는 헬퍼 메서드
  ///
  /// [featureName]: 생성할 기능의 이름 (auth, user, onboarding 등)
  /// [verbose]: 상세한 로그 출력 여부
  Future<void> _generateFeature(String featureName, bool verbose) async {
    try {
      // 브릭 이름 생성: featureName + '_supabase' 형식
      final brickName = '${featureName}_supabase';

      if (verbose) {
        print('   🔍 Finding brick: $brickName');
      }

      // 브릭 경로를 찾고 Mason Generator 생성
      final brickPath = await findBrickPath(brickName);
      final brick = Brick.path(brickPath);
      final generator = await MasonGenerator.fromBrick(brick);
      final target = DirectoryGeneratorTarget(Directory.current);

      if (verbose) {
        print('   ⚙️  Generating files from brick...');
      }

      // 브릭에서 파일들을 생성
      await generator.generate(
        target,
        vars: <String, dynamic>{
          'feature_name': featureName,
          'backend_type': 'supabase',
        },
      );

      // Hook 실행
      await _runPostGenHook(brickPath, target.dir, <String, dynamic>{
        'feature_name': featureName,
        'backend_type': 'supabase',
      });

      print('   ✅ $featureName feature created successfully');
    } catch (e) {
      print('   ❌ Error creating $featureName feature: $e');
      // 에러가 발생해도 다른 기능 생성을 계속 진행할 수 있도록 던지지 않습니다
    }
  }

  /// 프로젝트 이름을 Flutter 프로젝트 명명 규칙에 맞게 검증하고 정리하는 메서드
  ///
  /// Flutter 프로젝트 이름은 다음 규칙을 따라야 합니다:
  /// - 소문자만 사용
  /// - 숫자와 밑줄(_)만 허용
  /// - 영문자로 시작해야 함
  ///
  /// [name]: 원본 프로젝트 이름
  /// 반환값: 정리된 프로젝트 이름
  String _validateAndSanitizeProjectName(String name) {
    // 소문자로 변환하고 허용되지 않는 문자를 밑줄로 치환
    String sanitized = name.toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9_]'),
      '_',
    );

    // 숫자로 시작하는 경우 앞에 'app_' 추가
    if (RegExp(r'^[0-9]').hasMatch(sanitized)) {
      sanitized = 'app_$sanitized';
    }

    // 빈 문자열이거나 밑줄만 있는 경우 기본값 사용
    if (sanitized.isEmpty || sanitized.replaceAll('_', '').isEmpty) {
      sanitized = 'flutter_app';
    }

    return sanitized;
  }

  /// post_gen Hook을 실행하는 메서드
  Future<void> _runPostGenHook(
    String brickPath,
    Directory workingDir,
    Map<String, dynamic> vars,
  ) async {
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
        final mainContent =
            '''
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
        final pubGetResult = await Process.run('dart', [
          'pub',
          'get',
        ], workingDirectory: tempDir.path);

        if (pubGetResult.exitCode != 0) {
          print(
            'Warning: Failed to get dependencies for hook: ${pubGetResult.stderr}',
          );
          return;
        }

        // Hook 실행
        final hookResult = await Process.run('dart', [
          'run',
          'main.dart',
        ], workingDirectory: tempDir.path);

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
