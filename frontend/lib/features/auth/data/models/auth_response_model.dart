import 'user_model.dart';

/// Modèle de réponse d'authentification retourné par le backend.
/// Contient le JWT, le refresh token, la durée de validité et les infos utilisateur.
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

  /// Parse la réponse JSON du backend (camelCase .NET) en objet Dart.
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresIn: json['expiresIn'] as int,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
