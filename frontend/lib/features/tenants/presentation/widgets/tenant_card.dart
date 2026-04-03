import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:immo_manager/config/theme/app_colors.dart';
import 'package:immo_manager/config/theme/app_text_styles.dart';
import '../../domain/entities/tenant_entity.dart';

/// Carte affichant les informations resumees d'un locataire.
class TenantCard extends StatelessWidget {
  const TenantCard({
    super.key,
    required this.tenant,
    this.onTap,
  });

  final TenantEntity tenant;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'fr_FR', symbol: '\u20ac');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar avec initiales
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primarySurface,
                child: Text(
                  tenant.initials,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Informations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tenant.fullName,
                      style: AppTextStyles.labelLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tenant.propertyName,
                      style: AppTextStyles.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currencyFormat.format(tenant.monthlyRent),
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Statut et indicateur de paiement
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _StatusBadge(status: tenant.status),
                  const SizedBox(height: 8),
                  Icon(
                    tenant.status == TenantStatus.latePayment
                        ? Icons.warning_rounded
                        : Icons.check_circle_rounded,
                    size: 20,
                    color: tenant.status == TenantStatus.latePayment
                        ? AppColors.error
                        : AppColors.success,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final TenantStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.label,
        style: AppTextStyles.labelSmall.copyWith(
          color: _textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color get _backgroundColor {
    switch (status) {
      case TenantStatus.active:
        return AppColors.successLight;
      case TenantStatus.latePayment:
        return AppColors.errorLight;
      case TenantStatus.leaving:
        return AppColors.warningLight;
      case TenantStatus.inactive:
        return AppColors.surfaceVariant;
    }
  }

  Color get _textColor {
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
