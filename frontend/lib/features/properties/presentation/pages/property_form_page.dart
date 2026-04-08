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
/// Si [parentPropertyId] est fourni, crée un appartement dans un immeuble.
class PropertyFormPage extends ConsumerStatefulWidget {
  const PropertyFormPage({super.key, this.propertyId, this.parentPropertyId});

  final String? propertyId;

  /// ID de l'immeuble parent (pour créer un appartement dans un immeuble).
  final String? parentPropertyId;

  @override
  ConsumerState<PropertyFormPage> createState() => _PropertyFormPageState();
}

class _PropertyFormPageState extends ConsumerState<PropertyFormPage> {
  final _formKey = GlobalKey<FormState>();

  bool get _isEditing => widget.propertyId != null;
  bool get _isChildApartment => widget.parentPropertyId != null;

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
  final _taxController = TextEditingController();
  final _insuranceController = TextEditingController();
  final _chargesController = TextEditingController();

  bool _isSaving = false;
  bool _isLoadingInitial = false;
  String? _loadError;

  /// Indique si le type sélectionné est un immeuble (pas de surface/loyer propre).
  bool get _isBuilding => _selectedType == PropertyType.building;

  @override
  void initState() {
    super.initState();
    // Un appartement enfant est forcément de type apartment.
    if (_isChildApartment) {
      _selectedType = PropertyType.apartment;
    }
    // Chargement initial (édition et/ou pré-remplissage parent).
    if (_isEditing || _isChildApartment) {
      _isLoadingInitial = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
    }
  }

