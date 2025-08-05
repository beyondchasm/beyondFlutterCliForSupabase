import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/app_settings_local_model.dart';
import 'settings_local_data_source.dart';

@LazySingleton(as: SettingsLocalDataSource)
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences _prefs;
  final String _settingsKey = 'app_settings';
  final StreamController<AppSettingsLocalModel?> _settingsController = 
      StreamController<AppSettingsLocalModel?>.broadcast();

  SettingsLocalDataSourceImpl(this._prefs);

  @override
  Future<AppSettingsLocalModel?> getSettings() async {
    try {
      final settingsJson = _prefs.getString(_settingsKey);
      if (settingsJson == null) return null;
      
      final json = jsonDecode(settingsJson) as Map<String, dynamic>;
      return AppSettingsLocalModel.fromJson(json);
    } catch (e) {
      throw Exception('Failed to get settings: $e');
    }
  }

  @override
  Future<void> saveSettings(AppSettingsLocalModel settings) async {
    try {
      final json = settings.toJson();
      final settingsJson = jsonEncode(json);
      await _prefs.setString(_settingsKey, settingsJson);
      
      // Notify listeners
      _settingsController.add(settings);
    } catch (e) {
      throw Exception('Failed to save settings: $e');
    }
  }

  @override
  Future<void> updateSetting<T>(String key, T value) async {
    try {
      final currentSettings = await getSettings();
      if (currentSettings == null) {
        throw Exception('No settings found to update');
      }

      // Update the specific setting
      final updatedJson = currentSettings.toJson();
      updatedJson[key] = value;
      updatedJson['updatedAt'] = DateTime.now().toIso8601String();

      final updatedSettings = AppSettingsLocalModel.fromJson(updatedJson);
      await saveSettings(updatedSettings);
    } catch (e) {
      throw Exception('Failed to update setting $key: $e');
    }
  }

  @override
  Future<T?> getSetting<T>(String key) async {
    try {
      final settings = await getSettings();
      if (settings == null) return null;
      
      final json = settings.toJson();
      return json[key] as T?;
    } catch (e) {
      throw Exception('Failed to get setting $key: $e');
    }
  }

  @override
  Future<bool> hasSettings() async {
    return _prefs.containsKey(_settingsKey);
  }

  @override
  Future<void> clearSettings() async {
    try {
      await _prefs.remove(_settingsKey);
      _settingsController.add(null);
    } catch (e) {
      throw Exception('Failed to clear settings: $e');
    }
  }

  @override
  Stream<AppSettingsLocalModel?> getSettingsStream() {
    return _settingsController.stream;
  }

  @disposeMethod
  void dispose() {
    _settingsController.close();
  }
}