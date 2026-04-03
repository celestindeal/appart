import 'package:equatable/equatable.dart';

/// Entité utilisateur du domaine.
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.profileImageUrl,
    required this.createdAt,
  });

  /// Nom complet de l'utilisateur.
  String get fullName => '$firstName $lastName';

  /// Initiales pour l'avatar par défaut.
  String get initials {
    final first = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final last = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$first$last';
  }

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        phoneNumber,
        profileImageUrl,
        createdAt,
      ];
}
