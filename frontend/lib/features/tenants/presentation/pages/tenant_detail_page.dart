import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:immo_manager/config/routes/app_routes.dart';
import 'package:immo_manager/config/theme/app_colors.dart';
import 'package:immo_manager/config/theme/app_text_styles.dart';
import '../../domain/entities/tenant_entity.dart';
import '../../domain/entities/rent_payment_entity.dart';
import '../../domain/entities/reminder_entity.dart';
import '../../../documents/data/datasources/document_remote_datasource.dart';
import '../../../documents/domain/entities/document_entity.dart';
import '../../../documents/presentation/widgets/documents_section.dart';
import '../providers/payment_provider.dart';
import '../providers/tenant_provider.dart';
import '../widgets/payment_form_dialog.dart';
import '../widgets/payment_status_badge.dart';

/// Page de detail d'un locataire avec onglets.
class TenantDetailPage extends ConsumerWidget {
  const TenantDetailPage({
    super.key,
    required this.tenantId,
  });

  final String tenantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tenantAsync = ref.watch(tenantDetailProvider(tenantId));

    return tenantAsync.when(
      data: (tenant) => _TenantDetailContent(tenant: tenant),
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Locataire')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Locataire')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text('Erreur de chargement', style: AppTextStyles.h4),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () =>
                    ref.invalidate(tenantDetailProvider(tenantId)),
                child: const Text('Reessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TenantDetailContent extends StatelessWidget {
  const _TenantDetailContent({required this.tenant});

  final TenantEntity tenant;

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'fr_FR', symbol: '\u20ac');

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(tenant.fullName),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.goNamed(
                  RouteNames.tenantEdit,
                  pathParameters: {'id': tenant.id},
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // En-tete avec informations principales
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: AppColors.surface,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primarySurface,
                    child: Text(
                      tenant.initials,
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(tenant.fullName, style: AppTextStyles.h3),
                  const SizedBox(height: 4),
                  Text(tenant.propertyName, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 12),
                  // Boutons de contact
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ContactButton(
                        icon: Icons.email_outlined,
                        label: tenant.email,
                        onTap: () {
                          // TODO: Ouvrir email
                        },
                      ),
                      const SizedBox(width: 16),
                      _ContactButton(
                        icon: Icons.phone_outlined,
                        label: tenant.phoneNumber,
                        onTap: () {
                          // TODO: Ouvrir telephone
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Resume financier
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _SummaryItem(
                        label: 'Loyer',
                        value: currencyFormat.format(tenant.monthlyRent),
                        color: AppColors.primary,
                      ),
                      _SummaryItem(
                        label: 'Depot',
                        value: currencyFormat.format(tenant.depositAmount),
                        color: AppColors.secondary,
                      ),
                      _SummaryItem(
                        label: 'Statut',
                        value: tenant.status.label,
                        color: _statusColor(tenant.status),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Onglets
            const TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(text: 'Informations'),
                Tab(text: 'Paiements'),
                Tab(text: 'Documents'),
                Tab(text: 'Rappels'),
              ],
            ),
            // Contenu des onglets
            Expanded(
              child: TabBarView(
                children: [
                  _InformationsTab(tenant: tenant),
                  _PaiementsTab(tenant: tenant),
                  _DocumentsTab(tenant: tenant),
                  _RappelsTab(tenant: tenant),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(TenantStatus status) {
    switch (status) {
      case TenantStatus.active:
        return AppColors.success;
      case TenantStatus.latePayment:
        return AppColors.error;
      case TenantStatus.leaving:
        return AppColors.warning;
      case TenantStatus.inactive:
        return AppColors.disabled;
    }
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(color: color),
        ),
      ],
    );
  }
}

// ── Onglet Informations ────────────────────────────────────

class _InformationsTab extends StatelessWidget {
  const _InformationsTab({required this.tenant});

  final TenantEntity tenant;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SectionCard(
          title: 'Informations personnelles',
          children: [
            _InfoRow(label: 'Prenom', value: tenant.firstName),
            _InfoRow(label: 'Nom', value: tenant.lastName),
            _InfoRow(label: 'Email', value: tenant.email),
            _InfoRow(label: 'Telephone', value: tenant.phoneNumber),
            _InfoRow(
                label: 'Type de piece d\'identite',
                value: tenant.identityDocumentType),
            _InfoRow(
                label: 'Numero de piece', value: tenant.identityDocumentNumber),
          ],
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: 'Bail',
          children: [
            _InfoRow(label: 'Bien', value: tenant.propertyName),
            _InfoRow(
              label: 'Date d\'entree',
              value: dateFormat.format(tenant.moveInDate),
            ),
            if (tenant.moveOutDate != null)
              _InfoRow(
                label: 'Date de sortie',
                value: dateFormat.format(tenant.moveOutDate!),
              ),
            _InfoRow(
              label: 'Loyer mensuel',
              value: NumberFormat.currency(locale: 'fr_FR', symbol: '\u20ac')
                  .format(tenant.monthlyRent),
            ),
            _InfoRow(
              label: 'Depot de garantie',
              value: NumberFormat.currency(locale: 'fr_FR', symbol: '\u20ac')
                  .format(tenant.depositAmount),
            ),
            if (tenant.depositReturnedDate != null)
              _InfoRow(
                label: 'Depot restitue le',
                value: dateFormat.format(tenant.depositReturnedDate!),
              ),
          ],
        ),
      ],
    );
  }
}

