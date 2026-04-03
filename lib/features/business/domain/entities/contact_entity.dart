import 'package:equatable/equatable.dart';

enum ContactType { contractor, solicitor, realEstateAgent, banker, accountant, tenant, supplier, other }

class ContactEntity extends Equatable {
  final String id;
  final String name;
  final String? email;
  final String? phoneNumber;
  final ContactType contactType;
  final String? companyName;
  final String? address;
  final String? notes;
  final DateTime createdAt;

  const ContactEntity({
    required this.id,
    required this.name,
    this.email,
    this.phoneNumber,
    required this.contactType,
    this.companyName,
    this.address,
    this.notes,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}
