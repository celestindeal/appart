import '../../domain/entities/reminder_entity.dart';

/// Modele de donnees pour un rappel (JSON <-> entite).
class ReminderModel {
  const ReminderModel({
    required this.id,
    required this.tenantId,
    required this.title,
    required this.description,
    required this.reminderType,
    required this.reminderDate,
    required this.isCompleted,
    required this.createdAt,
  });

  final String id;
  final String tenantId;
  final String title;
  final String? description;
  final ReminderType reminderType;
  final DateTime reminderDate;
  final bool isCompleted;
  final DateTime createdAt;

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'].toString(),
      tenantId: json['tenantId'].toString(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      reminderType: _parseType(json['reminderType'] as String?),
      reminderDate: DateTime.parse(json['reminderDate'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  ReminderEntity toEntity() => ReminderEntity(
        id: id,
        tenantId: tenantId,
        title: title,
        description: description ?? '',
        reminderType: reminderType,
        reminderDate: reminderDate,
        isCompleted: isCompleted,
        createdAt: createdAt,
      );

  Map<String, dynamic> toCreateJson() => {
        'tenantId': tenantId,
        'title': title,
        'description': description,
        'reminderType': _typeToJson(reminderType),
        'reminderDate': reminderDate.toIso8601String(),
        'isCompleted': isCompleted,
      };

  Map<String, dynamic> toUpdateJson() => {
        'title': title,
        'description': description,
        'reminderType': _typeToJson(reminderType),
        'reminderDate': reminderDate.toIso8601String(),
        'isCompleted': isCompleted,
      };

  static ReminderModel fromEntity(ReminderEntity e) => ReminderModel(
        id: e.id,
        tenantId: e.tenantId,
        title: e.title,
        description: e.description.isEmpty ? null : e.description,
        reminderType: e.reminderType,
        reminderDate: e.reminderDate,
        isCompleted: e.isCompleted,
        createdAt: e.createdAt,
      );

  // ── Serialisation enum ──────────────────────────────────────
  // Le backend stocke le type en string libre (pas un enum .NET).
  // On utilise les memes noms que le frontend.

  static ReminderType _parseType(String? raw) {
    switch (raw) {
      case 'RentDue':
        return ReminderType.rentDue;
      case 'LeaseRenewal':
        return ReminderType.leaseRenewal;
      case 'DocumentExpiry':
        return ReminderType.documentExpiry;
      case 'Maintenance':
        return ReminderType.maintenance;
      case 'Custom':
      default:
        return ReminderType.custom;
    }
  }

  static String _typeToJson(ReminderType t) {
    switch (t) {
      case ReminderType.rentDue:
        return 'RentDue';
      case ReminderType.leaseRenewal:
        return 'LeaseRenewal';
      case ReminderType.documentExpiry:
        return 'DocumentExpiry';
      case ReminderType.maintenance:
        return 'Maintenance';
      case ReminderType.custom:
        return 'Custom';
    }
  }
}
