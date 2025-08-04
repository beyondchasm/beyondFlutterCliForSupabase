import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:beyond_flutter_cli_for_supabase/src/commands/feature_command.dart';
import 'package:beyond_flutter_cli_for_supabase/src/commands/init_command.dart';
import 'package:beyond_flutter_cli_for_supabase/src/commands/scaffold_command.dart';

void main(List<String> args) async {
  final runner = CommandRunner<int>(
    'beyond',
    'A CLI for creating Flutter projects with Supabase.',
  )
    ..addCommand(ScaffoldCommand())
    ..addCommand(FeatureCommand())
    ..addCommand(InitCommand());

  try {
    final exitCode = await runner.run(args);
    exit(exitCode ?? 1);
  } on UsageException catch (e) {
    print(e);
    exit(64);
  }
}
