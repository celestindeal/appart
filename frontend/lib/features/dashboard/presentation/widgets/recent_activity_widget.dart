import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../providers/dashboard_provider.dart';

/// Widget affichant la liste des activités récentes.
class RecentActivityWidget extends ConsumerWidget {
  const RecentActivityWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(recentActivitiesProvider);

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
                  Icons.history_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text('Activité récente', style: AppTextStyles.h4),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          activitiesAsync.when(
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
            data: (activities) {
              if (activities.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      'Aucune activité récente',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activities.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: AppColors.borderLight),
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  return _ActivityTile(activity: activity);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final RecentActivity activity;

  const _ActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_icon, size: 18, color: _iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: AppTextStyles.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  activity.description,
                  style: AppTextStyles.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _formatTimestamp(activity.timestamp),
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  IconData get _icon {
    switch (activity.type) {
      case RecentActivityType.rentPayment:
        return Icons.payments_outlined;
      case RecentActivityType.newTenant:
        return Icons.person_add_outlined;
      case RecentActivityType.tenantDeparture:
        return Icons.person_remove_outlined;
      case RecentActivityType.maintenance:
        return Icons.build_outlined;
      case RecentActivityType.documentAdded:
        return Icons.description_outlined;
      case RecentActivityType.propertyAdded:
        return Icons.home_work_outlined;
    }
  }

  Color get _iconColor {
    switch (activity.type) {
      case RecentActivityType.rentPayment:
        return AppColors.success;
      case RecentActivityType.newTenant:
        return AppColors.primary;
      case RecentActivityType.tenantDeparture:
        return AppColors.warning;
      case RecentActivityType.maintenance:
        return AppColors.accent;
      case RecentActivityType.documentAdded:
        return AppColors.info;
      case RecentActivityType.propertyAdded:
        return AppColors.secondary;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 60) {
      return 'Il y a ${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return 'Il y a ${diff.inHours} h';
    } else if (diff.inDays < 7) {
      return 'Il y a ${diff.inDays} j';
    }
    return DateFormat('dd/MM/yyyy').format(timestamp);
  }
}
