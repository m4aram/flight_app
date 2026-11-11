import '../../../../core/utils/result.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._local);

  final SettingsLocalDataSource _local;

  @override
  Future<Result<AppSettings>> getSettings() =>
      guard(() async => _local.getSettings());

  @override
  Future<Result<void>> saveSettings(AppSettings settings) =>
      guard(() => _local.saveSettings(settings));
}
