import 'package:injectable/injectable.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../local/data_sources/settings_local_data_source.dart';
import '../models/app_settings_local_model.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _localDataSource;

  SettingsRepositoryImpl(this._localDataSource);

  @override
  Future<AppSettings> getSettings() async {
    try {
      final localModel = await _localDataSource.getSettings();
      
      if (localModel == null) {
        // Return default settings if none exist
        final defaultSettings = AppSettings.defaults();
        await updateSettings(defaultSettings);
        return defaultSettings;
      }
      
      return localModel.toEntity();
    } catch (e) {
      throw Exception('Failed to get settings: $e');
    }
  }

  @override
  Future<AppSettings> updateSettings(AppSettings settings) async {
    try {
      final localModel = AppSettingsLocalModel.fromEntity(settings);
      await _localDataSource.saveSettings(localModel);
      return settings;
    } catch (e) {
      throw Exception('Failed to update settings: $e');
    }
  }

  @override
  Future<AppSettings> resetToDefaults() async {
    try {
      await _localDataSource.clearSettings();
      final defaultSettings = AppSettings.defaults();
      await updateSettings(defaultSettings);
      return defaultSettings;
    } catch (e) {
      throw Exception('Failed to reset settings: $e');
    }
  }

  @override
  Stream<AppSettings> getSettingsStream() {
    return _localDataSource.getSettingsStream().map((localModel) {
      if (localModel == null) {
        return AppSettings.defaults();
      }
      return localModel.toEntity();
    });
  }

  @override
  Future<void> updateSetting<T>(String key, T value) async {
    try {
      await _localDataSource.updateSetting<T>(key, value);
    } catch (e) {
      throw Exception('Failed to update setting $key: $e');
    }
  }

  @override
  Future<T?> getSetting<T>(String key) async {
    try {
      return await _localDataSource.getSetting<T>(key);
    } catch (e) {
      throw Exception('Failed to get setting $key: $e');
    }
  }

  @override
  Future<bool> hasSettings() async {
    try {
      return await _localDataSource.hasSettings();
    } catch (e) {
      throw Exception('Failed to check if settings exist: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> exportSettings() async {
    try {
      final settings = await getSettings();
      return settings.toJson();
    } catch (e) {
      throw Exception('Failed to export settings: $e');
    }
  }

  @override
  Future<AppSettings> importSettings(Map<String, dynamic> json) async {
    try {
      final settings = AppSettings.fromJson(json);
      await updateSettings(settings);
      return settings;
    } catch (e) {
      throw Exception('Failed to import settings: $e');
    }
  }

  @override
  Future<void> clearSettings() async {
    try {
      await _localDataSource.clearSettings();
    } catch (e) {
      throw Exception('Failed to clear settings: $e');
    }
  }
}