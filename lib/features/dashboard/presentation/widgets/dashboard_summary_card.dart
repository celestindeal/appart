import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';

/// Carte de résumé pour le tableau de bord (version enrichie).
/// Affiche un titre, une valeur, une icone et un indicateur de tendance optionnel.
class DashboardSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? trend;
  final bool? trendPositive;
  final VoidCallback? onTap;

  const DashboardSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color = AppColors.primary,
    this.trend,
    this.trendPositive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
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
            // Icone
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 22, color: color),
            ),

            const SizedBox(height: 16),

            // Valeur
            Text(
              value,
              style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Titre
            Text(
              title,
              style: AppTextStyles.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Tendance (optionnel)
            if (trend != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    trendPositive == true
                        ? Icons.trending_up_rounded
                        : Icons.trending_down_rounded,
                    size: 16,
                    color: trendPositive == true
                        ? AppColors.success
                        : AppColors.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    trend!,
                    style: AppTextStyles.caption.copyWith(
                      color: trendPositive == true
                          ? AppColors.success
                          : AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
