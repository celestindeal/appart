import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:immo_manager/config/theme/app_colors.dart';
import 'package:immo_manager/config/theme/app_text_styles.dart';
import '../../../properties/domain/entities/property_entity.dart';
import '../../../properties/presentation/providers/property_provider.dart';
import '../../domain/entities/tenant_entity.dart';
import '../providers/tenant_provider.dart';

/// Formulaire de création ou modification d'un locataire.
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
  static final _dateFormat = DateFormat('dd/MM/yyyy', 'fr_FR');

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _identityTypeController = TextEditingController();
  final _identityNumberController = TextEditingController();
  final _monthlyRentController = TextEditingController();
  final _depositController = TextEditingController();

  String? _selectedPropertyId;
  DateTime? _moveInDate;
  DateTime? _moveOutDate;
  TenantStatus _status = TenantStatus.active;
  bool _isSaving = false;
  bool _isLoadingInitial = false;
  String? _loadError;

  bool get _isEditing => widget.tenantId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _isLoadingInitial = true;
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _loadTenantData());
    }
  }

  Future<void> _loadTenantData() async {
    try {
      final tenant =
          await ref.read(tenantDetailProvider(widget.tenantId!).future);
      if (!mounted) return;
      _firstNameController.text = tenant.firstName;
      _lastNameController.text = tenant.lastName;
      _emailController.text = tenant.email;
      _phoneController.text = tenant.phoneNumber;
      _identityTypeController.text = tenant.identityDocumentType;
      _identityNumberController.text = tenant.identityDocumentNumber;
      _monthlyRentController.text = tenant.monthlyRent.toStringAsFixed(0);
      _depositController.text = tenant.depositAmount.toStringAsFixed(0);
      _selectedPropertyId = tenant.propertyId;
      _moveInDate = tenant.moveInDate;
      _moveOutDate = tenant.moveOutDate;
      _status = tenant.status;
    } catch (e) {
      if (!mounted) return;
      _loadError = e.toString();
    } finally {
      if (mounted) setState(() => _isLoadingInitial = false);
    }
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
    final initial = isMoveIn
        ? (_moveInDate ?? DateTime.now())
        : (_moveOutDate ?? _moveInDate ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('fr', 'FR'),
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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPropertyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner un bien'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_moveInDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner la date d\'entrée'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final now = DateTime.now();
      final tenant = TenantEntity(
        id: widget.tenantId ?? '',
        propertyId: _selectedPropertyId!,
        propertyName: '',
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        identityDocumentType: _identityTypeController.text.trim(),
        identityDocumentNumber: _identityNumberController.text.trim(),
        moveInDate: _moveInDate!,
        moveOutDate: _moveOutDate,
        monthlyRent:
            double.tryParse(_monthlyRentController.text.trim()) ?? 0,
        depositAmount: double.tryParse(_depositController.text.trim()) ?? 0,
        status: _status,
        createdAt: now,
        updatedAt: now,
      );

      final repository = ref.read(tenantRepositoryProvider);
      if (_isEditing) {
        await repository.updateTenant(tenant);
      } else {
        await repository.createTenant(tenant);
      }

      // Rafraîchit la liste et le détail du bien associé (pour l'onglet Événements).
      ref.invalidate(tenantsListProvider);
      ref.invalidate(propertiesListProvider);
      ref.invalidate(propertyDetailProvider(_selectedPropertyId!));
      if (_isEditing) {
        ref.invalidate(tenantDetailProvider(widget.tenantId!));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Locataire modifié avec succès'
                  : 'Locataire créé avec succès',
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
        title: Text(
          _isEditing ? 'Modifier le Locataire' : 'Nouveau Locataire',
        ),
      ),
      body: _isLoadingInitial
          ? const Center(child: CircularProgressIndicator())
          : _loadError != null
              ? _buildLoadError()
              : _buildForm(),
    );
  }

  Widget _buildLoadError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline,
              size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          Text('Impossible de charger le locataire',
              style: AppTextStyles.h4),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              _loadError ?? '',
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
              _loadTenantData();
            },
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Section Identité ──────────────────────────────
          const _SectionHeader(title: 'Identité'),
          const SizedBox(height: 12),
          TextFormField(
            controller: _firstNameController,
            decoration: _inputDecoration('Prénom'),
            validator: (v) =>
                v == null || v.isEmpty ? 'Le prénom est requis' : null,
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
            decoration: _inputDecoration('Email (optionnel)'),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneController,
            decoration: _inputDecoration('Téléphone (optionnel)'),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _identityTypeController,
            decoration:
                _inputDecoration('Type de pièce d\'identité (optionnel)'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _identityNumberController,
            decoration:
                _inputDecoration('Numéro de pièce d\'identité (optionnel)'),
          ),

          const SizedBox(height: 24),

          // ── Section Bail ──────────────────────────────────
          const _SectionHeader(title: 'Bail'),
          const SizedBox(height: 12),
          _buildPropertyPicker(),
          const SizedBox(height: 12),
          // Date d'entrée
          InkWell(
            onTap: () => _selectDate(context, true),
            child: InputDecorator(
              decoration: _inputDecoration('Date d\'entrée'),
              child: Text(
                _moveInDate != null
                    ? _dateFormat.format(_moveInDate!)
                    : 'Sélectionner une date',
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
              decoration: _inputDecoration(
                'Date de sortie (optionnelle)',
              ).copyWith(
                suffixIcon: _moveOutDate != null
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => setState(() => _moveOutDate = null),
                      )
                    : null,
              ),
              child: Text(
                _moveOutDate != null
                    ? _dateFormat.format(_moveOutDate!)
                    : 'Aucune',
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
            decoration: _inputDecoration('Loyer mensuel (€)'),
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Le loyer est requis';
              if (double.tryParse(v.trim()) == null) {
                return 'Nombre invalide';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _depositController,
            decoration: _inputDecoration('Dépôt de garantie (€)'),
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return null;
              if (double.tryParse(v.trim()) == null) {
                return 'Nombre invalide';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<TenantStatus>(
            initialValue: _status,
            decoration: _inputDecoration('Statut'),
            items: TenantStatus.values
                .map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(s.label),
                    ))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _status = v);
            },
          ),
          const SizedBox(height: 32),

          // Bouton de sauvegarde
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : Text(
                      _isEditing ? 'Mettre à jour' : 'Enregistrer',
                      style: AppTextStyles.button
                          .copyWith(color: AppColors.white),
                    ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Dropdown des biens disponibles. Inclut les appartements enfants
  /// et exclut les immeubles (on loue un appart, pas un immeuble entier).
  Widget _buildPropertyPicker() {
    final propertiesAsync = ref.watch(propertiesListProvider);

    return propertiesAsync.when(
      data: (properties) {
        // Aplatis : garde les biens simples (apartment/other) + les apparts enfants des immeubles.
        final locatable = <PropertyEntity>[];
        for (final p in properties) {
          if (p.propertyType == PropertyType.building) {
            locatable.addAll(p.apartments);
          } else {
            locatable.add(p);
          }
        }

        if (locatable.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warningLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.warning),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_outlined,
                    color: AppColors.warning, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Aucun bien disponible. Créez d\'abord un bien '
                    'dans la section Biens.',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.warning),
                  ),
                ),
              ],
            ),
          );
        }

        // Si l'ID sélectionné n'est pas dans la liste, on le remet à null.
        final validSelection = locatable.any((p) => p.id == _selectedPropertyId)
            ? _selectedPropertyId
            : null;

        return DropdownButtonFormField<String>(
          initialValue: validSelection,
          decoration: _inputDecoration('Bien'),
          isExpanded: true,
          items: locatable
              .map(
                (p) => DropdownMenuItem(
                  value: p.id,
                  child: Text(
                    '${p.name} · ${p.city}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => _selectedPropertyId = value),
          validator: (v) =>
              v == null || v.isEmpty ? 'Le bien est requis' : null,
        );
      },
      loading: () => InputDecorator(
        decoration: _inputDecoration('Bien'),
        child: Row(
          children: [
            const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text('Chargement des biens…', style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
      error: (error, _) => InputDecorator(
        decoration: _inputDecoration('Bien').copyWith(
          errorText: 'Impossible de charger les biens',
        ),
        child: TextButton(
          onPressed: () => ref.invalidate(propertiesListProvider),
          child: const Text('Réessayer'),
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
