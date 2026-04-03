import 'package:equatable/equatable.dart';

/// Statut du locataire.
enum TenantStatus {
  active('Actif'),
  latePayment('Retard de paiement'),
  leaving('En cours de depart'),
  inactive('Inactif');

  const TenantStatus(this.label);
  final String label;
}

/// Entite representant un locataire.
class TenantEntity extends Equatable {
  const TenantEntity({
    required this.id,
    required this.propertyId,
    required this.propertyName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.identityDocumentType,
    required this.identityDocumentNumber,
    required this.moveInDate,
    required this.monthlyRent,
    required this.depositAmount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.moveOutDate,
    this.depositReturnedDate,
  });

  final String id;
  final String propertyId;
  final String propertyName;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String identityDocumentType;
  final String identityDocumentNumber;
  final DateTime moveInDate;
  final DateTime? moveOutDate;
  final double monthlyRent;
  final double depositAmount;
  final DateTime? depositReturnedDate;
  final TenantStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Nom complet du locataire.
  String get fullName => '$firstName $lastName';

  /// Initiales pour l'avatar.
  String get initials {
    final first = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final last = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$first$last';
  }

  /// Indique si le locataire est actuellement actif.
  bool get isActive => status == TenantStatus.active;

  TenantEntity copyWith({
    String? id,
    String? propertyId,
    String? propertyName,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? identityDocumentType,
    String? identityDocumentNumber,
    DateTime? moveInDate,
    DateTime? moveOutDate,
    double? monthlyRent,
    double? depositAmount,
    DateTime? depositReturnedDate,
    TenantStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TenantEntity(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      propertyName: propertyName ?? this.propertyName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      identityDocumentType: identityDocumentType ?? this.identityDocumentType,
      identityDocumentNumber:
          identityDocumentNumber ?? this.identityDocumentNumber,
      moveInDate: moveInDate ?? this.moveInDate,
      moveOutDate: moveOutDate ?? this.moveOutDate,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      depositAmount: depositAmount ?? this.depositAmount,
      depositReturnedDate: depositReturnedDate ?? this.depositReturnedDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        propertyId,
        propertyName,
        firstName,
        lastName,
        email,
        phoneNumber,
        identityDocumentType,
        identityDocumentNumber,
        moveInDate,
        moveOutDate,
        monthlyRent,
        depositAmount,
        depositReturnedDate,
        status,
        createdAt,
        updatedAt,
      ];
}
