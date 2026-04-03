import '../../domain/entities/user_entity.dart';

/// Modèle de données utilisateur pour la sérialisation JSON.
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

  /// Crée un [UserModel] à partir d'une map JSON.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phoneNumber: json['phone_number'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Convertit le modèle en map JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'profile_image_url': profileImageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Crée un [UserModel] à partir d'une [UserEntity].
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

  /// Convertit en [UserEntity].
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
