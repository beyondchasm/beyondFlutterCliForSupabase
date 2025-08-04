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

  ScaffoldCommand() {
    argParser
      ..addOption('org', help: 'The organization name.')
      ..addFlag('with-auth', help: 'Include authentication feature.')
      ..addFlag('with-user', help: 'Include user profile feature.');
  }

  @override
  Future<int> run() async {
    final org = argResults?['org'] as String?;
    final withAuth = argResults?['with-auth'] as bool? ?? false;
    final withUser = argResults?['with-user'] as bool? ?? false;
    final verbose = globalResults?['verbose'] as bool? ?? false;

    try {
      final pubspecFile = File('pubspec.yaml');
      if (!await pubspecFile.exists()) {
        print('Creating Flutter project...');
        final currentDir = path.basename(Directory.current.path);
        final validProjectName = _validateAndSanitizeProjectName(currentDir);

        final createArgs = ['create', '.', '--empty', '--project-name', validProjectName];
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
        vars: <String, dynamic>{
          'with_auth': withAuth,
          'with_user': withUser,
        },
      );

      print('Project scaffold created successfully with Supabase backend!');

      if (withAuth) {
        await _generateFeature('auth', verbose);
      }
      if (withUser) {
        await _generateFeature('user', verbose);
      }

      print('\nReady to start! Run the following commands:');
      print('   flutter pub get');
      print('   dart run build_runner build');
      print('   flutter run');

      return 0;
    } catch (e) {
      print('Error creating scaffold: $e');
      return 1;
    }
  }

  Future<void> _generateFeature(String featureName, bool verbose) async {
    try {
      final brickName = '${featureName}_supabase';
      final brickPath = await findBrickPath(brickName);
      final brick = Brick.path(brickPath);
      final generator = await MasonGenerator.fromBrick(brick);
      final target = DirectoryGeneratorTarget(Directory.current);

      await generator.generate(
        target,
        vars: <String, dynamic>{'feature_name': featureName},
      );

      print('$featureName feature created');
    } catch (e) {
      print('Error creating $featureName feature: $e');
    }
  }

  String _validateAndSanitizeProjectName(String name) {
    // Implementation from the original file
    return name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '_');
  }
}
