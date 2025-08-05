import 'package:injectable/injectable.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

@lazySingleton
class GetSettingsUseCase {
  final SettingsRepository _repository;

  GetSettingsUseCase(this._repository);

  Future<AppSettings> call() async {
    try {
      final hasSettings = await _repository.hasSettings();
      if (!hasSettings) {
        // Return default settings if none exist
        final defaultSettings = AppSettings.defaults();
        await _repository.updateSettings(defaultSettings);
        return defaultSettings;
      }
      
      return await _repository.getSettings();
    } catch (e) {
      // Return default settings on error
      return AppSettings.defaults();
    }
  }

  Stream<AppSettings> getStream() {
    return _repository.getSettingsStream();
  }
}