import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:immo_manager/config/theme/app_colors.dart';
import 'package:immo_manager/config/theme/app_text_styles.dart';
import '../../domain/entities/rent_payment_entity.dart';
import '../providers/payment_provider.dart';

/// Dialog d'ajout / edition d'un paiement de loyer.
class PaymentFormDialog extends ConsumerStatefulWidget {
  const PaymentFormDialog({
    super.key,
    required this.tenantId,
    required this.propertyId,
    this.payment,
    this.defaultAmount,
  });

  final String tenantId;
  final String propertyId;
  final RentPaymentEntity? payment;

  /// Montant par defaut (ex : loyer du locataire) pour un nouveau paiement.
  final double? defaultAmount;

  /// Helper pour afficher le dialog.
  static Future<bool?> show(
    BuildContext context, {
    required String tenantId,
    required String propertyId,
    RentPaymentEntity? payment,
    double? defaultAmount,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => PaymentFormDialog(
        tenantId: tenantId,
        propertyId: propertyId,
        payment: payment,
        defaultAmount: defaultAmount,
      ),
    );
  }

  @override
  ConsumerState<PaymentFormDialog> createState() => _PaymentFormDialogState();
}

class _PaymentFormDialogState extends ConsumerState<PaymentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  bool get _isEditing => widget.payment != null;

  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _dueDate = DateTime.now();
  DateTime? _paymentDate;
  PaymentMethod? _paymentMethod;
  PaymentStatus _status = PaymentStatus.pending;
  bool _isSaving = false;

  static final _dateFormat = DateFormat('dd/MM/yyyy', 'fr_FR');

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final p = widget.payment!;
      _amountController.text = p.amount.toStringAsFixed(2);
      _dueDate = p.paymentDueDate;
      _paymentDate = p.paymentDate;
      _paymentMethod = p.paymentMethod;
      _status = p.status;
      _notesController.text = p.notes ?? '';
    } else if (widget.defaultAmount != null) {
      _amountController.text = widget.defaultAmount!.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isDueDate}) async {
    final initial = isDueDate ? _dueDate : (_paymentDate ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      setState(() {
        if (isDueDate) {
          _dueDate = picked;
        } else {
          _paymentDate = picked;
        }
      });
    }
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final payment = RentPaymentEntity(
        id: widget.payment?.id ?? '',
        tenantId: widget.tenantId,
        propertyId: widget.propertyId,
        amount: double.tryParse(_amountController.text.trim()) ?? 0,
        paymentDueDate: _dueDate,
        paymentDate:
            _status == PaymentStatus.paid ? (_paymentDate ?? DateTime.now()) : _paymentDate,
        paymentMethod: _paymentMethod,
        status: _status,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      final actions = ref.read(paymentActionsProvider);
      if (_isEditing) {
        await actions.update(payment);
      } else {
        await actions.create(payment);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Paiement modifié avec succès'
                  : 'Paiement ajouté avec succès',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop(true);
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
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEditing ? 'Modifier le paiement' : 'Nouveau paiement',
                  style: AppTextStyles.h3,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _amountController,
                  label: 'Montant (€)',
                  hint: 'Ex : 850.00',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Ce champ est requis';
                    }
                    final parsed = double.tryParse(v.trim());
                    if (parsed == null || parsed <= 0) {
                      return 'Montant invalide';
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDateField(
                  label: 'Date d\'échéance',
                  value: _dueDate,
                  onTap: () => _pickDate(isDueDate: true),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<PaymentStatus>(
                  value: _status,
                  decoration: _inputDecoration('Statut'),
                  items: PaymentStatus.values
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s.label),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() {
                      _status = v;
                      // Preselect payment date if marking as paid.
                      if (v == PaymentStatus.paid && _paymentDate == null) {
                        _paymentDate = DateTime.now();
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildDateField(
                  label: 'Date de paiement (optionnel)',
                  value: _paymentDate,
                  onTap: () => _pickDate(isDueDate: false),
                  onClear: _paymentDate == null
                      ? null
                      : () => setState(() => _paymentDate = null),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<PaymentMethod?>(
                  value: _paymentMethod,
                  decoration: _inputDecoration('Méthode (optionnel)'),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Aucune'),
                    ),
                    ...PaymentMethod.values.map((m) => DropdownMenuItem(
                          value: m,
                          child: Text(m.label),
                        )),
                  ],
                  onChanged: (v) => setState(() => _paymentMethod = v),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _notesController,
                  label: 'Notes (optionnel)',
                  hint: '',
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.of(context).pop(false),
                      child: const Text('Annuler'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _isSaving ? null : _onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              ),
                            )
                          : Text(_isEditing ? 'Enregistrer' : 'Ajouter'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {String? hint}) {
    return InputDecoration(
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label, hint: hint),
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
    VoidCallback? onClear,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: _inputDecoration(label).copyWith(
          suffixIcon: onClear != null
              ? IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: onClear,
                )
              : const Icon(Icons.calendar_today, size: 18),
        ),
        child: Text(
          value != null ? _dateFormat.format(value) : '—',
          style: AppTextStyles.bodyMedium,
        ),
      ),
    );
  }
}
