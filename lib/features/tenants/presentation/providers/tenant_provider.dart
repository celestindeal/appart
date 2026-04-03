import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/tenant_entity.dart';
import '../../domain/repositories/tenant_repository.dart';

/// Provider du repository (a overrider dans le main avec l'implementation concrete).
final tenantRepositoryProvider = Provider<TenantRepository>((ref) {
  throw UnimplementedError(
    'tenantRepositoryProvider doit etre override avec une implementation concrete.',
  );
});

/// Provider de la liste des locataires.
final tenantsListProvider =
    FutureProvider.autoDispose<List<TenantEntity>>((ref) async {
  final repository = ref.watch(tenantRepositoryProvider);
  return repository.getTenants();
});

/// Provider du detail d'un locataire par son identifiant.
final tenantDetailProvider =
    FutureProvider.autoDispose.family<TenantEntity, String>((ref, id) async {
  final repository = ref.watch(tenantRepositoryProvider);
  return repository.getTenantById(id);
});
