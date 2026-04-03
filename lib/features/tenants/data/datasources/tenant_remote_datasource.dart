import '../models/tenant_model.dart';
import '../../domain/entities/rent_payment_entity.dart';
import '../../domain/entities/tenant_document_entity.dart';
import '../../domain/entities/reminder_entity.dart';

/// Contrat de la source de donnees distante pour les locataires.
abstract class TenantRemoteDatasource {
  // ── Locataires ──────────────────────────────────────────

  /// Recupere la liste de tous les locataires.
  Future<List<TenantModel>> getTenants();

  /// Recupere un locataire par son identifiant.
  Future<TenantModel> getTenantById(String id);

  /// Cree un nouveau locataire.
  Future<TenantModel> createTenant(TenantModel model);

  /// Met a jour un locataire existant.
  Future<TenantModel> updateTenant(TenantModel model);

  /// Supprime un locataire par son identifiant.
  Future<void> deleteTenant(String id);

  // ── Paiements ───────────────────────────────────────────

  /// Recupere les paiements d'un locataire.
  Future<List<RentPaymentEntity>> getPaymentsByTenant(String tenantId);

  /// Ajoute un paiement.
  Future<RentPaymentEntity> addPayment(RentPaymentEntity payment);

  /// Met a jour un paiement.
  Future<RentPaymentEntity> updatePayment(RentPaymentEntity payment);

  // ── Documents ───────────────────────────────────────────

  /// Recupere les documents d'un locataire.
  Future<List<TenantDocumentEntity>> getDocumentsByTenant(String tenantId);

  /// Ajoute un document.
  Future<TenantDocumentEntity> addDocument(TenantDocumentEntity document);

  /// Supprime un document.
  Future<void> deleteDocument(String id);

  // ── Rappels ─────────────────────────────────────────────

  /// Recupere les rappels d'un locataire.
  Future<List<ReminderEntity>> getRemindersByTenant(String tenantId);

  /// Ajoute un rappel.
  Future<ReminderEntity> addReminder(ReminderEntity reminder);

  /// Met a jour un rappel.
  Future<ReminderEntity> updateReminder(ReminderEntity reminder);

  /// Supprime un rappel.
  Future<void> deleteReminder(String id);
}
