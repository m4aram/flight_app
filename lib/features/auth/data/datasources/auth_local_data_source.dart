import 'dart:convert';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/user_model.dart';

/// Persists the session in encrypted storage.
abstract interface class AuthLocalDataSource {
  Future<void> saveSession(AuthSession session);

  Future<UserModel?> getCachedUser();

  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this._storage);

  final SecureStorage _storage;

  @override
  Future<void> saveSession(AuthSession session) async {
    try {
      await _storage.write(StorageKeys.authToken, session.token);
      await _storage.write(
        StorageKeys.authUser,
        jsonEncode(session.user.toJson()),
      );
    } catch (_) {
      throw const CacheException('Could not save your session');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final token = await _storage.read(StorageKeys.authToken);
      final rawUser = await _storage.read(StorageKeys.authUser);
      if (token == null || token.isEmpty || rawUser == null) return null;

      final decoded = jsonDecode(rawUser);
      if (decoded is! Map<String, dynamic>) return null;
      return UserModel.fromJson(decoded);
    } on FormatException {
      // Corrupted data: drop it and treat as logged out.
      await clearSession();
      return null;
    } on TypeError {
      await clearSession();
      return null;
    }
  }

  @override
  Future<void> clearSession() async {
    await _storage.delete(StorageKeys.authToken);
    await _storage.delete(StorageKeys.authUser);
  }
}
