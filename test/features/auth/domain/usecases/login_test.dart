import 'package:flight_app/core/utils/result.dart';
import 'package:flight_app/features/auth/domain/entities/user.dart';
import 'package:flight_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flight_app/features/auth/domain/usecases/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flight_app/core/error/failures.dart';
/// A fake repository. It does nothing unless we tell it what to do.
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late Login login;

  // Runs before EVERY test, so each test starts fresh.
  setUp(() {
    repository = MockAuthRepository();
    login = Login(repository);
  });

  group('Login', () {
    test('does not call the repository when the email is invalid', () async {
      // Act
      final result = await login(
        const LoginParams(email: 'manar', password: '12345678'),
      );

      // Assert
      expect(result, isA<Failed<User>>());
      verifyNever(
            () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    });
    test('sends a clean email to the repository', () async {
      // Arrange: tell the mock what to answer
      const manar = User(id: '1', email: 'manar@gmail.com', name: 'Manar');
      when(
            () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Success(manar));

      // Act
      final result = await login(
        const LoginParams(email: '  Manar@Gmail.com ', password: '12345678'),
      );

      // Assert
      expect(result, isA<Success<User>>());
      verify(
            () => repository.login(email: 'manar@gmail.com', password: '12345678'),
      ).called(1);
    });
    test('returns the failure when the server rejects the login', () async {
      // Arrange: tell the mock what to answer
      when(
            () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Failed(AuthFailure('Wrong email or password')));

      // Act
      final result = await login(
        const LoginParams(email: '  Manar@Gmail.com ', password: '12345678'),
      );

      // Assert
      expect(result, isA<Failed<User>>());
    });
  });
}