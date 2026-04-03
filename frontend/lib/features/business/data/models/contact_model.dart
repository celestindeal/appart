import '../../domain/entities/contact_entity.dart';

class ContactModel extends ContactEntity {
  const ContactModel({
    required super.id,
    required super.name,
    super.email,
    super.phoneNumber,
    required super.contactType,
    super.companyName,
    super.address,
    super.notes,
    required super.createdAt,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      contactType: ContactType.values.byName(json['contactType'] as String),
      companyName: json['companyName'] as String?,
      address: json['address'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phoneNumber': phoneNumber,
    'contactType': contactType.name,
    'companyName': companyName,
    'address': address,
    'notes': notes,
  };
}
