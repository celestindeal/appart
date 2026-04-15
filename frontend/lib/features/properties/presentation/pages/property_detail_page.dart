import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:immo_manager/config/theme/app_colors.dart';
import 'package:immo_manager/config/theme/app_text_styles.dart';
import 'package:immo_manager/config/routes/app_routes.dart';
import '../../../renovation/domain/entities/renovation_project_entity.dart';
import '../../../renovation/presentation/providers/renovation_provider.dart';
import '../../../loans/domain/entities/loan_entity.dart';
import '../../../loans/presentation/pages/loan_form_page.dart';
import '../../../loans/presentation/providers/loan_provider.dart';
import '../../../tenants/domain/entities/tenant_entity.dart';
import '../../../tenants/presentation/providers/tenant_provider.dart';
import '../../../documents/data/datasources/document_remote_datasource.dart';
import '../../../documents/domain/entities/document_entity.dart';
import '../../../documents/presentation/widgets/documents_section.dart';
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
    // Locataires du compte — sert à dériver le loyer effectif (actuel ou dernier
    // connu) pour les métriques, l'onglet finances et le cash-flow.
    final tenants = ref.watch(tenantsListProvider).maybeWhen(
          data: (list) => list,
          orElse: () => const <TenantEntity>[],
        );

    final totalRent = _resolveTotalRent(property, tenants);
    final grossYield = _resolveGrossYield(property, tenants);

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
                  onPressed: () => context.goNamed(
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
                      totalRent != null
                          ? '${_currencyFormat.format(totalRent)}/m'
                          : 'N/A',
                      Icons.payments_outlined,
                      AppColors.secondary,
                    ),
                    const SizedBox(width: 8),
                    _buildMetricCard(
                      'Rendement',
                      grossYield != null
                          ? '${grossYield.toStringAsFixed(1)}%'
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
              _buildFinancesTab(context, ref, property, tenants),
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
                onPressed: () => context.goNamed(
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
        onTap: () => context.goNamed(
          RouteNames.propertyDetail,
          pathParameters: {'id': apartment.id},
        ),
      ),
    );
  }

  /// Onglet finances avec valeurs agrégées pour les immeubles.
  /// Le loyer affiché est celui du locataire actuel, ou à défaut du dernier
  /// locataire connu (résolu via la liste réelle des locataires).
  Widget _buildFinancesTab(
    BuildContext context,
    WidgetRef ref,
    PropertyEntity property,
    List<TenantEntity> tenants,
  ) {
    final loansAsync = ref.watch(loansForPropertyProvider(property.id));
    final loans = loansAsync.maybeWhen(
      data: (list) => list,
      orElse: () => const <LoanEntity>[],
    );

    final totalRent = _resolveTotalRent(property, tenants);
    final totalLoanPayment = loans
        .where((l) => l.isActive)
        .fold(0.0, (sum, l) => sum + l.monthlyPayment);
    final cashFlow = _calculateMonthlyCashFlow(
      property,
      totalRent,
      totalLoanPayment,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Bilan mensuel ──
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
                  property.isBuilding
                      ? 'Loyer total (${property.apartments.length} appts)'
                      : 'Loyer mensuel',
                  totalRent,
                  isIncome: true,
                ),
                if (property.isBuilding &&
                    property.apartments.isNotEmpty) ...[
                  ...property.apartments.map((apt) => Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: _buildFinanceRow(
                          '  ${apt.name}',
                          _resolveRent(apt.id, tenants),
                          isIncome: true,
                        ),
                      )),
                ],
                const Divider(),
                _buildFinanceRow(
                  'Taxe foncière (mensuel)',
                  property.propertyTax != null
                      ? property.propertyTax! / 12
                      : null,
                ),
                _buildFinanceRow(
                  'Assurance (mensuel)',
                  property.insurance != null
                      ? property.insurance! / 12
                      : null,
                ),
                _buildFinanceRow('Charges', property.charges),
                if (totalLoanPayment > 0)
                  _buildFinanceRow(
                    'Mensualité emprunt',
                    totalLoanPayment,
                  ),
                const Divider(),
                _buildFinanceRow(
                  'Cash-flow mensuel',
                  cashFlow,
                  isBold: true,
                  isIncome: (cashFlow ?? 0) >= 0,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── Emprunts ──
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Emprunts', style: AppTextStyles.h4),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline,
                          color: AppColors.primary),
                      tooltip: 'Ajouter un emprunt',
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => LoanFormPage(
                            propertyId: property.id,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (loansAsync.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (loans.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Aucun emprunt enregistré',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textTertiary),
                    ),
                  )
                else
                  ...loans.map((loan) => _buildLoanCard(
                        context,
                        ref,
                        property,
                        loan,
                      )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── Acquisition ──
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

  Widget _buildLoanCard(
    BuildContext context,
    WidgetRef ref,
    PropertyEntity property,
    LoanEntity loan,
  ) {
    final durationYears = loan.durationMonths ~/ 12;
    final durationRemainderMonths = loan.durationMonths % 12;
    final durationLabel = durationRemainderMonths > 0
        ? '${durationYears}a ${durationRemainderMonths}m'
        : '${durationYears} ans';

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loan.name,
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (loan.bankName != null && loan.bankName!.isNotEmpty)
                      Text(
                        loan.bankName!,
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.textSecondary),
                      ),
                  ],
                ),
              ),
              if (loan.isActive)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    loan.isInDeferralPeriod ? 'Différé' : 'En cours',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.success),
                  ),
                )
              else
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.textTertiary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Terminé',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textTertiary),
                  ),
                ),
              PopupMenuButton<String>(
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Modifier')),
                  PopupMenuItem(value: 'delete', child: Text('Supprimer')),
                ],
                onSelected: (action) {
                  if (action == 'edit') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LoanFormPage(
                          propertyId: property.id,
                          loan: loan,
                        ),
                      ),
                    );
                  } else if (action == 'delete') {
                    _showDeleteLoanDialog(context, ref, loan);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildLoanMetric(
                  'Montant', _currencyFormat.format(loan.amount)),
              _buildLoanMetric('Taux', '${loan.interestRate}%'),
              _buildLoanMetric('Durée', durationLabel),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _buildLoanMetric(
                'Mensualité',
                _currencyFormat.format(loan.monthlyPayment),
              ),
              if (loan.deferralMonths > 0)
                _buildLoanMetric(
                  'Différé',
                  '${loan.deferralMonths} mois (${loan.deferralType?.label ?? ""})',
                ),
              _buildLoanMetric(
                'Restant',
                '${loan.remainingMonths} mois',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoanMetric(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.textTertiary, fontSize: 11)),
          Text(value, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  void _showDeleteLoanDialog(
    BuildContext context,
    WidgetRef ref,
    LoanEntity loan,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer l\'emprunt'),
        content: Text(
          'Supprimer "${loan.name}" ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await ref.read(loanActionsProvider).delete(
                      loanId: loan.id,
                      propertyId: loan.propertyId,
                    );
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur : $e')),
                  );
                }
              }
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  /// Types de documents pertinents pour un bien immobilier.
  static const _propertyDocTypes = [
    DocumentType.deedOfSale,
    DocumentType.architecturalPlan,
    DocumentType.propertySurvey,
    DocumentType.lease,
    DocumentType.receipt,
    DocumentType.other,
  ];

  Widget _buildDocumentsTab() {
    return DocumentsSection(
      owner: DocumentOwner.property,
      ownerId: propertyId,
      availableTypes: _propertyDocTypes,
    );
  }

  /// Onglet chronologie : agrège les locataires et travaux rattachés au bien.
  /// Chaque entrée est cliquable et redirige vers la fiche correspondante.
  /// La création se fait depuis les sections dédiées (Locataires / Travaux).
  Widget _buildEventsTab(
    BuildContext context,
    WidgetRef ref,
    PropertyEntity property,
  ) {
    final tenantsAsync = ref.watch(tenantsListProvider);
    final renovationsAsync = ref.watch(renovationProjectsProvider);

    // Construit la liste unifiée en filtrant sur propertyId (et ses appartements).
    final propertyIds = <String>{
      property.id,
      ...property.apartments.map((a) => a.id),
    };

    final tenants = tenantsAsync.maybeWhen(
      data: (list) => list.where((t) => propertyIds.contains(t.propertyId)).toList(),
      orElse: () => const <TenantEntity>[],
    );
    final renovations = renovationsAsync.maybeWhen(
      data: (list) => list.where((r) => propertyIds.contains(r.propertyId)).toList(),
      orElse: () => const <RenovationProjectEntity>[],
    );

    final items = <_TimelineItem>[
      ...tenants.map(_TimelineItem.fromTenant),
      ...renovations.map(_TimelineItem.fromRenovation),
    ]..sort((a, b) => b.startDate.compareTo(a.startDate));

    // État de chargement global si l'un des deux est encore en fetch initial.
    final isLoading =
        tenantsAsync.isLoading || renovationsAsync.isLoading;

    if (isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timeline, size: 64, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text(
              'Aucun événement',
              style: AppTextStyles.h4.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Les locataires et les travaux rattachés à ce bien '
                'apparaîtront ici. Créez-les depuis leurs sections respectives.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildTimelineCard(context, items[index]),
    );
  }

  /// Carte représentant un locataire ou un projet de travaux dans la timeline.
  Widget _buildTimelineCard(BuildContext context, _TimelineItem item) {
    final dateRange = item.endDate != null
        ? '${_dateFormat.format(item.startDate)} → ${_dateFormat.format(item.endDate!)}'
        : 'Depuis le ${_dateFormat.format(item.startDate)}';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openTimelineItem(context, item),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: item.color.withValues(alpha: 0.15),
                child: Icon(item.icon, color: item.color, size: 20),
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
                            item.title,
                            style: AppTextStyles.labelLarge,
                          ),
                        ),
                        if (item.isActive)
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
                      item.categoryLabel,
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
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 6),
                      Text(item.subtitle!, style: AppTextStyles.bodySmall),
                    ],
                    if (item.amountText != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        item.amountText!,
                        style: AppTextStyles.labelMedium
                            .copyWith(color: item.color),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Navigue vers la fiche détail correspondante (locataire ou travaux).
  void _openTimelineItem(BuildContext context, _TimelineItem item) {
    switch (item.kind) {
      case _TimelineKind.tenant:
        context.goNamed(
          RouteNames.tenantDetail,
          pathParameters: {'id': item.id},
        );
      case _TimelineKind.renovation:
        context.goNamed(
          RouteNames.renovationDetail,
          pathParameters: {'id': item.id},
        );
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

  /// Calcule le cash-flow mensuel net à partir du loyer effectif fourni
  /// (résolu en amont depuis les locataires actuels ou le dernier connu).
  double? _calculateMonthlyCashFlow(
    PropertyEntity property,
    double? rent,
    double loanPayment,
  ) {
    if (rent == null) return null;
    final tax = (property.propertyTax ?? 0) / 12;
    final insurance = (property.insurance ?? 0) / 12;
    final charges = property.charges ?? 0;
    return rent - tax - insurance - charges - loanPayment;
  }

  /// Résout le loyer d'un bien (par son id) à partir de la liste des locataires.
  /// Privilégie un locataire actif (Active ou LatePayment), sinon retombe sur
  /// le locataire le plus récent par date d'entrée. Renvoie null si aucun
  /// locataire n'a jamais été enregistré pour ce bien.
  static double? _resolveRent(String propertyId, List<TenantEntity> tenants) {
    final forProperty =
        tenants.where((t) => t.propertyId == propertyId).toList();
    if (forProperty.isEmpty) return null;

    final active = forProperty
        .where((t) =>
            t.status == TenantStatus.active ||
            t.status == TenantStatus.latePayment)
        .toList();
    if (active.isNotEmpty) {
      active.sort((a, b) => b.moveInDate.compareTo(a.moveInDate));
      return active.first.monthlyRent;
    }

    forProperty.sort((a, b) => b.moveInDate.compareTo(a.moveInDate));
    return forProperty.first.monthlyRent;
  }

  /// Loyer total effectif : somme des loyers résolus des appartements pour un
  /// immeuble, ou loyer résolu du bien lui-même sinon.
  static double? _resolveTotalRent(
    PropertyEntity property,
    List<TenantEntity> tenants,
  ) {
    if (property.isBuilding && property.apartments.isNotEmpty) {
      double sum = 0;
      var any = false;
      for (final apt in property.apartments) {
        final r = _resolveRent(apt.id, tenants);
        if (r != null) {
          sum += r;
          any = true;
        }
      }
      return any ? sum : null;
    }
    return _resolveRent(property.id, tenants);
  }

  /// Rendement brut effectif basé sur le loyer résolu via les locataires.
  static double? _resolveGrossYield(
    PropertyEntity property,
    List<TenantEntity> tenants,
  ) {
    final rent = _resolveTotalRent(property, tenants);
    if (rent == null || property.acquisitionPrice <= 0) return null;
    return (rent * 12) / property.acquisitionPrice * 100;
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
            onPressed: () async {
              Navigator.of(ctx).pop();
              final messenger = ScaffoldMessenger.of(context);
              try {
                await ref
                    .read(propertyRepositoryProvider)
                    .deleteProperty(property.id);
                ref.invalidate(propertiesListProvider);
                ref.invalidate(propertyDetailProvider(property.id));
                if (property.parentPropertyId != null) {
                  ref.invalidate(
                    propertyDetailProvider(property.parentPropertyId!),
                  );
                }
                if (context.mounted) context.pop();
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(content: Text('Erreur lors de la suppression : $e')),
                );
              }
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

/// Nature d'une entrée de la chronologie d'un bien.
enum _TimelineKind { tenant, renovation }

/// Représentation unifiée d'un locataire ou d'un projet de travaux
/// pour l'affichage dans la chronologie d'un bien.
class _TimelineItem {
  const _TimelineItem({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.categoryLabel,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.icon,
    required this.color,
    required this.amountText,
  });

  final String id;
  final _TimelineKind kind;
  final String title;
  final String? subtitle;
  final String categoryLabel;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final IconData icon;
  final Color color;
  final String? amountText;

  static final _currencyFormat = NumberFormat.currency(
    locale: 'fr_FR',
    symbol: '€',
    decimalDigits: 0,
  );

  /// Construit une entrée depuis un locataire.
  factory _TimelineItem.fromTenant(TenantEntity tenant) {
    return _TimelineItem(
      id: tenant.id,
      kind: _TimelineKind.tenant,
      title: '${tenant.firstName} ${tenant.lastName}',
      subtitle: tenant.email.isNotEmpty ? tenant.email : null,
      categoryLabel: 'Locataire',
      startDate: tenant.moveInDate,
      endDate: tenant.moveOutDate,
      isActive: tenant.status == TenantStatus.active ||
          tenant.status == TenantStatus.latePayment,
      icon: Icons.person_outline,
      color: AppColors.primary,
      amountText: '${_currencyFormat.format(tenant.monthlyRent)}/mois',
    );
  }

  /// Construit une entrée depuis un projet de travaux.
  factory _TimelineItem.fromRenovation(RenovationProjectEntity project) {
    final active = project.status == RenovationStatus.inProgress ||
        project.status == RenovationStatus.planning;
    return _TimelineItem(
      id: project.id,
      kind: _TimelineKind.renovation,
      title: project.projectName,
      subtitle: project.description,
      categoryLabel: 'Travaux',
      startDate: project.startDate,
      endDate: project.actualEndDate ?? project.expectedEndDate,
      isActive: active,
      icon: Icons.construction_outlined,
      color: AppColors.warning,
      amountText: _currencyFormat.format(project.totalBudget),
    );
  }
}
