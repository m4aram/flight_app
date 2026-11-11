import 'dart:math';

import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthSession> login({required String email, required String password});

  Future<AuthSession> register({
    required String name,
    required String email,
    required String password,
  });

  /// Asks the server to email a password reset link.
  Future<void> sendPasswordReset({required String email});
}

/// Mock API: accepts any valid email with a password of 8+ characters.
/// Replace with a real HTTP implementation and update the DI binding.
class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  FakeAuthRemoteDataSource({
    this.latency = const Duration(milliseconds: 800),
    Random? random,
  }) : _random = random ?? Random.secure();

  final Duration latency;
  final Random _random;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(latency);

    if (password.length < 8) {
      // Same message for every failure so we don't reveal which field is wrong.
      throw const AuthException('Invalid email or password');
    }

    return AuthSession(
      token: _generateToken(),
      user: UserModel(
        id: email.hashCode.toUnsigned(32).toString(),
        email: email,
      ),
    );
  }

  @override
  Future<AuthSession> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(latency);
    return AuthSession(
      token: _generateToken(),
      user: UserModel(
        id: email.hashCode.toUnsigned(32).toString(),
        email: email,
        name: name,
      ),
    );
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {
    // A real server should answer the same way whether the email exists
    // or not, so attackers can't discover registered accounts.
    await Future<void>.delayed(latency);
  }

  String _generateToken() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(
      48,
      (_) => chars[_random.nextInt(chars.length)],
    ).join();
  }
}
