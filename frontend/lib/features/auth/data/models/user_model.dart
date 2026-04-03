import '../../domain/entities/user_entity.dart';

/// Modèle de données utilisateur pour la sérialisation/désérialisation JSON.
/// Fait le pont entre le JSON du backend (camelCase) et l'entité domaine Dart.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    super.phoneNumber,
    super.profileImageUrl,
    required super.createdAt,
  });

  /// Parse un utilisateur depuis le JSON du backend.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  /// Sérialise l'utilisateur en JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Crée un UserModel à partir d'une UserEntity.
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
      phoneNumber: entity.phoneNumber,
      profileImageUrl: entity.profileImageUrl,
      createdAt: entity.createdAt,
    );
  }

  /// Convertit vers l'entité domaine.
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
      createdAt: createdAt,
    );
  }
}
