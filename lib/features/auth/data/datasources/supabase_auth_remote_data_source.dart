import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

/// Talks to Supabase Auth. This is the ONLY file that knows Supabase exists.
class SupabaseAuthRemoteDataSource implements AuthRemoteDataSource {
  const SupabaseAuthRemoteDataSource(this._client);

  final supabase.SupabaseClient _client;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return _toSession(response);
    } on supabase.AuthRetryableFetchException {
      throw const ServerException(
        'Check your internet connection and try again.',
      );
    } on supabase.AuthException {
      // Same message for every failure so we don't reveal which field is wrong.
      throw const AuthException('Invalid email or password');
    }
  }

  @override
  Future<AuthSession> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      return _toSession(response);
    } on supabase.AuthRetryableFetchException {
      throw const ServerException(
        'Check your internet connection and try again.',
      );
    } on supabase.AuthException {
      throw const AuthException('Could not create the account.');
    }
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } on supabase.AuthException {
      // Answer the same way whether the email exists or not,
      // so attackers can't discover registered accounts.
    }
  }

  /// Turns Supabase's answer into our own AuthSession.
  AuthSession _toSession(supabase.AuthResponse response) {
    final session = response.session;
    final user = response.user;
    if (session == null || user == null) {
      throw const AuthException('Please confirm your email first.');
    }
    return AuthSession(
      token: session.accessToken,
      user: UserModel(
        id: user.id,
        email: user.email ?? '',
        name: user.userMetadata?['name'] as String?,
      ),
    );
  }
}