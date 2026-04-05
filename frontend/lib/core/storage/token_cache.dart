import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../config/constants/app_constants.dart';

/// Cache mémoire des tokens JWT avec persistance best-effort dans
/// [FlutterSecureStorage].
///
/// Motivation : sur Flutter Web, `flutter_secure_storage` (qui utilise la
/// Web Crypto API) peut lever `OperationError` à la lecture si la clé AES
/// stockée dans `localStorage` se désynchronise avec la valeur chiffrée
/// (bug connu des versions 9.x). Les lectures pendant une session sont donc
/// faites depuis la mémoire, et `flutter_secure_storage` n'est utilisé
/// que pour persister entre deux lancements (avec tolérance aux erreurs).
class TokenCache {
  TokenCache({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

  final FlutterSecureStorage _secureStorage;

  String? _accessToken;
  String? _refreshToken;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  bool get hasAccessToken => _accessToken != null && _accessToken!.isNotEmpty;

  /// Charge les tokens depuis le stockage persistant vers la mémoire.
  /// Appelé au démarrage de l'app. En cas d'erreur (corruption), on purge.
  Future<void> loadFromStorage() async {
    _accessToken = await _safeRead(AppConstants.accessTokenKey);
    _refreshToken = await _safeRead(AppConstants.refreshTokenKey);
  }

  /// Enregistre les deux tokens en mémoire et tente de les persister.
  Future<void> setTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    await _safeWrite(AppConstants.accessTokenKey, accessToken);
    await _safeWrite(AppConstants.refreshTokenKey, refreshToken);
  }

  /// Met à jour uniquement l'access token (après un refresh).
  Future<void> updateAccessToken(String accessToken) async {
    _accessToken = accessToken;
    await _safeWrite(AppConstants.accessTokenKey, accessToken);
  }

  /// Met à jour uniquement le refresh token (après un refresh).
  Future<void> updateRefreshToken(String refreshToken) async {
    _refreshToken = refreshToken;
    await _safeWrite(AppConstants.refreshTokenKey, refreshToken);
  }

  /// Vide la mémoire et le stockage persistant.
  Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
    await _safeDelete(AppConstants.accessTokenKey);
    await _safeDelete(AppConstants.refreshTokenKey);
  }

  Future<String?> _safeRead(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      debugPrint('TokenCache read échec ($key) : $e');
      await _safeDelete(key);
      return null;
    }
  }

  Future<void> _safeWrite(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
    } catch (e) {
      debugPrint('TokenCache write échec ($key) : $e');
    }
  }

  Future<void> _safeDelete(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (_) {
      // Ignoré : on tolère l'échec de suppression.
    }
  }
}
