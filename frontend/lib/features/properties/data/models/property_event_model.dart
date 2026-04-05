import '../../domain/entities/property_event_entity.dart';

/// Modèle de données pour un événement de bien.
/// Fait le pont entre le JSON du backend (camelCase) et l'entité domaine.
class PropertyEventModel extends PropertyEventEntity {
  const PropertyEventModel({
    required super.id,
    required super.propertyId,
    required super.userId,
    required super.eventType,
    required super.title,
    required super.startDate,
    required super.createdAt,
    required super.updatedAt,
    super.description,
    super.endDate,
    super.monthlyRent,
    super.depositAmount,
    super.cost,
  });

  /// Parse un événement depuis le JSON du backend.
  factory PropertyEventModel.fromJson(Map<String, dynamic> json) {
    return PropertyEventModel(
      id: json['id'] as String,
      propertyId: json['propertyId'] as String,
      userId: json['userId'] as String? ?? '',
      eventType: PropertyEventType.values.firstWhere(
        (e) =>
            e.name.toLowerCase() ==
            (json['eventType'] as String?)?.toLowerCase(),
        orElse: () => PropertyEventType.tenant,
      ),
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      monthlyRent: (json['monthlyRent'] as num?)?.toDouble(),
      depositAmount: (json['depositAmount'] as num?)?.toDouble(),
      cost: (json['cost'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Construit un PropertyEventModel à partir d'une entité domaine.
  factory PropertyEventModel.fromEntity(PropertyEventEntity entity) {
    return PropertyEventModel(
      id: entity.id,
      propertyId: entity.propertyId,
      userId: entity.userId,
      eventType: entity.eventType,
      title: entity.title,
      description: entity.description,
      startDate: entity.startDate,
      endDate: entity.endDate,
      monthlyRent: entity.monthlyRent,
      depositAmount: entity.depositAmount,
      cost: entity.cost,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Sérialise l'événement pour la requête de création côté backend.
  /// Le backend attend `eventType` en PascalCase (Tenant, Renovation, Other).
  Map<String, dynamic> toJson() {
    final typeName = eventType.name;
    final capitalized =
        typeName[0].toUpperCase() + typeName.substring(1);
    return {
      'propertyId': propertyId,
      'eventType': capitalized,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'monthlyRent': monthlyRent,
      'depositAmount': depositAmount,
      'cost': cost,
    };
  }
}
