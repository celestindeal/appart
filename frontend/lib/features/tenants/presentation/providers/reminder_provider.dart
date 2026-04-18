import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/reminder_remote_datasource.dart';
import '../../data/models/reminder_model.dart';
import '../../domain/entities/reminder_entity.dart';

/// Provider du datasource (a overrider dans main.dart).
final reminderRemoteDatasourceProvider =
    Provider<ReminderRemoteDatasource>((ref) {
  throw UnimplementedError(
    'reminderRemoteDatasourceProvider doit etre override.',
  );
});

/// Liste des rappels d'un locataire.
final remindersForTenantProvider =
    FutureProvider.autoDispose.family<List<ReminderEntity>, String>(
  (ref, tenantId) async {
    final datasource = ref.watch(reminderRemoteDatasourceProvider);
    return datasource.getByTenant(tenantId);
  },
);

/// Actions CRUD pour les rappels.
final reminderActionsProvider = Provider<ReminderActions>((ref) {
  return ReminderActions(ref);
});

class ReminderActions {
  ReminderActions(this._ref);
  final Ref _ref;

  Future<ReminderEntity> create(ReminderEntity reminder) async {
    final datasource = _ref.read(reminderRemoteDatasourceProvider);
    final model = ReminderModel.fromEntity(reminder);
    final created = await datasource.create(model);
    _ref.invalidate(remindersForTenantProvider(reminder.tenantId));
    return created;
  }

  Future<ReminderEntity> update(ReminderEntity reminder) async {
    final datasource = _ref.read(reminderRemoteDatasourceProvider);
    final model = ReminderModel.fromEntity(reminder);
    final updated = await datasource.update(model);
    _ref.invalidate(remindersForTenantProvider(reminder.tenantId));
    return updated;
  }

  Future<void> delete({
    required String reminderId,
    required String tenantId,
  }) async {
    final datasource = _ref.read(reminderRemoteDatasourceProvider);
    await datasource.delete(reminderId);
    _ref.invalidate(remindersForTenantProvider(tenantId));
  }
}
