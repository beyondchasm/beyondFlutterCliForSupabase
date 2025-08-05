import 'package:injectable/injectable.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

@lazySingleton
class ResetSettingsUseCase {
  final SettingsRepository _repository;

  ResetSettingsUseCase(this._repository);

  Future<AppSettings> call() async {
    return await _repository.resetToDefaults();
  }
}