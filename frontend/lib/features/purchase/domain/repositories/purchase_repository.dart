import '../entities/purchase_milestone_entity.dart';
import '../entities/purchase_project_entity.dart';

/// Contrat du repository pour la gestion des projets d'achat.
abstract class PurchaseRepository {
  /// Récupère tous les projets d'achat.
  Future<List<PurchaseProjectEntity>> getProjects();

  /// Récupère un projet d'achat par son identifiant.
  Future<PurchaseProjectEntity> getProjectById(String id);

  /// Crée un nouveau projet d'achat.
  Future<PurchaseProjectEntity> createProject(PurchaseProjectEntity project);

  /// Met à jour un projet d'achat existant.
  Future<PurchaseProjectEntity> updateProject(PurchaseProjectEntity project);

  /// Supprime un projet d'achat.
  Future<void> deleteProject(String id);

  /// Récupère les projets filtrés par statut.
  Future<List<PurchaseProjectEntity>> getProjectsByStatus(
    PurchaseStatus status,
  );

  /// Ajoute un jalon à un projet.
  Future<PurchaseMilestoneEntity> addMilestone(
    String projectId,
    PurchaseMilestoneEntity milestone,
  );

  /// Met à jour un jalon existant.
  Future<PurchaseMilestoneEntity> updateMilestone(
    PurchaseMilestoneEntity milestone,
  );

  /// Supprime un jalon.
  Future<void> deleteMilestone(String projectId, String milestoneId);
}
