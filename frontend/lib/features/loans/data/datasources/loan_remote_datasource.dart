import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/loan_model.dart';

class LoanRemoteDatasource {
  final Dio _dio;

  LoanRemoteDatasource({required Dio dio}) : _dio = dio;

  Future<List<LoanModel>> getByProperty(String propertyId) async {
    final response = await _dio.get(
      ApiEndpoints.loans,
      queryParameters: {'propertyId': propertyId},
    );
    final list = response.data as List<dynamic>;
    return list
        .map((json) => LoanModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<LoanModel> create(LoanModel model) async {
    final response = await _dio.post(
      ApiEndpoints.loans,
      data: model.toCreateJson(),
    );
    return LoanModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<LoanModel> update(LoanModel model) async {
    final response = await _dio.put(
      ApiEndpoints.loanById(model.id),
      data: model.toUpdateJson(),
    );
    return LoanModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> delete(String id) async {
    await _dio.delete(ApiEndpoints.loanById(id));
  }
}
