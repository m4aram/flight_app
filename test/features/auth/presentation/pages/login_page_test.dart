import 'package:flight_app/core/error/failures.dart';
import 'package:flight_app/core/utils/result.dart';
import 'package:flight_app/core/widgets/primary_button.dart';
import 'package:flight_app/features/auth/domain/usecases/login.dart';
import 'package:flight_app/features/auth/presentation/bloc/login_bloc.dart';
import 'package:flight_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLogin extends Mock implements Login {}

void main() {
  late MockLogin login;
  setUpAll(() {
    registerFallbackValue(const LoginParams(email: '', password: ''));
  });
  setUp(() {
    login = MockLogin();
  });

  /// Opens the login screen with a real Bloc and a fake Login use case.
  Widget buildPage() {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => LoginBloc(login),
        child: const LoginView(),
      ),
    );
  }

  group('LoginPage', () {
    testWidgets('shows errors when Login is tapped with an empty form', (
        tester,
        ) async {
      // Arrange: open the screen
      await tester.pumpWidget(buildPage());
      expect(find.text('Email is required'), findsNothing);

      // Act: tap the Login button
      await tester.tap(find.widgetWithText(PrimaryButton, 'Login'));
      await tester.pump();

      // Assert: the red messages are on the screen
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });
    testWidgets('switches the eye icon when it is tapped', (
        tester,
        ) async {
      // Arrange: open the screen
      await tester.pumpWidget(buildPage());
      expect(find.byTooltip('Show password'), findsOneWidget);
      // Act: tap the Login button
      await tester.tap(find.byTooltip('Show password'));
      await tester.pump();

      // Assert: the red messages are on the screen
      expect(find.byTooltip('Hide password'), findsOneWidget);   // صار موجود؟
      expect(find.byTooltip('Show password'),findsNothing);   // لسا موجود؟
    });

    testWidgets('shows the server error when login fails', (tester) async {
      // Arrange: the fake server rejects the login
      when(() => login(any())).thenAnswer(
            (_) async => const Failed(AuthFailure('Wrong email or password')),
      );
      await tester.pumpWidget(buildPage());

      // Act: type, then tap Login
      await tester.enterText(find.byType(TextField).first, 'manar@gmail.com');
      await tester.enterText(find.byType(TextField).last, '12345678');
      await tester.tap(find.widgetWithText(PrimaryButton, 'Login'));
      await tester.pumpAndSettle();

      // Assert: the message is on the screen
      expect(find.text('Wrong email or password'), findsOneWidget);
    });
  });
}