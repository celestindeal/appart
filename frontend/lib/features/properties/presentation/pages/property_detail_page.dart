import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:immo_manager/config/theme/app_colors.dart';
import 'package:immo_manager/config/theme/app_text_styles.dart';
import 'package:immo_manager/config/routes/app_routes.dart';
import '../../domain/entities/property_entity.dart';
import '../providers/property_provider.dart';

/// Page de détail d'un bien immobilier.
class PropertyDetailPage extends ConsumerWidget {
  const PropertyDetailPage({super.key, required this.propertyId});

  final String propertyId;

  static final _currencyFormat = NumberFormat.currency(
    locale: 'fr_FR',
    symbol: '€',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertyAsync = ref.watch(propertyDetailProvider(propertyId));

    return propertyAsync.when(
      data: (property) => _buildContent(context, ref, property),
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text('Erreur : $error', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () =>
                    ref.invalidate(propertyDetailProvider(propertyId)),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    PropertyEntity property,
  ) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              title: Text(property.name),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => context.pushNamed(
                    RouteNames.propertyEdit,
                    pathParameters: {'id': property.id},
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _showDeleteDialog(context, ref, property),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: _buildHeroSection(property),
              ),
            ),
            // Métriques
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _buildMetricCard(
                      'Prix',
                      _currencyFormat.format(property.acquisitionPrice),
                      Icons.euro,
                      AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    _buildMetricCard(
                      'Loyer',
                      property.monthlyRent != null
                          ? '${_currencyFormat.format(property.monthlyRent)}/m'
                          : 'N/A',
                      Icons.payments_outlined,
                      AppColors.secondary,
                    ),
                    const SizedBox(width: 8),
                    _buildMetricCard(
                      'Rendement',
                      property.grossYield != null
                          ? '${property.grossYield!.toStringAsFixed(1)}%'
                          : 'N/A',
                      Icons.trending_up,
                      AppColors.accent,
                    ),
                    const SizedBox(width: 8),
                    _buildMetricCard(
                      'Surface',
                      '${property.surface.toStringAsFixed(0)} m²',
                      Icons.square_foot,
                      AppColors.info,
                    ),
                  ],
                ),
              ),
            ),
            // Onglets
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                TabBar(
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorColor: AppColors.primary,
                  labelStyle: AppTextStyles.labelLarge,
                  unselectedLabelStyle: AppTextStyles.labelMedium,
                  tabs: const [
                    Tab(text: 'Détails'),
                    Tab(text: 'Finances'),
                    Tab(text: 'Documents'),
                    Tab(text: 'Historique'),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              _buildDetailsTab(property),
              _buildFinancesTab(property),
              _buildDocumentsTab(),
              _buildHistoryTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(PropertyEntity property) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Icon(
                _iconForType(property.propertyType),
                size: 48,
                color: AppColors.white.withValues(alpha: 0.9),
              ),
              const SizedBox(height: 8),
              Text(
                property.name,
                style: AppTextStyles.h3.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppColors.white.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    property.city,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildStatusBadge(property.status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(PropertyStatus status) {
    Color bgColor;
    Color textColor;
    switch (status) {
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.label,
        style: AppTextStyles.labelMedium.copyWith(color: textColor),
      ),
    );
  }

  Widget _buildMetricCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Column(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: AppTextStyles.labelLarge.copyWith(color: color),
                ),
              ),
              const SizedBox(height: 2),
              Text(label, style: AppTextStyles.caption),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsTab(PropertyEntity property) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionTitle('Informations générales'),
        _buildInfoRow('Type', property.propertyType.label),
        if (property.description != null)
          _buildInfoRow('Description', property.description!),
        _buildInfoRow('Statut', property.status.label),
        const SizedBox(height: 16),
        _buildSectionTitle('Localisation'),
        _buildInfoRow('Adresse', property.address),
        _buildInfoRow('Code postal', property.postalCode),
        _buildInfoRow('Ville', property.city),
        _buildInfoRow('Pays', property.country),
        const SizedBox(height: 16),
        _buildSectionTitle('Caractéristiques'),
        _buildInfoRow('Surface', '${property.surface.toStringAsFixed(0)} m²'),
        if (property.roomCount != null)
          _buildInfoRow('Pièces', '${property.roomCount}'),
        if (property.bathroomCount != null)
          _buildInfoRow('Salles de bain', '${property.bathroomCount}'),
        if (property.parkingSpaces != null)
          _buildInfoRow('Parking', '${property.parkingSpaces} place(s)'),
      ],
    );
  }

  Widget _buildFinancesTab(PropertyEntity property) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
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
                Text('Bilan mensuel', style: AppTextStyles.h4),
                const SizedBox(height: 16),
                _buildFinanceRow(
                  'Loyer mensuel',
                  property.monthlyRent,
                  isIncome: true,
                ),
                const Divider(),
                _buildFinanceRow('Taxe foncière (mensuel)',
                    property.propertyTax != null
                        ? property.propertyTax! / 12
                        : null),
                _buildFinanceRow('Assurance (mensuel)',
                    property.insurance != null
                        ? property.insurance! / 12
                        : null),
                _buildFinanceRow('Charges', property.charges),
                const Divider(),
                _buildFinanceRow(
                  'Cash-flow mensuel',
                  _calculateMonthlyCashFlow(property),
                  isBold: true,
                  isIncome: (_calculateMonthlyCashFlow(property) ?? 0) >= 0,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
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
                Text('Acquisition', style: AppTextStyles.h4),
                const SizedBox(height: 16),
                _buildInfoRow(
                  'Prix d\'acquisition',
                  _currencyFormat.format(property.acquisitionPrice),
                ),
                if (property.currentValue != null)
                  _buildInfoRow(
                    'Valeur actuelle',
                    _currencyFormat.format(property.currentValue),
                  ),
                _buildInfoRow(
                  'Prix au m²',
                  _currencyFormat.format(property.pricePerSqm),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open_outlined,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun document',
            style: AppTextStyles.h4.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Les documents associés à ce bien\napparaîtront ici',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun historique',
            style: AppTextStyles.h4.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'L\'historique des événements de ce bien\napparaîtra ici',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: AppTextStyles.h4),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceRow(
    String label,
    double? amount, {
    bool isIncome = false,
    bool isBold = false,
  }) {
    final displayAmount = amount != null
        ? '${isIncome ? '+' : '-'} ${_currencyFormat.format(amount.abs())}'
        : 'N/A';
    final color = amount == null
        ? AppColors.textTertiary
        : isIncome
            ? AppColors.success
            : AppColors.textPrimary;

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
            displayAmount,
            style: (isBold ? AppTextStyles.labelLarge : AppTextStyles.bodyMedium)
                .copyWith(color: color),
          ),
        ],
      ),
    );
  }

  double? _calculateMonthlyCashFlow(PropertyEntity property) {
    if (property.monthlyRent == null) return null;
    final rent = property.monthlyRent!;
    final tax = (property.propertyTax ?? 0) / 12;
    final insurance = (property.insurance ?? 0) / 12;
    final charges = property.charges ?? 0;
    return rent - tax - insurance - charges;
  }

  void _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    PropertyEntity property,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer le bien'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer "${property.name}" ? '
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Supprimer'),
          ),
        ],
      ),
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

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  const _TabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.surface,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
