import 'package:shared_preferences/shared_preferences.dart';

/// Service d'encapsulation de SharedPreferences pour le stockage local.
class LocalStorageService {
  LocalStorageService({required SharedPreferences sharedPreferences})
      : _prefs = sharedPreferences;

  final SharedPreferences _prefs;

  /// Lit une chaîne de caractères.
  String? getString(String key) => _prefs.getString(key);

  /// Enregistre une chaîne de caractères.
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  /// Lit un booléen.
  bool? getBool(String key) => _prefs.getBool(key);

  /// Enregistre un booléen.
  Future<bool> setBool(String key, {required bool value}) =>
      _prefs.setBool(key, value);

  /// Supprime une entrée par clé.
  Future<bool> remove(String key) => _prefs.remove(key);

  /// Supprime toutes les entrées.
  Future<bool> clear() => _prefs.clear();
}
