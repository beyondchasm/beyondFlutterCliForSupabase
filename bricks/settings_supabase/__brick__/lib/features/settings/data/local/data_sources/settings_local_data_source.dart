import '../../models/app_settings_local_model.dart';

abstract class SettingsLocalDataSource {
  /// Get settings from local storage
  Future<AppSettingsLocalModel?> getSettings();
  
  /// Save settings to local storage
  Future<void> saveSettings(AppSettingsLocalModel settings);
  
  /// Update a specific setting
  Future<void> updateSetting<T>(String key, T value);
  
  /// Get a specific setting value
  Future<T?> getSetting<T>(String key);
  
  /// Check if settings exist
  Future<bool> hasSettings();
  
  /// Clear all settings
  Future<void> clearSettings();
  
  /// Get settings stream for real-time updates
  Stream<AppSettingsLocalModel?> getSettingsStream();
}