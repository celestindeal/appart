import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:immo_manager/config/theme/app_colors.dart';
import 'package:immo_manager/config/theme/app_text_styles.dart';
import '../../domain/entities/loan_entity.dart';
import '../providers/loan_provider.dart';

/// Formulaire de creation / edition d'un emprunt.
class LoanFormPage extends ConsumerStatefulWidget {
  const LoanFormPage({
    super.key,
    required this.propertyId,
    this.loan,
  });

  final String propertyId;
  final LoanEntity? loan;

  @override
  ConsumerState<LoanFormPage> createState() => _LoanFormPageState();
}

class _LoanFormPageState extends ConsumerState<LoanFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool get _isEditing => widget.loan != null;

  final _nameController = TextEditingController();
  final _bankController = TextEditingController();
  final _amountController = TextEditingController();
  final _rateController = TextEditingController();
  final _durationController = TextEditingController();
  final _deferralController = TextEditingController(text: '0');
  final _monthlyPaymentController = TextEditingController();

  DateTime _startDate = DateTime.now();
  LoanDeferralType? _deferralType;
  bool _isSaving = false;

  static final _dateFormat = DateFormat('dd/MM/yyyy', 'fr_FR');

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final l = widget.loan!;
      _nameController.text = l.name;
      _bankController.text = l.bankName ?? '';
      _amountController.text = l.amount.toStringAsFixed(0);
      _rateController.text = l.interestRate.toString();
      _durationController.text = l.durationMonths.toString();
      _startDate = l.startDate;
      _deferralController.text = l.deferralMonths.toString();
      _deferralType = l.deferralType;
      _monthlyPaymentController.text = l.monthlyPayment.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bankController.dispose();
    _amountController.dispose();
    _rateController.dispose();
    _durationController.dispose();
    _deferralController.dispose();
    _monthlyPaymentController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final now = DateTime.now();
      final deferralMonths =
          int.tryParse(_deferralController.text.trim()) ?? 0;

      final loan = LoanEntity(
        id: widget.loan?.id ?? '',
        propertyId: widget.propertyId,
        name: _nameController.text.trim(),
        bankName: _bankController.text.trim().isNotEmpty
            ? _bankController.text.trim()
            : null,
        amount: double.tryParse(_amountController.text.trim()) ?? 0,
        interestRate: double.tryParse(_rateController.text.trim()) ?? 0,
        durationMonths:
            int.tryParse(_durationController.text.trim()) ?? 0,
        startDate: _startDate,
        deferralMonths: deferralMonths,
        deferralType: deferralMonths > 0 ? _deferralType : null,
        monthlyPayment:
            double.tryParse(_monthlyPaymentController.text.trim()) ?? 0,
        createdAt: widget.loan?.createdAt ?? now,
        updatedAt: now,
      );

      final actions = ref.read(loanActionsProvider);
      if (_isEditing) {
        await actions.update(loan);
      } else {
        await actions.create(loan);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Emprunt modifié avec succès'
                  : 'Emprunt ajouté avec succès',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifier l\'emprunt' : 'Nouvel emprunt'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionCard(
              title: 'Informations générales',
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: 'Nom de l\'emprunt',
                  hint: 'Ex : Prêt principal',
                  validator: _required,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _bankController,
                  label: 'Banque (optionnel)',
                  hint: 'Ex : Crédit Agricole',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              title: 'Conditions',
              children: [
                _buildTextField(
                  controller: _amountController,
                  label: 'Montant emprunté (€)',
                  hint: 'Ex : 200000',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: _required,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[\d.]')),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _rateController,
                  label: 'Taux d\'intérêt annuel (%)',
                  hint: 'Ex : 3.5',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: _required,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[\d.]')),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _durationController,
                  label: 'Durée (mois)',
                  hint: 'Ex : 240 (20 ans)',
                  keyboardType: TextInputType.number,
                  validator: _required,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const SizedBox(height: 16),
                // Date de debut
                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Date de début',
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.border),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      suffixIcon:
                          const Icon(Icons.calendar_today, size: 18),
                    ),
                    child: Text(
                      _dateFormat.format(_startDate),
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              title: 'Différé',
              children: [
                _buildTextField(
                  controller: _deferralController,
                  label: 'Durée du différé (mois)',
                  hint: '0',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<LoanDeferralType>(
                  value: _deferralType,
                  decoration: InputDecoration(
                    labelText: 'Type de différé',
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AppColors.border),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: null,
                      child: Text('Aucun'),
                    ),
                    DropdownMenuItem(
                      value: LoanDeferralType.total,
                      child: Text('Total'),
                    ),
                    DropdownMenuItem(
                      value: LoanDeferralType.partial,
                      child: Text('Partiel'),
                    ),
                  ],
                  onChanged: (v) => setState(() => _deferralType = v),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              title: 'Remboursement',
              children: [
                _buildTextField(
                  controller: _monthlyPaymentController,
                  label: 'Mensualité (€)',
                  hint: 'Ex : 950.00',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: _required,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[\d.]')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : Text(
                        _isEditing
                            ? 'Enregistrer les modifications'
                            : 'Ajouter l\'emprunt',
                        style: AppTextStyles.button
                            .copyWith(color: AppColors.white),
                      ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String? _required(String? v) {
    if (v == null || v.trim().isEmpty) return 'Ce champ est requis';
    return null;
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
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
            Text(title, style: AppTextStyles.h4),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: AppColors.background,
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
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
    );
  }
}
