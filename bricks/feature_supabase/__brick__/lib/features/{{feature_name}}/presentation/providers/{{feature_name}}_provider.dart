import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/{{feature_name}}.dart';
import '../../domain/use_cases/get_{{feature_name}}_usecase.dart';
import '../../domain/use_cases/create_{{feature_name}}_usecase.dart';
import '../../domain/use_cases/update_{{feature_name}}_usecase.dart';
import '../../domain/use_cases/delete_{{feature_name}}_usecase.dart';
import '../../../../core/di/injection.dart';

class {{feature_name.pascalCase()}}State {
  final List<{{feature_name.pascalCase()}}> items;
  final bool isLoading;
  final String? error;

  const {{feature_name.pascalCase()}}State({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  {{feature_name.pascalCase()}}State copyWith({
    List<{{feature_name.pascalCase()}}>? items,
    bool? isLoading,
    String? error,
  }) {
    return {{feature_name.pascalCase()}}State(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

@injectable
class {{feature_name.pascalCase()}}Notifier extends AsyncNotifier<{{feature_name.pascalCase()}}State> {
  final Get{{feature_name.pascalCase()}}UseCase _getUseCase;
  final Create{{feature_name.pascalCase()}}UseCase _createUseCase;
  final Update{{feature_name.pascalCase()}}UseCase _updateUseCase;
  final Delete{{feature_name.pascalCase()}}UseCase _deleteUseCase;

  {{feature_name.pascalCase()}}Notifier(
    this._getUseCase,
    this._createUseCase,
    this._updateUseCase,
    this._deleteUseCase,
  );

  @override
  FutureOr<{{feature_name.pascalCase()}}State> build() async {
    return const {{feature_name.pascalCase()}}State();
  }

  Future<void> loadAll() async {
    state = AsyncValue.data(
      state.value!.copyWith(isLoading: true, error: null),
    );

    try {
      final list = await _getUseCase();
      state = AsyncValue.data(
        state.value!.copyWith(items: list, isLoading: false),
      );
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  Future<void> create({{feature_name.pascalCase()}} item) async {
    state = AsyncValue.data(
      state.value!.copyWith(isLoading: true, error: null),
    );

    try {
      final created = await _createUseCase(item);
      state = AsyncValue.data(
        state.value!.copyWith(
          items: [...state.value!.items, created], 
          isLoading: false,
        ),
      );
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  Future<void> update({{feature_name.pascalCase()}} item) async {
    state = AsyncValue.data(
      state.value!.copyWith(isLoading: true, error: null),
    );

    try {
      final updated = await _updateUseCase(item);
      final idx = state.value!.items.indexWhere((e) => e.id == item.id);
      if (idx != -1) {
        final newList = [...state.value!.items]..[idx] = updated;
        state = AsyncValue.data(
          state.value!.copyWith(items: newList, isLoading: false),
        );
      }
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  Future<void> delete(int id) async {
    state = AsyncValue.data(
      state.value!.copyWith(isLoading: true, error: null),
    );

    try {
      final success = await _deleteUseCase(id);
      if (success) {
        state = AsyncValue.data(
          state.value!.copyWith(
            items: state.value!.items.where((e) => e.id != id).toList(),
            isLoading: false,
          ),
        );
      }
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  void clearError() {
    state = AsyncValue.data(state.value!.copyWith(error: null));
  }
}

final {{feature_name.camelCase()}}Provider = AsyncNotifierProvider<{{feature_name.pascalCase()}}Notifier, {{feature_name.pascalCase()}}State>(() {
  return getIt<{{feature_name.pascalCase()}}Notifier>();
});