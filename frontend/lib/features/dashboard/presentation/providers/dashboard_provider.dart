import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../properties/domain/entities/property_entity.dart';
import '../../../properties/presentation/providers/property_provider.dart';

/// Données résumées du tableau de bord (compteurs et KPIs).
class DashboardSummary {
  final int totalProperties;
  final int totalApartments;
  final int activeTenants;
  final double monthlyRevenue;
  final double occupancyRate;
  final double totalSurface;
  final double grossYield;

  const DashboardSummary({
    required this.totalProperties,
    required this.totalApartments,
    required this.activeTenants,
    required this.monthlyRevenue,
    required this.occupancyRate,
    required this.totalSurface,
    required this.grossYield,
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
/// Calcule les KPIs à partir de la liste réelle des biens.
final dashboardSummaryProvider = FutureProvider<DashboardSummary>((ref) async {
  final properties = await ref.watch(propertiesListProvider.future);

  // Nombre total de biens racine (immeubles + apparts solo + autres).
  final totalProperties = properties.length;

  // Nombre total d'appartements (enfants d'immeubles + apparts solo).
  int totalApartments = 0;
  for (final p in properties) {
    if (p.isBuilding) {
      totalApartments += p.apartments.length;
    } else if (p.propertyType == PropertyType.apartment) {
      totalApartments += 1;
    }
  }

  // Revenus mensuels totaux (loyer agrégé pour les immeubles).
  double monthlyRevenue = 0;
  for (final p in properties) {
    monthlyRevenue += p.totalMonthlyRent ?? 0;
  }

  // Surface totale (agrégée pour les immeubles).
  double totalSurface = 0;
  for (final p in properties) {
    totalSurface += p.totalSurface;
  }

  // Taux d'occupation : apparts loués / total apparts.
  int totalRentable = 0;
  int totalRented = 0;
  for (final p in properties) {
    if (p.isBuilding) {
      totalRentable += p.apartments.length;
      totalRented += p.rentedApartmentCount;
    } else {
      totalRentable += 1;
      if (p.isRented) totalRented += 1;
    }
  }
  final occupancyRate =
      totalRentable > 0 ? (totalRented / totalRentable) * 100 : 0.0;

  // Rendement brut moyen pondéré.
  double totalAcquisition = 0;
  for (final p in properties) {
    totalAcquisition += p.acquisitionPrice;
  }
  final grossYield = totalAcquisition > 0
      ? (monthlyRevenue * 12) / totalAcquisition * 100
      : 0.0;

  return DashboardSummary(
    totalProperties: totalProperties,
    totalApartments: totalApartments,
    activeTenants: totalRented,
    monthlyRevenue: monthlyRevenue,
    occupancyRate: occupancyRate,
    totalSurface: totalSurface,
    grossYield: grossYield,
  );
});

/// Provider des alertes du tableau de bord.
/// TODO: Brancher sur les données réelles (loyers impayés, baux expirants...).
final dashboardAlertsProvider =
    FutureProvider<List<DashboardAlert>>((ref) async {
  return [];
});

/// Provider des activités récentes.
/// Génère automatiquement les activités depuis les biens créés récemment.
final recentActivitiesProvider =
    FutureProvider<List<RecentActivity>>((ref) async {
  final properties = await ref.watch(propertiesListProvider.future);

  // Trie les biens par date de création décroissante, prend les 5 derniers.
  final sorted = [...properties]
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  final recent = sorted.take(5).toList();

  return recent.map((p) {
    final isBuilding = p.propertyType == PropertyType.building;
    return RecentActivity(
      id: p.id,
      title: isBuilding
          ? 'Immeuble ajouté : ${p.name}'
          : 'Bien ajouté : ${p.name}',
      description: '${p.propertyType.label} · ${p.city}',
      timestamp: p.createdAt,
      type: RecentActivityType.propertyAdded,
    );
  }).toList();
});
