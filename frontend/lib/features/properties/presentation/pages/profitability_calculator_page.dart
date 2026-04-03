import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:immo_manager/config/theme/app_colors.dart';
import 'package:immo_manager/config/theme/app_text_styles.dart';
import '../../domain/entities/profitability_result.dart';
import '../../domain/usecases/calculate_profitability_usecase.dart';

/// Page du calculateur de rentabilité immobilière.
class ProfitabilityCalculatorPage extends ConsumerStatefulWidget {
  const ProfitabilityCalculatorPage({super.key});

  @override
  ConsumerState<ProfitabilityCalculatorPage> createState() =>
      _ProfitabilityCalculatorPageState();
}

class _ProfitabilityCalculatorPageState
    extends ConsumerState<ProfitabilityCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _usecase = CalculateProfitabilityUsecase();

  ProfitabilityResult? _result;

  // Champs du formulaire
  final _priceController = TextEditingController();
  final _rentController = TextEditingController();
  final _chargesController = TextEditingController();
  final _taxController = TextEditingController();
  final _insuranceController = TextEditingController();
  final _rateController = TextEditingController();
  final _durationController = TextEditingController();
  final _downPaymentController = TextEditingController();
  final _renovationController = TextEditingController();
  final _notaryFeesController = TextEditingController(text: '7.5');

  static final _currencyFormat = NumberFormat.currency(
    locale: 'fr_FR',
    symbol: '€',
    decimalDigits: 0,
  );

  @override
  void dispose() {
    _priceController.dispose();
    _rentController.dispose();
    _chargesController.dispose();
    _taxController.dispose();
    _insuranceController.dispose();
    _rateController.dispose();
    _durationController.dispose();
    _downPaymentController.dispose();
    _renovationController.dispose();
    _notaryFeesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Calculateur de Rentabilité'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Formulaire
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppColors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Paramètres du bien', style: AppTextStyles.h4),
                      const SizedBox(height: 16),
                      _buildNumberField(
                        controller: _priceController,
                        label: 'Prix d\'achat (€)',
                        hint: 'Ex: 200000',
                        required: true,
                      ),
                      const SizedBox(height: 12),
                      _buildNumberField(
                        controller: _rentController,
                        label: 'Loyer mensuel (€)',
                        hint: 'Ex: 800',
                        required: true,
                      ),
                      const SizedBox(height: 12),
                      _buildNumberField(
                        controller: _chargesController,
                        label: 'Charges mensuelles (€)',
                        hint: '0',
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildNumberField(
                              controller: _taxController,
                              label: 'Taxe foncière (€/an)',
                              hint: '0',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildNumberField(
                              controller: _insuranceController,
                              label: 'Assurance (€/an)',
                              hint: '0',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text('Financement', style: AppTextStyles.h4),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildNumberField(
                              controller: _rateController,
                              label: 'Taux du crédit (%)',
                              hint: 'Ex: 3.5',
                              allowDecimal: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildNumberField(
                              controller: _durationController,
                              label: 'Durée (années)',
                              hint: 'Ex: 20',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildNumberField(
                        controller: _downPaymentController,
                        label: 'Apport personnel (€)',
                        hint: '0',
                      ),
                      const SizedBox(height: 12),
                      _buildNumberField(
                        controller: _renovationController,
                        label: 'Coût des travaux (€)',
                        hint: '0',
                      ),
                      const SizedBox(height: 12),
                      _buildNumberField(
                        controller: _notaryFeesController,
                        label: 'Frais de notaire (%)',
                        hint: '7.5',
                        allowDecimal: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Boutons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _calculate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Calculer',
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 50,
                  child: TextButton(
                    onPressed: _reset,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Réinitialiser'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Résultats
            if (_result != null) ...[
              Text('Résultats', style: AppTextStyles.h3),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildResultCard(
                      'Rendement brut',
                      '${_result!.grossYield.toStringAsFixed(2)}%',
                      Icons.trending_up,
                      _yieldColor(_result!.grossYield),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildResultCard(
                      'Rendement net',
                      '${_result!.netYield.toStringAsFixed(2)}%',
                      Icons.show_chart,
                      _yieldColor(_result!.netYield),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildResultCard(
                      'Cash-flow mensuel',
                      '${_result!.cashFlow >= 0 ? '+' : ''}${_currencyFormat.format(_result!.cashFlow)}',
                      Icons.account_balance_wallet,
                      _result!.cashFlow >= 0
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildResultCard(
                      'Mensualité crédit',
                      _currencyFormat.format(_result!.monthlyMortgage),
                      Icons.credit_card,
                      AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildResultCard(
                      'Investissement total',
                      _currencyFormat.format(_result!.totalInvestment),
                      Icons.savings,
                      AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildResultCard(
                      'Revenu annuel net',
                      _currencyFormat.format(_result!.annualNetIncome),
                      Icons.euro,
                      _result!.annualNetIncome >= 0
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool required = false,
    bool allowDecimal = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      inputFormatters: [
        if (allowDecimal)
          FilteringTextInputFormatter.allow(RegExp(r'[\d.,]'))
        else
          FilteringTextInputFormatter.digitsOnly,
      ],
      validator: required
          ? (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Ce champ est requis';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildResultCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(height: 12),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: AppTextStyles.h4.copyWith(color: color),
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }

  Color _yieldColor(double yield_) {
    if (yield_ >= 7) return AppColors.success;
    if (yield_ >= 4) return AppColors.warning;
    return AppColors.error;
  }

  double _parseDouble(String text) {
    if (text.trim().isEmpty) return 0;
    return double.tryParse(text.replaceAll(',', '.').replaceAll(' ', '')) ?? 0;
  }

  int _parseInt(String text) {
    if (text.trim().isEmpty) return 0;
    return int.tryParse(text.replaceAll(' ', '')) ?? 0;
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final result = _usecase.execute(
      price: _parseDouble(_priceController.text),
      monthlyRent: _parseDouble(_rentController.text),
      charges: _parseDouble(_chargesController.text),
      propertyTax: _parseDouble(_taxController.text),
      insurance: _parseDouble(_insuranceController.text),
      loanRate: _parseDouble(_rateController.text),
      loanDuration: _parseInt(_durationController.text),
      downPayment: _parseDouble(_downPaymentController.text),
      renovationCost: _parseDouble(_renovationController.text),
      notaryFeesPercent: _parseDouble(_notaryFeesController.text),
    );

    setState(() => _result = result);
  }

  void _reset() {
    _priceController.clear();
    _rentController.clear();
    _chargesController.clear();
    _taxController.clear();
    _insuranceController.clear();
    _rateController.clear();
    _durationController.clear();
    _downPaymentController.clear();
    _renovationController.clear();
    _notaryFeesController.text = '7.5';
    setState(() => _result = null);
  }
}
