import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../config/constants/app_constants.dart';
import '../api_endpoints.dart';

/// Intercepteur Dio qui ajoute le token JWT à chaque requête
/// et rafraîchit automatiquement le token en cas de 401.
///
/// Utilise [QueuedInterceptor] pour mettre en file d'attente les requêtes
/// pendant qu'un refresh est en cours (évite les appels multiples simultanés).
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required FlutterSecureStorage secureStorage,
    required Dio dio,
  })  : _secureStorage = secureStorage,
        _dio = dio;

  final FlutterSecureStorage _secureStorage;
  final Dio _dio;
  bool _isRefreshing = false;

  /// Ajoute le header "Authorization: Bearer <token>" à chaque requête sortante
  /// si un access token est présent dans le stockage sécurisé.
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.read(key: AppConstants.accessTokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  /// En cas de 401, tente un refresh automatique du token.
  /// Si le refresh réussit, rejoue la requête originale.
  /// Si le refresh échoue, supprime les tokens et laisse passer l'erreur.
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Ne rien faire si ce n'est pas un 401 ou si un refresh est déjà en cours.
    if (err.response?.statusCode != 401 || _isRefreshing) {
      return handler.next(err);
    }

    // Ne pas tenter de refresh sur les routes d'auth elles-mêmes.
    final path = err.requestOptions.path;
    if (path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/refresh')) {
      return handler.next(err);
    }

    _isRefreshing = true;
    try {
      final refreshToken = await _secureStorage.read(
        key: AppConstants.refreshTokenKey,
      );
      if (refreshToken == null) {
        await _clearTokens();
        return handler.next(err);
      }

      // Appel au endpoint /auth/refresh sans passer par l'intercepteur.
      final response = await _dio.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
        options: Options(headers: {}),
      );

      final data = response.data as Map<String, dynamic>;
      final newAccessToken = data['accessToken'] as String;
      final newRefreshToken = data['refreshToken'] as String;

      // Sauvegarde des nouveaux tokens.
      await Future.wait([
        _secureStorage.write(
          key: AppConstants.accessTokenKey,
          value: newAccessToken,
        ),
        _secureStorage.write(
          key: AppConstants.refreshTokenKey,
          value: newRefreshToken,
        ),
      ]);

      // Rejeu de la requête originale avec le nouveau token.
      final opts = err.requestOptions;
      opts.headers['Authorization'] = 'Bearer $newAccessToken';
      final retryResponse = await _dio.fetch(opts);
      return handler.resolve(retryResponse);
    } catch (_) {
      // Le refresh a échoué → on nettoie les tokens (l'utilisateur devra se reconnecter).
      await _clearTokens();
      return handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  /// Supprime les tokens du stockage sécurisé.
  Future<void> _clearTokens() async {
    await Future.wait([
      _secureStorage.delete(key: AppConstants.accessTokenKey),
      _secureStorage.delete(key: AppConstants.refreshTokenKey),
    ]);
  }
}
