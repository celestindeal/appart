import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Données résumées du tableau de bord.
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

/// Alerte ou rappel du tableau de bord.
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

enum DashboardAlertType {
  rentDue,
  leaseExpiry,
  maintenance,
  payment,
  other,
}

/// Activité récente.
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

enum RecentActivityType {
  rentPayment,
  newTenant,
  tenantDeparture,
  maintenance,
  documentAdded,
  propertyAdded,
}

/// Provider des données résumées du tableau de bord.
final dashboardSummaryProvider = FutureProvider<DashboardSummary>((ref) async {
  // TODO: Remplacer par l'appel au repository réel.
  return const DashboardSummary(
    totalProperties: 5,
    activeTenants: 8,
    monthlyRevenue: 4250.00,
    occupancyRate: 87.5,
  );
});

/// Provider des alertes du tableau de bord.
final dashboardAlertsProvider =
    FutureProvider<List<DashboardAlert>>((ref) async {
  // TODO: Remplacer par l'appel au repository réel.
  return [
    DashboardAlert(
      id: '1',
      title: 'Loyer en retard',
      description: 'M. Martin - Appartement 3B, rue de la Paix',
      dueDate: DateTime.now().subtract(const Duration(days: 3)),
      type: DashboardAlertType.rentDue,
    ),
    DashboardAlert(
      id: '2',
      title: 'Bail arrivant à échéance',
      description: 'Mme Dubois - Studio 12, avenue des Champs',
      dueDate: DateTime.now().add(const Duration(days: 28)),
      type: DashboardAlertType.leaseExpiry,
    ),
    DashboardAlert(
      id: '3',
      title: 'Intervention plomberie',
      description: 'Appartement 7A - Fuite signalée',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      type: DashboardAlertType.maintenance,
    ),
  ];
});

/// Provider des activités récentes.
final recentActivitiesProvider =
    FutureProvider<List<RecentActivity>>((ref) async {
  // TODO: Remplacer par l'appel au repository réel.
  return [
    RecentActivity(
      id: '1',
      title: 'Paiement de loyer reçu',
      description: 'M. Lefevre - 850,00 € - Appartement 2A',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: RecentActivityType.rentPayment,
    ),
    RecentActivity(
      id: '2',
      title: 'Nouveau locataire',
      description: 'Mme Garcia - Studio 5C, rue Molière',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: RecentActivityType.newTenant,
    ),
    RecentActivity(
      id: '3',
      title: 'Document ajouté',
      description: 'Quittance de loyer - Mars 2026',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      type: RecentActivityType.documentAdded,
    ),
    RecentActivity(
      id: '4',
      title: 'Bien ajouté',
      description: 'Appartement T3 - 15 rue Victor Hugo',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      type: RecentActivityType.propertyAdded,
    ),
  ];
});
