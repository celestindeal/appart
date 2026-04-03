import '../../domain/entities/renovation_project_entity.dart';

class RenovationProjectModel extends RenovationProjectEntity {
  const RenovationProjectModel({
    required super.id,
    required super.propertyId,
    required super.propertyName,
    required super.projectName,
    super.description,
    required super.status,
    required super.startDate,
    required super.expectedEndDate,
    super.actualEndDate,
    required super.totalBudget,
    super.totalSpent,
    super.progress,
    required super.createdAt,
    super.updatedAt,
  });

  factory RenovationProjectModel.fromJson(Map<String, dynamic> json) {
    return RenovationProjectModel(
      id: json['id'] as String,
      propertyId: json['propertyId'] as String,
      propertyName: json['propertyName'] as String? ?? '',
      projectName: json['projectName'] as String,
      description: json['description'] as String?,
      status: RenovationStatus.values.byName(json['status'] as String),
      startDate: DateTime.parse(json['startDate'] as String),
      expectedEndDate: DateTime.parse(json['expectedEndDate'] as String),
      actualEndDate: json['actualEndDate'] != null ? DateTime.parse(json['actualEndDate'] as String) : null,
      totalBudget: (json['totalBudget'] as num).toDouble(),
      totalSpent: (json['totalSpent'] as num?)?.toDouble() ?? 0,
      progress: json['progress'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'propertyId': propertyId,
    'projectName': projectName,
    'description': description,
    'status': status.name,
    'startDate': startDate.toIso8601String(),
    'expectedEndDate': expectedEndDate.toIso8601String(),
    'actualEndDate': actualEndDate?.toIso8601String(),
    'totalBudget': totalBudget,
    'totalSpent': totalSpent,
    'progress': progress,
  };
}
