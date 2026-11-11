import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/utils/validators.dart';
import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class GetProfile implements UseCase<Profile?, NoParams> {
  const GetProfile(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Result<Profile?>> call(NoParams params) => _repository.getProfile();
}

class SaveProfile implements UseCase<void, Profile> {
  const SaveProfile(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Result<void>> call(Profile params) async {
    final error =
        Validators.name(params.firstName, field: 'First name') ??
        Validators.name(params.lastName, field: 'Last name') ??
        Validators.email(params.email);
    if (error != null) return Failed(ValidationFailure(error));

    final dob = params.dateOfBirth;
    if (dob != null && dob.isAfter(DateTime.now())) {
      return const Failed(ValidationFailure('Invalid date of birth'));
    }

    return _repository.saveProfile(
      Profile(
        firstName: params.firstName.trim(),
        lastName: params.lastName.trim(),
        email: params.email.trim().toLowerCase(),
        gender: params.gender,
        dateOfBirth: params.dateOfBirth,
        nationality: params.nationality,
      ),
    );
  }
}
