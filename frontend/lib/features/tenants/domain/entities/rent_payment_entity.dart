import 'package:equatable/equatable.dart';

/// Methode de paiement du loyer.
enum PaymentMethod {
  bankTransfer('Virement bancaire'),
  check('Cheque'),
  cash('Especes'),
  card('Carte bancaire');

  const PaymentMethod(this.label);
  final String label;
}

/// Statut du paiement.
enum PaymentStatus {
  pending('En attente'),
  paid('Paye'),
  late_('En retard'),
  cancelled('Annule');

  const PaymentStatus(this.label);
  final String label;
}

/// Entite representant un paiement de loyer.
class RentPaymentEntity extends Equatable {
  const RentPaymentEntity({
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

  /// Indique si le paiement est en retard.
  bool get isLate => status == PaymentStatus.late_;

  /// Indique si le paiement a ete effectue.
  bool get isPaid => status == PaymentStatus.paid;

  RentPaymentEntity copyWith({
    String? id,
    String? tenantId,
    String? propertyId,
    double? amount,
    DateTime? paymentDueDate,
    DateTime? paymentDate,
    PaymentMethod? paymentMethod,
    PaymentStatus? status,
    String? notes,
  }) {
    return RentPaymentEntity(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      propertyId: propertyId ?? this.propertyId,
      amount: amount ?? this.amount,
      paymentDueDate: paymentDueDate ?? this.paymentDueDate,
      paymentDate: paymentDate ?? this.paymentDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        tenantId,
        propertyId,
        amount,
        paymentDueDate,
        paymentDate,
        paymentMethod,
        status,
        notes,
      ];
}
