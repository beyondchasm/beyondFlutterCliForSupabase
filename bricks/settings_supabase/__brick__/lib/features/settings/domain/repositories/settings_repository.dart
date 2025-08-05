import '../entities/app_settings.dart';

abstract class SettingsRepository {
  /// Get current app settings
  Future<AppSettings> getSettings();
  
  /// Update app settings
  Future<AppSettings> updateSettings(AppSettings settings);
  
  /// Reset settings to default
  Future<AppSettings> resetToDefaults();
  
  /// Get settings stream for real-time updates
  Stream<AppSettings> getSettingsStream();
  
  /// Update a specific setting
  Future<void> updateSetting<T>(String key, T value);
  
  /// Get a specific setting value
  Future<T?> getSetting<T>(String key);
  
  /// Check if settings exist
  Future<bool> hasSettings();
  
  /// Export settings as JSON
  Future<Map<String, dynamic>> exportSettings();
  
  /// Import settings from JSON
  Future<AppSettings> importSettings(Map<String, dynamic> json);
  
  /// Clear all settings
  Future<void> clearSettings();
}