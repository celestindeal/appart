import '../../domain/entities/tenant_entity.dart';

/// Modèle de données pour un locataire, sérialisable en JSON.
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

  /// Construit un [TenantModel] à partir d'un [Map] JSON reçu du backend.
  /// Tolère les champs absents (propertyName, phoneNumber…) car le DTO
  /// n'inclut pas toutes les colonnes.
  factory TenantModel.fromJson(Map<String, dynamic> json) {
    final statusRaw = (json['status'] as String?)?.toLowerCase();
    return TenantModel(
      id: json['id'] as String,
      propertyId: json['propertyId'] as String,
      propertyName: (json['propertyName'] as String?) ?? '',
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: (json['email'] as String?) ?? '',
      phoneNumber: (json['phoneNumber'] as String?) ?? '',
      identityDocumentType: (json['identityDocumentType'] as String?) ?? '',
      identityDocumentNumber:
          (json['identityDocumentNumber'] as String?) ?? '',
      moveInDate: DateTime.parse(json['moveInDate'] as String),
      moveOutDate: json['moveOutDate'] != null
          ? DateTime.parse(json['moveOutDate'] as String)
          : null,
      monthlyRent: (json['monthlyRent'] as num).toDouble(),
      depositAmount: (json['depositAmount'] as num?)?.toDouble() ?? 0,
      depositReturnedDate: json['depositReturnedDate'] != null
          ? DateTime.parse(json['depositReturnedDate'] as String)
          : null,
      status: TenantStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == statusRaw,
        orElse: () => TenantStatus.active,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Construit un [TenantModel] à partir d'une entité domaine.
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

  /// Sérialise le locataire pour une création (POST /api/tenants).
  /// Correspond au `CreateTenantRequest` attendu par le backend .NET.
  /// Le statut est envoyé en PascalCase (convention JsonStringEnumConverter).
  Map<String, dynamic> toCreateJson() {
    return {
      'propertyId': propertyId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email.isNotEmpty ? email : null,
      'phoneNumber': phoneNumber.isNotEmpty ? phoneNumber : null,
      'identityDocumentType':
          identityDocumentType.isNotEmpty ? identityDocumentType : null,
      'identityDocumentNumber':
          identityDocumentNumber.isNotEmpty ? identityDocumentNumber : null,
      'moveInDate': moveInDate.toIso8601String(),
      'moveOutDate': moveOutDate?.toIso8601String(),
      'monthlyRent': monthlyRent,
      'depositAmount': depositAmount,
      'status': _statusToPascalCase(status),
    };
  }

  /// Sérialise pour une mise à jour (PUT /api/tenants/{id}).
  /// Correspond au `UpdateTenantRequest` du backend.
  Map<String, dynamic> toUpdateJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email.isNotEmpty ? email : null,
      'phoneNumber': phoneNumber.isNotEmpty ? phoneNumber : null,
      'identityDocumentType':
          identityDocumentType.isNotEmpty ? identityDocumentType : null,
      'identityDocumentNumber':
          identityDocumentNumber.isNotEmpty ? identityDocumentNumber : null,
      'moveInDate': moveInDate.toIso8601String(),
      'moveOutDate': moveOutDate?.toIso8601String(),
      'monthlyRent': monthlyRent,
      'depositAmount': depositAmount,
      'depositReturnedDate': depositReturnedDate?.toIso8601String(),
      'status': _statusToPascalCase(status),
    };
  }

  /// Convertit l'enum en PascalCase pour le backend (ex: active → Active).
  static String _statusToPascalCase(TenantStatus status) {
    final name = status.name;
    return name[0].toUpperCase() + name.substring(1);
  }
}
