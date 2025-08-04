import 'dart:io';
import 'package:mason/mason.dart';

/// Feature 생성 후 실행되는 훅
/// 
/// 새로운 feature가 생성된 후 dependencies_injection.dart 파일에
/// 자동으로 import문과 등록 코드를 추가하여 DI 설정을 완성합니다.
void run(HookContext context) {
  final logger = context.logger;
  final featureName = context.vars['feature_name'] as String;
  
  logger.info('🔧 Setting up dependency injection for $featureName feature...');
  
  try {
    _updateDependencyInjection(featureName, logger);
    logger.success('✅ Successfully configured DI for $featureName feature!');
    
    // 사용자에게 다음 단계 안내
    _showNextSteps(featureName, logger);
  } catch (e) {
    logger.err('❌ Failed to update dependency injection: $e');
    logger.info('💡 Please manually add the following to lib/core/di/dependencies_injection.dart:');
    logger.info('   import \'../../features/$featureName/data/data_sources/${featureName}_remote_data_source_impl.dart\';');
    logger.info('   import \'../../features/$featureName/data/repositories/${featureName}_repository_impl.dart\';');
    logger.info('   import \'../../features/$featureName/domain/use_cases/get_${featureName}_usecase.dart\';');
  }
}

/// dependencies_injection.dart 파일을 업데이트하여 새로운 feature의 DI 설정을 추가합니다
void _updateDependencyInjection(String featureName, Logger logger) {
  final diFile = File('lib/core/di/dependencies_injection.dart');
  
  if (!diFile.existsSync()) {
    throw Exception('dependencies_injection.dart file not found');
  }
  
  String content = diFile.readAsStringSync();
  
  // Import 문들 추가
  final imports = [
    "import '../../features/$featureName/data/remote/data_sources/${featureName}_remote_data_source.dart';",
    "import '../../features/$featureName/data/remote/data_sources/${featureName}_remote_data_source_impl.dart';",
    "import '../../features/$featureName/data/local/data_sources/${featureName}_local_data_source.dart';",
    "import '../../features/$featureName/data/local/data_sources/${featureName}_local_data_source_impl.dart';",
    "import '../../features/$featureName/data/repositories/${featureName}_repository_impl.dart';",
    "import '../../features/$featureName/domain/repositories/${featureName}_repository.dart';",
    "import '../../features/$featureName/domain/use_cases/get_${featureName}_usecase.dart';",
    "import '../../features/$featureName/domain/use_cases/create_${featureName}_usecase.dart';",
    "import '../../features/$featureName/domain/use_cases/update_${featureName}_usecase.dart';",
    "import '../../features/$featureName/domain/use_cases/delete_${featureName}_usecase.dart';",
    "import '../../features/$featureName/presentation/providers/${featureName}_provider.dart';",
  ];
  
  // Import 구문들을 기존 import 다음에 추가
  final lastImportIndex = content.lastIndexOf("import ");
  if (lastImportIndex != -1) {
    final nextLineIndex = content.indexOf('\n', lastImportIndex);
    if (nextLineIndex != -1) {
      final importString = imports.join('\n') + '\n';
      content = content.substring(0, nextLineIndex + 1) + 
                importString + 
                content.substring(nextLineIndex + 1);
    }
  }
  
  // Data Sources 등록 코드 추가
  final dataSourceRegistration = '''
    // $featureName Feature Data Sources
    getIt.registerLazySingleton<${_toPascalCase(featureName)}RemoteDataSource>(
      () => ${_toPascalCase(featureName)}RemoteDataSourceImpl(
        client: getIt<SupabaseClient>(),
      ),
    );
    
    getIt.registerLazySingleton<${_toPascalCase(featureName)}LocalDataSource>(
      () => ${_toPascalCase(featureName)}LocalDataSourceImpl(),
    );''';
  
  // Repository 등록 코드 추가
  final repositoryRegistration = '''
    // $featureName Feature Repository
    getIt.registerLazySingleton<${_toPascalCase(featureName)}Repository>(
      () => ${_toPascalCase(featureName)}RepositoryImpl(
        remoteDataSource: getIt<${_toPascalCase(featureName)}RemoteDataSource>(),
        localDataSource: getIt<${_toPascalCase(featureName)}LocalDataSource>(),
      ),
    );''';
  
  // Use Cases 등록 코드 추가
  final useCasesRegistration = '''
    // $featureName Feature Use Cases
    getIt.registerLazySingleton(() => Get${_toPascalCase(featureName)}UseCase(getIt<${_toPascalCase(featureName)}Repository>()));
    getIt.registerLazySingleton(() => Create${_toPascalCase(featureName)}UseCase(getIt<${_toPascalCase(featureName)}Repository>()));
    getIt.registerLazySingleton(() => Update${_toPascalCase(featureName)}UseCase(getIt<${_toPascalCase(featureName)}Repository>()));
    getIt.registerLazySingleton(() => Delete${_toPascalCase(featureName)}UseCase(getIt<${_toPascalCase(featureName)}Repository>()));''';
  
  // Provider 등록 코드 추가
  final providerRegistration = '''
    // $featureName Feature Provider
    getIt.registerFactory(() => ${_toPascalCase(featureName)}Provider(
      get${_toPascalCase(featureName)}UseCase: getIt<Get${_toPascalCase(featureName)}UseCase>(),
      create${_toPascalCase(featureName)}UseCase: getIt<Create${_toPascalCase(featureName)}UseCase>(),
      update${_toPascalCase(featureName)}UseCase: getIt<Update${_toPascalCase(featureName)}UseCase>(),
      delete${_toPascalCase(featureName)}UseCase: getIt<Delete${_toPascalCase(featureName)}UseCase>(),
    ));''';
  
  // 각 섹션에 등록 코드 추가
  content = _insertIntoSection(content, '_registerDataSources()', dataSourceRegistration);
  content = _insertIntoSection(content, '_registerRepositories()', repositoryRegistration);
  content = _insertIntoSection(content, '_registerUseCases()', useCasesRegistration);
  content = _insertIntoSection(content, '_registerProviders()', providerRegistration);
  
  // 파일에 내용 쓰기
  diFile.writeAsStringSync(content);
  
  logger.info('📝 Updated dependencies_injection.dart with $featureName registrations');
}

