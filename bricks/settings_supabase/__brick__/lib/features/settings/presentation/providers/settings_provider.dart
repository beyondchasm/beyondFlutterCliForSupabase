import 'dart:async';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/use_cases/get_settings_usecase.dart';
import '../../domain/use_cases/update_settings_usecase.dart';
import '../../domain/use_cases/reset_settings_usecase.dart';
import '../../domain/use_cases/export_import_settings_usecase.dart';

@injectable
class SettingsProvider extends ChangeNotifier {
  final GetSettingsUseCase _getSettingsUseCase;
  final UpdateSettingsUseCase _updateSettingsUseCase;
  final ResetSettingsUseCase _resetSettingsUseCase;
  final ExportImportSettingsUseCase _exportImportSettingsUseCase;

  SettingsProvider(
    this._getSettingsUseCase,
    this._updateSettingsUseCase,
    this._resetSettingsUseCase,
    this._exportImportSettingsUseCase,
  );

  AppSettings? _settings;
  bool _isLoading = false;
  bool _isUpdating = false;
  String? _error;
  StreamSubscription<AppSettings>? _settingsSubscription;

  AppSettings? get settings => _settings;
  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  String? get error => _error;

  /// Initialize settings
  Future<void> initialize() async {
    _setLoading(true);
    _setError(null);

    try {
      _settings = await _getSettingsUseCase.call();
      _subscribeToSettings();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Subscribe to settings stream for real-time updates
  void _subscribeToSettings() {
    _settingsSubscription?.cancel();
    _settingsSubscription = _getSettingsUseCase.getStream().listen(
      (settings) {
        _settings = settings;
        _setError(null);
        notifyListeners();
      },
      onError: (error) {
        _setError(error.toString());
      },
    );
  }

  /// Update entire settings
  Future<void> updateSettings(AppSettings settings) async {
    _setUpdating(true);
    _setError(null);

    try {
      _settings = await _updateSettingsUseCase.call(settings);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setUpdating(false);
    }
  }

  /// Update a specific setting
  Future<void> updateSetting<T>(String key, T value) async {
    if (_settings == null) return;

    _setUpdating(true);
    _setError(null);

    try {
      await _updateSettingsUseCase.updateSetting<T>(key, value);
      
      // Update local state immediately for better UX
      final currentSettings = _settings!;
      final json = currentSettings.toJson();
      json[key] = value;
      json['updatedAt'] = DateTime.now().toIso8601String();
      
      _settings = AppSettings.fromJson(json);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setUpdating(false);
    }
  }

  /// Update theme mode
  Future<void> updateThemeMode(ThemeMode themeMode) async {
    if (_settings == null) return;
    
    final updatedSettings = _settings!.copyWith(themeMode: themeMode);
    await updateSettings(updatedSettings);
  }

  /// Update language
  Future<void> updateLanguage(String language) async {
    if (_settings == null) return;
    
    final updatedSettings = _settings!.copyWith(language: language);
    await updateSettings(updatedSettings);
  }

  /// Toggle notification setting
  Future<void> toggleNotifications(bool enabled) async {
    if (_settings == null) return;
    
    final updatedSettings = _settings!.copyWith(
      pushNotificationsEnabled: enabled,
      inAppNotificationsEnabled: enabled,
    );
    await updateSettings(updatedSettings);
  }

  /// Toggle biometric authentication
  Future<void> toggleBiometricAuth(bool enabled) async {
    if (_settings == null) return;
    
    final updatedSettings = _settings!.copyWith(biometricAuthEnabled: enabled);
    await updateSettings(updatedSettings);
  }

  /// Update auto lock duration
  Future<void> updateAutoLockDuration(AutoLockDuration duration) async {
    if (_settings == null) return;
    
    final updatedSettings = _settings!.copyWith(autoLockDuration: duration);
    await updateSettings(updatedSettings);
  }

  /// Update text scale
  Future<void> updateTextScale(double scale) async {
    if (_settings == null) return;
    
    final updatedSettings = _settings!.copyWith(textScale: scale);
    await updateSettings(updatedSettings);
  }

  /// Toggle analytics
  Future<void> toggleAnalytics(bool enabled) async {
    if (_settings == null) return;
    
    final updatedSettings = _settings!.copyWith(analyticsEnabled: enabled);
    await updateSettings(updatedSettings);
  }

  /// Reset settings to defaults
  Future<void> resetToDefaults() async {
    _setUpdating(true);
    _setError(null);

    try {
      _settings = await _resetSettingsUseCase.call();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setUpdating(false);
    }
  }

  /// Export settings
  Future<Map<String, dynamic>?> exportSettings() async {
    _setUpdating(true);
    _setError(null);

    try {
      final exportedSettings = await _exportImportSettingsUseCase.exportSettings();
      return exportedSettings;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setUpdating(false);
    }
  }

  /// Import settings
  Future<void> importSettings(Map<String, dynamic> json) async {
    _setUpdating(true);
    _setError(null);

    try {
      _settings = await _exportImportSettingsUseCase.importSettings(json);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setUpdating(false);
    }
  }

  /// Get current theme mode for system-wide use
  ThemeMode get currentThemeMode {
    return _settings?.themeMode ?? ThemeMode.system;
  }

  /// Get current locale for system-wide use
  Locale? get currentLocale {
    if (_settings == null || _settings!.language == 'system') {
      return null; // Use system locale
    }
    
    final parts = _settings!.language.split('_');
    if (parts.length == 2) {
      return Locale(parts[0], parts[1]);
    } else {
      return Locale(parts[0]);
    }
  }

  /// Get text scale factor
  double get textScaleFactor {
    return _settings?.textScale ?? 1.0;
  }

  /// Check if high contrast is enabled
  bool get isHighContrastEnabled {
    return _settings?.highContrastEnabled ?? false;
  }

  /// Check if animations should be reduced
  bool get shouldReduceAnimations {
    return _settings?.reduceAnimationsEnabled ?? false;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setUpdating(bool updating) {
    _isUpdating = updating;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _settingsSubscription?.cancel();
    super.dispose();
  }
}