// ── Onglet Paiements ────────────────────────────────────────

class _PaiementsTab extends ConsumerWidget {
  const _PaiementsTab({required this.tenant});

  final TenantEntity tenant;

  Future<void> _openAddDialog(BuildContext context) async {
    await PaymentFormDialog.show(
      context,
      tenantId: tenant.id,
      propertyId: tenant.propertyId,
      defaultAmount: tenant.monthlyRent,
    );
  }

  Future<void> _openEditDialog(
    BuildContext context,
    RentPaymentEntity payment,
  ) async {
    await PaymentFormDialog.show(
      context,
      tenantId: tenant.id,
      propertyId: tenant.propertyId,
      payment: payment,
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    RentPaymentEntity payment,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer le paiement'),
        content: const Text('Cette action est irréversible. Continuer ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(paymentActionsProvider).delete(
            paymentId: payment.id,
            tenantId: tenant.id,
          );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(paymentsForTenantProvider(tenant.id));
    final dateFormat = DateFormat('dd/MM/yyyy');
    final currencyFormat =
        NumberFormat.currency(locale: 'fr_FR', symbol: '\u20ac');

    return Stack(
      children: [
        paymentsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text('Erreur de chargement',
                      style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => ref
                        .invalidate(paymentsForTenantProvider(tenant.id)),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          ),
          data: (payments) {
            if (payments.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.payment_outlined,
                        size: 48, color: AppColors.disabled),
                    const SizedBox(height: 16),
                    Text(
                      'Aucun paiement enregistré',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Appuyez sur + pour en ajouter un',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: payments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final payment = payments[index];
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: ListTile(
                    onTap: () => _openEditDialog(context, payment),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            currencyFormat.format(payment.amount),
                            style: AppTextStyles.labelLarge.copyWith(
                              color: payment.isPaid
                                  ? AppColors.success
                                  : payment.isLate
                                      ? AppColors.error
                                      : AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        PaymentStatusBadge(status: payment.status),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Échéance : ${dateFormat.format(payment.paymentDueDate)}',
                            style: AppTextStyles.bodySmall,
                          ),
                          if (payment.paymentDate != null)
                            Text(
                              'Payé le : ${dateFormat.format(payment.paymentDate!)}',
                              style: AppTextStyles.bodySmall,
                            ),
                          if (payment.paymentMethod != null)
                            Text(
                              'Méthode : ${payment.paymentMethod!.label}',
                              style: AppTextStyles.bodySmall,
                            ),
                          if (payment.notes != null &&
                              payment.notes!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                payment.notes!,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: AppColors.error),
                      onPressed: () =>
                          _confirmDelete(context, ref, payment),
                    ),
                  ),
                );
              },
            );
          },
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.small(
            onPressed: () => _openAddDialog(context),
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add, color: AppColors.white),
          ),
        ),
      ],
    );
  }
}

// ── Onglet Documents ────────────────────────────────────────

class _DocumentsTab extends StatelessWidget {
  const _DocumentsTab({required this.tenant});

  final TenantEntity tenant;

  /// Types de documents pertinents pour un locataire.
  static const _tenantDocTypes = [
    DocumentType.lease,
    DocumentType.identity,
    DocumentType.incomeProof,
    DocumentType.propertySurvey,
    DocumentType.receipt,
    DocumentType.other,
  ];

  @override
  Widget build(BuildContext context) {
    return DocumentsSection(
      owner: DocumentOwner.tenant,
      ownerId: tenant.id,
      availableTypes: _tenantDocTypes,
    );
  }
}

// ── Onglet Rappels ──────────────────────────────────────────

class _RappelsTab extends StatelessWidget {
  const _RappelsTab({required this.tenant});

  final TenantEntity tenant;

  @override
  Widget build(BuildContext context) {
    // TODO: Charger les rappels depuis le provider
    final List<ReminderEntity> reminders = [];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Ajouter un rappel
            },
            icon: const Icon(Icons.add_alarm),
            label: const Text('Ajouter un rappel'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        if (reminders.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none,
                      size: 48, color: AppColors.disabled),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun rappel',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                final dateFormat = DateFormat('dd/MM/yyyy');

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: reminder.isOverdue
                          ? AppColors.error
                          : AppColors.border,
                    ),
                  ),
                  child: CheckboxListTile(
                    value: reminder.isCompleted,
                    onChanged: (value) {
                      // TODO: Marquer comme complete
                    },
                    title: Text(
                      reminder.title,
                      style: AppTextStyles.labelLarge.copyWith(
                        decoration: reminder.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(reminder.description,
                            style: AppTextStyles.bodySmall),
                        const SizedBox(height: 4),
                        Text(
                          dateFormat.format(reminder.reminderDate),
                          style: AppTextStyles.caption.copyWith(
                            color: reminder.isOverdue
                                ? AppColors.error
                                : AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    secondary: Icon(
                      reminder.isOverdue
                          ? Icons.warning_rounded
                          : Icons.notifications_active_outlined,
                      color: reminder.isOverdue
                          ? AppColors.error
                          : AppColors.primary,
                    ),
                    activeColor: AppColors.primary,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

// ── Widgets utilitaires ─────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(label, style: AppTextStyles.bodySmall),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }
}
