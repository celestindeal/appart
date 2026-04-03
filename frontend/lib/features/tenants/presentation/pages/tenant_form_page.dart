import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:immo_manager/config/theme/app_colors.dart';
import 'package:immo_manager/config/theme/app_text_styles.dart';
import '../providers/tenant_provider.dart';

/// Formulaire de creation ou modification d'un locataire.
class TenantFormPage extends ConsumerStatefulWidget {
  const TenantFormPage({
    super.key,
    this.tenantId,
  });

  final String? tenantId;

  @override
  ConsumerState<TenantFormPage> createState() => _TenantFormPageState();
}

class _TenantFormPageState extends ConsumerState<TenantFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _identityTypeController = TextEditingController();
  final _identityNumberController = TextEditingController();
  final _monthlyRentController = TextEditingController();
  final _depositController = TextEditingController();

  DateTime? _moveInDate;
  DateTime? _moveOutDate;

  bool get _isEditing => widget.tenantId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadTenantData();
    }
  }

  Future<void> _loadTenantData() async {
    // TODO: Charger les donnees du locataire pour l'edition
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _identityTypeController.dispose();
    _identityNumberController.dispose();
    _monthlyRentController.dispose();
    _depositController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isMoveIn) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isMoveIn) {
          _moveInDate = picked;
        } else {
          _moveOutDate = picked;
        }
      });
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      // TODO: Sauvegarder le locataire
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Modifier le Locataire' : 'Nouveau Locataire',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Section Identite ──────────────────────────────
            _SectionHeader(title: 'Identite'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _firstNameController,
              decoration: _inputDecoration('Prenom'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Le prenom est requis' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lastNameController,
              decoration: _inputDecoration('Nom'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Le nom est requis' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              decoration: _inputDecoration('Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  v == null || v.isEmpty ? 'L\'email est requis' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              decoration: _inputDecoration('Telephone'),
              keyboardType: TextInputType.phone,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Le telephone est requis' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _identityTypeController,
              decoration: _inputDecoration('Type de piece d\'identite'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _identityNumberController,
              decoration: _inputDecoration('Numero de piece d\'identite'),
            ),

            const SizedBox(height: 24),

            // ── Section Bail ──────────────────────────────────
            _SectionHeader(title: 'Bail'),
            const SizedBox(height: 12),
            // Placeholder pour le dropdown de bien
            DropdownButtonFormField<String>(
              decoration: _inputDecoration('Bien'),
              items: const [
                // TODO: Charger la liste des biens
              ],
              onChanged: (value) {
                // TODO: Selectionner le bien
              },
              validator: (v) =>
                  v == null || v.isEmpty ? 'Le bien est requis' : null,
            ),
            const SizedBox(height: 12),
            // Date d'entree
            InkWell(
              onTap: () => _selectDate(context, true),
              child: InputDecorator(
                decoration: _inputDecoration('Date d\'entree'),
                child: Text(
                  _moveInDate != null
                      ? dateFormat.format(_moveInDate!)
                      : 'Selectionner une date',
                  style: _moveInDate != null
                      ? AppTextStyles.bodyMedium
                      : AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textTertiary,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Date de sortie
            InkWell(
              onTap: () => _selectDate(context, false),
              child: InputDecorator(
                decoration: _inputDecoration('Date de sortie (optionnelle)'),
                child: Text(
                  _moveOutDate != null
                      ? dateFormat.format(_moveOutDate!)
                      : 'Selectionner une date',
                  style: _moveOutDate != null
                      ? AppTextStyles.bodyMedium
                      : AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textTertiary,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _monthlyRentController,
              decoration: _inputDecoration('Loyer mensuel (\u20ac)'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Le loyer est requis' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _depositController,
              decoration: _inputDecoration('Depot de garantie (\u20ac)'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => v == null || v.isEmpty
                  ? 'Le depot de garantie est requis'
                  : null,
            ),
            const SizedBox(height: 32),

            // Bouton de sauvegarde
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _isEditing ? 'Mettre a jour' : 'Enregistrer',
                  style: AppTextStyles.button.copyWith(color: AppColors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.h4);
  }
}
