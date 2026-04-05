import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../storage/token_cache.dart';
import '../api_endpoints.dart';

/// Intercepteur Dio qui ajoute le token JWT à chaque requête
/// et rafraîchit automatiquement le token en cas de 401.
///
/// Utilise [QueuedInterceptor] pour sérialiser les requêtes
/// pendant qu'un refresh est en cours.
///
/// Un [Dio] dédié ([_refreshDio]) sans intercepteurs est utilisé pour le refresh
/// afin d'éviter la récursion.
///
/// Le callback [onAuthExpired] est appelé quand le refresh échoue,
/// permettant à l'app de forcer la déconnexion.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required TokenCache tokenCache,
    required Dio dio,
    this.onAuthExpired,
  })  : _tokenCache = tokenCache,
        _dio = dio,
        _refreshDio = Dio(
          BaseOptions(
            baseUrl: dio.options.baseUrl,
            connectTimeout: dio.options.connectTimeout,
            receiveTimeout: dio.options.receiveTimeout,
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );

  final TokenCache _tokenCache;
  final Dio _dio;
  final Dio _refreshDio;
  final VoidCallback? onAuthExpired;
  bool _isRefreshing = false;
  bool _sessionExpired = false;

  /// Réinitialise le flag de session expirée (appelé après un login réussi).
  void resetSessionExpired() => _sessionExpired = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = _tokenCache.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final path = err.requestOptions.path;
    if (path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/refresh')) {
      return handler.next(err);
    }

    if (_sessionExpired || _isRefreshing) {
      return handler.next(err);
    }

    _isRefreshing = true;
    try {
      final refreshToken = _tokenCache.refreshToken;
      if (refreshToken == null || refreshToken.isEmpty) {
        await _forceLogout();
        return handler.next(err);
      }

      final response = await _refreshDio.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      final data = response.data as Map<String, dynamic>;
      final newAccessToken = data['accessToken'] as String;
      final newRefreshToken = data['refreshToken'] as String;

      await _tokenCache.setTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );

      final opts = err.requestOptions;
      opts.headers['Authorization'] = 'Bearer $newAccessToken';
      final retryResponse = await _dio.fetch(opts);
      return handler.resolve(retryResponse);
    } catch (e) {
      debugPrint('Refresh token échoué : $e');
      await _forceLogout();
      return handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _forceLogout() async {
    _sessionExpired = true;
    await _tokenCache.clear();
    onAuthExpired?.call();
  }
}
