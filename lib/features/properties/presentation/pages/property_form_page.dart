import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:immo_manager/config/theme/app_colors.dart';
import 'package:immo_manager/config/theme/app_text_styles.dart';
import 'package:immo_manager/core/utils/validators.dart';
import '../../domain/entities/property_entity.dart';
import '../providers/property_provider.dart';

/// Formulaire de création/modification d'un bien immobilier.
class PropertyFormPage extends ConsumerStatefulWidget {
  const PropertyFormPage({super.key, this.propertyId});

  final String? propertyId;

  @override
  ConsumerState<PropertyFormPage> createState() => _PropertyFormPageState();
}

class _PropertyFormPageState extends ConsumerState<PropertyFormPage> {
  final _formKey = GlobalKey<FormState>();

  bool get _isEditing => widget.propertyId != null;

  // Informations générales
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  PropertyType _selectedType = PropertyType.apartment;

  // Localisation
  final _addressController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController(text: 'France');

  // Caractéristiques
  final _surfaceController = TextEditingController();
  final _roomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _parkingController = TextEditingController();

  // Finances
  final _priceController = TextEditingController();
  final _rentController = TextEditingController();
  final _taxController = TextEditingController();
  final _insuranceController = TextEditingController();
  final _chargesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadPropertyData();
    }
  }

  void _loadPropertyData() {
    final propertyAsync = ref.read(propertyDetailProvider(widget.propertyId!));
    propertyAsync.whenData((property) {
      _nameController.text = property.name;
      _descriptionController.text = property.description ?? '';
      _selectedType = property.propertyType;
      _addressController.text = property.address;
      _postalCodeController.text = property.postalCode;
      _cityController.text = property.city;
      _countryController.text = property.country;
      _surfaceController.text = property.surface.toStringAsFixed(0);
      _roomsController.text = property.roomCount?.toString() ?? '';
      _bathroomsController.text = property.bathroomCount?.toString() ?? '';
      _parkingController.text = property.parkingSpaces?.toString() ?? '';
      _priceController.text = property.acquisitionPrice.toStringAsFixed(0);
      _rentController.text = property.monthlyRent?.toStringAsFixed(0) ?? '';
      _taxController.text = property.propertyTax?.toStringAsFixed(0) ?? '';
      _insuranceController.text = property.insurance?.toStringAsFixed(0) ?? '';
      _chargesController.text = property.charges?.toStringAsFixed(0) ?? '';
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _surfaceController.dispose();
    _roomsController.dispose();
    _bathroomsController.dispose();
    _parkingController.dispose();
    _priceController.dispose();
    _rentController.dispose();
    _taxController.dispose();
    _insuranceController.dispose();
    _chargesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifier le Bien' : 'Nouveau Bien'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Section Informations générales
            _buildSectionCard(
              title: 'Informations générales',
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: 'Nom du bien',
                  hint: 'Ex: Appartement centre-ville',
                  validator: (v) =>
                      Validators.validateRequired(v, fieldName: 'Le nom'),
                ),
                const SizedBox(height: 16),
                _buildDropdownField(),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  hint: 'Description du bien...',
                  maxLines: 3,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Section Localisation
            _buildSectionCard(
              title: 'Localisation',
              children: [
                _buildTextField(
                  controller: _addressController,
                  label: 'Adresse',
                  hint: 'Ex: 12 rue de la Paix',
                  validator: (v) =>
                      Validators.validateRequired(v, fieldName: 'L\'adresse'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildTextField(
                        controller: _postalCodeController,
                        label: 'Code postal',
                        hint: '75001',
                        keyboardType: TextInputType.number,
                        validator: Validators.validatePostalCode,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: _buildTextField(
                        controller: _cityController,
                        label: 'Ville',
                        hint: 'Paris',
                        validator: (v) =>
                            Validators.validateRequired(v, fieldName: 'La ville'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _countryController,
                  label: 'Pays',
                  hint: 'France',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Section Caractéristiques
            _buildSectionCard(
              title: 'Caractéristiques',
              children: [
                _buildTextField(
                  controller: _surfaceController,
                  label: 'Surface (m²)',
                  hint: 'Ex: 65',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) =>
                      Validators.validateRequired(v, fieldName: 'La surface'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _roomsController,
                        label: 'Chambres',
                        hint: '0',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _bathroomsController,
                        label: 'Salles de bain',
                        hint: '0',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _parkingController,
                        label: 'Parking',
                        hint: '0',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Section Finances
            _buildSectionCard(
              title: 'Finances',
              children: [
                _buildTextField(
                  controller: _priceController,
                  label: 'Prix d\'acquisition (€)',
                  hint: 'Ex: 250000',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: Validators.validatePrice,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _rentController,
                  label: 'Loyer mensuel (€)',
                  hint: 'Ex: 850',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _taxController,
                        label: 'Taxe foncière (€/an)',
                        hint: '0',
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _insuranceController,
                        label: 'Assurance (€/an)',
                        hint: '0',
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _chargesController,
                  label: 'Charges mensuelles (€)',
                  hint: '0',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Bouton de sauvegarde
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _isEditing ? 'Enregistrer les modifications' : 'Créer le bien',
                  style: AppTextStyles.button.copyWith(color: AppColors.white),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
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
    int maxLines = 1,
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
      maxLines: maxLines,
      validator: validator,
      inputFormatters: inputFormatters,
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<PropertyType>(
      value: _selectedType,
      decoration: InputDecoration(
        labelText: 'Type de bien',
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
      items: PropertyType.values
          .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type.label),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedType = value);
        }
      },
    );
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    // La sauvegarde réelle serait effectuée via le repository/provider.
    // Pour l'instant, on navigue simplement en arrière.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing
              ? 'Bien modifié avec succès'
              : 'Bien créé avec succès',
        ),
        backgroundColor: AppColors.success,
      ),
    );
    context.pop();
  }
}
