import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../config/constants/app_constants.dart';

/// Service d'encapsulation de FlutterSecureStorage pour les données sensibles.
class SecureStorageService {
  SecureStorageService({required FlutterSecureStorage secureStorage})
      : _storage = secureStorage;

  final FlutterSecureStorage _storage;

  // ── Tokens ──────────────────────────────────────────────────

  /// Enregistre le token d'accès.
  Future<void> saveAccessToken(String token) =>
      _storage.write(key: AppConstants.accessTokenKey, value: token);

  /// Lit le token d'accès.
  Future<String?> readAccessToken() =>
      _storage.read(key: AppConstants.accessTokenKey);

  /// Supprime le token d'accès.
  Future<void> deleteAccessToken() =>
      _storage.delete(key: AppConstants.accessTokenKey);

  /// Enregistre le token de rafraîchissement.
  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: AppConstants.refreshTokenKey, value: token);

  /// Lit le token de rafraîchissement.
  Future<String?> readRefreshToken() =>
      _storage.read(key: AppConstants.refreshTokenKey);

  /// Supprime le token de rafraîchissement.
  Future<void> deleteRefreshToken() =>
      _storage.delete(key: AppConstants.refreshTokenKey);

  // ── Générique ───────────────────────────────────────────────

  /// Enregistre une valeur sécurisée.
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  /// Lit une valeur sécurisée.
  Future<String?> read({required String key}) => _storage.read(key: key);

  /// Supprime une valeur sécurisée.
  Future<void> delete({required String key}) => _storage.delete(key: key);

  /// Supprime toutes les données sécurisées (déconnexion).
  Future<void> deleteAll() => _storage.deleteAll();
}
