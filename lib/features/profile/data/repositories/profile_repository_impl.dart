import '../../../../core/utils/result.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._local);

  final ProfileLocalDataSource _local;

  @override
  Future<Result<Profile?>> getProfile() =>
      guard(() async => _local.getProfile());

  @override
  Future<Result<void>> saveProfile(Profile profile) =>
      guard(() => _local.saveProfile(ProfileModel.fromEntity(profile)));
}
