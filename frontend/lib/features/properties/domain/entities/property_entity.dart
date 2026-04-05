import 'package:equatable/equatable.dart';

import 'property_event_entity.dart';

/// Types de biens immobiliers.
enum PropertyType {
  apartment('Appartement'),
  building('Immeuble'),
  other('Autre');

  const PropertyType(this.label);

  /// Libellé en français affiché dans l'interface.
  final String label;
}

/// Statut du bien dans le cycle de gestion.
enum PropertyStatus {
  prospect('Prospect'),
  owned('En possession'),
  sold('Vendu');

  const PropertyStatus(this.label);

  /// Libellé en français affiché dans l'interface.
  final String label;
}

/// Entité représentant un bien immobilier.
class PropertyEntity extends Equatable {
  const PropertyEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.address,
    required this.postalCode,
    required this.city,
    required this.country,
    required this.propertyType,
    required this.acquisitionPrice,
    required this.surface,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.acquisitionDate,
    this.currentValue,
    this.roomCount,
    this.bathroomCount,
    this.parkingSpaces,
    this.propertyTax,
    this.insurance,
    this.charges,
    this.monthlyExpenses,
    this.parentPropertyId,
    this.apartments = const [],
    this.events = const [],
  });

  final String id;
  final String userId;
  final String name;
  final String? description;
  final String address;
  final String postalCode;
  final String city;
  final String country;
  final PropertyType propertyType;
  final DateTime? acquisitionDate;
  final double acquisitionPrice;
  final double? currentValue;
  final double surface;
  final int? roomCount;
  final int? bathroomCount;
  final int? parkingSpaces;
  final double? propertyTax;
  final double? insurance;
  final double? charges;
  final double? monthlyExpenses;
  final PropertyStatus status;

  /// ID du bien parent (immeuble) si cet appartement en fait partie.
  final String? parentPropertyId;

  /// Liste des appartements contenus dans cet immeuble.
  final List<PropertyEntity> apartments;

  /// Liste des événements (locataires, travaux, autres) attachés au bien.
  final List<PropertyEventEntity> events;

  final DateTime createdAt;
  final DateTime updatedAt;

  /// Vrai si ce bien est un immeuble contenant des appartements.
  bool get isBuilding => propertyType == PropertyType.building;

  /// Vrai si ce bien est un appartement enfant d'un immeuble.
  bool get isChildApartment => parentPropertyId != null;

  /// Premier événement locataire actif (le plus pertinent pour le loyer en cours).
  PropertyEventEntity? get activeTenantEvent => events
      .where(
        (e) => e.eventType == PropertyEventType.tenant && e.isActive,
      )
      .fold<PropertyEventEntity?>(null, (prev, e) => prev ?? e);

  /// Loyer mensuel du locataire actif (compatibilité API avec l'ancien champ).
  double? get monthlyRent => activeTenantEvent?.monthlyRent;

  /// Vrai si un locataire actif est attaché au bien (calculé depuis les événements).
  bool get isRented => activeTenantEvent != null;

  /// Surface totale : somme des surfaces des appartements pour un immeuble,
  /// ou la surface propre pour un bien simple.
  double get totalSurface => isBuilding && apartments.isNotEmpty
      ? apartments.fold(0.0, (sum, a) => sum + a.surface)
      : surface;

  /// Loyer mensuel total : somme des loyers des appartements pour un immeuble,
  /// ou le loyer propre pour un bien simple.
  double? get totalMonthlyRent {
    if (isBuilding && apartments.isNotEmpty) {
      final total = apartments.fold(
        0.0,
        (sum, a) => sum + (a.activeTenantEvent?.monthlyRent ?? 0),
      );
      return total > 0 ? total : null;
    }
    return monthlyRent;
  }

  /// Nombre total de pièces agrégé depuis les appartements.
  int? get totalRoomCount {
    if (isBuilding && apartments.isNotEmpty) {
      final total = apartments.fold(0, (sum, a) => sum + (a.roomCount ?? 0));
      return total > 0 ? total : null;
    }
    return roomCount;
  }

  /// Nombre d'appartements occupés (loués) dans l'immeuble.
  int get rentedApartmentCount =>
      apartments.where((a) => a.isRented).length;

  /// Rendement brut estimatif rapide.
  /// Pour un immeuble, utilise le loyer total agrégé.
  double? get grossYield {
    final rent = totalMonthlyRent;
    if (rent == null || acquisitionPrice <= 0) return null;
    return (rent * 12) / acquisitionPrice * 100;
  }

  /// Prix au mètre carré (utilise la surface totale pour les immeubles).
  double get pricePerSqm {
    final s = totalSurface;
    return s > 0 ? acquisitionPrice / s : 0;
  }

  /// Copie l'entité en remplaçant les champs spécifiés.
  PropertyEntity copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    String? address,
    String? postalCode,
    String? city,
    String? country,
    PropertyType? propertyType,
    DateTime? acquisitionDate,
    double? acquisitionPrice,
    double? currentValue,
    double? surface,
    int? roomCount,
    int? bathroomCount,
    int? parkingSpaces,
    double? propertyTax,
    double? insurance,
    double? charges,
    double? monthlyExpenses,
    PropertyStatus? status,
    String? parentPropertyId,
    List<PropertyEntity>? apartments,
    List<PropertyEventEntity>? events,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PropertyEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      postalCode: postalCode ?? this.postalCode,
      city: city ?? this.city,
      country: country ?? this.country,
      propertyType: propertyType ?? this.propertyType,
      acquisitionDate: acquisitionDate ?? this.acquisitionDate,
      acquisitionPrice: acquisitionPrice ?? this.acquisitionPrice,
      currentValue: currentValue ?? this.currentValue,
      surface: surface ?? this.surface,
      roomCount: roomCount ?? this.roomCount,
      bathroomCount: bathroomCount ?? this.bathroomCount,
      parkingSpaces: parkingSpaces ?? this.parkingSpaces,
      propertyTax: propertyTax ?? this.propertyTax,
      insurance: insurance ?? this.insurance,
      charges: charges ?? this.charges,
      monthlyExpenses: monthlyExpenses ?? this.monthlyExpenses,
      status: status ?? this.status,
      parentPropertyId: parentPropertyId ?? this.parentPropertyId,
      apartments: apartments ?? this.apartments,
      events: events ?? this.events,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        description,
        address,
        postalCode,
        city,
        country,
        propertyType,
        acquisitionDate,
        acquisitionPrice,
        currentValue,
        surface,
        roomCount,
        bathroomCount,
        parkingSpaces,
        propertyTax,
        insurance,
        charges,
        monthlyExpenses,
        status,
        parentPropertyId,
        apartments,
        events,
        createdAt,
        updatedAt,
      ];
}
