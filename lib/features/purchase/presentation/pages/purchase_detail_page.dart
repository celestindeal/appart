import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:immo_manager/config/theme/app_colors.dart';
import 'package:immo_manager/config/theme/app_text_styles.dart';
import '../../domain/entities/purchase_project_entity.dart';
import '../../domain/entities/purchase_milestone_entity.dart';
import '../providers/purchase_provider.dart';

/// Page de détail d'un projet d'achat immobilier.
class PurchaseDetailPage extends ConsumerWidget {
  const PurchaseDetailPage({super.key, required this.projectId});

  final String projectId;

  static final _currencyFormat = NumberFormat.currency(
    locale: 'fr_FR',
    symbol: '€',
    decimalDigits: 0,
  );

  static final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(purchaseDetailProvider);

    // Charger les données si nécessaire
    if (state is PurchaseDetailInitial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(purchaseDetailProvider.notifier).loadProject(projectId);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          state is PurchaseDetailLoaded
              ? state.project.propertyName
              : 'Projet d\'achat',
        ),
      ),
      body: _buildBody(context, ref, state),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    PurchaseDetailState state,
  ) {
    if (state is PurchaseDetailLoading || state is PurchaseDetailInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is PurchaseDetailError) {
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
                  ref.read(purchaseDetailProvider.notifier).loadProject(projectId),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    final project = (state as PurchaseDetailLoaded).project;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec statut
          _buildStatusHeader(project),
          const SizedBox(height: 16),

          // Résumé financier
          _buildFinancialSummary(project),
          const SizedBox(height: 16),

          // Jalons
          _buildMilestonesSection(project),
          const SizedBox(height: 16),

          // Notes
          _buildNotesSection(),
        ],
      ),
    );
  }

  Widget _buildStatusHeader(PurchaseProjectEntity project) {
    final color = _statusColor(project.status);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.home_work, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.propertyName, style: AppTextStyles.h4),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      project.status.label,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${project.progressPercent.toStringAsFixed(0)}%',
                  style: AppTextStyles.h3.copyWith(color: color),
                ),
                Text('avancement', style: AppTextStyles.caption),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialSummary(PurchaseProjectEntity project) {
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
            Text('Résumé financier', style: AppTextStyles.h4),
            const SizedBox(height: 16),
            _buildFinanceRow(
              'Prix cible',
              project.targetPrice != null
                  ? _currencyFormat.format(project.targetPrice)
                  : 'N/A',
            ),
            _buildFinanceRow(
              'Prix final',
              project.finalPrice != null
                  ? _currencyFormat.format(project.finalPrice)
                  : 'N/A',
            ),
            const Divider(),
            _buildFinanceRow(
              'Apport',
              project.downPayment != null
                  ? _currencyFormat.format(project.downPayment)
                  : 'N/A',
            ),
            _buildFinanceRow(
              'Montant prêt',
              project.loanAmount != null
                  ? _currencyFormat.format(project.loanAmount)
                  : 'N/A',
            ),
            _buildFinanceRow(
              'Taux',
              project.interestRate != null
                  ? '${project.interestRate!.toStringAsFixed(2)}%'
                  : 'N/A',
            ),
            _buildFinanceRow(
              'Durée',
              project.loanTermMonths != null
                  ? '${(project.loanTermMonths! / 12).toStringAsFixed(0)} ans'
                  : 'N/A',
            ),
            const Divider(),
            _buildFinanceRow(
              'Frais de notaire',
              project.notaryFees != null
                  ? _currencyFormat.format(project.notaryFees)
                  : 'N/A',
            ),
            _buildFinanceRow(
              'Frais d\'agence',
              project.agencyFees != null
                  ? _currencyFormat.format(project.agencyFees)
                  : 'N/A',
            ),
            _buildFinanceRow(
              'Autres frais',
              project.otherCosts != null
                  ? _currencyFormat.format(project.otherCosts)
                  : 'N/A',
            ),
            const Divider(),
            _buildFinanceRow(
              'Coût total',
              _currencyFormat.format(project.totalCost),
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold
                ? AppTextStyles.labelLarge
                : AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
          ),
          Text(
            value,
            style: isBold
                ? AppTextStyles.labelLarge.copyWith(color: AppColors.primary)
                : AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildMilestonesSection(PurchaseProjectEntity project) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Jalons', style: AppTextStyles.h4),
                Text(
                  '${project.completedMilestones}/${project.milestones.length}',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (project.milestones.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.flag_outlined,
                        size: 40,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Aucun jalon défini',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...project.milestones.asMap().entries.map(
                    (entry) => _buildMilestoneItem(
                      entry.value,
                      isLast: entry.key == project.milestones.length - 1,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestoneItem(
    PurchaseMilestoneEntity milestone, {
    bool isLast = false,
  }) {
    final color = milestone.isCompleted
        ? AppColors.success
        : milestone.isOverdue
            ? AppColors.error
            : AppColors.textTertiary;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ligne verticale + icône
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: milestone.isCompleted
                        ? AppColors.success
                        : AppColors.surface,
                    border: Border.all(color: color, width: 2),
                    shape: BoxShape.circle,
                  ),
                  child: milestone.isCompleted
                      ? const Icon(
                          Icons.check,
                          size: 14,
                          color: AppColors.white,
                        )
                      : null,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: AppColors.border,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Contenu
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    milestone.title,
                    style: AppTextStyles.labelLarge.copyWith(
                      decoration: milestone.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (milestone.plannedDate != null)
                    Row(
                      children: [
                        Icon(
                          Icons.event_outlined,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Prévu : ${_dateFormat.format(milestone.plannedDate!)}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  if (milestone.actualDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 14,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Réalisé : ${_dateFormat.format(milestone.actualDate!)}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
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
            Text('Notes', style: AppTextStyles.h4),
            const SizedBox(height: 12),
            Text(
              'Aucune note pour ce projet.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
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
