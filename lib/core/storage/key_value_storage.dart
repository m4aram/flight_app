import 'package:shared_preferences/shared_preferences.dart';

import '../error/exceptions.dart';

/// Abstraction over simple (non-sensitive) key/value persistence.
abstract interface class KeyValueStorage {
  String? getString(String key);

  Future<void> setString(String key, String value);

  List<String>? getStringList(String key);

  Future<void> setStringList(String key, List<String> value);

  Future<void> remove(String key);
}

class SharedPrefsStorage implements KeyValueStorage {
  const SharedPrefsStorage(this._prefs);

  final SharedPreferences _prefs;

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<void> setString(String key, String value) async {
    final ok = await _prefs.setString(key, value);
    if (!ok) throw const CacheException();
  }

  @override
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  @override
  Future<void> setStringList(String key, List<String> value) async {
    final ok = await _prefs.setStringList(key, value);
    if (!ok) throw const CacheException();
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }
}
