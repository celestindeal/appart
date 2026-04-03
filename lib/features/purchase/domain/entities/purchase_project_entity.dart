import 'package:equatable/equatable.dart';

import 'purchase_milestone_entity.dart';

/// Statut d'un projet d'achat immobilier.
enum PurchaseStatus {
  prospect,
  negotiation,
  offerMade,
  offerAccepted,
  financing,
  notary,
  completed,
  cancelled;

  String get label {
    switch (this) {
      case PurchaseStatus.prospect:
        return 'Prospect';
      case PurchaseStatus.negotiation:
        return 'Négociation';
      case PurchaseStatus.offerMade:
        return 'Offre faite';
      case PurchaseStatus.offerAccepted:
        return 'Offre acceptée';
      case PurchaseStatus.financing:
        return 'Financement';
      case PurchaseStatus.notary:
        return 'Notaire';
      case PurchaseStatus.completed:
        return 'Terminé';
      case PurchaseStatus.cancelled:
        return 'Annulé';
    }
  }

  /// Ordre d'avancement pour le calcul de progression.
  int get order {
    switch (this) {
      case PurchaseStatus.prospect:
        return 0;
      case PurchaseStatus.negotiation:
        return 1;
      case PurchaseStatus.offerMade:
        return 2;
      case PurchaseStatus.offerAccepted:
        return 3;
      case PurchaseStatus.financing:
        return 4;
      case PurchaseStatus.notary:
        return 5;
      case PurchaseStatus.completed:
        return 6;
      case PurchaseStatus.cancelled:
        return -1;
    }
  }
}

/// Entité représentant un projet d'achat immobilier.
class PurchaseProjectEntity extends Equatable {
  final String id;
  final String propertyId;
  final String propertyName;
  final PurchaseStatus status;
  final double? targetPrice;
  final double? finalPrice;
  final double? downPayment;
  final double? loanAmount;
  final double? interestRate;
  final int? loanTermMonths;
  final double? notaryFees;
  final double? agencyFees;
  final double? otherCosts;
  final DateTime? expectedCompletionDate;
  final DateTime? actualCompletionDate;
  final List<PurchaseMilestoneEntity> milestones;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PurchaseProjectEntity({
    required this.id,
    required this.propertyId,
    required this.propertyName,
    required this.status,
    this.targetPrice,
    this.finalPrice,
    this.downPayment,
    this.loanAmount,
    this.interestRate,
    this.loanTermMonths,
    this.notaryFees,
    this.agencyFees,
    this.otherCosts,
    this.expectedCompletionDate,
    this.actualCompletionDate,
    this.milestones = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// Coût total de l'acquisition (prix + frais).
  double get totalCost {
    return (finalPrice ?? targetPrice ?? 0) +
        (notaryFees ?? 0) +
        (agencyFees ?? 0) +
        (otherCosts ?? 0);
  }

  /// Pourcentage d'avancement basé sur le statut.
  double get progressPercent {
    if (status == PurchaseStatus.cancelled) return 0;
    if (status == PurchaseStatus.completed) return 100;
    // 6 étapes actives (prospect -> completed), on exclut cancelled
    return (status.order / 6) * 100;
  }

  /// Nombre de jalons complétés.
  int get completedMilestones =>
      milestones.where((m) => m.isCompleted).length;

  PurchaseProjectEntity copyWith({
    String? id,
    String? propertyId,
    String? propertyName,
    PurchaseStatus? status,
    double? targetPrice,
    double? finalPrice,
    double? downPayment,
    double? loanAmount,
    double? interestRate,
    int? loanTermMonths,
    double? notaryFees,
    double? agencyFees,
    double? otherCosts,
    DateTime? expectedCompletionDate,
    DateTime? actualCompletionDate,
    List<PurchaseMilestoneEntity>? milestones,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PurchaseProjectEntity(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      propertyName: propertyName ?? this.propertyName,
      status: status ?? this.status,
      targetPrice: targetPrice ?? this.targetPrice,
      finalPrice: finalPrice ?? this.finalPrice,
      downPayment: downPayment ?? this.downPayment,
      loanAmount: loanAmount ?? this.loanAmount,
      interestRate: interestRate ?? this.interestRate,
      loanTermMonths: loanTermMonths ?? this.loanTermMonths,
      notaryFees: notaryFees ?? this.notaryFees,
      agencyFees: agencyFees ?? this.agencyFees,
      otherCosts: otherCosts ?? this.otherCosts,
      expectedCompletionDate:
          expectedCompletionDate ?? this.expectedCompletionDate,
      actualCompletionDate:
          actualCompletionDate ?? this.actualCompletionDate,
      milestones: milestones ?? this.milestones,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        propertyId,
        propertyName,
        status,
        targetPrice,
        finalPrice,
        downPayment,
        loanAmount,
        interestRate,
        loanTermMonths,
        notaryFees,
        agencyFees,
        otherCosts,
        expectedCompletionDate,
        actualCompletionDate,
        milestones,
        createdAt,
        updatedAt,
      ];
}
