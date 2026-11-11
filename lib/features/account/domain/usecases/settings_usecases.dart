import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class GetSettings implements UseCase<AppSettings, NoParams> {
  const GetSettings(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Result<AppSettings>> call(NoParams params) =>
      _repository.getSettings();
}

class SaveSettings implements UseCase<void, AppSettings> {
  const SaveSettings(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Result<void>> call(AppSettings params) async {
    final isValid =
        AppSettings.languages.contains(params.language) &&
        AppSettings.currencies.contains(params.currency) &&
        AppSettings.regions.any((r) => r.code == params.regionCode);
    if (!isValid) return const Failed(ValidationFailure('Invalid settings'));
    return _repository.saveSettings(params);
  }
}