/// 특정 섹션에 코드를 삽입하는 헬퍼 함수
String _insertIntoSection(String content, String sectionMethod, String codeToInsert) {
  final sectionIndex = content.indexOf(sectionMethod);
  if (sectionIndex == -1) return content;
  
  // 메서드 시작 찾기
  final methodStart = content.indexOf('{', sectionIndex);
  if (methodStart == -1) return content;
  
  // 메서드 끝 찾기 (간단한 구현)
  int braceCount = 1;
  int pos = methodStart + 1;
  while (pos < content.length && braceCount > 0) {
    if (content[pos] == '{') braceCount++;
    else if (content[pos] == '}') braceCount--;
    pos++;
  }
  
  if (braceCount == 0) {
    // 메서드 끝 바로 앞에 코드 삽입
    final insertPosition = pos - 1;
    return content.substring(0, insertPosition) + 
           '\n$codeToInsert\n  ' + 
           content.substring(insertPosition);
  }
  
  return content;
}

/// snake_case를 PascalCase로 변환
String _toPascalCase(String input) {
  return input
      .split('_')
      .map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join('');
}

/// 사용자에게 다음 단계를 안내하는 함수
void _showNextSteps(String featureName, Logger logger) {
  logger.info('');
  logger.info('🎉 $featureName feature created successfully!');
  logger.info('');
  logger.info('📋 Next steps:');
  logger.info('1. Update your Supabase database with the necessary tables');
  logger.info('2. Modify the generated models to match your data structure');
  logger.info('3. Implement the actual API calls in the data sources');
  logger.info('4. Add the ${_toPascalCase(featureName)}Provider to your widget tree');
  logger.info('5. Build your UI screens using the generated provider');
  logger.info('');
  logger.info('📁 Generated files:');
  logger.info('  • lib/features/$featureName/domain/entities/${featureName}.dart');
  logger.info('  • lib/features/$featureName/domain/repositories/${featureName}_repository.dart');
  logger.info('  • lib/features/$featureName/domain/use_cases/*.dart');
  logger.info('  • lib/features/$featureName/data/repositories/${featureName}_repository_impl.dart');
  logger.info('  • lib/features/$featureName/data/remote/data_sources/*.dart');
  logger.info('  • lib/features/$featureName/data/local/data_sources/*.dart');
  logger.info('  • lib/features/$featureName/presentation/providers/${featureName}_provider.dart');
  logger.info('  • lib/features/$featureName/presentation/screens/${featureName}_screen.dart');
  logger.info('');
  logger.info('💡 Pro tip: Run `dart run build_runner build` to generate any missing code!');
}