import 'package:injectable/injectable.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

@lazySingleton
class UpdateSettingsUseCase {
  final SettingsRepository _repository;

  UpdateSettingsUseCase(this._repository);

  Future<AppSettings> call(AppSettings settings) async {
    final validationErrors = settings.validate();
    if (validationErrors.isNotEmpty) {
      throw Exception('Settings validation failed: ${validationErrors.join(', ')}');
    }

    final updatedSettings = settings.copyWithTimestamp();
    return await _repository.updateSettings(updatedSettings);
  }

  Future<void> updateSetting<T>(String key, T value) async {
    if (key.isEmpty) {
      throw Exception('Setting key cannot be empty');
    }
    
    await _repository.updateSetting<T>(key, value);
  }
}