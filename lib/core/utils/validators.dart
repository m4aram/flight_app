/// Form validators. Each returns `null` when the value is valid,
/// otherwise a user-facing error message.
abstract final class Validators {
  static final RegExp _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}$',
  );

  static final RegExp _nameRegex = RegExp(r"^[\p{L} '\-]+$", unicode: true);

  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxEmailLength = 254;

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email is required';
    if (email.length > maxEmailLength) return 'Email is too long';
    if (!_emailRegex.hasMatch(email)) return 'Enter a valid email';
    return null;
  }

  static String? password(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Password is required';
    if (password.length < minPasswordLength) {
      return 'Password must be at least $minPasswordLength characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != password) return "Passwords don't match";
    return null;
  }

  static final RegExp _documentRegex = RegExp(r'^[A-Za-z0-9]{5,20}$');

  static String? documentNumber(String? value) {
    final number = value?.trim() ?? '';
    if (number.isEmpty) return 'Document number is required';
    if (!_documentRegex.hasMatch(number)) {
      return 'Use 5-20 letters and numbers only';
    }
    return null;
  }

  static String? name(String? value, {String field = 'This field'}) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return '$field is required';
    if (name.length > maxNameLength) return '$field is too long';
    if (!_nameRegex.hasMatch(name)) return '$field can contain letters only';
    return null;
  }
}
