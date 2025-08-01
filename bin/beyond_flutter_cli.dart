import 'dart:io';
import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;

const String version = '0.1.0';

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
        ),
    )
    ..addCommand(
      'feature',
      ArgParser()
        ..addOption(
          'backend',
          abbr: 'b',
          allowed: ['firebase', 'supabase', 'rest-api'],
          defaultsTo: 'rest-api',
          help: 'Backend type to use (firebase, supabase, rest-api)',
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
  print('');
  print('Backend options:');
  print('  --backend, -b    Backend type: firebase, supabase, rest-api (default: rest-api)');
  print('');
  print('Examples:');
  print('  beyond_flutter_cli scaffold --backend firebase');
  print('  beyond_flutter_cli feature user_profile --backend supabase');
  print('');
  print('Global options:');
  print(argParser.usage);
  print('');
  print(
    'Run "beyond_flutter_cli <command> --help" for more information about a command.',
  );
}

Future<void> runScaffoldCommand(String backendType, bool verbose) async {
  try {
    final brickPath = path.join(
      Directory.current.path,
      'bricks',
      'project_scaffold_${backendType.replaceAll('-', '_')}',
    );
    final brick = Brick.path(brickPath);
    final generator = await MasonGenerator.fromBrick(brick);

    if (verbose) {
      print('[VERBOSE] Creating project scaffold with $backendType backend...');
    }

    final target = DirectoryGeneratorTarget(Directory.current);
    await generator.generate(target, vars: <String, dynamic>{
      'backend_type': backendType,
    });

    print('✅ Project scaffold created successfully with $backendType backend!');
    print('📁 Created directories:');
    print('   - lib/core/');
    print('   - lib/features/');
    print('   - lib/main/init_app.dart');
    print('🔧 Backend type: $backendType');
  } catch (e) {
    print('❌ Error creating scaffold: $e');
    exit(1);
  }
}

Future<void> runFeatureCommand(List<String> args, String backendType, bool verbose) async {
  if (args.isEmpty) {
    print('❌ Feature name is required');
    print('Usage: beyond_flutter_cli feature <feature_name> --backend <backend_type>');
    exit(1);
  }

  final featureName = args[0];

  try {
    final brickPath = path.join(Directory.current.path, 'bricks', 'feature_${backendType.replaceAll('-', '_')}');
    final brick = Brick.path(brickPath);
    final generator = await MasonGenerator.fromBrick(brick);

    if (verbose) {
      print('[VERBOSE] Creating feature: $featureName with $backendType backend...');
    }

    final target = DirectoryGeneratorTarget(Directory.current);
    await generator.generate(
      target,
      vars: <String, dynamic>{
        'feature_name': featureName,
        'backend_type': backendType,
      },
    );

    print('✅ Feature "$featureName" created successfully with $backendType backend!');
    print('📁 Created feature structure:');
    print('   - lib/features/$featureName/data/');
    print('   - lib/features/$featureName/domain/');
    print('   - lib/features/$featureName/presentation/');
    print('🔧 Backend type: $backendType');

    // Run DI registration hook if it exists
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
      if (result.exitCode == 0) {
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
      return;
    }
    if (results.flag('verbose')) {
      verbose = true;
    }

    // Handle commands
    if (results.command?.name == 'scaffold') {
      final backendType = results.command!['backend'] as String;
      await runScaffoldCommand(backendType, verbose);
      return;
    }

    if (results.command?.name == 'feature') {
      final backendType = results.command!['backend'] as String;
      await runFeatureCommand(results.rest, backendType, verbose);
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
