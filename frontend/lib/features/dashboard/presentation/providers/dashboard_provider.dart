import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Données résumées du tableau de bord (compteurs et KPIs).
class DashboardSummary {
  final int totalProperties;
  final int activeTenants;
  final double monthlyRevenue;
  final double occupancyRate;

  const DashboardSummary({
    required this.totalProperties,
    required this.activeTenants,
    required this.monthlyRevenue,
    required this.occupancyRate,
  });
}

/// Alerte ou rappel affiché sur le tableau de bord.
class DashboardAlert {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final DashboardAlertType type;

  const DashboardAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.type,
  });
}

/// Types d'alertes possibles sur le dashboard.
enum DashboardAlertType {
  rentDue,
  leaseExpiry,
  maintenance,
  payment,
  other,
}

/// Activité récente affichée sur le tableau de bord.
class RecentActivity {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final RecentActivityType type;

  const RecentActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
  });
}

/// Types d'activités récentes.
enum RecentActivityType {
  rentPayment,
  newTenant,
  tenantDeparture,
  maintenance,
  documentAdded,
  propertyAdded,
}

/// Provider des données résumées du tableau de bord.
/// Renvoie les vrais compteurs (tout à zéro pour un compte vierge).
/// TODO: Brancher sur l'API backend quand les endpoints dashboard seront prêts.
final dashboardSummaryProvider = FutureProvider<DashboardSummary>((ref) async {
  return const DashboardSummary(
    totalProperties: 0,
    activeTenants: 0,
    monthlyRevenue: 0,
    occupancyRate: 0,
  );
});

/// Provider des alertes du tableau de bord.
/// Liste vide tant qu'il n'y a pas de données réelles.
final dashboardAlertsProvider =
    FutureProvider<List<DashboardAlert>>((ref) async {
  return [];
});

/// Provider des activités récentes.
/// Liste vide tant qu'il n'y a pas de données réelles.
final recentActivitiesProvider =
    FutureProvider<List<RecentActivity>>((ref) async {
  return [];
});
