import '../entities/tenant_entity.dart';
import '../entities/rent_payment_entity.dart';
import '../entities/tenant_document_entity.dart';
import '../entities/reminder_entity.dart';

/// Contrat du repository pour la gestion des locataires.
abstract class TenantRepository {
  // ── Locataires ──────────────────────────────────────────

  /// Recupere la liste de tous les locataires.
  Future<List<TenantEntity>> getTenants();

  /// Recupere un locataire par son identifiant.
  Future<TenantEntity> getTenantById(String id);

  /// Cree un nouveau locataire.
  Future<TenantEntity> createTenant(TenantEntity tenant);

  /// Met a jour un locataire existant.
  Future<TenantEntity> updateTenant(TenantEntity tenant);

  /// Supprime un locataire par son identifiant.
  Future<void> deleteTenant(String id);

  // ── Paiements ───────────────────────────────────────────

  /// Recupere les paiements d'un locataire.
  Future<List<RentPaymentEntity>> getPaymentsByTenant(String tenantId);

  /// Ajoute un paiement pour un locataire.
  Future<RentPaymentEntity> addPayment(RentPaymentEntity payment);

  /// Met a jour un paiement existant.
  Future<RentPaymentEntity> updatePayment(RentPaymentEntity payment);

  // ── Documents ───────────────────────────────────────────

  /// Recupere les documents d'un locataire.
  Future<List<TenantDocumentEntity>> getDocumentsByTenant(String tenantId);

  /// Ajoute un document pour un locataire.
  Future<TenantDocumentEntity> addDocument(TenantDocumentEntity document);

  /// Supprime un document par son identifiant.
  Future<void> deleteDocument(String id);

  // ── Rappels ─────────────────────────────────────────────

  /// Recupere les rappels d'un locataire.
  Future<List<ReminderEntity>> getRemindersByTenant(String tenantId);

  /// Ajoute un rappel pour un locataire.
  Future<ReminderEntity> addReminder(ReminderEntity reminder);

  /// Met a jour un rappel existant.
  Future<ReminderEntity> updateReminder(ReminderEntity reminder);

  /// Supprime un rappel par son identifiant.
  Future<void> deleteReminder(String id);
}
