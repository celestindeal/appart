import '../../domain/entities/purchase_milestone_entity.dart';
import '../../domain/entities/purchase_project_entity.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../datasources/purchase_remote_datasource.dart';
import '../models/purchase_project_model.dart';

/// Implémentation concrète du repository d'achat.
class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseRemoteDataSource _remoteDataSource;

  PurchaseRepositoryImpl({
    required PurchaseRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<List<PurchaseProjectEntity>> getProjects() async {
    final models = await _remoteDataSource.getProjects();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<PurchaseProjectEntity> getProjectById(String id) async {
    final model = await _remoteDataSource.getProjectById(id);
    return model.toEntity();
  }

  @override
  Future<PurchaseProjectEntity> createProject(
    PurchaseProjectEntity project,
  ) async {
    final model = PurchaseProjectModel.fromEntity(project);
    final result = await _remoteDataSource.createProject(model);
    return result.toEntity();
  }

  @override
  Future<PurchaseProjectEntity> updateProject(
    PurchaseProjectEntity project,
  ) async {
    final model = PurchaseProjectModel.fromEntity(project);
    final result = await _remoteDataSource.updateProject(model);
    return result.toEntity();
  }

  @override
  Future<void> deleteProject(String id) async {
    await _remoteDataSource.deleteProject(id);
  }

  @override
  Future<List<PurchaseProjectEntity>> getProjectsByStatus(
    PurchaseStatus status,
  ) async {
    final models =
        await _remoteDataSource.getProjectsByStatus(status.name);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<PurchaseMilestoneEntity> addMilestone(
    String projectId,
    PurchaseMilestoneEntity milestone,
  ) async {
    final model = PurchaseMilestoneModel.fromEntity(milestone);
    final result =
        await _remoteDataSource.addMilestone(projectId, model);
    return result;
  }

  @override
  Future<PurchaseMilestoneEntity> updateMilestone(
    PurchaseMilestoneEntity milestone,
  ) async {
    final model = PurchaseMilestoneModel.fromEntity(milestone);
    final result = await _remoteDataSource.updateMilestone(model);
    return result;
  }

  @override
  Future<void> deleteMilestone(
    String projectId,
    String milestoneId,
  ) async {
    await _remoteDataSource.deleteMilestone(projectId, milestoneId);
  }
}
