import 'package:flutter/material.dart';

import 'package:immo_manager/config/theme/app_colors.dart';
import 'package:immo_manager/config/theme/app_text_styles.dart';
import '../../domain/entities/rent_payment_entity.dart';

/// Badge affichant le statut d'un paiement avec une couleur associee.
class PaymentStatusBadge extends StatelessWidget {
  const PaymentStatusBadge({
    super.key,
    required this.status,
  });

  final PaymentStatus status;

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
      case PaymentStatus.paid:
        return AppColors.successLight;
      case PaymentStatus.pending:
        return AppColors.warningLight;
      case PaymentStatus.late_:
        return AppColors.errorLight;
      case PaymentStatus.cancelled:
        return AppColors.surfaceVariant;
    }
  }

  Color get _textColor {
    switch (status) {
      case PaymentStatus.paid:
        return AppColors.success;
      case PaymentStatus.pending:
        return AppColors.warning;
      case PaymentStatus.late_:
        return AppColors.error;
      case PaymentStatus.cancelled:
        return AppColors.disabled;
    }
  }
}
