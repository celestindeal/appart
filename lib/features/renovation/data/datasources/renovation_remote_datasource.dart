import '../../domain/entities/renovation_project_entity.dart';
import '../../domain/entities/renovation_task_entity.dart';
import '../../domain/entities/budget_item_entity.dart';

abstract class RenovationRemoteDatasource {
  Future<List<RenovationProjectEntity>> getProjects();
  Future<RenovationProjectEntity> getProjectById(String id);
  Future<void> createProject(Map<String, dynamic> data);
  Future<void> updateProject(String id, Map<String, dynamic> data);
  Future<void> deleteProject(String id);
  Future<List<RenovationTaskEntity>> getTasksByProject(String projectId);
  Future<void> addTask(Map<String, dynamic> data);
  Future<void> updateTask(String taskId, Map<String, dynamic> data);
  Future<List<BudgetItemEntity>> getBudgetItems(String projectId);
  Future<void> addBudgetItem(Map<String, dynamic> data);
}
