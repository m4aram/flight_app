import '../../../../core/utils/result.dart';
import '../entities/profile.dart';

abstract interface class ProfileRepository {
  /// `null` when the user hasn't saved a profile yet.
  Future<Result<Profile?>> getProfile();

  Future<Result<void>> saveProfile(Profile profile);
}
