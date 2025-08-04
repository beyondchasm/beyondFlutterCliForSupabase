import 'dart:io';
import 'package:path/path.dart' as path;

/// Finds the path to a brick, whether the CLI is run from a global installation or locally.
Future<String> findBrickPath(String brickName) async {
  final scriptPath = Platform.script.toFilePath();

  // Check if running from a global installation (e.g., via `dart pub global activate`)
  if (scriptPath.contains('.pub-cache')) {
    return _findGlobalBrickPath(brickName);
  } else {
    return _findLocalBrickPath(brickName, scriptPath);
  }
}

Future<String> _findGlobalBrickPath(String brickName) async {
  final pubCacheDir = _findPubCacheDir();
  if (pubCacheDir == null) {
    throw Exception('Could not find .pub-cache directory.');
  }

  final gitDir = Directory(path.join(pubCacheDir.path, 'git'));
  if (!await gitDir.exists()) {
    throw Exception('Git directory not found in .pub-cache.');
  }

  final beyondDirs = await gitDir
      .list()
      .where((entity) =>
          entity is Directory && entity.path.contains('beyond_flutter_cli_for_supabase'))
      .cast<Directory>()
      .toList();

  if (beyondDirs.isEmpty) {
    throw Exception(
        'beyond_flutter_cli_for_supabase git repository not found in pub-cache.');
  }

  // Use the most recent version (usually the last one in the list)
  final packageDir = beyondDirs.last.path;
  final brickPath = path.join(packageDir, 'bricks', brickName);

  if (!await Directory(brickPath).exists()) {
    throw Exception('Brick "$brickName" not found at path: $brickPath');
  }

  return brickPath;
}

String _findLocalBrickPath(String brickName, String scriptPath) {
  String projectRoot;

  // Determine project root based on script path
  if (scriptPath.contains('.dart_tool')) {
    // Running from snapshot (e.g., after `dart compile`)
    final dartToolIndex = scriptPath.indexOf('.dart_tool');
    projectRoot = scriptPath.substring(0, dartToolIndex);
  } else {
    // Running directly from source (e.g., `dart run`)
    projectRoot = path.dirname(path.dirname(scriptPath));
  }

  final brickPath = path.join(projectRoot, 'bricks', brickName);

  if (!Directory(brickPath).existsSync()) {
    throw Exception('Brick "$brickName" not found at path: $brickPath');
  }

  return brickPath;
}

Directory? _findPubCacheDir() {
  final homeDir = Platform.environment['HOME'] ??
      Platform.environment['USERPROFILE'] ??
      Directory.current.path;

  final commonPaths = [
    path.join(homeDir, '.pub-cache'),
    path.join(homeDir, 'AppData', 'Local', 'Pub', 'Cache'), // Windows
  ];

  for (final dirPath in commonPaths) {
    final dir = Directory(dirPath);
    if (dir.existsSync()) {
      return dir;
    }
  }

  return null;
}

