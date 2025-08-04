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

    // Auth Supabase Data Sources
    getIt.registerLazySingleton<SupabaseAuthRemoteDataSource>(
      () => SupabaseAuthRemoteDataSourceImpl(),
    );''',
    'getIt.registerLazySingleton<SupabaseAuthRemoteDataSource>',
  );

  _addRegistration(
    lines,
    'void _registerRepositories()',
    '''

    // Auth Repository
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(),
    );''',
    'getIt.registerLazySingleton<AuthRepository>',
  );

  _addRegistration(
    lines,
    'void _registerUseCases()',
    '''

    // Auth Use Cases
    getIt.registerLazySingleton<SignInUseCase>(() => SignInUseCase());
    getIt.registerLazySingleton<SignUpUseCase>(() => SignUpUseCase());
    getIt.registerLazySingleton<SignOutUseCase>(() => SignOutUseCase());
    getIt.registerLazySingleton<ResetPasswordUseCase>(() => ResetPasswordUseCase());
    getIt.registerLazySingleton<GetCurrentUserUseCase>(() => GetCurrentUserUseCase());''',
    'getIt.registerLazySingleton<SignInUseCase>',
  );

  _addRegistration(
    lines,
    'void _registerProviders()',
    '''

    // Auth Provider
    getIt.registerFactory<AuthProvider>(() => AuthProvider());''',
    'getIt.registerFactory<AuthProvider>',
  );

  final newContent = lines.join('\n');

  if (originalContent != newContent) {
    await diFile.writeAsString(newContent);
    logger.success('✅ Auth Supabase DI registration completed');
  } else {
    logger.info('Auth Supabase DI registration already exists');
  }
}

void _addImports(List<String> lines) {
  const importBlock = '''

// Auth Supabase Imports
import '../../features/auth/data/remote/data_sources/supabase_auth_remote_data_source.dart';
import '../../features/auth/data/remote/data_sources/supabase_auth_remote_data_source_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/use_cases/sign_in_usecase.dart';
import '../../features/auth/domain/use_cases/sign_up_usecase.dart';
import '../../features/auth/domain/use_cases/sign_out_usecase.dart';
import '../../features/auth/domain/use_cases/reset_password_usecase.dart';
import '../../features/auth/domain/use_cases/get_current_user_usecase.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';''';

  if (lines.any((line) => line.contains('// Auth Supabase Imports'))) {
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