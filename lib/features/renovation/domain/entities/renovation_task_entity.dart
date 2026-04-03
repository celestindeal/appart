import 'package:equatable/equatable.dart';

enum WorkType { demolition, plumbing, electrical, painting, flooring, carpentry, roofing, insulation, windows, kitchen, bathroom, other }
enum TaskStatus { pending, inProgress, completed, cancelled }

class RenovationTaskEntity extends Equatable {
  final String id;
  final String projectId;
  final String taskName;
  final String? description;
  final WorkType workType;
  final DateTime? plannedStartDate;
  final DateTime? plannedEndDate;
  final DateTime? actualStartDate;
  final DateTime? actualEndDate;
  final double budgetAmount;
  final double actualCost;
  final TaskStatus status;
  final String? contractor;
  final int progress;
  final int priority;

  const RenovationTaskEntity({
    required this.id,
    required this.projectId,
    required this.taskName,
    this.description,
    required this.workType,
    this.plannedStartDate,
    this.plannedEndDate,
    this.actualStartDate,
    this.actualEndDate,
    this.budgetAmount = 0,
    this.actualCost = 0,
    this.status = TaskStatus.pending,
    this.contractor,
    this.progress = 0,
    this.priority = 0,
  });

  @override
  List<Object?> get props => [id];
}
