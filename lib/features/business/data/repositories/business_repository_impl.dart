import '../../domain/entities/accounting_entry_entity.dart';
import '../../domain/entities/contact_entity.dart';
import '../../domain/repositories/business_repository.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  @override
  Future<List<AccountingEntryEntity>> getEntries() async => [];

  @override
  Future<List<AccountingEntryEntity>> getEntriesByDateRange(DateTime from, DateTime to) async => [];

  @override
  Future<List<AccountingEntryEntity>> getEntriesByProperty(String propertyId) async => [];

  @override
  Future<void> addEntry(AccountingEntryEntity entry) async {}

  @override
  Future<void> updateEntry(AccountingEntryEntity entry) async {}

  @override
  Future<void> deleteEntry(String id) async {}

  @override
  Future<List<ContactEntity>> getContacts() async => [];

  @override
  Future<List<ContactEntity>> getContactsByType(ContactType type) async => [];

  @override
  Future<void> addContact(ContactEntity contact) async {}

  @override
  Future<void> updateContact(ContactEntity contact) async {}

  @override
  Future<void> deleteContact(String id) async {}
}
