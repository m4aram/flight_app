import '../../../../core/utils/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Future<Result<User>> login({
    required String email,
    required String password,
  }) {
    return guard(() async {
      final session = await _remote.login(email: email, password: password);
      await _local.saveSession(session);
      return session.user;
    });
  }

  @override
  Future<Result<User>> register({
    required String name,
    required String email,
    required String password,
  }) {
    return guard(() async {
      final session = await _remote.register(
        name: name,
        email: email,
        password: password,
      );
      await _local.saveSession(session);
      return session.user;
    });
  }

  @override
  Future<Result<void>> sendPasswordReset({required String email}) =>
      guard(() => _remote.sendPasswordReset(email: email));

  @override
  Future<Result<void>> logout() => guard(_local.clearSession);

  @override
  Future<Result<User?>> getCurrentUser() => guard(_local.getCachedUser);
}
