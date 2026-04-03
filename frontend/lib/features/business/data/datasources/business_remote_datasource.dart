import '../../domain/entities/accounting_entry_entity.dart';
import '../../domain/entities/contact_entity.dart';

abstract class BusinessRemoteDatasource {
  Future<List<AccountingEntryEntity>> getEntries({DateTime? from, DateTime? to, String? propertyId});
  Future<void> addEntry(Map<String, dynamic> data);
  Future<void> updateEntry(String id, Map<String, dynamic> data);
  Future<void> deleteEntry(String id);
  Future<List<ContactEntity>> getContacts({String? type, String? search});
  Future<void> addContact(Map<String, dynamic> data);
  Future<void> updateContact(String id, Map<String, dynamic> data);
  Future<void> deleteContact(String id);
}
