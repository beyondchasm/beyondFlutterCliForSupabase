import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final logger = context.logger;
  final diFile = File('lib/core/di/dependencies_injection.dart');

  if (!await diFile.exists()) {
    logger.warn('⚠️ DI file not found: ${diFile.path}');
    return;
  }

  var lines = await diFile.readAsLines();
  final originalContent = lines.join('\n');

  // Add imports
  _addImports(lines);

  // Add registrations
  _addRegistration(
    lines,
    'void _registerDataSources()',
    '''

    // User Supabase Data Sources
    ServiceLocator.registerLazySingleton<SupabaseUserRemoteDataSource>(
      () => SupabaseUserRemoteDataSourceImpl(),
    );''',
    'ServiceLocator.registerLazySingleton<SupabaseUserRemoteDataSource>',
  );

  _addRegistration(
    lines,
    'void _registerRepositories()',
    '''

    // User Repository
    ServiceLocator.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(),
    );''',
    'ServiceLocator.registerLazySingleton<UserRepository>',
  );

  _addRegistration(
    lines,
    'void _registerUseCases()',
    '''

    // User Use Cases
    ServiceLocator.registerLazySingleton<GetUserProfileUseCase>(() => GetUserProfileUseCase());
    ServiceLocator.registerLazySingleton<UpdateUserProfileUseCase>(() => UpdateUserProfileUseCase());
    ServiceLocator.registerLazySingleton<DeleteUserProfileUseCase>(() => DeleteUserProfileUseCase());''',
    'ServiceLocator.registerLazySingleton<GetUserProfileUseCase>',
  );

  _addRegistration(
    lines,
    'void _registerProviders()',
    '''

    // User Provider
    ServiceLocator.registerFactory<UserProvider>(() => UserProvider());''',
    'ServiceLocator.registerFactory<UserProvider>',
  );

  final newContent = lines.join('\n');

  if (originalContent != newContent) {
    await diFile.writeAsString(newContent);
    logger.success('✅ User Supabase DI registration completed');
  } else {
    logger.info('User Supabase DI registration already exists');
  }
}

void _addImports(List<String> lines) {
  const importBlock = '''

// User Supabase Imports
import '../../features/user/data/remote/data_sources/supabase_user_remote_data_source.dart';
import '../../features/user/data/remote/data_sources/supabase_user_remote_data_source_impl.dart';
import '../../features/user/data/repositories/user_repository_impl.dart';
import '../../features/user/domain/repositories/user_repository.dart';
import '../../features/user/domain/use_cases/get_user_profile_usecase.dart';
import '../../features/user/domain/use_cases/update_user_profile_usecase.dart';
import '../../features/user/domain/use_cases/delete_user_profile_usecase.dart';
import '../../features/user/presentation/providers/user_provider.dart';''';

  if (lines.any((line) => line.contains('// User Supabase Imports'))) {
    return;
  }

  final importIndex = lines.indexWhere((line) => line.contains("import 'service_locator.dart';"));
  if (importIndex != -1) {
    lines.insert(importIndex + 1, importBlock);
  }
}

void _addRegistration(
  List<String> lines,
  String functionSignature,
  String registrationBlock,
  String checkString,
) {
  if (lines.any((line) => line.contains(checkString))) {
    return;
  }

  final functionStartIndex = lines.indexWhere((line) => line.contains(functionSignature));
  if (functionStartIndex == -1) {
    return;
  }

  var openBraces = 0;
  var functionEndIndex = -1;
  for (var i = functionStartIndex; i < lines.length; i++) {
    if (lines[i].contains('{')) {
      openBraces++;
    }
    if (lines[i].contains('}')) {
      openBraces--;
      if (openBraces == 0) {
        functionEndIndex = i;
        break;
      }
    }
  }

  if (functionEndIndex != -1) {
    // Check if the function body is empty (only contains whitespace between braces)
    final body = lines.sublist(functionStartIndex + 1, functionEndIndex).join('').trim();
    if (body.isEmpty) {
        // Insert before the closing brace, but without the initial newline
        lines.insert(functionEndIndex, registrationBlock.trimLeft());
    } else {
        lines.insert(functionEndIndex, registrationBlock);
    }
  }
}