  /// Charge les données initiales de manière asynchrone :
  /// — en mode édition : les données du bien à modifier
  /// — pour un appartement enfant : l'adresse de l'immeuble parent
  Future<void> _loadInitialData() async {
    try {
      if (_isEditing) {
        final property =
            await ref.read(propertyDetailProvider(widget.propertyId!).future);
        if (!mounted) return;
        _nameController.text = property.name;
        _descriptionController.text = property.description ?? '';
        _selectedType = property.propertyType;
        _addressController.text = property.address;
        _postalCodeController.text = property.postalCode;
        _cityController.text = property.city;
        _countryController.text = property.country;
        _surfaceController.text = property.surface > 0
            ? property.surface.toStringAsFixed(0)
            : '';
        _roomsController.text = property.roomCount?.toString() ?? '';
        _bathroomsController.text = property.bathroomCount?.toString() ?? '';
        _parkingController.text = property.parkingSpaces?.toString() ?? '';
        _priceController.text = property.acquisitionPrice > 0
            ? property.acquisitionPrice.toStringAsFixed(0)
            : '';
        _taxController.text = property.propertyTax?.toStringAsFixed(0) ?? '';
        _insuranceController.text =
            property.insurance?.toStringAsFixed(0) ?? '';
        _chargesController.text = property.charges?.toStringAsFixed(0) ?? '';
      } else if (_isChildApartment) {
        final parent = await ref
            .read(propertyDetailProvider(widget.parentPropertyId!).future);
        if (!mounted) return;
        _addressController.text = parent.address;
        _postalCodeController.text = parent.postalCode;
        _cityController.text = parent.city;
        _countryController.text = parent.country;
      }
    } catch (e) {
      if (!mounted) return;
      _loadError = e.toString();
    } finally {
      if (mounted) setState(() => _isLoadingInitial = false);
    }
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
        title: Text(
          _isEditing
              ? 'Modifier le Bien'
              : _isChildApartment
                  ? 'Nouvel Appartement'
                  : 'Nouveau Bien',
        ),
      ),
      body: _isLoadingInitial
          ? const Center(child: CircularProgressIndicator())
          : _loadError != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: AppColors.error),
                      const SizedBox(height: 16),
                      Text(
                        'Impossible de charger le bien',
                        style: AppTextStyles.h4,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          _loadError!,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.caption,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _loadError = null;
                            _isLoadingInitial = true;
                          });
                          _loadInitialData();
                        },
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // — Section Informations générales —
            _buildSectionCard(
              title: 'Informations générales',
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: _isChildApartment ? 'Nom de l\'appartement' : 'Nom du bien',
                  hint: _isChildApartment ? 'Ex: Appartement 1A' : 'Ex: Appartement centre-ville',
                  validator: (v) =>
                      Validators.validateRequired(v, fieldName: 'Le nom'),
                ),
                const SizedBox(height: 16),
                // Masque le choix du type pour les appartements enfants.
                if (!_isChildApartment) _buildDropdownField(),
                if (!_isChildApartment) const SizedBox(height: 16),
                // Info contextuelle pour les immeubles.
                if (_isBuilding && !_isEditing)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.infoLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, size: 18, color: AppColors.info),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Créez d\'abord l\'immeuble, puis ajoutez les appartements depuis sa fiche.',
                              style: AppTextStyles.caption.copyWith(color: AppColors.info),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  hint: 'Description du bien...',
                  maxLines: 3,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // — Section Localisation —
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(5),
                        ],
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

            // — Section Caractéristiques —
            // Masquée pour les immeubles (car défini par appartement).
            if (!_isBuilding)
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
            if (!_isBuilding) const SizedBox(height: 16),

            // — Section Finances —
            _buildSectionCard(
              title: 'Finances',
              children: [
                // Prix d'acquisition : global à l'immeuble, masqué pour appart enfant.
                if (!_isChildApartment) ...[
                  _buildTextField(
                    controller: _priceController,
                    label: 'Prix d\'acquisition (€)',
                    hint: 'Ex: 250000',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: Validators.validatePrice,
                  ),
                  const SizedBox(height: 16),
                ],
                // Note : le loyer mensuel n'est plus saisi ici.
                // Il est désormais attaché à un événement « Locataire »
                // depuis la chronologie du bien.
                // Taxe, assurance, charges : global à l'immeuble, masqué pour appart enfant.
                if (!_isChildApartment) ...[
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
              ],
            ),
            const SizedBox(height: 24),

            // — Bouton de sauvegarde —
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
                            : _isChildApartment
                                ? 'Ajouter l\'appartement'
                                : 'Créer le bien',
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

  /// Sauvegarde le bien en appelant l'API (création ou modification).
  /// Rafraîchit la liste des biens après succès et revient en arrière.
  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final now = DateTime.now();
      final property = PropertyEntity(
        id: widget.propertyId ?? '',
        userId: '',
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        address: _addressController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        city: _cityController.text.trim(),
        country: _countryController.text.trim(),
        propertyType: _selectedType,
        acquisitionPrice: double.tryParse(_priceController.text.trim()) ?? 0,
        surface: double.tryParse(_surfaceController.text.trim()) ?? 0,
        roomCount: int.tryParse(_roomsController.text.trim()),
        bathroomCount: int.tryParse(_bathroomsController.text.trim()),
        parkingSpaces: int.tryParse(_parkingController.text.trim()),
        propertyTax: double.tryParse(_taxController.text.trim()),
        insurance: double.tryParse(_insuranceController.text.trim()),
        charges: double.tryParse(_chargesController.text.trim()),
        parentPropertyId: widget.parentPropertyId,
        status: PropertyStatus.owned,
        createdAt: now,
        updatedAt: now,
      );

      final repository = ref.read(propertyRepositoryProvider);

      if (_isEditing) {
        await repository.updateProperty(property);
      } else {
        await repository.createProperty(property);
      }

      /// Rafraîchit la liste des biens, le détail du bien édité,
      /// et le détail du parent si c'est un appartement enfant.
      ref.invalidate(propertiesListProvider);
      if (_isEditing) {
        ref.invalidate(propertyDetailProvider(widget.propertyId!));
      }
      if (widget.parentPropertyId != null) {
        ref.invalidate(propertyDetailProvider(widget.parentPropertyId!));
      }

      if (mounted) {
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
