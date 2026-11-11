import '../../../../core/utils/result.dart';
import '../entities/app_settings.dart';

abstract interface class SettingsRepository {
  Future<Result<AppSettings>> getSettings();

  Future<Result<void>> saveSettings(AppSettings settings);
}
