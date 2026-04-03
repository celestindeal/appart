import '../models/auth_response_model.dart';
import '../models/user_model.dart';

/// Source de données distante pour l'authentification.
abstract class AuthRemoteDataSource {
  /// Connexion avec email et mot de passe.
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  /// Inscription d'un nouvel utilisateur.
  Future<AuthResponseModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
  });

  /// Déconnexion côté serveur (invalidation du token).
  Future<void> logout(String accessToken);

  /// Récupère le profil de l'utilisateur courant.
  Future<UserModel> getCurrentUser(String accessToken);

  /// Rafraîchit le token d'accès.
  Future<AuthResponseModel> refreshToken(String refreshToken);
}
