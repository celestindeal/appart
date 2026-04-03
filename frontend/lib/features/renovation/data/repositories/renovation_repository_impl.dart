import '../../domain/entities/renovation_project_entity.dart';
import '../../domain/entities/renovation_task_entity.dart';
import '../../domain/entities/budget_item_entity.dart';
import '../../domain/repositories/renovation_repository.dart';

class RenovationRepositoryImpl implements RenovationRepository {
  @override
  Future<List<RenovationProjectEntity>> getProjects() async => [];

  @override
  Future<RenovationProjectEntity?> getProjectById(String id) async => null;

  @override
  Future<void> createProject(RenovationProjectEntity project) async {}

  @override
  Future<void> updateProject(RenovationProjectEntity project) async {}

  @override
  Future<void> deleteProject(String id) async {}

  @override
  Future<List<RenovationTaskEntity>> getTasksByProject(String projectId) async => [];

  @override
  Future<void> addTask(RenovationTaskEntity task) async {}

  @override
  Future<void> updateTask(RenovationTaskEntity task) async {}

  @override
  Future<void> deleteTask(String taskId) async {}

  @override
  Future<List<BudgetItemEntity>> getBudgetItems(String projectId) async => [];

  @override
  Future<void> addBudgetItem(BudgetItemEntity item) async {}

  @override
  Future<void> updateBudgetItem(BudgetItemEntity item) async {}
}
