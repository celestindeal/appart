import 'package:equatable/equatable.dart';

/// Type de differe d'emprunt.
enum LoanDeferralType {
  total('Total'),
  partial('Partiel');

  const LoanDeferralType(this.label);
  final String label;
}

/// Entite representant un emprunt bancaire lie a un bien.
class LoanEntity extends Equatable {
  const LoanEntity({
    required this.id,
    required this.propertyId,
    required this.name,
    required this.amount,
    required this.interestRate,
    required this.durationMonths,
    required this.startDate,
    required this.deferralMonths,
    required this.monthlyPayment,
    required this.createdAt,
    required this.updatedAt,
    this.bankName,
    this.deferralType,
  });

  final String id;
  final String propertyId;
  final String name;
  final String? bankName;
  final double amount;
  final double interestRate;
  final int durationMonths;
  final DateTime startDate;
  final int deferralMonths;
  final LoanDeferralType? deferralType;
  final double monthlyPayment;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Date de fin estimee de l'emprunt.
  DateTime get endDate =>
      DateTime(startDate.year, startDate.month + durationMonths, startDate.day);

  /// Cout total de l'emprunt (mensualite * duree hors differe).
  double get totalCost => monthlyPayment * (durationMonths - deferralMonths);

  /// Nombre de mois restants a partir d'aujourd'hui.
  int get remainingMonths {
    final now = DateTime.now();
    final end = endDate;
    if (now.isAfter(end)) return 0;
    return (end.year - now.year) * 12 + end.month - now.month;
  }

  /// Vrai si l'emprunt est encore en cours (pas termine).
  bool get isActive => DateTime.now().isBefore(endDate);

  /// Vrai si on est encore dans la periode de differe.
  bool get isInDeferralPeriod {
    if (deferralMonths <= 0) return false;
    final deferralEnd = DateTime(
      startDate.year,
      startDate.month + deferralMonths,
      startDate.day,
    );
    return DateTime.now().isBefore(deferralEnd);
  }

  @override
  List<Object?> get props => [
        id,
        propertyId,
        name,
        bankName,
        amount,
        interestRate,
        durationMonths,
        startDate,
        deferralMonths,
        deferralType,
        monthlyPayment,
        createdAt,
        updatedAt,
      ];
}
