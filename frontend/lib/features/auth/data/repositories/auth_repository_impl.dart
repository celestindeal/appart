import '../../../../core/storage/token_cache.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implémentation concrète du repository d'authentification.
/// Gère la persistance des tokens via [TokenCache] (mémoire + stockage
/// sécurisé tolérant aux erreurs) et délègue les appels réseau au
/// [AuthRemoteDataSource].
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required TokenCache tokenCache,
  })  : _remoteDataSource = remoteDataSource,
        _tokenCache = tokenCache;

  final AuthRemoteDataSource _remoteDataSource;
  final TokenCache _tokenCache;

  /// Appelle le login API, sauvegarde les tokens en local et renvoie l'utilisateur.
  @override
  Future<UserEntity> login(String email, String password) async {
    final response = await _remoteDataSource.login(
      email: email,
      password: password,
    );
    await _tokenCache.setTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    return response.user.toEntity();
  }

  /// Appelle le register API, sauvegarde les tokens et renvoie l'utilisateur créé.
  @override
  Future<UserEntity> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    final response = await _remoteDataSource.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
    );
    await _tokenCache.setTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    return response.user.toEntity();
  }

  /// Révoque le refresh token côté serveur puis supprime les tokens en local.
  /// Si l'appel serveur échoue, on nettoie quand même en local.
  @override
  Future<void> logout() async {
    final refreshToken = _tokenCache.refreshToken;
    if (refreshToken != null) {
      try {
        await _remoteDataSource.logout(refreshToken);
      } catch (_) {
        // On supprime les tokens localement même si l'appel serveur échoue.
      }
    }
    await _tokenCache.clear();
  }

  /// Vérifie si l'utilisateur a un token valide et récupère son profil.
  /// Renvoie null si aucun token ou si le token est expiré.
  @override
  Future<UserEntity?> getCurrentUser() async {
    if (!_tokenCache.hasAccessToken) return null;

    try {
      final userModel = await _remoteDataSource.getCurrentUser();
      return userModel.toEntity();
    } catch (_) {
      return null;
    }
  }

  /// Échange le refresh token contre de nouveaux tokens et les sauvegarde.
  @override
  Future<String> refreshToken(String refreshToken) async {
    final response = await _remoteDataSource.refreshToken(refreshToken);
    await _tokenCache.setTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    return response.accessToken;
  }
}
