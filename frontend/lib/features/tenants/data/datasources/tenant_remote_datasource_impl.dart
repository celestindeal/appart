import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/rent_payment_entity.dart';
import '../../domain/entities/tenant_document_entity.dart';
import '../../domain/entities/reminder_entity.dart';
import '../models/tenant_model.dart';
import 'tenant_remote_datasource.dart';

/// Implémentation Dio de la source distante des locataires.
/// Les endpoints paiements/documents/rappels sont stubés pour l'instant
/// (retournent une liste vide) car l'UI ne les consomme pas encore.
class TenantRemoteDatasourceImpl implements TenantRemoteDatasource {
  TenantRemoteDatasourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  // ── Locataires ──────────────────────────────────────────

  @override
  Future<List<TenantModel>> getTenants() async {
    final response = await _dio.get(ApiEndpoints.tenants);
    final list = response.data as List<dynamic>;
    return list
        .map((json) => TenantModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<TenantModel> getTenantById(String id) async {
    final response = await _dio.get(ApiEndpoints.tenantById(id));
    return TenantModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<TenantModel> createTenant(TenantModel model) async {
    final response = await _dio.post(
      ApiEndpoints.tenants,
      data: model.toCreateJson(),
    );
    return TenantModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<TenantModel> updateTenant(TenantModel model) async {
    final response = await _dio.put(
      ApiEndpoints.tenantById(model.id),
      data: model.toUpdateJson(),
    );
    return TenantModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteTenant(String id) async {
    await _dio.delete(ApiEndpoints.tenantById(id));
  }

  // ── Paiements ───────────────────────────────────────────

  @override
  Future<List<RentPaymentEntity>> getPaymentsByTenant(String tenantId) async {
    // TODO: brancher au backend quand l'UI paiements sera prête.
    return const [];
  }

  @override
  Future<RentPaymentEntity> addPayment(RentPaymentEntity payment) async {
    throw UnimplementedError('Ajout de paiement non implémenté.');
  }

  @override
  Future<RentPaymentEntity> updatePayment(RentPaymentEntity payment) async {
    throw UnimplementedError('Mise à jour de paiement non implémentée.');
  }

  // ── Documents ───────────────────────────────────────────

  @override
  Future<List<TenantDocumentEntity>> getDocumentsByTenant(
      String tenantId) async {
    return const [];
  }

  @override
  Future<TenantDocumentEntity> addDocument(
      TenantDocumentEntity document) async {
    throw UnimplementedError('Ajout de document non implémenté.');
  }

  @override
  Future<void> deleteDocument(String id) async {
    throw UnimplementedError('Suppression de document non implémentée.');
  }

  // ── Rappels ─────────────────────────────────────────────

  @override
  Future<List<ReminderEntity>> getRemindersByTenant(String tenantId) async {
    return const [];
  }

  @override
  Future<ReminderEntity> addReminder(ReminderEntity reminder) async {
    throw UnimplementedError('Ajout de rappel non implémenté.');
  }

  @override
  Future<ReminderEntity> updateReminder(ReminderEntity reminder) async {
    throw UnimplementedError('Mise à jour de rappel non implémentée.');
  }

  @override
  Future<void> deleteReminder(String id) async {
    throw UnimplementedError('Suppression de rappel non implémentée.');
  }
}
