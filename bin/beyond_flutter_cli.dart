import 'dart:io';
import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;

const String version = '0.2.5';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addFlag('version', negatable: false, help: 'Print the tool version.')
    ..addCommand(
      'scaffold',
      ArgParser()
        ..addOption(
          'backend',
          abbr: 'b',
          allowed: ['firebase', 'supabase', 'rest-api'],
          defaultsTo: 'rest-api',
          help: 'Backend type to use (firebase, supabase, rest-api)',
        )
        ..addOption(
          'org',
          abbr: 'o',
          help: 'Organization name (e.g., com.example)',
        )
        ..addOption(
          'android-language',
          allowed: ['java', 'kotlin'],
          defaultsTo: 'kotlin',
          help: 'Android language (java, kotlin)',
        )
        ..addOption(
          'ios-language',
          allowed: ['objc', 'swift'],
          defaultsTo: 'swift',
          help: 'iOS language (objc, swift)',
        )
        ..addFlag(
          'with-auth',
          negatable: false,
          help: 'Include authentication feature (login, register, logout)',
        )
        ..addFlag(
          'with-user',
          negatable: false,
          help: 'Include user profile feature (view, edit profile)',
        ),
    )
    ..addCommand(
      'feature',
      ArgParser()..addOption(
        'backend',
        abbr: 'b',
        allowed: ['firebase', 'supabase', 'rest-api'],
        defaultsTo: 'rest-api',
        help: 'Backend type to use (firebase, supabase, rest-api)',
      ),
    )
    ..addCommand(
      'init',
      ArgParser()..addFlag(
        'force',
        negatable: false,
        help: 'Force overwrite existing config file',
      ),
    );
}

void printUsage(ArgParser argParser) {
  print('Flutter Clean Architecture CLI Tool');
  print('');
  print('Usage: beyond_flutter_cli <command> [arguments]');
  print('');
  print('Available commands:');
  print(
    '  scaffold    Create Flutter project scaffold with Clean Architecture structure',
  );
  print('  feature     Generate a new feature with Clean Architecture layers');
  print('  init        Create configuration file (beyond_cli.yaml)');
  print('');
  print('Scaffold options:');
  print(
    '  --backend, -b           Backend type: firebase, supabase, rest-api (default: rest-api)',
  );
  print('  --org, -o              Organization name (e.g., com.example)');
  print(
    '  --android-language     Android language: java, kotlin (default: kotlin)',
  );
  print('  --ios-language         iOS language: objc, swift (default: swift)');
  print('  --with-auth            Include authentication feature');
  print('  --with-user            Include user profile feature');
  print('');
  print('Examples:');
  print('  beyond_flutter_cli scaffold --backend firebase --org com.mycompany');
  print(
    '  beyond_flutter_cli scaffold --backend firebase --android-language java --with-auth --with-user',
  );
  print('  beyond_flutter_cli feature user_profile --backend supabase');
  print('');
  print('Global options:');
  print(argParser.usage);
  print('');
  print(
    'Run "beyond_flutter_cli <command> --help" for more information about a command.',
  );
}

String _validateAndSanitizeProjectName(String directoryName) {
  // Convert to valid Dart package name
  String sanitized = directoryName
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9_]'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');

  // Ensure it doesn't start with a number
  if (sanitized.isNotEmpty && RegExp(r'^\d').hasMatch(sanitized)) {
    sanitized = 'app_$sanitized';
  }

  // Ensure it's not empty
  if (sanitized.isEmpty) {
    sanitized = 'flutter_app';
  }

  // Check if it's a reserved word
  final reservedWords = [
    'if',
    'for',
    'while',
    'do',
    'switch',
    'case',
    'default',
    'break',
    'continue',
    'function',
    'return',
    'var',
    'let',
    'const',
    'class',
    'extends',
    'implements',
    'interface',
    'package',
    'import',
    'export',
    'public',
    'private',
    'protected',
    'static',
    'final',
    'abstract',
  ];
  if (reservedWords.contains(sanitized)) {
    sanitized = '${sanitized}_app';
  }

  return sanitized;
}

