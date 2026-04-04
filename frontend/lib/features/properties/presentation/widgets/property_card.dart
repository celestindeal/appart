import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:immo_manager/config/theme/app_colors.dart';
import 'package:immo_manager/config/theme/app_text_styles.dart';
import '../../domain/entities/property_entity.dart';

/// Carte affichant un resume d'un bien immobilier dans la liste.
class PropertyCard extends StatelessWidget {
  const PropertyCard({
    super.key,
    required this.property,
    this.onTap,
    this.isGridView = false,
  });

  final PropertyEntity property;
  final VoidCallback? onTap;
  final bool isGridView;

  static final _currencyFormat = NumberFormat.currency(
    locale: 'fr_FR',
    symbol: '\u20ac',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: isGridView ? _buildGridLayout() : _buildListLayout(),
      ),
    );
  }

  Widget _buildImagePlaceholder({double height = 140}) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: AppColors.surfaceVariant,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _iconForType(property.propertyType),
              size: 40,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 4),
            Text(
              property.propertyType.label,
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYieldBadge() {
    final yield_ = property.grossYield;
    if (yield_ == null) return const SizedBox.shrink();

    final color = yield_ >= 7
        ? AppColors.success
        : yield_ >= 4
            ? AppColors.warning
            : AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '${yield_.toStringAsFixed(1)}%',
        style: AppTextStyles.labelMedium.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color bgColor;
    Color textColor;
    switch (property.status) {
      case PropertyStatus.prospect:
        bgColor = AppColors.infoLight;
        textColor = AppColors.info;
      case PropertyStatus.owned:
        bgColor = AppColors.successLight;
        textColor = AppColors.success;
      case PropertyStatus.sold:
        bgColor = AppColors.surfaceVariant;
        textColor = AppColors.textTertiary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        property.status.label,
        style: AppTextStyles.labelSmall.copyWith(color: textColor),
      ),
    );
  }

  Widget _buildGridLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            _buildImagePlaceholder(height: 120),
            Positioned(
              top: 8,
              right: 8,
              child: _buildYieldBadge(),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: _buildStatusChip(),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                property.name,
                style: AppTextStyles.labelLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      property.city,
                      style: AppTextStyles.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _currencyFormat.format(property.acquisitionPrice),
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildInfoChip(
                    Icons.square_foot,
                    '${property.surface.toStringAsFixed(0)} m\u00b2',
                  ),
                  if (property.monthlyRent != null) ...[
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      Icons.payments_outlined,
                      '${_currencyFormat.format(property.monthlyRent)}/m',
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListLayout() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 100,
              height: 80,
              child: _buildImagePlaceholder(height: 80),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        property.name,
                        style: AppTextStyles.labelLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildStatusChip(),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        '${property.city} ${property.postalCode}',
                        style: AppTextStyles.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      _currencyFormat.format(property.acquisitionPrice),
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    _buildInfoChip(
                      Icons.square_foot,
                      '${property.surface.toStringAsFixed(0)} m\u00b2',
                    ),
                    if (property.monthlyRent != null) ...[
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        Icons.payments_outlined,
                        '${_currencyFormat.format(property.monthlyRent)}/m',
                      ),
                    ],
                    if (property.grossYield != null) ...[
                      const SizedBox(width: 8),
                      _buildYieldBadge(),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 2),
        Text(text, style: AppTextStyles.caption),
      ],
    );
  }

  /// Renvoie l'icône correspondant au type de bien.
  IconData _iconForType(PropertyType type) {
    return switch (type) {
      PropertyType.apartment => Icons.apartment,
      PropertyType.building => Icons.business,
      PropertyType.other => Icons.home_work,
    };
  }
}
