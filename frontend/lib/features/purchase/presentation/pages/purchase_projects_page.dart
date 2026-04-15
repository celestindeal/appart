import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:immo_manager/config/theme/app_colors.dart';
import 'package:immo_manager/config/theme/app_text_styles.dart';
import 'package:immo_manager/config/routes/app_routes.dart';
import '../../domain/entities/purchase_project_entity.dart';
import '../providers/purchase_provider.dart';

/// Page listant les projets d'achat immobilier.
class PurchaseProjectsPage extends ConsumerWidget {
  const PurchaseProjectsPage({super.key});

  static final _currencyFormat = NumberFormat.currency(
    locale: 'fr_FR',
    symbol: '€',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(purchaseListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Projets d\'Achat'),
      ),
      body: Column(
        children: [
          // Vue toggle (Liste / Kanban) - pour l'instant seule la liste est active
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _ViewToggleButton(
                  label: 'Liste',
                  icon: Icons.view_list,
                  isSelected: true,
                  onTap: () {},
                ),
                const SizedBox(width: 8),
                _ViewToggleButton(
                  label: 'Kanban',
                  icon: Icons.view_kanban,
                  isSelected: false,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vue Kanban bientôt disponible'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Contenu
          Expanded(
            child: _buildBody(context, ref, state),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Création de projet bientôt disponible'),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, PurchaseListState state) {
    if (state is PurchaseListLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is PurchaseListError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text('Erreur : ${state.message}', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () =>
                  ref.read(purchaseListProvider.notifier).loadProjects(),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (state is PurchaseListLoaded) {
      if (state.projects.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 64,
                color: AppColors.textTertiary,
              ),
              const SizedBox(height: 16),
              Text(
                'Aucun projet d\'achat',
                style: AppTextStyles.h4.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Créez votre premier projet d\'achat',
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
        itemCount: state.projects.length,
        itemBuilder: (context, index) {
          final project = state.projects[index];
          return _buildProjectCard(context, project);
        },
      );
    }

    // Initial state - trigger load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(purchaseListProvider.notifier).loadProjects();
    });

    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildProjectCard(BuildContext context, PurchaseProjectEntity project) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.goNamed(
            RouteNames.purchaseDetail,
            pathParameters: {'id': project.id},
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.propertyName,
                      style: AppTextStyles.labelLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusBadge(project.status),
                ],
              ),
              const SizedBox(height: 8),
              if (project.targetPrice != null)
                Text(
                  'Prix cible : ${_currencyFormat.format(project.targetPrice)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              const SizedBox(height: 12),
              // Barre de progression
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progression',
                        style: AppTextStyles.caption,
                      ),
                      Text(
                        '${project.progressPercent.toStringAsFixed(0)}%',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: project.progressPercent / 100,
                      minHeight: 6,
                      backgroundColor: AppColors.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _statusColor(project.status),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.flag_outlined,
                    size: 14,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${project.completedMilestones}/${project.milestones.length} jalons',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(PurchaseStatus status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.label,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _statusColor(PurchaseStatus status) {
    return switch (status) {
      PurchaseStatus.prospect => AppColors.info,
      PurchaseStatus.negotiation => AppColors.accent,
      PurchaseStatus.offerMade => AppColors.accentDark,
      PurchaseStatus.offerAccepted => AppColors.secondaryLight,
      PurchaseStatus.financing => AppColors.primary,
      PurchaseStatus.notary => AppColors.primaryDark,
      PurchaseStatus.completed => AppColors.success,
      PurchaseStatus.cancelled => AppColors.error,
    };
  }
}

class _ViewToggleButton extends StatelessWidget {
  const _ViewToggleButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? AppColors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