Future<void> runScaffoldCommand(
  String backendType,
  bool withAuth,
  bool withUser,
  bool verbose, {
  String? org,
  String? androidLanguage,
  String? iosLanguage,
}) async {
  try {
    // Step 1: Check if Flutter project exists, if not create it
    final pubspecFile = File('pubspec.yaml');
    if (!await pubspecFile.exists()) {
      print('📱 Creating Flutter project...');

      // Get current directory name and validate it
      final currentDir = Directory.current.path.split('/').last;
      final validProjectName = _validateAndSanitizeProjectName(currentDir);

      if (currentDir != validProjectName) {
        print(
          '⚠️  Directory name "$currentDir" is not a valid Dart package name',
        );
        print('🔄 Using sanitized name: "$validProjectName"');
      }

      // Build flutter create command
      final createArgs = <String>[
        'create',
        '.',
        '--empty',
        '--project-name',
        validProjectName,
      ];

      if (org != null && org.isNotEmpty) {
        createArgs.addAll(['--org', org]);
      }

      if (androidLanguage != null && androidLanguage.isNotEmpty) {
        createArgs.addAll(['--android-language', androidLanguage]);
      }

      // Remove deprecated iOS language option
      // Note: --ios-language is deprecated in newer Flutter versions

      if (verbose) {
        print('[VERBOSE] Running: flutter ${createArgs.join(' ')}');
      }

      final createResult = await Process.run('flutter', createArgs);
      if (createResult.exitCode != 0) {
        print('❌ Failed to create Flutter project');
        print('');
        if (createResult.stderr.toString().contains(
          'flutter: command not found',
        )) {
          print('🔧 Error: Flutter is not installed or not in PATH');
          print(
            '💡 Solution: Install Flutter from https://flutter.dev/docs/get-started/install',
          );
        } else if (createResult.stderr.toString().contains(
          'Invalid project name',
        )) {
          print('🔧 Error: Invalid project name or directory');
          print(
            '💡 Solution: Ensure you\'re in an empty directory with a valid name',
          );
        } else {
          print('🔧 Error: ${createResult.stderr}');
          print('💡 Solution: Check Flutter installation and try again');
        }
        exit(1);
      }

      print('✅ Flutter project created successfully!');
    }

    // Step 2: Generate base scaffold
    // Get absolute path to bricks directory
    String brickPath;
    final scriptPath = Platform.script.toFilePath();

    // Check if running from global installation
    if (scriptPath.contains('.pub-cache') &&
        scriptPath.contains('global_packages')) {
      // Global installation from git: find the git repository in pub-cache
      final homeDir = Platform.environment['HOME'] ?? Directory.current.path;
      final pubCacheDir = Directory(path.join(homeDir, '.pub-cache'));
      final gitDir = Directory(path.join(pubCacheDir.path, 'git'));

      if (await gitDir.exists()) {
        final beyondDirs = await gitDir
            .list()
            .where(
              (entity) =>
                  entity is Directory &&
                  entity.path.contains('beyondFlutterCli'),
            )
            .cast<Directory>()
            .toList();

        if (beyondDirs.isNotEmpty) {
          // Use the most recent version (should be the last in the list)
          final packageDir = beyondDirs.last.path;
          brickPath = path.join(
            packageDir,
            'bricks',
            'project_scaffold_${backendType.replaceAll('-', '_')}',
          );
        } else {
          throw Exception(
            'beyondFlutterCli git repository not found in pub-cache',
          );
        }
      } else {
        throw Exception('Git directory not found in pub-cache');
      }
    } else {
      // Local development or path-based installation: use relative path from bin directory
      // scriptPath could be like: /path/to/project/bin/script.dart or /path/to/project/.dart_tool/pub/bin/script.dart-snapshot
      String projectRoot;
      if (scriptPath.contains('.dart_tool')) {
        // Running from snapshot: /path/to/project/.dart_tool/pub/bin/beyond_flutter_cli/beyond_flutter_cli.dart-3.8.1.snapshot
        final dartToolIndex = scriptPath.indexOf('.dart_tool');
        projectRoot = scriptPath.substring(0, dartToolIndex);
      } else {
        // Running directly: /path/to/project/bin/beyond_flutter_cli.dart
        projectRoot = path.dirname(path.dirname(scriptPath));
      }
      brickPath = path.join(
        projectRoot,
        'bricks',
        'project_scaffold_${backendType.replaceAll('-', '_')}',
      );
    }

    if (verbose) {
      print('[VERBOSE] Script path: $scriptPath');
      print('[VERBOSE] Brick path: $brickPath');
      print('[VERBOSE] Brick exists: ${await Directory(brickPath).exists()}');
    }

    final brick = Brick.path(brickPath);
    final generator = await MasonGenerator.fromBrick(brick);

    if (verbose) {
      print('[VERBOSE] Creating project scaffold with $backendType backend...');
      if (withAuth) print('[VERBOSE] Including auth feature...');
      if (withUser) print('[VERBOSE] Including user feature...');
    }

    final target = DirectoryGeneratorTarget(Directory.current);
    await generator.generate(
      target,
      vars: <String, dynamic>{
        'backend_type': backendType,
        'with_auth': withAuth,
        'with_user': withUser,
      },
    );

    print('✅ Project scaffold created successfully with $backendType backend!');
    print('📁 Created directories:');
    print('   - lib/core/');
    print('   - lib/features/');
    print('   - lib/main/init_app.dart');
    print('   - Splash & Home screens included');
    print('🔧 Backend type: $backendType');
    if (org != null) print('🏢 Organization: $org');
    if (androidLanguage != null) print('📱 Android language: $androidLanguage');
    if (iosLanguage != null) print('🍎 iOS language: $iosLanguage');

    // Generate optional features
    if (withAuth) {
      await _generateFeature('auth', backendType, verbose);
    }

    if (withUser) {
      await _generateFeature('user', backendType, verbose);
    }

    print('');
    print('🚀 Ready to start! Run the following commands:');
    print('   flutter pub get');
    print('   dart run build_runner build');
    print('   flutter run');
  } catch (e) {
    print('❌ Error creating scaffold');
    print('');
    if (verbose) {
      print('[VERBOSE] Exception: $e');
      print('[VERBOSE] Stack trace: ${StackTrace.current}');
    }
    _handleCommonErrors(e.toString());
    exit(1);
  }
}

