import 'package:equatable/equatable.dart';

/// Resultat complet d'un calcul de rentabilite immobiliere.
class ProfitabilityResult extends Equatable {
  const ProfitabilityResult({
    required this.grossYield,
    required this.netYield,
    required this.cashFlow,
    required this.monthlyMortgage,
    required this.totalInvestment,
    required this.annualRent,
    required this.annualExpenses,
    required this.annualNetIncome,
    required this.cashOnCashReturn,
    required this.pricePerSqm,
    required this.breakEvenYears,
  });

  /// Rendement brut en pourcentage.
  final double grossYield;

  /// Rendement net en pourcentage (apres charges et fiscalite).
  final double netYield;

  /// Cash-flow mensuel net (loyer - charges - mensualite credit).
  final double cashFlow;

  /// Mensualite du credit immobilier.
  final double monthlyMortgage;

  /// Investissement total (prix + frais de notaire + travaux).
  final double totalInvestment;

  /// Loyer annuel brut.
  final double annualRent;

  /// Charges annuelles totales (taxe fonciere, assurance, charges, gestion).
  final double annualExpenses;

  /// Revenu net annuel apres deduction des charges.
  final double annualNetIncome;

  /// Rendement sur fonds propres (cash-on-cash return) en pourcentage.
  final double cashOnCashReturn;

  /// Prix au metre carre.
  final double pricePerSqm;

  /// Nombre d'annees pour atteindre le seuil de rentabilite.
  final double breakEvenYears;

  @override
  List<Object?> get props => [
        grossYield,
        netYield,
        cashFlow,
        monthlyMortgage,
        totalInvestment,
        annualRent,
        annualExpenses,
        annualNetIncome,
        cashOnCashReturn,
        pricePerSqm,
        breakEvenYears,
      ];
}
