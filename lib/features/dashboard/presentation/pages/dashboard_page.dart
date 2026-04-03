import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/alerts_widget.dart';
import '../widgets/recent_activity_widget.dart';

/// Page principale du tableau de bord.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final currencyFormat = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: '\u20AC',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          ref.invalidate(dashboardSummaryProvider);
          ref.invalidate(dashboardAlertsProvider);
          ref.invalidate(recentActivitiesProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── En-tete de bienvenue ──────────────────────
              _WelcomeHeader(userName: user?.firstName ?? 'Utilisateur'),

              const SizedBox(height: 24),

              // ── Cartes de statistiques ────────────────────
              summaryAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'Erreur de chargement des données',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ),
                data: (summary) => LayoutBuilder(
                  builder: (context, constraints) {
                    final isSmallScreen = constraints.maxWidth < 600;
                    final crossAxisCount = isSmallScreen ? 2 : 4;
                    final childAspectRatio = isSmallScreen ? 1.1 : 1.3;

                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: childAspectRatio,
                      children: [
                        StatCard(
                          label: 'Total biens',
                          value: '${summary.totalProperties}',
                          icon: Icons.home_work_outlined,
                          iconColor: AppColors.primary,
                        ),
                        StatCard(
                          label: 'Locataires actifs',
                          value: '${summary.activeTenants}',
                          icon: Icons.people_outlined,
                          iconColor: AppColors.secondary,
                        ),
                        StatCard(
                          label: 'Revenus mensuels',
                          value: currencyFormat.format(summary.monthlyRevenue),
                          icon: Icons.account_balance_wallet_outlined,
                          iconColor: AppColors.success,
                        ),
                        StatCard(
                          label: "Taux d'occupation",
                          value: '${summary.occupancyRate.toStringAsFixed(1)}%',
                          icon: Icons.pie_chart_outline,
                          iconColor: AppColors.accent,
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // ── Alertes ──────────────────────────────────
              const AlertsWidget(),

              const SizedBox(height: 24),

              // ── Activité récente ─────────────────────────
              const RecentActivityWidget(),

              const SizedBox(height: 24),

              // ── Rentabilité globale (placeholder) ────────
              _ProfitabilityPlaceholder(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// En-tete avec message de bienvenue et date.
class _WelcomeHeader extends StatelessWidget {
  final String userName;

  const _WelcomeHeader({required this.userName});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final greeting = _getGreeting(now.hour);
    final dateFormatted = DateFormat("EEEE d MMMM yyyy", 'fr_FR').format(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, $userName',
          style: AppTextStyles.h2,
        ),
        const SizedBox(height: 4),
        Text(
          dateFormatted.substring(0, 1).toUpperCase() +
              dateFormatted.substring(1),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  String _getGreeting(int hour) {
    if (hour < 12) return 'Bonjour';
    if (hour < 18) return 'Bon après-midi';
    return 'Bonsoir';
  }
}

/// Placeholder pour la section de rentabilité globale.
class _ProfitabilityPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            children: [
              const Icon(
                Icons.show_chart_rounded,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text('Rentabilité globale', style: AppTextStyles.h4),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bar_chart_rounded,
                    size: 48,
                    color: AppColors.textTertiary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Graphique de rentabilité',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Disponible prochainement',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
