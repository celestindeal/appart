import '../models/auth_response_model.dart';
import '../models/user_model.dart';

/// Contrat de la source de données distante pour l'authentification.
/// Définit les appels API nécessaires sans détail d'implémentation.
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

  /// Déconnexion côté serveur (révocation du refresh token).
  Future<void> logout(String refreshToken);

  /// Récupère le profil de l'utilisateur connecté via le JWT.
  Future<UserModel> getCurrentUser();

  /// Rafraîchit les tokens (échange refresh token → nouveau JWT + refresh).
  Future<AuthResponseModel> refreshToken(String refreshToken);
}
