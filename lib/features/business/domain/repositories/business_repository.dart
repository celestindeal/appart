import '../entities/accounting_entry_entity.dart';
import '../entities/contact_entity.dart';

abstract class BusinessRepository {
  Future<List<AccountingEntryEntity>> getEntries();
  Future<List<AccountingEntryEntity>> getEntriesByDateRange(DateTime from, DateTime to);
  Future<List<AccountingEntryEntity>> getEntriesByProperty(String propertyId);
  Future<void> addEntry(AccountingEntryEntity entry);
  Future<void> updateEntry(AccountingEntryEntity entry);
  Future<void> deleteEntry(String id);
  Future<List<ContactEntity>> getContacts();
  Future<List<ContactEntity>> getContactsByType(ContactType type);
  Future<void> addContact(ContactEntity contact);
  Future<void> updateContact(ContactEntity contact);
  Future<void> deleteContact(String id);
}
