#!/bin/bash

# Register User Supabase Dependencies
# This script adds the necessary DI registrations to the service locator

DI_FILE="lib/core/di/dependencies_injection.dart"

if [ -f "$DI_FILE" ]; then
    # Add imports
    grep -q "import.*user.*supabase_user_remote_data_source" "$DI_FILE" || {
        sed -i '' '/^import.*service_locator/a\
\
// User Supabase Imports\
import '\''../../features/user/data/remote/data_sources/supabase_user_remote_data_source.dart'\'';\
import '\''../../features/user/data/remote/data_sources/supabase_user_remote_data_source_impl.dart'\'';\
import '\''../../features/user/data/repositories/user_repository_impl.dart'\'';\
import '\''../../features/user/domain/repositories/user_repository.dart'\'';\
import '\''../../features/user/domain/use_cases/get_user_profile_usecase.dart'\'';\
import '\''../../features/user/domain/use_cases/update_user_profile_usecase.dart'\'';\
import '\''../../features/user/domain/use_cases/delete_user_profile_usecase.dart'\'';\
import '\''../../features/user/presentation/providers/user_provider.dart'\'';\

' "$DI_FILE"
    }

    # Add registrations
    grep -q "registerLazySingleton<SupabaseUserRemoteDataSource>" "$DI_FILE" || {
        sed -i '' '/void _registerDataSources()/,/^  }$/{
            /^  }$/ i\
\
    // User Supabase Data Sources\
    registerLazySingleton<SupabaseUserRemoteDataSource>(\
      () => SupabaseUserRemoteDataSourceImpl(),\
    );\

        }' "$DI_FILE"
    }

    grep -q "registerLazySingleton<UserRepository>" "$DI_FILE" || {
        sed -i '' '/void _registerRepositories()/,/^  }$/{
            /^  }$/ i\
\
    // User Repository\
    registerLazySingleton<UserRepository>(\
      () => UserRepositoryImpl(),\
    );\

        }' "$DI_FILE"
    }

    grep -q "registerLazySingleton<GetUserProfileUseCase>" "$DI_FILE" || {
        sed -i '' '/void _registerUseCases()/,/^  }$/{
            /^  }$/ i\
\
    // User Use Cases\
    registerLazySingleton<GetUserProfileUseCase>(() => GetUserProfileUseCase());\
    registerLazySingleton<UpdateUserProfileUseCase>(() => UpdateUserProfileUseCase());\
    registerLazySingleton<DeleteUserProfileUseCase>(() => DeleteUserProfileUseCase());\

        }' "$DI_FILE"
    }

    grep -q "registerFactory<UserProvider>" "$DI_FILE" || {
        sed -i '' '/void _registerProviders()/,/^  }$/{
            /^  }$/ i\
\
    // User Provider\
    registerFactory<UserProvider>(() => UserProvider());\

        }' "$DI_FILE"
    }

    echo "✅ User Supabase DI registration completed"
else
    echo "⚠️  DI file not found: $DI_FILE"
fi