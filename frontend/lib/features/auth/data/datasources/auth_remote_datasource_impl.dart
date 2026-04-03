import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

/// Implémentation des appels API d'authentification via Dio.
/// Chaque méthode appelle le endpoint backend correspondant
/// et parse la réponse JSON en modèle Dart.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  /// POST /auth/login → connecte l'utilisateur et renvoie JWT + refresh token.
  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// POST /auth/register → crée un compte et renvoie directement les tokens.
  @override
  Future<AuthResponseModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.register,
      data: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
      },
    );
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// POST /auth/logout → révoque le refresh token côté serveur.
  @override
  Future<void> logout(String refreshToken) async {
    await _dio.post(
      ApiEndpoints.logout,
      data: {'refreshToken': refreshToken},
    );
  }

  /// GET /auth/me → récupère le profil de l'utilisateur connecté.
  @override
  Future<UserModel> getCurrentUser() async {
    final response = await _dio.get(ApiEndpoints.me);
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// POST /auth/refresh → échange le refresh token contre de nouveaux tokens.
  @override
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    final response = await _dio.post(
      ApiEndpoints.refreshToken,
      data: {'refreshToken': refreshToken},
    );
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }
}
