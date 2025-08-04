import 'dart:io';
import 'package:args/command_runner.dart';

class InitCommand extends Command<int> {
  @override
  final name = 'init';
  @override
  final description = 'Initializes a new configuration file.';

  InitCommand() {
    argParser.addFlag('force', negatable: false, help: 'Force overwrite of existing config file.');
  }

  @override
  Future<int> run() async {
    final force = argResults!['force'] as bool;
    const configFileName = 'beyond_cli.yaml';
    final configFile = File(configFileName);

    if (await configFile.exists() && !force) {
      print('Configuration file already exists: $configFileName');
      print('Use --force to overwrite.');
      return 1;
    }

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

    await configFile.writeAsString(configContent);
    print('Configuration file created: $configFileName');
    return 0;
  }
}
