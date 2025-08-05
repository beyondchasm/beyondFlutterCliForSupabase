import 'package:injectable/injectable.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

@lazySingleton
class ExportImportSettingsUseCase {
  final SettingsRepository _repository;

  ExportImportSettingsUseCase(this._repository);

  Future<Map<String, dynamic>> exportSettings() async {
    final settings = await _repository.exportSettings();
    
    // Add metadata
    settings['exportedAt'] = DateTime.now().toIso8601String();
    settings['exportVersion'] = '1.0.0';
    
    return settings;
  }

  Future<AppSettings> importSettings(Map<String, dynamic> json) async {
    if (json.isEmpty) {
      throw Exception('Settings data cannot be empty');
    }

    // Validate import data
    if (!json.containsKey('themeMode') && !json.containsKey('language')) {
      throw Exception('Invalid settings format - missing required fields');
    }

    // Remove metadata before importing
    final cleanedJson = Map<String, dynamic>.from(json);
    cleanedJson.remove('exportedAt');
    cleanedJson.remove('exportVersion');

    try {
      final importedSettings = await _repository.importSettings(cleanedJson);
      final validationErrors = importedSettings.validate();
      
      if (validationErrors.isNotEmpty) {
        throw Exception('Imported settings validation failed: ${validationErrors.join(', ')}');
      }

      return importedSettings;
    } catch (e) {
      throw Exception('Failed to import settings: $e');
    }
  }
}