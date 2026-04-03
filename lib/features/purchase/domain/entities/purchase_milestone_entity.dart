import 'package:equatable/equatable.dart';

/// Type de jalon dans le processus d'achat.
enum MilestoneType {
  visit,
  offer,
  counterOffer,
  inspection,
  financing,
  notarySigning,
  keyHandover;

  String get label {
    switch (this) {
      case MilestoneType.visit:
        return 'Visite';
      case MilestoneType.offer:
        return 'Offre';
      case MilestoneType.counterOffer:
        return 'Contre-offre';
      case MilestoneType.inspection:
        return 'Inspection';
      case MilestoneType.financing:
        return 'Financement';
      case MilestoneType.notarySigning:
        return 'Signature notaire';
      case MilestoneType.keyHandover:
        return 'Remise des clés';
    }
  }
}

/// Jalon d'un projet d'achat immobilier.
class PurchaseMilestoneEntity extends Equatable {
  final String id;
  final String projectId;
  final String title;
  final String? description;
  final MilestoneType milestoneType;
  final DateTime? plannedDate;
  final DateTime? actualDate;
  final bool isCompleted;
  final String? notes;

  const PurchaseMilestoneEntity({
    required this.id,
    required this.projectId,
    required this.title,
    this.description,
    required this.milestoneType,
    this.plannedDate,
    this.actualDate,
    this.isCompleted = false,
    this.notes,
  });

  /// Indique si le jalon est en retard.
  bool get isOverdue {
    if (isCompleted || plannedDate == null) return false;
    return DateTime.now().isAfter(plannedDate!);
  }

  PurchaseMilestoneEntity copyWith({
    String? id,
    String? projectId,
    String? title,
    String? description,
    MilestoneType? milestoneType,
    DateTime? plannedDate,
    DateTime? actualDate,
    bool? isCompleted,
    String? notes,
  }) {
    return PurchaseMilestoneEntity(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      milestoneType: milestoneType ?? this.milestoneType,
      plannedDate: plannedDate ?? this.plannedDate,
      actualDate: actualDate ?? this.actualDate,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        projectId,
        title,
        description,
        milestoneType,
        plannedDate,
        actualDate,
        isCompleted,
        notes,
      ];
}
