import '../../../../core/utils/result.dart';
import '../entities/user.dart';

abstract interface class AuthRepository {
  Future<Result<User>> login({required String email, required String password});

  Future<Result<User>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<void>> sendPasswordReset({required String email});

  Future<Result<void>> logout();

  /// Returns the signed-in user, or `null` when there is no session.
  Future<Result<User?>> getCurrentUser();
}
