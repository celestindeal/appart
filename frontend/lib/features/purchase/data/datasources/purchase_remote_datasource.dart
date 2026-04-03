import '../models/purchase_project_model.dart';

/// Source de données distante pour les projets d'achat.
abstract class PurchaseRemoteDataSource {
  /// Récupère tous les projets d'achat.
  Future<List<PurchaseProjectModel>> getProjects();

  /// Récupère un projet d'achat par son identifiant.
  Future<PurchaseProjectModel> getProjectById(String id);

  /// Crée un nouveau projet d'achat.
  Future<PurchaseProjectModel> createProject(PurchaseProjectModel project);

  /// Met à jour un projet d'achat existant.
  Future<PurchaseProjectModel> updateProject(PurchaseProjectModel project);

  /// Supprime un projet d'achat.
  Future<void> deleteProject(String id);

  /// Récupère les projets filtrés par statut.
  Future<List<PurchaseProjectModel>> getProjectsByStatus(String status);

  /// Ajoute un jalon à un projet.
  Future<PurchaseMilestoneModel> addMilestone(
    String projectId,
    PurchaseMilestoneModel milestone,
  );

  /// Met à jour un jalon existant.
  Future<PurchaseMilestoneModel> updateMilestone(
    PurchaseMilestoneModel milestone,
  );

  /// Supprime un jalon.
  Future<void> deleteMilestone(String projectId, String milestoneId);
}