Future<void> _generateFeature(
  String featureName,
  String backendType,
  bool verbose,
) async {
  try {
    String brickPath;
    final scriptPath = Platform.script.toFilePath();

    // Determine brick name based on feature type
    String brickName;
    if (featureName == 'auth') {
      brickName = 'auth_${backendType.replaceAll('-', '_')}';
    } else if (featureName == 'user') {
      brickName = 'user_${backendType.replaceAll('-', '_')}';
    } else {
      brickName = 'feature_${backendType.replaceAll('-', '_')}';
    }

    // Check if running from global installation
    if (scriptPath.contains('.pub-cache') &&
        scriptPath.contains('global_packages')) {
      // Global installation from git: find the git repository in pub-cache
      final homeDir = Platform.environment['HOME'] ?? Directory.current.path;
      final pubCacheDir = Directory(path.join(homeDir, '.pub-cache'));
      final gitDir = Directory(path.join(pubCacheDir.path, 'git'));

      if (await gitDir.exists()) {
        final beyondDirs = await gitDir
            .list()
            .where(
              (entity) =>
                  entity is Directory &&
                  entity.path.contains('beyondFlutterCli'),
            )
            .cast<Directory>()
            .toList();

        if (beyondDirs.isNotEmpty) {
          // Use the most recent version (should be the last in the list)
          final packageDir = beyondDirs.last.path;
          brickPath = path.join(packageDir, 'bricks', brickName);
        } else {
          throw Exception(
            'beyondFlutterCli git repository not found in pub-cache',
          );
        }
      } else {
        throw Exception('Git directory not found in pub-cache');
      }
    } else {
      // Local development or path-based installation: use relative path from bin directory
      // scriptPath could be like: /path/to/project/bin/script.dart or /path/to/project/.dart_tool/pub/bin/script.dart-snapshot
      String projectRoot;
      if (scriptPath.contains('.dart_tool')) {
        // Running from snapshot: /path/to/project/.dart_tool/pub/bin/beyond_flutter_cli/beyond_flutter_cli.dart-3.8.1.snapshot
        final dartToolIndex = scriptPath.indexOf('.dart_tool');
        projectRoot = scriptPath.substring(0, dartToolIndex);
      } else {
        // Running directly: /path/to/project/bin/beyond_flutter_cli.dart
        projectRoot = path.dirname(path.dirname(scriptPath));
      }
      brickPath = path.join(projectRoot, 'bricks', brickName);
    }

    final brick = Brick.path(brickPath);
    final generator = await MasonGenerator.fromBrick(brick);

    if (verbose) {
      print('[VERBOSE] Generating $featureName feature...');
    }

    final target = DirectoryGeneratorTarget(Directory.current);
    await generator.generate(
      target,
      vars: <String, dynamic>{
        'feature_name': featureName,
        'backend_type': backendType,
      },
    );

    print('✅ $featureName feature created');

    // Run DI registration hook if it exists
    String hookPath;
    if (scriptPath.contains('.pub-cache') &&
        scriptPath.contains('global_packages')) {
      // Global installation from git: find the git repository in pub-cache
      final homeDir = Platform.environment['HOME'] ?? Directory.current.path;
      final pubCacheDir = Directory(path.join(homeDir, '.pub-cache'));
      final gitDir = Directory(path.join(pubCacheDir.path, 'git'));

      if (await gitDir.exists()) {
        final beyondDirs = await gitDir
            .list()
            .where(
              (entity) =>
                  entity is Directory &&
                  entity.path.contains('beyondFlutterCli'),
            )
            .cast<Directory>()
            .toList();

        if (beyondDirs.isNotEmpty) {
          // Use the most recent version (should be the last in the list)
          final packageDir = beyondDirs.last.path;
          hookPath = path.join(
            packageDir,
            'bricks',
            brickName,
            '__brick__',
            'hooks',
            'register_di.sh',
          );
        } else {
          hookPath = ''; // Skip hook if can't find repository
        }
      } else {
        hookPath = ''; // Skip hook if can't find git directory
      }
    } else {
      // Local development or path-based installation: use relative path from bin directory
      String projectRoot;
      if (scriptPath.contains('.dart_tool')) {
        // Running from snapshot: /path/to/project/.dart_tool/pub/bin/beyond_flutter_cli/beyond_flutter_cli.dart-3.8.1.snapshot
        final dartToolIndex = scriptPath.indexOf('.dart_tool');
        projectRoot = scriptPath.substring(0, dartToolIndex);
      } else {
        // Running directly: /path/to/project/bin/beyond_flutter_cli.dart
        projectRoot = path.dirname(path.dirname(scriptPath));
      }
      hookPath = path.join(
        projectRoot,
        'bricks',
        brickName,
        '__brick__',
        'hooks',
        'register_di.sh',
      );
    }

    if (await File(hookPath).exists()) {
      if (verbose) {
        print('[VERBOSE] Running DI registration hook for $featureName...');
      }

      final result = await Process.run('bash', [hookPath]);
      if (result.exitCode == 0) {
        print('✅ $featureName DI registration completed');
      } else {
        if (verbose) {
          print(
            '⚠️  $featureName DI registration hook failed: ${result.stderr}',
          );
        }
      }
    }
  } catch (e) {
    print('⚠️  Error creating $featureName feature: $e');
  }
}

