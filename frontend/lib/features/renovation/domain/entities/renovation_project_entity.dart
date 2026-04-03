import 'package:equatable/equatable.dart';

enum RenovationStatus { planning, inProgress, onHold, completed, cancelled }

class RenovationProjectEntity extends Equatable {
  final String id;
  final String propertyId;
  final String propertyName;
  final String projectName;
  final String? description;
  final RenovationStatus status;
  final DateTime startDate;
  final DateTime expectedEndDate;
  final DateTime? actualEndDate;
  final double totalBudget;
  final double totalSpent;
  final int progress;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const RenovationProjectEntity({
    required this.id,
    required this.propertyId,
    required this.propertyName,
    required this.projectName,
    this.description,
    required this.status,
    required this.startDate,
    required this.expectedEndDate,
    this.actualEndDate,
    required this.totalBudget,
    this.totalSpent = 0,
    this.progress = 0,
    required this.createdAt,
    this.updatedAt,
  });

  double get remaining => totalBudget - totalSpent;
  double get budgetProgress => totalBudget > 0 ? totalSpent / totalBudget : 0;

  @override
  List<Object?> get props => [id];
}
