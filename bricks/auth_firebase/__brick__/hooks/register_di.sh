#!/bin/bash

# Register Auth Firebase Dependencies
# This script adds the necessary DI registrations to the service locator

DI_FILE="lib/core/di/dependencies_injection.dart"

if [ -f "$DI_FILE" ]; then
    # Add imports
    grep -q "import.*auth.*firebase_auth_remote_data_source" "$DI_FILE" || {
        sed -i '' '/^import.*service_locator/a\
\
// Auth Firebase Imports\
import '\''../../features/auth/data/remote/data_sources/firebase_auth_remote_data_source.dart'\'';\
import '\''../../features/auth/data/remote/data_sources/firebase_auth_remote_data_source_impl.dart'\'';\
import '\''../../features/auth/data/repositories/auth_repository_impl.dart'\'';\
import '\''../../features/auth/domain/repositories/auth_repository.dart'\'';\
import '\''../../features/auth/domain/use_cases/sign_in_usecase.dart'\'';\
import '\''../../features/auth/domain/use_cases/sign_up_usecase.dart'\'';\
import '\''../../features/auth/domain/use_cases/sign_out_usecase.dart'\'';\
import '\''../../features/auth/domain/use_cases/reset_password_usecase.dart'\'';\
import '\''../../features/auth/domain/use_cases/get_current_user_usecase.dart'\'';\
import '\''../../features/auth/presentation/providers/auth_provider.dart'\'';\

' "$DI_FILE"
    }

    # Add registrations
    grep -q "getit.registerLazySingleton<FirebaseAuthRemoteDataSource>" "$DI_FILE" || {
        sed -i '' '/void _registerDataSources()/,/^  }$/{
            /^  }$/ i\
\
    // Auth Firebase Data Sources\
    getit.registerLazySingleton<FirebaseAuthRemoteDataSource>(\
      () => FirebaseAuthRemoteDataSourceImpl(),\
    );\

        }' "$DI_FILE"
    }

    grep -q "getit.registerLazySingleton<AuthRepository>" "$DI_FILE" || {
        sed -i '' '/void _registerRepositories()/,/^  }$/{
            /^  }$/ i\
\
    // Auth Repository\
    getit.registerLazySingleton<AuthRepository>(\
      () => AuthRepositoryImpl(),\
    );\

        }' "$DI_FILE"
    }

    grep -q "getit.registerLazySingleton<SignInUseCase>" "$DI_FILE" || {
        sed -i '' '/void _registerUseCases()/,/^  }$/{
            /^  }$/ i\
\
    // Auth Use Cases\
    getit.registerLazySingleton<SignInUseCase>(() => SignInUseCase());\
    getit.registerLazySingleton<SignUpUseCase>(() => SignUpUseCase());\
    getit.registerLazySingleton<SignOutUseCase>(() => SignOutUseCase());\
    getit.registerLazySingleton<ResetPasswordUseCase>(() => ResetPasswordUseCase());\
    getit.registerLazySingleton<GetCurrentUserUseCase>(() => GetCurrentUserUseCase());\

        }' "$DI_FILE"
    }

    grep -q "getit.registerFactory<AuthProvider>" "$DI_FILE" || {
        sed -i '' '/void _registerProviders()/,/^  }$/{
            /^  }$/ i\
\
    // Auth Provider\
    getit.registerFactory<AuthProvider>(() => AuthProvider());\

        }' "$DI_FILE"
    }

    echo "✅ Auth Firebase DI registration completed"
else
    echo "⚠️  DI file not found: $DI_FILE"
fi