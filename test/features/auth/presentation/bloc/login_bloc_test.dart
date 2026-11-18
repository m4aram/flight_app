import 'package:bloc_test/bloc_test.dart';
import 'package:flight_app/core/error/failures.dart';
import 'package:flight_app/core/utils/result.dart';
import 'package:flight_app/features/auth/domain/entities/user.dart';
import 'package:flight_app/features/auth/domain/usecases/login.dart';
import 'package:flight_app/features/auth/presentation/bloc/login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// The Bloc needs a Login use case. We give it a fake one.
class MockLogin extends Mock implements Login {}
const manar = User(id: '1', email: 'manar@gmail.com');
void main() {
  late MockLogin login;
  setUpAll(() {
    registerFallbackValue(const LoginParams(email: '', password: ''));
  });
  setUp(() {
    login = MockLogin();
  });

  group('LoginBloc', () {
    test('starts with an empty form', () {
      final bloc = LoginBloc(login);

      expect(bloc.state, const LoginState());
    });

    blocTest<LoginBloc, LoginState>(
      'shows the password when the eye icon is tapped',
      build: () => LoginBloc(login),
      act: (bloc) => bloc.add(const LoginPasswordVisibilityToggled()),
      expect: () => [const LoginState(obscurePassword: false)],
    );


    blocTest<LoginBloc, LoginState>(
      'hides the password again when the eye icon is tapped twice',
      build: () => LoginBloc(login),
      act: (bloc) {
        bloc.add(const LoginPasswordVisibilityToggled());
        bloc.add(const LoginPasswordVisibilityToggled());
      },
      expect: () => [
        const LoginState(obscurePassword: false),
        const LoginState(obscurePassword: true),
      ],
    );
    blocTest<LoginBloc, LoginState>(
      'emits submitting then success when login works',
      setUp: () {
        when(() => login(any())).thenAnswer((_) async => const Success(manar));
      },
      build: () => LoginBloc(login),
      seed: () => const LoginState(
        email: 'manar@gmail.com',
        password: '12345678',
      ),
      act: (bloc) => bloc.add(const LoginSubmitted()),
      expect: () => [
        const LoginState(
          email: 'manar@gmail.com',
          password: '12345678',
          showErrors: true,
          status: LoginStatus.submitting,
        ),
        const LoginState(
          email: 'manar@gmail.com',
          password: '',
          showErrors: true,
          status: LoginStatus.success,
          user: manar,
        ),

      ],
    );

 ///////////////////////////////////////////
    blocTest<LoginBloc, LoginState>(
      'emits submitting then failure when login fails',
      setUp: () {
        when(() => login(any())).thenAnswer((_) async =>const Failed(AuthFailure('Wrong email or password')));
      },
      build: () => LoginBloc(login),
      seed: () => const LoginState(
        email: 'manar@gmail.com',
        password: '12345678',
      ),
      act: (bloc) => bloc.add(const LoginSubmitted()),
      expect: () => [
        const LoginState(
          email: 'manar@gmail.com',
          password: '12345678',
          showErrors: true,
          status: LoginStatus.submitting,
        ),
        const LoginState(
          email: 'manar@gmail.com',
          password: '12345678',
          showErrors: true,
          status: LoginStatus.failure,
          errorMessage: 'Wrong email or password',
        ),

      ],
    );
    blocTest<LoginBloc, LoginState>(
      'shows errors and does not call login when the form is empty',
      build: () => LoginBloc(login),
      act: (bloc) => bloc.add(const LoginSubmitted()),
      expect: () => [const LoginState(showErrors: true)],
      verify: (_) {
        verifyNever(() => login(any()));
      },
    );
  });
}