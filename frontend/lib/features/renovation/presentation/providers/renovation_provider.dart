import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/renovation_project_entity.dart';

final renovationProjectsProvider = FutureProvider<List<RenovationProjectEntity>>((ref) async {
  // TODO: connect to repository
  return [];
});

final renovationDetailProvider = FutureProvider.family<RenovationProjectEntity?, String>((ref, id) async {
  // TODO: connect to repository
  return null;
});
