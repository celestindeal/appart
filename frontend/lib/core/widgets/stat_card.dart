import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';

/// Carte de statistique pour le tableau de bord.
/// Affiche une icône, un libellé, une valeur et une tendance optionnelle.
class StatCard extends StatelessWidget {
  const StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.trend,
    this.trendPositive,
    this.iconColor,
    this.iconBackgroundColor,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;

  /// Texte de la tendance, par ex. « +12 % ».
  final String? trend;

  /// `true` = tendance positive (vert), `false` = négative (rouge).
  final bool? trendPositive;

  final Color? iconColor;
  final Color? iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? AppColors.primary;
    final effectiveBgColor = iconBackgroundColor ?? AppColors.primarySurface;

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
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: effectiveBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: effectiveIconColor),
                ),
                const Spacer(),
                if (trend != null) _TrendBadge(trend: trend!, positive: trendPositive),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendBadge extends StatelessWidget {
  const _TrendBadge({required this.trend, this.positive});

  final String trend;
  final bool? positive;

  @override
  Widget build(BuildContext context) {
    final isPositive = positive ?? true;
    final color = isPositive ? AppColors.success : AppColors.error;
    final bgColor = isPositive ? AppColors.successLight : AppColors.errorLight;
    final icon = isPositive ? Icons.trending_up : Icons.trending_down;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            trend,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