Future<void> runFeatureCommand(
  List<String> args,
  String backendType,
  bool verbose,
) async {
  if (args.isEmpty) {
    print('❌ Feature name is required');
    print(
      'Usage: beyond_flutter_cli feature <feature_name> --backend <backend_type>',
    );
    exit(1);
  }

  final featureName = args[0];

  try {
    // 👇 scaffold와 동일한 방식으로 글로벌/로컬 브릭 경로 탐색
    String brickPath;
    final scriptPath = Platform.script.toFilePath();
    final brickName = 'feature_${backendType.replaceAll('-', '_')}';

    if (scriptPath.contains('.pub-cache') &&
        scriptPath.contains('global_packages')) {
      // 글로벌 설치된 git 캐시 경로에서 beyondFlutterCli 브릭 찾아오기
      final homeDir = Platform.environment['HOME']!;
      final pubCacheGit = Directory(path.join(homeDir, '.pub-cache', 'git'));
      final beyondDirs = pubCacheGit
          .listSync() // sync 방식으로 리스트 가져오기
          .whereType<Directory>() // Directory만 골라내고
          .where((d) => d.path.contains('beyondFlutterCli'))
          .toList();

      if (beyondDirs.isEmpty) {
        throw Exception('beyondFlutterCli git repo not found in pub-cache');
      }

      final pkgDir = beyondDirs.last.path;
      brickPath = path.join(pkgDir, 'bricks', brickName);
    } else {
      // 로컬 개발용 or path 설치: 스크립트 기준 프로젝트 루트 추출
      String projectRoot;
      if (scriptPath.contains('.dart_tool')) {
        projectRoot = scriptPath.substring(0, scriptPath.indexOf('.dart_tool'));
      } else {
        projectRoot = path.dirname(path.dirname(scriptPath));
      }
      brickPath = path.join(projectRoot, 'bricks', brickName);
    }

    if (verbose) {
      print('[VERBOSE] Script path: $scriptPath');
      print('[VERBOSE] Feature brick path: $brickPath');
      print('[VERBOSE] Brick exists: ${await Directory(brickPath).exists()}');
    }

    final brick = Brick.path(brickPath);
    final generator = await MasonGenerator.fromBrick(brick);

    if (verbose) {
      print(
        '[VERBOSE] Creating feature: $featureName with $backendType backend...',
      );
    }

    final target = DirectoryGeneratorTarget(Directory.current);
    await generator.generate(
      target,
      vars: <String, dynamic>{
        'feature_name': featureName,
        'backend_type': backendType,
      },
    );

    print(
      '✅ Feature "$featureName" created successfully with $backendType backend!',
    );
    print('📁 Created feature structure:');
    print('   - lib/features/$featureName/data/');
    print('   - lib/features/$featureName/domain/');
    print('   - lib/features/$featureName/presentation/');
    print('🔧 Backend type: $backendType');

    // DI registration hook 실행
    final hookPath = path.join(
      'lib',
      'features',
      featureName,
      'hooks',
      'register_di.sh',
    );
    if (await File(hookPath).exists()) {
      if (verbose) {
        print('[VERBOSE] Running DI registration hook...');
      }
      final result = await Process.run('bash', [hookPath]);
      if (result.exitCode == 0) {ㄲ
        print('✅ DI registration completed');
      } else {
        print('⚠️  DI registration hook failed: ${result.stderr}');
      }
    }
  } catch (e) {
    print('❌ Error creating feature: $e');
    exit(1);
  }
}

