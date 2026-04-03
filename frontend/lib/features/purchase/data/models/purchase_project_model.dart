import '../../domain/entities/purchase_milestone_entity.dart';
import '../../domain/entities/purchase_project_entity.dart';

/// Modèle de jalon pour la sérialisation JSON.
class PurchaseMilestoneModel extends PurchaseMilestoneEntity {
  const PurchaseMilestoneModel({
    required super.id,
    required super.projectId,
    required super.title,
    super.description,
    required super.milestoneType,
    super.plannedDate,
    super.actualDate,
    super.isCompleted,
    super.notes,
  });

  factory PurchaseMilestoneModel.fromJson(Map<String, dynamic> json) {
    return PurchaseMilestoneModel(
      id: json['id'] as String,
      projectId: json['project_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      milestoneType: MilestoneType.values.firstWhere(
        (e) => e.name == json['milestone_type'],
        orElse: () => MilestoneType.visit,
      ),
      plannedDate: json['planned_date'] != null
          ? DateTime.parse(json['planned_date'] as String)
          : null,
      actualDate: json['actual_date'] != null
          ? DateTime.parse(json['actual_date'] as String)
          : null,
      isCompleted: json['is_completed'] as bool? ?? false,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'title': title,
      'description': description,
      'milestone_type': milestoneType.name,
      'planned_date': plannedDate?.toIso8601String(),
      'actual_date': actualDate?.toIso8601String(),
      'is_completed': isCompleted,
      'notes': notes,
    };
  }

  factory PurchaseMilestoneModel.fromEntity(PurchaseMilestoneEntity entity) {
    return PurchaseMilestoneModel(
      id: entity.id,
      projectId: entity.projectId,
      title: entity.title,
      description: entity.description,
      milestoneType: entity.milestoneType,
      plannedDate: entity.plannedDate,
      actualDate: entity.actualDate,
      isCompleted: entity.isCompleted,
      notes: entity.notes,
    );
  }
}

/// Modèle de projet d'achat pour la sérialisation JSON.
class PurchaseProjectModel extends PurchaseProjectEntity {
  const PurchaseProjectModel({
    required super.id,
    required super.propertyId,
    required super.propertyName,
    required super.status,
    super.targetPrice,
    super.finalPrice,
    super.downPayment,
    super.loanAmount,
    super.interestRate,
    super.loanTermMonths,
    super.notaryFees,
    super.agencyFees,
    super.otherCosts,
    super.expectedCompletionDate,
    super.actualCompletionDate,
    super.milestones,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PurchaseProjectModel.fromJson(Map<String, dynamic> json) {
    final milestonesJson = json['milestones'] as List<dynamic>?;

    return PurchaseProjectModel(
      id: json['id'] as String,
      propertyId: json['property_id'] as String,
      propertyName: json['property_name'] as String,
      status: PurchaseStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PurchaseStatus.prospect,
      ),
      targetPrice: (json['target_price'] as num?)?.toDouble(),
      finalPrice: (json['final_price'] as num?)?.toDouble(),
      downPayment: (json['down_payment'] as num?)?.toDouble(),
      loanAmount: (json['loan_amount'] as num?)?.toDouble(),
      interestRate: (json['interest_rate'] as num?)?.toDouble(),
      loanTermMonths: json['loan_term_months'] as int?,
      notaryFees: (json['notary_fees'] as num?)?.toDouble(),
      agencyFees: (json['agency_fees'] as num?)?.toDouble(),
      otherCosts: (json['other_costs'] as num?)?.toDouble(),
      expectedCompletionDate: json['expected_completion_date'] != null
          ? DateTime.parse(json['expected_completion_date'] as String)
          : null,
      actualCompletionDate: json['actual_completion_date'] != null
          ? DateTime.parse(json['actual_completion_date'] as String)
          : null,
      milestones: milestonesJson
              ?.map((e) => PurchaseMilestoneModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property_id': propertyId,
      'property_name': propertyName,
      'status': status.name,
      'target_price': targetPrice,
      'final_price': finalPrice,
      'down_payment': downPayment,
      'loan_amount': loanAmount,
      'interest_rate': interestRate,
      'loan_term_months': loanTermMonths,
      'notary_fees': notaryFees,
      'agency_fees': agencyFees,
      'other_costs': otherCosts,
      'expected_completion_date':
          expectedCompletionDate?.toIso8601String(),
      'actual_completion_date':
          actualCompletionDate?.toIso8601String(),
      'milestones': milestones
          .map((e) => PurchaseMilestoneModel.fromEntity(e).toJson())
          .toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory PurchaseProjectModel.fromEntity(PurchaseProjectEntity entity) {
    return PurchaseProjectModel(
      id: entity.id,
      propertyId: entity.propertyId,
      propertyName: entity.propertyName,
      status: entity.status,
      targetPrice: entity.targetPrice,
      finalPrice: entity.finalPrice,
      downPayment: entity.downPayment,
      loanAmount: entity.loanAmount,
      interestRate: entity.interestRate,
      loanTermMonths: entity.loanTermMonths,
      notaryFees: entity.notaryFees,
      agencyFees: entity.agencyFees,
      otherCosts: entity.otherCosts,
      expectedCompletionDate: entity.expectedCompletionDate,
      actualCompletionDate: entity.actualCompletionDate,
      milestones: entity.milestones,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  PurchaseProjectEntity toEntity() {
    return PurchaseProjectEntity(
      id: id,
      propertyId: propertyId,
      propertyName: propertyName,
      status: status,
      targetPrice: targetPrice,
      finalPrice: finalPrice,
      downPayment: downPayment,
      loanAmount: loanAmount,
      interestRate: interestRate,
      loanTermMonths: loanTermMonths,
      notaryFees: notaryFees,
      agencyFees: agencyFees,
      otherCosts: otherCosts,
      expectedCompletionDate: expectedCompletionDate,
      actualCompletionDate: actualCompletionDate,
      milestones: milestones,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
