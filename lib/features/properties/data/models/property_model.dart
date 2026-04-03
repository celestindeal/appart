import '../../domain/entities/property_entity.dart';

/// Modele de donnees pour un bien immobilier, serialisable en JSON.
class PropertyModel extends PropertyEntity {
  const PropertyModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.address,
    required super.postalCode,
    required super.city,
    required super.country,
    required super.propertyType,
    required super.acquisitionPrice,
    required super.surface,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.description,
    super.acquisitionDate,
    super.currentValue,
    super.roomCount,
    super.bathroomCount,
    super.parkingSpaces,
    super.monthlyRent,
    super.propertyTax,
    super.insurance,
    super.charges,
    super.monthlyExpenses,
    super.isRented,
  });

  /// Construit un [PropertyModel] a partir d'un [Map] JSON.
  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String,
      postalCode: json['postalCode'] as String,
      city: json['city'] as String,
      country: json['country'] as String? ?? 'France',
      propertyType: PropertyType.values.firstWhere(
        (e) => e.name == json['propertyType'],
        orElse: () => PropertyType.apartment,
      ),
      acquisitionDate: json['acquisitionDate'] != null
          ? DateTime.parse(json['acquisitionDate'] as String)
          : null,
      acquisitionPrice: (json['acquisitionPrice'] as num).toDouble(),
      currentValue: (json['currentValue'] as num?)?.toDouble(),
      surface: (json['surface'] as num).toDouble(),
      roomCount: json['roomCount'] as int?,
      bathroomCount: json['bathroomCount'] as int?,
      parkingSpaces: json['parkingSpaces'] as int?,
      monthlyRent: (json['monthlyRent'] as num?)?.toDouble(),
      propertyTax: (json['propertyTax'] as num?)?.toDouble(),
      insurance: (json['insurance'] as num?)?.toDouble(),
      charges: (json['charges'] as num?)?.toDouble(),
      monthlyExpenses: (json['monthlyExpenses'] as num?)?.toDouble(),
      isRented: json['isRented'] as bool? ?? false,
      status: PropertyStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PropertyStatus.prospect,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Construit un [PropertyModel] a partir d'une entite du domaine.
  factory PropertyModel.fromEntity(PropertyEntity entity) {
    return PropertyModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      description: entity.description,
      address: entity.address,
      postalCode: entity.postalCode,
      city: entity.city,
      country: entity.country,
      propertyType: entity.propertyType,
      acquisitionDate: entity.acquisitionDate,
      acquisitionPrice: entity.acquisitionPrice,
      currentValue: entity.currentValue,
      surface: entity.surface,
      roomCount: entity.roomCount,
      bathroomCount: entity.bathroomCount,
      parkingSpaces: entity.parkingSpaces,
      monthlyRent: entity.monthlyRent,
      propertyTax: entity.propertyTax,
      insurance: entity.insurance,
      charges: entity.charges,
      monthlyExpenses: entity.monthlyExpenses,
      isRented: entity.isRented,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convertit le modele en [Map] JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'address': address,
      'postalCode': postalCode,
      'city': city,
      'country': country,
      'propertyType': propertyType.name,
      'acquisitionDate': acquisitionDate?.toIso8601String(),
      'acquisitionPrice': acquisitionPrice,
      'currentValue': currentValue,
      'surface': surface,
      'roomCount': roomCount,
      'bathroomCount': bathroomCount,
      'parkingSpaces': parkingSpaces,
      'monthlyRent': monthlyRent,
      'propertyTax': propertyTax,
      'insurance': insurance,
      'charges': charges,
      'monthlyExpenses': monthlyExpenses,
      'isRented': isRented,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
