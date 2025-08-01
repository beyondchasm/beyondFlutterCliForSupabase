#!/usr/bin/env bash
set -e
FEATURE="{{feature_name}}"
PASCAL="$(echo "$FEATURE" | sed -E 's/(^|_)(.)/\U\2/g')"
SNAKE="$FEATURE"

DI_FILE="lib/core/di/dependencies_injection.dart"

if [ ! -f "$DI_FILE" ]; then
  echo "Warning: $DI_FILE not found. Skipping DI registration."
  exit 0
fi

# Add import statements at the top of the file
IMPORT_SECTION="
// Auto-generated imports for $PASCAL feature
import '../features/${SNAKE}/data/local/data_sources/${SNAKE}_local_data_source.dart';
import '../features/${SNAKE}/data/local/data_sources/${SNAKE}_local_data_source_impl.dart';
import '../features/${SNAKE}/data/remote/data_sources/${SNAKE}_remote_data_source.dart';
import '../features/${SNAKE}/data/remote/data_sources/${SNAKE}_remote_data_source_impl.dart';
import '../features/${SNAKE}/data/repositories/${SNAKE}_repository_impl.dart';
import '../features/${SNAKE}/domain/repositories/${SNAKE}_repository.dart';
import '../features/${SNAKE}/domain/use_cases/get_${SNAKE}_usecase.dart';
import '../features/${SNAKE}/domain/use_cases/create_${SNAKE}_usecase.dart';
import '../features/${SNAKE}/domain/use_cases/update_${SNAKE}_usecase.dart';
import '../features/${SNAKE}/domain/use_cases/delete_${SNAKE}_usecase.dart';
"

# Check if imports already exist
if ! grep -q "import.*${SNAKE}" "$DI_FILE"; then
  # Add imports after existing imports
  awk -v imports="$IMPORT_SECTION" '
    /^import/ { imports_section = 1 }
    !imports_section && /^$/ && prev_import { print imports; imports_added = 1 }
    !imports_section && !/^import/ && prev_import && !imports_added { print imports; imports_added = 1 }
    { print; prev_import = /^import/ }
  ' "$DI_FILE" > tmp && mv tmp "$DI_FILE"
fi

# 1) Add data sources to _registerDataSources()
awk -v reg="
    // Auto-registered: $PASCAL Data Sources
    getIt.registerSingleton<${PASCAL}LocalDataSource>(
      ${PASCAL}LocalDataSourceImpl(),
    );
    
    getIt.registerSingleton<${PASCAL}RemoteDataSource>(
      ${PASCAL}RemoteDataSourceImpl(),
    );" '
  /static void _registerDataSources/ {print; found=1; next}
  found && /^\s*\/\/ TODO: Register your data sources here/ {print; print reg; next}
  found && /^\s*}/ && !printed { print reg; printed=1 }
  {print}
' "$DI_FILE" > tmp && mv tmp "$DI_FILE"

# 2) Add repository to _registerRepositories()
awk -v reg="
    // Auto-registered: $PASCAL Repository
    getIt.registerLazySingleton<${PASCAL}Repository>(
      () => ${PASCAL}RepositoryImpl(
        getIt<${PASCAL}LocalDataSource>(),
        getIt<${PASCAL}RemoteDataSource>(),
      ),
    );" '
  /static void _registerRepositories/ {print; found=1; next}
  found && /^\s*\/\/ TODO: Register your repositories here/ {print; print reg; next}
  found && /^\s*}/ && !printed { print reg; printed=1 }
  {print}
' "$DI_FILE" > tmp && mv tmp "$DI_FILE"

# 3) Add use cases to _registerUseCases()
awk -v reg="
    // Auto-registered: $PASCAL Use Cases
    getIt.registerLazySingleton<Get${PASCAL}UseCase>(
      () => Get${PASCAL}UseCase(getIt<${PASCAL}Repository>()),
    );
    
    getIt.registerLazySingleton<Create${PASCAL}UseCase>(
      () => Create${PASCAL}UseCase(getIt<${PASCAL}Repository>()),
    );
    
    getIt.registerLazySingleton<Update${PASCAL}UseCase>(
      () => Update${PASCAL}UseCase(getIt<${PASCAL}Repository>()),
    );
    
    getIt.registerLazySingleton<Delete${PASCAL}UseCase>(
      () => Delete${PASCAL}UseCase(getIt<${PASCAL}Repository>()),
    );" '
  /static void _registerUseCases/ {print; found=1; next}
  found && /^\s*\/\/ TODO: Register your use cases here/ {print; print reg; next}
  found && /^\s*}/ && !printed { print reg; printed=1 }
  {print}
' "$DI_FILE" > tmp && mv tmp "$DI_FILE"

# 4) Add provider to _registerProviders()
awk -v reg="
    // Auto-registered: $PASCAL Provider
    getIt.registerFactory<${PASCAL}Provider>(
      () => ${PASCAL}Provider(),
    );" '
  /static void _registerProviders/ {print; found=1; next}
  found && /^\s*\/\/ TODO: Register your providers/ {print; print reg; next}
  found && /^\s*}/ && !printed { print reg; printed=1 }
  {print}
' "$DI_FILE" > tmp && mv tmp "$DI_FILE"

# Add provider import
PROVIDER_IMPORT="import '../features/${SNAKE}/presentation/providers/${SNAKE}_provider.dart';"
if ! grep -q "${SNAKE}_provider.dart" "$DI_FILE"; then
  sed -i.bak "1i\\
$PROVIDER_IMPORT
" "$DI_FILE" && rm "$DI_FILE.bak"
fi

echo "✅ DI registration completed for $PASCAL feature"
echo "📝 Added imports, data sources, repository, use cases, and provider"