import 'dart:math' as math;

import '../entities/profitability_result.dart';

/// Cas d'usage : calcul complet de la rentabilite d'un investissement immobilier.
///
/// Formules utilisees :
/// - Rendement brut = (loyer annuel / prix d'achat) * 100
/// - Rendement net = (revenu net annuel / investissement total) * 100
/// - Mensualite = [capital * taux_mensuel * (1 + taux_mensuel)^n] / [(1 + taux_mensuel)^n - 1]
/// - Cash-flow = loyer mensuel - charges mensuelles - mensualite credit
/// - Cash-on-cash = revenu net annuel / apport personnel * 100
class CalculateProfitabilityUsecase {
  /// Execute le calcul de rentabilite.
  ///
  /// [price] : prix d'achat du bien
  /// [monthlyRent] : loyer mensuel attendu
  /// [charges] : charges mensuelles (copropriete, gestion, etc.)
  /// [propertyTax] : taxe fonciere annuelle
  /// [insurance] : assurance annuelle (PNO, GLI, etc.)
  /// [loanRate] : taux d'interet annuel du credit en pourcentage
  /// [loanDuration] : duree du credit en annees
  /// [downPayment] : apport personnel
  /// [renovationCost] : cout des travaux
  /// [notaryFeesPercent] : pourcentage des frais de notaire (defaut 7.5%)
  /// [surface] : surface du bien en m2 (pour calcul prix/m2)
  ProfitabilityResult execute({
    required double price,
    required double monthlyRent,
    double charges = 0,
    double propertyTax = 0,
    double insurance = 0,
    double loanRate = 0,
    int loanDuration = 20,
    double downPayment = 0,
    double renovationCost = 0,
    double notaryFeesPercent = 7.5,
    double surface = 0,
  }) {
    // -- Investissement total --
    final notaryFees = price * notaryFeesPercent / 100;
    final totalInvestment = price + notaryFees + renovationCost;

    // -- Revenus --
    final annualRent = monthlyRent * 12;

    // -- Charges annuelles --
    final annualCharges = charges * 12;
    final annualExpenses = annualCharges + propertyTax + insurance;

    // -- Rendement brut --
    final grossYield = price > 0 ? (annualRent / price) * 100 : 0.0;

    // -- Mensualite credit --
    final loanAmount = totalInvestment - downPayment;
    final monthlyMortgage = _calculateMonthlyMortgage(
      principal: loanAmount,
      annualRate: loanRate,
      durationYears: loanDuration,
    );

    // -- Revenu net annuel --
    final annualMortgage = monthlyMortgage * 12;
    final annualNetIncome = annualRent - annualExpenses - annualMortgage;

    // -- Rendement net --
    final netYield =
        totalInvestment > 0 ? (annualRent - annualExpenses) / totalInvestment * 100 : 0.0;

    // -- Cash-flow mensuel --
    final cashFlow = monthlyRent - charges - (propertyTax / 12) - (insurance / 12) - monthlyMortgage;

    // -- Cash-on-cash return --
    final actualDownPayment = downPayment > 0 ? downPayment : totalInvestment;
    final cashOnCashReturn =
        actualDownPayment > 0 ? (annualNetIncome / actualDownPayment) * 100 : 0.0;

    // -- Prix au m2 --
    final pricePerSqm = surface > 0 ? price / surface : 0.0;

    // -- Seuil de rentabilite (annees) --
    final breakEvenYears = annualNetIncome > 0
        ? actualDownPayment / annualNetIncome
        : double.infinity;

    return ProfitabilityResult(
      grossYield: _round(grossYield),
      netYield: _round(netYield),
      cashFlow: _round(cashFlow),
      monthlyMortgage: _round(monthlyMortgage),
      totalInvestment: _round(totalInvestment),
      annualRent: _round(annualRent),
      annualExpenses: _round(annualExpenses),
      annualNetIncome: _round(annualNetIncome),
      cashOnCashReturn: _round(cashOnCashReturn),
      pricePerSqm: _round(pricePerSqm),
      breakEvenYears: breakEvenYears.isFinite ? _round(breakEvenYears) : -1,
    );
  }

  /// Calcule la mensualite d'un pret immobilier (formule d'annuite constante).
  double _calculateMonthlyMortgage({
    required double principal,
    required double annualRate,
    required int durationYears,
  }) {
    if (principal <= 0 || annualRate <= 0 || durationYears <= 0) return 0;

    final monthlyRate = annualRate / 100 / 12;
    final numberOfPayments = durationYears * 12;
    final compoundFactor = math.pow(1 + monthlyRate, numberOfPayments);

    return principal * monthlyRate * compoundFactor / (compoundFactor - 1);
  }

  /// Arrondit a 2 decimales.
  double _round(double value) => (value * 100).roundToDouble() / 100;
}
