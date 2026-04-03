import 'package:equatable/equatable.dart';

enum EntryType { income, expense, transfer }
enum ExpenseCategory { rent, charges, tax, insurance, maintenance, renovation, notaryFees, agencyFees, mortgage, other }

class AccountingEntryEntity extends Equatable {
  final String id;
  final String? propertyId;
  final String? propertyName;
  final EntryType entryType;
  final double amount;
  final DateTime entryDate;
  final String description;
  final ExpenseCategory category;
  final String? notes;
  final DateTime createdAt;

  const AccountingEntryEntity({
    required this.id,
    this.propertyId,
    this.propertyName,
    required this.entryType,
    required this.amount,
    required this.entryDate,
    required this.description,
    required this.category,
    this.notes,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}
