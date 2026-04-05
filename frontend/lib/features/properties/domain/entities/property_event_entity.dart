import 'package:equatable/equatable.dart';

/// Type d'événement attaché à un bien (chronologie).
enum PropertyEventType {
  tenant('Locataire'),
  renovation('Travaux'),
  other('Autre');

  const PropertyEventType(this.label);

  /// Libellé en français pour l'affichage.
  final String label;
}

/// Entité représentant un événement dans la chronologie d'un bien.
/// Un événement peut être un locataire, des travaux, ou un autre événement.
class PropertyEventEntity extends Equatable {
  const PropertyEventEntity({
    required this.id,
    required this.propertyId,
    required this.userId,
    required this.eventType,
    required this.title,
    required this.startDate,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.endDate,
    this.monthlyRent,
    this.depositAmount,
    this.cost,
  });

  final String id;
  final String propertyId;
  final String userId;
  final PropertyEventType eventType;
  final String title;
  final String? description;
  final DateTime startDate;
  final DateTime? endDate;
  final double? monthlyRent;
  final double? depositAmount;
  final double? cost;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Vrai si l'événement est actif (sans date de fin ou date de fin future).
  bool get isActive =>
      endDate == null || endDate!.isAfter(DateTime.now());

  PropertyEventEntity copyWith({
    String? id,
    String? propertyId,
    String? userId,
    PropertyEventType? eventType,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    double? monthlyRent,
    double? depositAmount,
    double? cost,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PropertyEventEntity(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      userId: userId ?? this.userId,
      eventType: eventType ?? this.eventType,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      depositAmount: depositAmount ?? this.depositAmount,
      cost: cost ?? this.cost,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        propertyId,
        userId,
        eventType,
        title,
        description,
        startDate,
        endDate,
        monthlyRent,
        depositAmount,
        cost,
        createdAt,
        updatedAt,
      ];
}
