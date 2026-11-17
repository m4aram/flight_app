import 'package:flight_app/core/error/exceptions.dart';
import 'package:flight_app/core/error/failures.dart';
import 'package:flight_app/core/utils/result.dart';
import 'package:flight_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flight_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flight_app/features/auth/data/models/user_model.dart';
import 'package:flight_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flight_app/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemote extends Mock implements AuthRemoteDataSource {}

class MockLocal extends Mock implements AuthLocalDataSource {}

void main() {
  late MockRemote remote;
  late MockLocal local;
  late AuthRepositoryImpl repository;

  setUp(() {
    remote = MockRemote();
    local = MockLocal();
    repository = AuthRepositoryImpl(remote: remote, local: local);
  });

  group('AuthRepositoryImpl.login', () {
    test('turns AuthException into AuthFailure and saves nothing', () async {
      // Arrange: the server throws
      when(
            () => remote.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const AuthException('Wrong email or password'));

      // Act
      final result = await repository.login(
        email: 'manar@gmail.com',
        password: 'wrong-pass',
      );

      // Assert
      final failure = result.fold((f) => f, (_) => null);
      expect(failure, const AuthFailure('Wrong email or password'));
      verifyNoMoreInteractions(local);
    });
    test('saves the session when login succeeds', () async {
      // Arrange
      const session = AuthSession(
        token: 'abc123',
        user: UserModel(id: '1', email: 'manar@gmail.com'),
      );
      when(
            () => remote.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => session);
      when(() => local.saveSession(session)).thenAnswer((_) async {});
      // Act
      final result = await repository.login(
        email: 'manar@gmail.com',
        password: '12345678',
      );

      // Assert
      expect(result, isA<Success<User>>());
      verify(() => local.saveSession(session)).called(1);
    });
  });

}