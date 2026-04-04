import '../../domain/entities/property_entity.dart';

/// Modèle de données pour un bien immobilier.
/// Fait le pont entre le JSON du backend (camelCase) et l'entité domaine Dart.
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
    super.apartmentCount,
  });

  /// Parse un bien depuis le JSON du backend (camelCase .NET).
  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String,
      postalCode: json['postalCode'] as String? ?? '',
      city: json['city'] as String,
      country: json['country'] as String? ?? 'France',
      propertyType: PropertyType.values.firstWhere(
        (e) => e.name.toLowerCase() == (json['propertyType'] as String?)?.toLowerCase()
            || e.name == json['propertyType'].toString(),
        orElse: () => PropertyType.apartment,
      ),
      acquisitionDate: json['acquisitionDate'] != null
          ? DateTime.parse(json['acquisitionDate'] as String)
          : null,
      acquisitionPrice: (json['acquisitionPrice'] as num).toDouble(),
      currentValue: (json['currentValue'] as num?)?.toDouble(),
      surface: (json['surface'] as num?)?.toDouble() ?? 0,
      roomCount: json['roomCount'] as int?,
      bathroomCount: json['bathroomCount'] as int?,
      parkingSpaces: json['parkingSpaces'] as int?,
      monthlyRent: (json['monthlyRent'] as num?)?.toDouble(),
      propertyTax: (json['propertyTax'] as num?)?.toDouble(),
      insurance: (json['insurance'] as num?)?.toDouble(),
      charges: (json['monthlyCharges'] as num?)?.toDouble(),
      monthlyExpenses: (json['monthlyExpenses'] as num?)?.toDouble(),
      isRented: json['isRented'] as bool? ?? false,
      status: PropertyStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == (json['status'] as String?)?.toLowerCase()
            || e.name == json['status'].toString(),
        orElse: () => PropertyStatus.prospect,
      ),
      apartmentCount: json['apartmentCount'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Construit un PropertyModel à partir d'une entité domaine.
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
      apartmentCount: entity.apartmentCount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Sérialise le bien en JSON pour envoi au backend.
  Map<String, dynamic> toJson() {
    return {
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
      'monthlyCharges': charges,
      'isRented': isRented,
      'status': status.name,
      'apartmentCount': apartmentCount,
    };
  }
}
