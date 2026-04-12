import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/loan_remote_datasource.dart';
import '../../data/models/loan_model.dart';
import '../../domain/entities/loan_entity.dart';

/// Provider du datasource (a overrider dans main.dart).
final loanRemoteDatasourceProvider = Provider<LoanRemoteDatasource>((ref) {
  throw UnimplementedError(
    'loanRemoteDatasourceProvider doit etre override.',
  );
});

/// Provider de la liste des emprunts d'un bien.
final loansForPropertyProvider =
    FutureProvider.autoDispose.family<List<LoanEntity>, String>(
  (ref, propertyId) async {
    final datasource = ref.watch(loanRemoteDatasourceProvider);
    return datasource.getByProperty(propertyId);
  },
);

/// Actions CRUD pour les emprunts.
final loanActionsProvider = Provider<LoanActions>((ref) {
  return LoanActions(ref);
});

class LoanActions {
  LoanActions(this._ref);
  final Ref _ref;

  Future<LoanEntity> create(LoanEntity loan) async {
    final datasource = _ref.read(loanRemoteDatasourceProvider);
    final model = LoanModel.fromEntity(loan);
    final created = await datasource.create(model);
    _ref.invalidate(loansForPropertyProvider(loan.propertyId));
    return created;
  }

  Future<LoanEntity> update(LoanEntity loan) async {
    final datasource = _ref.read(loanRemoteDatasourceProvider);
    final model = LoanModel.fromEntity(loan);
    final updated = await datasource.update(model);
    _ref.invalidate(loansForPropertyProvider(loan.propertyId));
    return updated;
  }

  Future<void> delete({
    required String loanId,
    required String propertyId,
  }) async {
    final datasource = _ref.read(loanRemoteDatasourceProvider);
    await datasource.delete(loanId);
    _ref.invalidate(loansForPropertyProvider(propertyId));
  }
}
