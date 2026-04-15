import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/rent_payment_entity.dart';
import '../models/rent_payment_model.dart';

/// Source distante pour les paiements de loyer.
class PaymentRemoteDatasource {
  PaymentRemoteDatasource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<List<RentPaymentEntity>> getByTenant(String tenantId) async {
    final response = await _dio.get(
      ApiEndpoints.payments,
      queryParameters: {'tenantId': tenantId},
    );
    final list = response.data as List<dynamic>;
    return list
        .map((json) =>
            RentPaymentModel.fromJson(json as Map<String, dynamic>).toEntity())
        .toList();
  }

  Future<RentPaymentEntity> create(RentPaymentModel model) async {
    final response = await _dio.post(
      ApiEndpoints.payments,
      data: model.toCreateJson(),
    );
    return RentPaymentModel.fromJson(response.data as Map<String, dynamic>)
        .toEntity();
  }

  Future<RentPaymentEntity> update(RentPaymentModel model) async {
    final response = await _dio.put(
      ApiEndpoints.paymentById(model.id),
      data: model.toUpdateJson(),
    );
    return RentPaymentModel.fromJson(response.data as Map<String, dynamic>)
        .toEntity();
  }

  Future<void> delete(String id) async {
    await _dio.delete(ApiEndpoints.paymentById(id));
  }
}
