import '../../domain/entities/accounting_entry_entity.dart';

class AccountingEntryModel extends AccountingEntryEntity {
  const AccountingEntryModel({
    required super.id,
    super.propertyId,
    super.propertyName,
    required super.entryType,
    required super.amount,
    required super.entryDate,
    required super.description,
    required super.category,
    super.notes,
    required super.createdAt,
  });

  factory AccountingEntryModel.fromJson(Map<String, dynamic> json) {
    return AccountingEntryModel(
      id: json['id'] as String,
      propertyId: json['propertyId'] as String?,
      propertyName: json['propertyName'] as String?,
      entryType: EntryType.values.byName(json['entryType'] as String),
      amount: (json['amount'] as num).toDouble(),
      entryDate: DateTime.parse(json['entryDate'] as String),
      description: json['description'] as String,
      category: ExpenseCategory.values.byName(json['category'] as String),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'propertyId': propertyId,
    'entryType': entryType.name,
    'amount': amount,
    'entryDate': entryDate.toIso8601String(),
    'description': description,
    'category': category.name,
    'notes': notes,
  };
}
