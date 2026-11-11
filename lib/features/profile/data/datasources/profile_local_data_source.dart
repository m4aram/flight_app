import 'dart:convert';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/storage/key_value_storage.dart';
import '../models/profile_model.dart';

abstract interface class ProfileLocalDataSource {
  ProfileModel? getProfile();

  Future<void> saveProfile(ProfileModel profile);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  const ProfileLocalDataSourceImpl(this._storage);

  final KeyValueStorage _storage;

  @override
  ProfileModel? getProfile() {
    final raw = _storage.getString(StorageKeys.profile);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      return ProfileModel.fromJson(decoded);
    } catch (_) {
      throw const CacheException('Saved profile data is corrupted');
    }
  }

  @override
  Future<void> saveProfile(ProfileModel profile) =>
      _storage.setString(StorageKeys.profile, jsonEncode(profile.toJson()));
}
