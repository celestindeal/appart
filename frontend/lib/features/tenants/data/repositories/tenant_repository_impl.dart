import '../../domain/entities/tenant_entity.dart';
import '../../domain/entities/rent_payment_entity.dart';
import '../../domain/entities/tenant_document_entity.dart';
import '../../domain/entities/reminder_entity.dart';
import '../../domain/repositories/tenant_repository.dart';
import '../datasources/tenant_remote_datasource.dart';
import '../models/tenant_model.dart';

/// Implementation concrete du repository des locataires.
class TenantRepositoryImpl implements TenantRepository {
  TenantRepositoryImpl({
    required TenantRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  final TenantRemoteDatasource _remoteDatasource;

  // ── Locataires ──────────────────────────────────────────

  @override
  Future<List<TenantEntity>> getTenants() async {
    return _remoteDatasource.getTenants();
  }

  @override
  Future<TenantEntity> getTenantById(String id) async {
    return _remoteDatasource.getTenantById(id);
  }

  @override
  Future<TenantEntity> createTenant(TenantEntity tenant) async {
    final model = TenantModel.fromEntity(tenant);
    return _remoteDatasource.createTenant(model);
  }

  @override
  Future<TenantEntity> updateTenant(TenantEntity tenant) async {
    final model = TenantModel.fromEntity(tenant);
    return _remoteDatasource.updateTenant(model);
  }

  @override
  Future<void> deleteTenant(String id) async {
    await _remoteDatasource.deleteTenant(id);
  }

  // ── Paiements ───────────────────────────────────────────

  @override
  Future<List<RentPaymentEntity>> getPaymentsByTenant(String tenantId) async {
    return _remoteDatasource.getPaymentsByTenant(tenantId);
  }

  @override
  Future<RentPaymentEntity> addPayment(RentPaymentEntity payment) async {
    return _remoteDatasource.addPayment(payment);
  }

  @override
  Future<RentPaymentEntity> updatePayment(RentPaymentEntity payment) async {
    return _remoteDatasource.updatePayment(payment);
  }

  // ── Documents ───────────────────────────────────────────

  @override
  Future<List<TenantDocumentEntity>> getDocumentsByTenant(
      String tenantId) async {
    return _remoteDatasource.getDocumentsByTenant(tenantId);
  }

  @override
  Future<TenantDocumentEntity> addDocument(
      TenantDocumentEntity document) async {
    return _remoteDatasource.addDocument(document);
  }

  @override
  Future<void> deleteDocument(String id) async {
    await _remoteDatasource.deleteDocument(id);
  }

  // ── Rappels ─────────────────────────────────────────────

  @override
  Future<List<ReminderEntity>> getRemindersByTenant(String tenantId) async {
    return _remoteDatasource.getRemindersByTenant(tenantId);
  }

  @override
  Future<ReminderEntity> addReminder(ReminderEntity reminder) async {
    return _remoteDatasource.addReminder(reminder);
  }

  @override
  Future<ReminderEntity> updateReminder(ReminderEntity reminder) async {
    return _remoteDatasource.updateReminder(reminder);
  }

  @override
  Future<void> deleteReminder(String id) async {
    await _remoteDatasource.deleteReminder(id);
  }
}
