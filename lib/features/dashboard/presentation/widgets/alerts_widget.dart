import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../providers/dashboard_provider.dart';

/// Widget affichant les alertes et rappels du tableau de bord.
class AlertsWidget extends ConsumerWidget {
  const AlertsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsAsync = ref.watch(dashboardAlertsProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                const Icon(
                  Icons.notification_important_outlined,
                  size: 20,
                  color: AppColors.warning,
                ),
                const SizedBox(width: 8),
                Text('Alertes', style: AppTextStyles.h4),
                const Spacer(),
                alertsAsync.whenOrNull(
                      data: (alerts) => alerts.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.warningLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${alerts.length}',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.accentDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : null,
                    ) ??
                    const SizedBox.shrink(),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          alertsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Erreur de chargement',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
            data: (alerts) {
              if (alerts.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          size: 40,
                          color: AppColors.success,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Aucune alerte en cours',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: alerts.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: AppColors.borderLight),
                itemBuilder: (context, index) {
                  final alert = alerts[index];
                  return _AlertTile(alert: alert);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final DashboardAlert alert;

  const _AlertTile({required this.alert});

  @override
  Widget build(BuildContext context) {
    final isOverdue = alert.dueDate.isBefore(DateTime.now());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isOverdue ? AppColors.error : _alertColor)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _alertIcon,
              size: 18,
              color: isOverdue ? AppColors.error : _alertColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isOverdue ? AppColors.error : AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  alert.description,
                  style: AppTextStyles.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isOverdue ? AppColors.errorLight : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _formatDueDate(alert.dueDate),
              style: AppTextStyles.caption.copyWith(
                color: isOverdue ? AppColors.error : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData get _alertIcon {
    switch (alert.type) {
      case DashboardAlertType.rentDue:
        return Icons.payments_outlined;
      case DashboardAlertType.leaseExpiry:
        return Icons.event_outlined;
      case DashboardAlertType.maintenance:
        return Icons.build_outlined;
      case DashboardAlertType.payment:
        return Icons.account_balance_wallet_outlined;
      case DashboardAlertType.other:
        return Icons.info_outline;
    }
  }

  Color get _alertColor {
    switch (alert.type) {
      case DashboardAlertType.rentDue:
        return AppColors.warning;
      case DashboardAlertType.leaseExpiry:
        return AppColors.info;
      case DashboardAlertType.maintenance:
        return AppColors.accent;
      case DashboardAlertType.payment:
        return AppColors.success;
      case DashboardAlertType.other:
        return AppColors.textSecondary;
    }
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;

    if (diff < -1) return 'Il y a ${-diff} j';
    if (diff == -1) return 'Hier';
    if (diff == 0) return "Aujourd'hui";
    if (diff == 1) return 'Demain';
    if (diff < 7) return 'Dans $diff j';
    return DateFormat('dd/MM').format(date);
  }
}
