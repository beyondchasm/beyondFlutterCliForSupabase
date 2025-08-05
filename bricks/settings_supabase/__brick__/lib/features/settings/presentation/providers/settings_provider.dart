import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/use_cases/get_settings_usecase.dart';
import '../../domain/use_cases/update_settings_usecase.dart';
import '../../domain/use_cases/reset_settings_usecase.dart';
import '../../domain/use_cases/export_import_settings_usecase.dart';
import '../../../../core/di/injection.dart';

class SettingsState {
  final AppSettings? settings;
  final bool isLoading;
  final bool isUpdating;
  final String? error;

  const SettingsState({
    this.settings,
    this.isLoading = false,
    this.isUpdating = false,
    this.error,
  });

  SettingsState copyWith({
    AppSettings? settings,
    bool? isLoading,
    bool? isUpdating,
    String? error,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      error: error ?? this.error,
    );
  }

  AppThemeMode get currentThemeMode {
    return settings?.themeMode ?? AppThemeMode.system;
  }

  Locale? get currentLocale {
    if (settings == null || settings!.language == 'system') {
      return null;
    }

    final parts = settings!.language.split('_');
    if (parts.length == 2) {
      return Locale(parts[0], parts[1]);
    } else {
      return Locale(parts[0]);
    }
  }

  double get textScaleFactor {
    return settings?.textScale ?? 1.0;
  }

  bool get isHighContrastEnabled {
    return settings?.highContrastEnabled ?? false;
  }

  bool get shouldReduceAnimations {
    return settings?.reduceAnimationsEnabled ?? false;
  }
}

@injectable
class SettingsNotifier extends AsyncNotifier<SettingsState> {
  final GetSettingsUseCase _getSettingsUseCase;
  final UpdateSettingsUseCase _updateSettingsUseCase;
  final ResetSettingsUseCase _resetSettingsUseCase;
  final ExportImportSettingsUseCase _exportImportSettingsUseCase;

  SettingsNotifier(
    this._getSettingsUseCase,
    this._updateSettingsUseCase,
    this._resetSettingsUseCase,
    this._exportImportSettingsUseCase,
  );

  StreamSubscription<AppSettings>? _settingsSubscription;

  @override
  FutureOr<SettingsState> build() async {
    final settings = await _getSettingsUseCase.call();
    _subscribeToSettings();
    return SettingsState(settings: settings);
  }

  void _subscribeToSettings() {
    _settingsSubscription?.cancel();
    _settingsSubscription = _getSettingsUseCase.getStream().listen(
      (settings) {
        state = AsyncValue.data(
          state.value!.copyWith(settings: settings, error: null),
        );
      },
      onError: (error) {
        state = AsyncValue.data(state.value!.copyWith(error: error.toString()));
      },
    );
  }

  Future<void> updateSettings(AppSettings settings) async {
    state = AsyncValue.data(
      state.value!.copyWith(isUpdating: true, error: null),
    );

    try {
      final updatedSettings = await _updateSettingsUseCase.call(settings);
      state = AsyncValue.data(
        state.value!.copyWith(settings: updatedSettings, isUpdating: false),
      );
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(isUpdating: false, error: e.toString()),
      );
    }
  }

  Future<void> updateSetting<T>(String key, T value) async {
    if (state.value?.settings == null) return;

    state = AsyncValue.data(
      state.value!.copyWith(isUpdating: true, error: null),
    );

    try {
      await _updateSettingsUseCase.updateSetting<T>(key, value);

      final currentSettings = state.value!.settings!;
      final json = currentSettings.toJson();
      json[key] = value;
      json['updatedAt'] = DateTime.now().toIso8601String();

      final updatedSettings = AppSettings.fromJson(json);
      state = AsyncValue.data(
        state.value!.copyWith(settings: updatedSettings, isUpdating: false),
      );
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(isUpdating: false, error: e.toString()),
      );
    }
  }

  Future<void> updateThemeMode(AppThemeMode themeMode) async {
    if (state.value?.settings == null) return;

    final updatedSettings = state.value!.settings!.copyWith(
      themeMode: themeMode,
    );
    await updateSettings(updatedSettings);
  }

  Future<void> updateLanguage(String language) async {
    if (state.value?.settings == null) return;

    final updatedSettings = state.value!.settings!.copyWith(language: language);
    await updateSettings(updatedSettings);
  }

  Future<void> toggleNotifications(bool enabled) async {
    if (state.value?.settings == null) return;

    final updatedSettings = state.value!.settings!.copyWith(
      pushNotificationsEnabled: enabled,
      inAppNotificationsEnabled: enabled,
    );
    await updateSettings(updatedSettings);
  }

  Future<void> toggleBiometricAuth(bool enabled) async {
    if (state.value?.settings == null) return;

    final updatedSettings = state.value!.settings!.copyWith(
      biometricAuthEnabled: enabled,
    );
    await updateSettings(updatedSettings);
  }

  Future<void> updateAutoLockDuration(AutoLockDuration duration) async {
    if (state.value?.settings == null) return;

    final updatedSettings = state.value!.settings!.copyWith(
      autoLockDuration: duration,
    );
    await updateSettings(updatedSettings);
  }

  Future<void> updateTextScale(double scale) async {
    if (state.value?.settings == null) return;

    final updatedSettings = state.value!.settings!.copyWith(textScale: scale);
    await updateSettings(updatedSettings);
  }

  Future<void> toggleAnalytics(bool enabled) async {
    if (state.value?.settings == null) return;

    final updatedSettings = state.value!.settings!.copyWith(
      analyticsEnabled: enabled,
    );
    await updateSettings(updatedSettings);
  }

  Future<void> resetToDefaults() async {
    state = AsyncValue.data(
      state.value!.copyWith(isUpdating: true, error: null),
    );

    try {
      final resetSettings = await _resetSettingsUseCase.call();
      state = AsyncValue.data(
        state.value!.copyWith(settings: resetSettings, isUpdating: false),
      );
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(isUpdating: false, error: e.toString()),
      );
    }
  }

  Future<Map<String, dynamic>?> exportSettings() async {
    state = AsyncValue.data(
      state.value!.copyWith(isUpdating: true, error: null),
    );

    try {
      final exportedSettings = await _exportImportSettingsUseCase
          .exportSettings();
      state = AsyncValue.data(state.value!.copyWith(isUpdating: false));
      return exportedSettings;
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(isUpdating: false, error: e.toString()),
      );
      return null;
    }
  }

  Future<void> importSettings(Map<String, dynamic> json) async {
    state = AsyncValue.data(
      state.value!.copyWith(isUpdating: true, error: null),
    );

    try {
      final importedSettings = await _exportImportSettingsUseCase
          .importSettings(json);
      state = AsyncValue.data(
        state.value!.copyWith(settings: importedSettings, isUpdating: false),
      );
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(isUpdating: false, error: e.toString()),
      );
    }
  }

  void clearError() {
    state = AsyncValue.data(state.value!.copyWith(error: null));
  }
}

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, SettingsState>(
  () {
    return getIt<SettingsNotifier>();
  },
);
