import '../../domain/entities/tenant_entity.dart';

/// Modele de donnees pour un locataire, serialisable en JSON.
class TenantModel extends TenantEntity {
  const TenantModel({
    required super.id,
    required super.propertyId,
    required super.propertyName,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phoneNumber,
    required super.identityDocumentType,
    required super.identityDocumentNumber,
    required super.moveInDate,
    required super.monthlyRent,
    required super.depositAmount,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.moveOutDate,
    super.depositReturnedDate,
  });

  /// Construit un [TenantModel] a partir d'un [Map] JSON.
  factory TenantModel.fromJson(Map<String, dynamic> json) {
    return TenantModel(
      id: json['id'] as String,
      propertyId: json['propertyId'] as String,
      propertyName: json['propertyName'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      identityDocumentType: json['identityDocumentType'] as String,
      identityDocumentNumber: json['identityDocumentNumber'] as String,
      moveInDate: DateTime.parse(json['moveInDate'] as String),
      moveOutDate: json['moveOutDate'] != null
          ? DateTime.parse(json['moveOutDate'] as String)
          : null,
      monthlyRent: (json['monthlyRent'] as num).toDouble(),
      depositAmount: (json['depositAmount'] as num).toDouble(),
      depositReturnedDate: json['depositReturnedDate'] != null
          ? DateTime.parse(json['depositReturnedDate'] as String)
          : null,
      status: TenantStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TenantStatus.active,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Construit un [TenantModel] a partir d'une entite.
  factory TenantModel.fromEntity(TenantEntity entity) {
    return TenantModel(
      id: entity.id,
      propertyId: entity.propertyId,
      propertyName: entity.propertyName,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      identityDocumentType: entity.identityDocumentType,
      identityDocumentNumber: entity.identityDocumentNumber,
      moveInDate: entity.moveInDate,
      moveOutDate: entity.moveOutDate,
      monthlyRent: entity.monthlyRent,
      depositAmount: entity.depositAmount,
      depositReturnedDate: entity.depositReturnedDate,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convertit le modele en [Map] JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'propertyName': propertyName,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'identityDocumentType': identityDocumentType,
      'identityDocumentNumber': identityDocumentNumber,
      'moveInDate': moveInDate.toIso8601String(),
      'moveOutDate': moveOutDate?.toIso8601String(),
      'monthlyRent': monthlyRent,
      'depositAmount': depositAmount,
      'depositReturnedDate': depositReturnedDate?.toIso8601String(),
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