void main(List<String> arguments) async {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;

    // Process the parsed arguments.
    if (results.flag('help')) {
      printUsage(argParser);
      return;
    }
    if (results.flag('version')) {
      print('beyond_flutter_cli version: $version');
      print('');
      print('🆕 What\'s New in v0.2.4:');
      print('  • 🛡️ Smart project name validation and auto-sanitization');
      print('  • 🔄 Latest Flutter compatibility (deprecated options removed)');
      print('  • 🌙 Dark mode support with system theme detection');
      print('  • 🏢 Organization name configuration (--org)');
      print('  • 📱 Android language selection (--android-language)');
      print('  • 🔧 Enhanced error handling with user-friendly messages');
      print('');
      print(
        '💡 Try: beyond_flutter_cli scaffold --backend firebase --org com.yourcompany --with-auth --with-user',
      );
      return;
    }
    if (results.flag('verbose')) {
      verbose = true;
    }

    // Handle commands
    if (results.command?.name == 'scaffold') {
      final backendType = results.command!['backend'] as String;
      final withAuth = results.command!.flag('with-auth');
      final withUser = results.command!.flag('with-user');
      final org = results.command!['org'] as String?;
      final androidLanguage = results.command!['android-language'] as String?;
      final iosLanguage = results.command!['ios-language'] as String?;

      await runScaffoldCommand(
        backendType,
        withAuth,
        withUser,
        verbose,
        org: org,
        androidLanguage: androidLanguage,
        iosLanguage: iosLanguage,
      );
      return;
    }

    if (results.command?.name == 'feature') {
      final backendType = results.command!['backend'] as String;
      await runFeatureCommand(results.command!.rest, backendType, verbose);
      return;
    }

    if (results.command?.name == 'init') {
      final force = results.command!.flag('force');
      await runInitCommand(force, verbose);
      return;
    }

    // No command provided
    if (results.rest.isEmpty) {
      printUsage(argParser);
      return;
    }

    // Unknown command
    print('Unknown command: ${results.rest[0]}');
    printUsage(argParser);
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}

