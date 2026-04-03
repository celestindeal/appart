import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:immo_manager/config/theme/app_colors.dart';
import 'package:immo_manager/config/theme/app_text_styles.dart';
import 'package:immo_manager/config/routes/app_routes.dart';
import '../../domain/entities/property_entity.dart';
import '../providers/property_provider.dart';
import '../widgets/property_card.dart';

/// Page listant tous les biens immobiliers avec recherche et filtres.
class PropertiesListPage extends ConsumerWidget {
  const PropertiesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(propertySearchProvider);
    final propertiesAsync = ref.watch(propertiesListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mes Biens'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ref.read(propertySearchProvider.notifier).updateQuery(
                    searchState.query.isEmpty ? ' ' : '',
                  );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          if (searchState.query.isNotEmpty || searchState.hasActiveFilters)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher un bien...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () {
                      ref.read(propertySearchProvider.notifier).clearAll();
                    },
                  ),
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
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) {
                  ref.read(propertySearchProvider.notifier).updateQuery(value);
                },
              ),
            ),

          // Filtres par type
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _FilterChip(
                    label: 'Tous',
                    isSelected: searchState.propertyType == null,
                    onSelected: () {
                      ref
                          .read(propertySearchProvider.notifier)
                          .updatePropertyType(null);
                    },
                  ),
                  const SizedBox(width: 8),
                  ...PropertyType.values
                      .where((t) => const [
                            PropertyType.apartment,
                            PropertyType.house,
                            PropertyType.commercial,
                            PropertyType.land,
                          ].contains(t))
                      .map(
                        (type) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _FilterChip(
                            label: type.label,
                            isSelected: searchState.propertyType == type,
                            onSelected: () {
                              ref
                                  .read(propertySearchProvider.notifier)
                                  .updatePropertyType(type);
                            },
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),

          // Liste des biens
          Expanded(
            child: propertiesAsync.when(
              data: (properties) {
                if (properties.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_work_outlined,
                          size: 64,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun bien trouvé',
                          style: AppTextStyles.h4.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ajoutez votre premier bien immobilier',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: properties.length,
                  itemBuilder: (context, index) {
                    final property = properties[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: PropertyCard(
                        property: property,
                        onTap: () {
                          context.pushNamed(
                            RouteNames.propertyDetail,
                            pathParameters: {'id': property.id},
                          );
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Erreur lors du chargement',
                      style: AppTextStyles.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => ref.invalidate(propertiesListProvider),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(RouteNames.propertyCreate),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected ? AppColors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
