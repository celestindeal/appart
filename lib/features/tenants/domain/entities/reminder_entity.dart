import 'package:equatable/equatable.dart';

/// Type de rappel.
enum ReminderType {
  rentDue('Loyer du'),
  leaseRenewal('Renouvellement de bail'),
  documentExpiry('Expiration de document'),
  maintenance('Maintenance'),
  custom('Personnalise');

  const ReminderType(this.label);
  final String label;
}

/// Entite representant un rappel associe a un locataire.
class ReminderEntity extends Equatable {
  const ReminderEntity({
    required this.id,
    required this.tenantId,
    required this.title,
    required this.description,
    required this.reminderType,
    required this.reminderDate,
    required this.createdAt,
    this.isCompleted = false,
  });

  final String id;
  final String tenantId;
  final String title;
  final String description;
  final ReminderType reminderType;
  final DateTime reminderDate;
  final bool isCompleted;
  final DateTime createdAt;

  /// Indique si le rappel est en retard.
  bool get isOverdue =>
      !isCompleted && reminderDate.isBefore(DateTime.now());

  ReminderEntity copyWith({
    String? id,
    String? tenantId,
    String? title,
    String? description,
    ReminderType? reminderType,
    DateTime? reminderDate,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return ReminderEntity(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      title: title ?? this.title,
      description: description ?? this.description,
      reminderType: reminderType ?? this.reminderType,
      reminderDate: reminderDate ?? this.reminderDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        tenantId,
        title,
        description,
        reminderType,
        reminderDate,
        isCompleted,
        createdAt,
      ];
}
