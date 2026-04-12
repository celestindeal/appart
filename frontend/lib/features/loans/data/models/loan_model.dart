import '../../domain/entities/loan_entity.dart';

class LoanModel extends LoanEntity {
  const LoanModel({
    required super.id,
    required super.propertyId,
    required super.name,
    required super.amount,
    required super.interestRate,
    required super.durationMonths,
    required super.startDate,
    required super.deferralMonths,
    required super.monthlyPayment,
    required super.createdAt,
    required super.updatedAt,
    super.bankName,
    super.deferralType,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['id'] as String,
      propertyId: json['propertyId'] as String,
      name: json['name'] as String,
      bankName: json['bankName'] as String?,
      amount: (json['amount'] as num).toDouble(),
      interestRate: (json['interestRate'] as num).toDouble(),
      durationMonths: json['durationMonths'] as int,
      startDate: DateTime.parse(json['startDate'] as String),
      deferralMonths: json['deferralMonths'] as int? ?? 0,
      deferralType: _parseDeferralType(json['deferralType'] as String?),
      monthlyPayment: (json['monthlyPayment'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  factory LoanModel.fromEntity(LoanEntity entity) {
    return LoanModel(
      id: entity.id,
      propertyId: entity.propertyId,
      name: entity.name,
      bankName: entity.bankName,
      amount: entity.amount,
      interestRate: entity.interestRate,
      durationMonths: entity.durationMonths,
      startDate: entity.startDate,
      deferralMonths: entity.deferralMonths,
      deferralType: entity.deferralType,
      monthlyPayment: entity.monthlyPayment,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'propertyId': propertyId,
      'name': name,
      'bankName': bankName,
      'amount': amount,
      'interestRate': interestRate,
      'durationMonths': durationMonths,
      'startDate': startDate.toIso8601String(),
      'deferralMonths': deferralMonths,
      'deferralType': deferralType?.name,
      'monthlyPayment': monthlyPayment,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'bankName': bankName,
      'amount': amount,
      'interestRate': interestRate,
      'durationMonths': durationMonths,
      'startDate': startDate.toIso8601String(),
      'deferralMonths': deferralMonths,
      'deferralType': deferralType?.name,
      'monthlyPayment': monthlyPayment,
    };
  }

  static LoanDeferralType? _parseDeferralType(String? value) {
    if (value == null) return null;
    switch (value.toLowerCase()) {
      case 'total':
        return LoanDeferralType.total;
      case 'partial':
        return LoanDeferralType.partial;
      default:
        return null;
    }
  }
}
