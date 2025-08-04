import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
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

      print('Feature "$featureName" created successfully.');
      return 0;
    } catch (e) {
      print('Error creating feature: $e');
      return 1;
    }
  }
}
