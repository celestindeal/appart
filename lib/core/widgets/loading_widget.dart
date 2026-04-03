import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';

/// Indicateur de chargement réutilisable.
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    this.message = 'Chargement...',
    this.size = 40.0,
    this.color,
    super.key,
  });

  final String message;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: color ?? AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}
