import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:immo_manager/config/theme/app_colors.dart';
import 'package:immo_manager/config/theme/app_text_styles.dart';
import 'package:immo_manager/config/routes/app_routes.dart';
import '../../domain/entities/property_entity.dart';
import '../../domain/entities/property_event_entity.dart';
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

  static final _dateFormat = DateFormat('dd/MM/yyyy', 'fr_FR');

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
            // Métriques (agrégées pour les immeubles)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Pour un immeuble : nombre d'apparts, sinon prix.
                    if (property.isBuilding)
                      _buildMetricCard(
                        'Apparts',
                        '${property.apartments.length}',
                        Icons.apartment,
                        AppColors.primary,
                      )
                    else
                      _buildMetricCard(
                        'Prix',
                        _currencyFormat.format(property.acquisitionPrice),
                        Icons.euro,
                        AppColors.primary,
                      ),
                    const SizedBox(width: 8),
                    _buildMetricCard(
                      'Loyer total',
                      property.totalMonthlyRent != null
                          ? '${_currencyFormat.format(property.totalMonthlyRent)}/m'
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
                      '${property.totalSurface.toStringAsFixed(0)} m²',
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
                    Tab(text: 'Événements'),
                    Tab(text: 'Documents'),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              _buildDetailsTab(context, ref, property),
              _buildFinancesTab(property),
              _buildEventsTab(context, ref, property),
              _buildDocumentsTab(),
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

  Widget _buildDetailsTab(BuildContext context, WidgetRef ref, PropertyEntity property) {
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

        // Section appartements pour les immeubles.
        if (property.propertyType == PropertyType.building) ...[
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionTitle('Appartements (${property.apartments.length})'),
              TextButton.icon(
                onPressed: () => context.pushNamed(
                  RouteNames.propertyCreate,
                  queryParameters: {'parentId': property.id},
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Ajouter'),
              ),
            ],
          ),
          if (property.apartments.isEmpty)
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppColors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.apartment, size: 40, color: AppColors.textTertiary),
                      const SizedBox(height: 8),
                      Text(
                        'Aucun appartement',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ajoutez des appartements à cet immeuble',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            ...property.apartments.map((apt) => _buildApartmentCard(context, apt)),
        ],
      ],
    );
  }

  /// Carte représentant un appartement dans un immeuble.
  Widget _buildApartmentCard(BuildContext context, PropertyEntity apartment) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryLight,
          child: Icon(Icons.apartment, color: AppColors.primary, size: 20),
        ),
        title: Text(apartment.name, style: AppTextStyles.labelLarge),
        subtitle: Text(
          '${apartment.surface.toStringAsFixed(0)} m²'
          '${apartment.monthlyRent != null ? ' · ${_currencyFormat.format(apartment.monthlyRent)}/m' : ''}',
          style: AppTextStyles.caption,
        ),
        trailing: Icon(Icons.chevron_right, color: AppColors.textTertiary),
        onTap: () => context.pushNamed(
          RouteNames.propertyDetail,
          pathParameters: {'id': apartment.id},
        ),
      ),
    );
  }

  /// Onglet finances avec valeurs agrégées pour les immeubles.
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
                  property.isBuilding ? 'Loyer total (${property.apartments.length} appts)' : 'Loyer mensuel',
                  property.totalMonthlyRent,
                  isIncome: true,
                ),
                // Détail par appartement pour les immeubles.
                if (property.isBuilding && property.apartments.isNotEmpty) ...[
                  ...property.apartments.map((apt) => Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: _buildFinanceRow(
                      '  ${apt.name}',
                      apt.monthlyRent,
                      isIncome: true,
                    ),
                  )),
                ],
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

  /// Onglet chronologie : affiche les événements du bien triés par date.
  Widget _buildEventsTab(
    BuildContext context,
    WidgetRef ref,
    PropertyEntity property,
  ) {
    final events = [...property.events]
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    return Stack(
      children: [
        if (events.isEmpty)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timeline, size: 64, color: AppColors.textTertiary),
                const SizedBox(height: 16),
                Text(
                  'Aucun événement',
                  style: AppTextStyles.h4
                      .copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ajoutez un locataire, des travaux\nou un autre événement',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: events.length,
            itemBuilder: (context, index) =>
                _buildEventCard(context, ref, property, events[index]),
          ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            heroTag: 'add_event_${property.id}',
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            onPressed: () => _showAddEventDialog(context, ref, property),
            icon: const Icon(Icons.add),
            label: const Text('Événement'),
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(
    BuildContext context,
    WidgetRef ref,
    PropertyEntity property,
    PropertyEventEntity event,
  ) {
    final icon = switch (event.eventType) {
      PropertyEventType.tenant => Icons.person_outline,
      PropertyEventType.renovation => Icons.construction_outlined,
      PropertyEventType.other => Icons.info_outline,
    };
    final color = switch (event.eventType) {
      PropertyEventType.tenant => AppColors.primary,
      PropertyEventType.renovation => AppColors.warning,
      PropertyEventType.other => AppColors.info,
    };

    final dateRange = event.endDate != null
        ? '${_dateFormat.format(event.startDate)} → ${_dateFormat.format(event.endDate!)}'
        : 'Depuis le ${_dateFormat.format(event.startDate)}';

    String? amountText;
    if (event.eventType == PropertyEventType.tenant &&
        event.monthlyRent != null) {
      amountText = '${_currencyFormat.format(event.monthlyRent)}/mois';
    } else if (event.cost != null) {
      amountText = _currencyFormat.format(event.cost);
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color, size: 20),
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
                          event.title,
                          style: AppTextStyles.labelLarge,
                        ),
                      ),
                      if (event.isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Actif',
                            style: AppTextStyles.labelSmall
                                .copyWith(color: AppColors.success),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.eventType.label,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(dateRange, style: AppTextStyles.caption),
                    ],
                  ),
                  if (event.description != null &&
                      event.description!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      event.description!,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                  if (amountText != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      amountText,
                      style: AppTextStyles.labelMedium.copyWith(color: color),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                size: 20,
                color: AppColors.textTertiary,
              ),
              onPressed: () => _confirmDeleteEvent(context, ref, event),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddEventDialog(
    BuildContext context,
    WidgetRef ref,
    PropertyEntity property,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => _AddEventDialog(propertyId: property.id),
    );
  }

  Future<void> _confirmDeleteEvent(
    BuildContext context,
    WidgetRef ref,
    PropertyEventEntity event,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer l\'événement'),
        content: Text('Voulez-vous vraiment supprimer "${event.title}" ?'),
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
      await ref.read(propertyEventActionsProvider).delete(
            eventId: event.id,
            propertyId: event.propertyId,
          );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Événement supprimé'),
            backgroundColor: AppColors.success,
          ),
        );
      }
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

  /// Calcule le cash-flow mensuel net.
  /// Pour un immeuble, utilise le loyer total agrégé depuis les appartements.
  double? _calculateMonthlyCashFlow(PropertyEntity property) {
    final rent = property.totalMonthlyRent;
    if (rent == null) return null;
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

/// Dialogue de saisie d'un nouvel événement (locataire, travaux, autre).
class _AddEventDialog extends ConsumerStatefulWidget {
  const _AddEventDialog({required this.propertyId});

  final String propertyId;

  @override
  ConsumerState<_AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends ConsumerState<_AddEventDialog> {
  static final _dateFormat = DateFormat('dd/MM/yyyy', 'fr_FR');

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rentController = TextEditingController();
  final _depositController = TextEditingController();
  final _costController = TextEditingController();

  PropertyEventType _type = PropertyEventType.tenant;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _rentController.dispose();
    _depositController.dispose();
    _costController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial =
        isStart ? _startDate : (_endDate ?? _startDate);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('fr', 'FR'),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
    });
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSaving) return;

    setState(() => _isSaving = true);
    final now = DateTime.now();
    final event = PropertyEventEntity(
      id: '',
      propertyId: widget.propertyId,
      userId: '',
      eventType: _type,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      startDate: _startDate,
      endDate: _endDate,
      monthlyRent: _type == PropertyEventType.tenant
          ? double.tryParse(_rentController.text.trim())
          : null,
      depositAmount: _type == PropertyEventType.tenant
          ? double.tryParse(_depositController.text.trim())
          : null,
      cost: _type != PropertyEventType.tenant
          ? double.tryParse(_costController.text.trim())
          : null,
      createdAt: now,
      updatedAt: now,
    );

    try {
      await ref.read(propertyEventActionsProvider).create(event);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Événement ajouté'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
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
  Widget build(BuildContext context) {
    final isTenant = _type == PropertyEventType.tenant;

    return AlertDialog(
      title: const Text('Nouvel événement'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<PropertyEventType>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: PropertyEventType.values
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t.label),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _type = v);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Requis' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Description (optionnel)'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () => _pickDate(isStart: true),
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Date de début'),
                  child: Text(_dateFormat.format(_startDate)),
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () => _pickDate(isStart: false),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date de fin (optionnelle)',
                    suffixIcon: _endDate != null
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () => setState(() => _endDate = null),
                          )
                        : null,
                  ),
                  child: Text(
                    _endDate != null
                        ? _dateFormat.format(_endDate!)
                        : 'Aucune',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (isTenant) ...[
                TextFormField(
                  controller: _rentController,
                  decoration:
                      const InputDecoration(labelText: 'Loyer mensuel (€)'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Requis';
                    if (double.tryParse(v.trim()) == null) {
                      return 'Nombre invalide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _depositController,
                  decoration: const InputDecoration(
                    labelText: 'Dépôt de garantie (€)',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ] else ...[
                TextFormField(
                  controller: _costController,
                  decoration: const InputDecoration(labelText: 'Coût (€)'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _onSubmit,
          child: _isSaving
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Ajouter'),
        ),
      ],
    );
  }
}
