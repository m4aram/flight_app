import 'dart:convert';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/storage/key_value_storage.dart';
import '../../domain/entities/app_settings.dart';

abstract interface class SettingsLocalDataSource {
  AppSettings getSettings();

  Future<void> saveSettings(AppSettings settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  const SettingsLocalDataSourceImpl(this._storage);

  final KeyValueStorage _storage;

  @override
  AppSettings getSettings() {
    final raw = _storage.getString(StorageKeys.settings);
    if (raw == null) return const AppSettings();
    try {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) return const AppSettings();
      const defaults = AppSettings();
      return AppSettings(
        language: json['language'] as String? ?? defaults.language,
        currency: json['currency'] as String? ?? defaults.currency,
        regionCode: json['region'] as String? ?? defaults.regionCode,
      );
    } catch (_) {
      // Corrupted value: fall back to defaults.
      return const AppSettings();
    }
  }

  @override
  Future<void> saveSettings(AppSettings settings) => _storage.setString(
    StorageKeys.settings,
    jsonEncode({
      'language': settings.language,
      'currency': settings.currency,
      'region': settings.regionCode,
    }),
  );
}
