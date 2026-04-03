import '../entities/user_entity.dart';

/// Contrat du repository d'authentification.
abstract class AuthRepository {
  /// Connexion avec email et mot de passe.
  Future<UserEntity> login(String email, String password);

  /// Inscription d'un nouvel utilisateur.
  Future<UserEntity> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
  });

  /// Déconnexion de l'utilisateur courant.
  Future<void> logout();

  /// Récupère l'utilisateur actuellement connecté, ou null.
  Future<UserEntity?> getCurrentUser();

  /// Rafraîchit le token d'accès à partir du refresh token.
  Future<String> refreshToken(String refreshToken);
}
