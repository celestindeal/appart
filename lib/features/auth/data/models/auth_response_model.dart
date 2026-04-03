import 'user_model.dart';

/// Modèle de réponse d'authentification (login / register).
class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final UserModel user;

  const AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
  });

  /// Crée un [AuthResponseModel] à partir d'une map JSON.
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresIn: json['expires_in'] as int,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
