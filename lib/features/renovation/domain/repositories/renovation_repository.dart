import '../entities/renovation_project_entity.dart';
import '../entities/renovation_task_entity.dart';
import '../entities/budget_item_entity.dart';

abstract class RenovationRepository {
  Future<List<RenovationProjectEntity>> getProjects();
  Future<RenovationProjectEntity?> getProjectById(String id);
  Future<void> createProject(RenovationProjectEntity project);
  Future<void> updateProject(RenovationProjectEntity project);
  Future<void> deleteProject(String id);
  Future<List<RenovationTaskEntity>> getTasksByProject(String projectId);
  Future<void> addTask(RenovationTaskEntity task);
  Future<void> updateTask(RenovationTaskEntity task);
  Future<void> deleteTask(String taskId);
  Future<List<BudgetItemEntity>> getBudgetItems(String projectId);
  Future<void> addBudgetItem(BudgetItemEntity item);
  Future<void> updateBudgetItem(BudgetItemEntity item);
}
