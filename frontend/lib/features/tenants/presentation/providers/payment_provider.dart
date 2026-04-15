import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/payment_remote_datasource.dart';
import '../../data/models/rent_payment_model.dart';
import '../../domain/entities/rent_payment_entity.dart';

/// Provider du datasource (a overrider dans main.dart).
final paymentRemoteDatasourceProvider = Provider<PaymentRemoteDatasource>((ref) {
  throw UnimplementedError(
    'paymentRemoteDatasourceProvider doit etre override.',
  );
});

/// Liste des paiements d'un locataire.
final paymentsForTenantProvider =
    FutureProvider.autoDispose.family<List<RentPaymentEntity>, String>(
  (ref, tenantId) async {
    final datasource = ref.watch(paymentRemoteDatasourceProvider);
    return datasource.getByTenant(tenantId);
  },
);

/// Actions CRUD pour les paiements.
final paymentActionsProvider = Provider<PaymentActions>((ref) {
  return PaymentActions(ref);
});

class PaymentActions {
  PaymentActions(this._ref);
  final Ref _ref;

  Future<RentPaymentEntity> create(RentPaymentEntity payment) async {
    final datasource = _ref.read(paymentRemoteDatasourceProvider);
    final model = RentPaymentModel.fromEntity(payment);
    final created = await datasource.create(model);
    _ref.invalidate(paymentsForTenantProvider(payment.tenantId));
    return created;
  }

  Future<RentPaymentEntity> update(RentPaymentEntity payment) async {
    final datasource = _ref.read(paymentRemoteDatasourceProvider);
    final model = RentPaymentModel.fromEntity(payment);
    final updated = await datasource.update(model);
    _ref.invalidate(paymentsForTenantProvider(payment.tenantId));
    return updated;
  }

  Future<void> delete({
    required String paymentId,
    required String tenantId,
  }) async {
    final datasource = _ref.read(paymentRemoteDatasourceProvider);
    await datasource.delete(paymentId);
    _ref.invalidate(paymentsForTenantProvider(tenantId));
  }
}
