import 'package:immo_manager/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:immo_manager/features/auth/data/models/auth_response_model.dart';
import 'package:immo_manager/features/auth/data/models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    // TODO: appel API
    throw UnimplementedError();
  }

  @override
  Future<AuthResponseModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> logout(String accessToken) async {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> getCurrentUser(String accessToken) async {
    throw UnimplementedError();
  }

  @override
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    throw UnimplementedError();
  }
}