Future<void> runInitCommand(bool force, bool verbose) async {
  const configFileName = 'beyond_cli.yaml';
  final configFile = File(configFileName);

  try {
    // Check if config file already exists
    if (await configFile.exists() && !force) {
      print('⚠️  Configuration file already exists: $configFileName');
      print('💡 Use --force to overwrite the existing file');
      print('💡 Or edit the existing file manually');
      return;
    }

    if (verbose) {
      print('[VERBOSE] Creating configuration file: $configFileName');
    }

    // Create default configuration
    const configContent = '''# Beyond Flutter CLI Configuration
# This file stores default settings for your project generation

# Default backend type (firebase, supabase, rest-api)
backend: rest-api

# Default organization name (used for package names)
# Example: com.yourcompany
org: com.example

# Default programming languages
languages:
  android: kotlin  # java or kotlin
  ios: swift       # objc or swift

# Default features to include
features:
  auth: false      # Include authentication features
  user: false      # Include user profile features

# Development preferences
preferences:
  verbose: false   # Show detailed output by default
  auto_pub_get: true  # Run 'flutter pub get' automatically
  auto_build_runner: true  # Run 'dart run build_runner build' automatically

# Project templates (future feature)
# templates:
#   - name: "minimal"
#     backend: "rest-api"
#     features: []
#   - name: "full-stack"
#     backend: "firebase"
#     features: ["auth", "user"]
''';

    await configFile.writeAsString(configContent);

    print('✅ Configuration file created: $configFileName');
    print('');
    print('📝 Default settings:');
    print('   Backend: rest-api');
    print('   Organization: com.example');
    print('   Android Language: kotlin');
    print('   iOS Language: swift');
    print('   Features: none');
    print('');
    print('💡 Edit $configFileName to customize your defaults');
    print(
      '💡 These settings will be used when options are not explicitly provided',
    );
  } catch (e) {
    print('❌ Error creating configuration file');
    print('');
    _handleCommonErrors(e.toString());
    exit(1);
  }
}

void _handleCommonErrors(String error) {
  if (error.contains('PathNotFoundException') ||
      error.contains('brick not found')) {
    print('🔧 Error: Brick template not found');
    print(
      '💡 Solution: Ensure the CLI is properly installed and bricks directory exists',
    );
  } else if (error.contains('PermissionDeniedException')) {
    print('🔧 Error: Permission denied');
    print(
      '💡 Solution: Check file/directory permissions or run with appropriate privileges',
    );
  } else if (error.contains('DirectoryNotEmptyException')) {
    print('🔧 Error: Directory is not empty');
    print('💡 Solution: Use an empty directory or remove existing files');
  } else if (error.contains('Mason')) {
    print('🔧 Error: Mason brick generation failed');
    print('💡 Solution: Try running with --verbose flag for more details');
  } else {
    print('🔧 Error: $error');
    print('💡 Solution: Try running with --verbose flag for more details');
  }
  print('');
  print(
    '🆘 Need help? Check: https://github.com/beyondchasm/beyondFlutterCli/issues',
  );
}
