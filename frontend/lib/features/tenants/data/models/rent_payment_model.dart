import '../../domain/entities/rent_payment_entity.dart';

/// Modele de donnees pour un paiement de loyer (JSON <-> entite).
class RentPaymentModel {
  const RentPaymentModel({
    required this.id,
    required this.tenantId,
    required this.propertyId,
    required this.amount,
    required this.paymentDueDate,
    required this.status,
    this.paymentDate,
    this.paymentMethod,
    this.notes,
  });

  final String id;
  final String tenantId;
  final String propertyId;
  final double amount;
  final DateTime paymentDueDate;
  final DateTime? paymentDate;
  final PaymentMethod? paymentMethod;
  final PaymentStatus status;
  final String? notes;

  factory RentPaymentModel.fromJson(Map<String, dynamic> json) {
    return RentPaymentModel(
      id: json['id'].toString(),
      tenantId: json['tenantId'].toString(),
      propertyId: json['propertyId'].toString(),
      amount: (json['amount'] as num).toDouble(),
      paymentDueDate: DateTime.parse(json['paymentDueDate'] as String),
      paymentDate: json['paymentDate'] == null
          ? null
          : DateTime.parse(json['paymentDate'] as String),
      paymentMethod: _parseMethod(json['paymentMethod'] as String?),
      status: _parseStatus(json['status'] as String?),
      notes: json['notes'] as String?,
    );
  }

  RentPaymentEntity toEntity() => RentPaymentEntity(
        id: id,
        tenantId: tenantId,
        propertyId: propertyId,
        amount: amount,
        paymentDueDate: paymentDueDate,
        paymentDate: paymentDate,
        paymentMethod: paymentMethod,
        status: status,
        notes: notes,
      );

  Map<String, dynamic> toCreateJson() => {
        'tenantId': tenantId,
        'propertyId': propertyId,
        'amount': amount,
        'paymentDueDate': paymentDueDate.toIso8601String(),
        'paymentDate': paymentDate?.toIso8601String(),
        'paymentMethod': _methodToJson(paymentMethod),
        'status': _statusToJson(status),
        'notes': notes,
      };

  Map<String, dynamic> toUpdateJson() => {
        'amount': amount,
        'paymentDueDate': paymentDueDate.toIso8601String(),
        'paymentDate': paymentDate?.toIso8601String(),
        'paymentMethod': _methodToJson(paymentMethod),
        'status': _statusToJson(status),
        'notes': notes,
      };

  static RentPaymentModel fromEntity(RentPaymentEntity e) => RentPaymentModel(
        id: e.id,
        tenantId: e.tenantId,
        propertyId: e.propertyId,
        amount: e.amount,
        paymentDueDate: e.paymentDueDate,
        paymentDate: e.paymentDate,
        paymentMethod: e.paymentMethod,
        status: e.status,
        notes: e.notes,
      );

  // ── Serialisation enum ──────────────────────────────────────
  // Le backend sérialise les enums en PascalCase ("BankTransfer", "Paid", ...).

  static PaymentMethod? _parseMethod(String? raw) {
    if (raw == null) return null;
    switch (raw) {
      case 'BankTransfer':
        return PaymentMethod.bankTransfer;
      case 'Check':
        return PaymentMethod.check;
      case 'Cash':
        return PaymentMethod.cash;
      case 'Card':
        return PaymentMethod.card;
    }
    return null;
  }

  static String? _methodToJson(PaymentMethod? m) {
    if (m == null) return null;
    switch (m) {
      case PaymentMethod.bankTransfer:
        return 'BankTransfer';
      case PaymentMethod.check:
        return 'Check';
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.card:
        return 'Card';
    }
  }

  static PaymentStatus _parseStatus(String? raw) {
    switch (raw) {
      case 'Paid':
        return PaymentStatus.paid;
      case 'Late':
        return PaymentStatus.late_;
      case 'Cancelled':
        return PaymentStatus.cancelled;
      case 'Pending':
      default:
        return PaymentStatus.pending;
    }
  }

  static String _statusToJson(PaymentStatus s) {
    switch (s) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.late_:
        return 'Late';
      case PaymentStatus.cancelled:
        return 'Cancelled';
    }
  }
}
