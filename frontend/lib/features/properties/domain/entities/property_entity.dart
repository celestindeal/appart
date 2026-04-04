import 'package:equatable/equatable.dart';

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
    this.monthlyRent,
    this.propertyTax,
    this.insurance,
    this.charges,
    this.monthlyExpenses,
    this.isRented = false,
    this.apartmentCount,
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
  final double? monthlyRent;
  final double? propertyTax;
  final double? insurance;
  final double? charges;
  final double? monthlyExpenses;
  final bool isRented;
  final PropertyStatus status;

  /// Nombre d'appartements (uniquement pour les immeubles).
  final int? apartmentCount;

  final DateTime createdAt;
  final DateTime updatedAt;

  /// Rendement brut estimatif rapide.
  double? get grossYield {
    if (monthlyRent == null || acquisitionPrice <= 0) return null;
    return (monthlyRent! * 12) / acquisitionPrice * 100;
  }

  /// Prix au mètre carré.
  double get pricePerSqm => surface > 0 ? acquisitionPrice / surface : 0;

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
    double? monthlyRent,
    double? propertyTax,
    double? insurance,
    double? charges,
    double? monthlyExpenses,
    bool? isRented,
    PropertyStatus? status,
    int? apartmentCount,
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
      monthlyRent: monthlyRent ?? this.monthlyRent,
      propertyTax: propertyTax ?? this.propertyTax,
      insurance: insurance ?? this.insurance,
      charges: charges ?? this.charges,
      monthlyExpenses: monthlyExpenses ?? this.monthlyExpenses,
      isRented: isRented ?? this.isRented,
      status: status ?? this.status,
      apartmentCount: apartmentCount ?? this.apartmentCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id, userId, name, description, address, postalCode, city, country,
        propertyType, acquisitionDate, acquisitionPrice, currentValue, surface,
        roomCount, bathroomCount, parkingSpaces, monthlyRent, propertyTax,
        insurance, charges, monthlyExpenses, isRented, status, apartmentCount,
        createdAt, updatedAt,
      ];
}
