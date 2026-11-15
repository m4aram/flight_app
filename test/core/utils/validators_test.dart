import 'package:flight_app/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.email', () {
    test('returns null for a valid email', () {
      // Arrange
      const email = 'manar@gmail.com';

      // Act
      final result = Validators.email(email);

      // Assert: null means "no error"
      expect(result, isNull);
    });

    test('returns "Email is required" when empty', () {
      final result = Validators.email('');

      expect(result, 'Email is required');
    });

    test('returns "Email is required" when only spaces', () {
      final result = Validators.email('   ');

      expect(result, 'Email is required');
    });

    test('returns "Email is required" when null', () {
      final result = Validators.email(null);

      expect(result, 'Email is required');
    });

    test('returns "Enter a valid email" when @ is missing', () {
      final result = Validators.email('manar');

      expect(result, 'Enter a valid email');
    });

    test('returns "Enter a valid email" when the domain is missing', () {
      final result = Validators.email('manar@gmail');

      expect(result, 'Enter a valid email');
    });

    test('returns null when a valid email has spaces around it', () {
      final result = Validators.email('  manar@gmail.com  ');

      expect(result, isNull);
    });
  });

  group('Validators.password', () {
    test('returns an error when the password is 7 characters', () {
      final result = Validators.password('1234567');

      expect(result, 'Password must be at least 8 characters');
    });

    test('returns null when the password is 8 characters', () {
      final result = Validators.password('12345678');

      expect(result, isNull);
    });
  });
}