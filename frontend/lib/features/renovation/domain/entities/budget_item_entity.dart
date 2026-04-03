import 'package:equatable/equatable.dart';

class BudgetItemEntity extends Equatable {
  final String id;
  final String projectId;
  final String itemName;
  final String? category;
  final double plannedAmount;
  final double spentAmount;
  final String? supplier;
  final double? quantity;
  final double? unitPrice;
  final String? notes;

  const BudgetItemEntity({
    required this.id,
    required this.projectId,
    required this.itemName,
    this.category,
    required this.plannedAmount,
    this.spentAmount = 0,
    this.supplier,
    this.quantity,
    this.unitPrice,
    this.notes,
  });

  double get ecart => plannedAmount - spentAmount;

  @override
  List<Object?> get props => [id];
}
