import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/accounting_entry_entity.dart';
import '../../domain/entities/contact_entity.dart';

final accountingEntriesProvider = FutureProvider<List<AccountingEntryEntity>>((ref) async {
  // TODO: connect to repository
  return [];
});

final contactsProvider = FutureProvider<List<ContactEntity>>((ref) async {
  // TODO: connect to repository
  return [];
});
