import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/purchase_milestone_entity.dart';
import '../../domain/entities/purchase_project_entity.dart';
import '../../domain/repositories/purchase_repository.dart';

/// Provider du repository d'achat.
/// Doit etre surchargé au démarrage avec l'implémentation concrète.
final purchaseRepositoryProvider = Provider<PurchaseRepository>((ref) {
  throw UnimplementedError(
    'purchaseRepositoryProvider doit etre surchargé avec une implémentation concrète.',
  );
});

/// État de la liste des projets d'achat.
sealed class PurchaseListState {
  const PurchaseListState();
}

class PurchaseListInitial extends PurchaseListState {
  const PurchaseListInitial();
}

class PurchaseListLoading extends PurchaseListState {
  const PurchaseListLoading();
}

class PurchaseListLoaded extends PurchaseListState {
  final List<PurchaseProjectEntity> projects;
  const PurchaseListLoaded(this.projects);
}

class PurchaseListError extends PurchaseListState {
  final String message;
  const PurchaseListError(this.message);
}

/// Notifier pour la liste des projets d'achat.
class PurchaseListNotifier extends StateNotifier<PurchaseListState> {
  final PurchaseRepository _repository;

  PurchaseListNotifier(this._repository) : super(const PurchaseListInitial());

  Future<void> loadProjects() async {
    state = const PurchaseListLoading();
    try {
      final projects = await _repository.getProjects();
      state = PurchaseListLoaded(projects);
    } catch (e) {
      state = PurchaseListError(e.toString());
    }
  }

  Future<void> filterByStatus(PurchaseStatus status) async {
    state = const PurchaseListLoading();
    try {
      final projects = await _repository.getProjectsByStatus(status);
      state = PurchaseListLoaded(projects);
    } catch (e) {
      state = PurchaseListError(e.toString());
    }
  }

  Future<void> deleteProject(String id) async {
    try {
      await _repository.deleteProject(id);
      await loadProjects();
    } catch (e) {
      state = PurchaseListError(e.toString());
    }
  }
}

/// Provider de la liste des projets d'achat.
final purchaseListProvider =
    StateNotifierProvider<PurchaseListNotifier, PurchaseListState>((ref) {
  final repository = ref.watch(purchaseRepositoryProvider);
  return PurchaseListNotifier(repository);
});

/// État du détail d'un projet d'achat.
sealed class PurchaseDetailState {
  const PurchaseDetailState();
}

class PurchaseDetailInitial extends PurchaseDetailState {
  const PurchaseDetailInitial();
}

class PurchaseDetailLoading extends PurchaseDetailState {
  const PurchaseDetailLoading();
}

class PurchaseDetailLoaded extends PurchaseDetailState {
  final PurchaseProjectEntity project;
  const PurchaseDetailLoaded(this.project);
}

class PurchaseDetailError extends PurchaseDetailState {
  final String message;
  const PurchaseDetailError(this.message);
}

/// Notifier pour le détail d'un projet d'achat.
class PurchaseDetailNotifier extends StateNotifier<PurchaseDetailState> {
  final PurchaseRepository _repository;

  PurchaseDetailNotifier(this._repository)
      : super(const PurchaseDetailInitial());

  Future<void> loadProject(String id) async {
    state = const PurchaseDetailLoading();
    try {
      final project = await _repository.getProjectById(id);
      state = PurchaseDetailLoaded(project);
    } catch (e) {
      state = PurchaseDetailError(e.toString());
    }
  }

  Future<void> updateProject(PurchaseProjectEntity project) async {
    state = const PurchaseDetailLoading();
    try {
      final updated = await _repository.updateProject(project);
      state = PurchaseDetailLoaded(updated);
    } catch (e) {
      state = PurchaseDetailError(e.toString());
    }
  }

  Future<void> addMilestone(
    String projectId,
    PurchaseMilestoneEntity milestone,
  ) async {
    try {
      await _repository.addMilestone(projectId, milestone);
      await loadProject(projectId);
    } catch (e) {
      state = PurchaseDetailError(e.toString());
    }
  }

  Future<void> updateMilestone(PurchaseMilestoneEntity milestone) async {
    try {
      await _repository.updateMilestone(milestone);
      await loadProject(milestone.projectId);
    } catch (e) {
      state = PurchaseDetailError(e.toString());
    }
  }

  Future<void> deleteMilestone(String projectId, String milestoneId) async {
    try {
      await _repository.deleteMilestone(projectId, milestoneId);
      await loadProject(projectId);
    } catch (e) {
      state = PurchaseDetailError(e.toString());
    }
  }
}

/// Provider du détail d'un projet d'achat.
final purchaseDetailProvider =
    StateNotifierProvider<PurchaseDetailNotifier, PurchaseDetailState>((ref) {
  final repository = ref.watch(purchaseRepositoryProvider);
  return PurchaseDetailNotifier(repository);
});

/// Provider des projets groupés par statut (pour la vue Kanban).
final purchaseProjectsByStatusProvider =
    Provider<Map<PurchaseStatus, List<PurchaseProjectEntity>>>((ref) {
  final state = ref.watch(purchaseListProvider);
  if (state is PurchaseListLoaded) {
    final grouped = <PurchaseStatus, List<PurchaseProjectEntity>>{};
    for (final status in PurchaseStatus.values) {
      grouped[status] =
          state.projects.where((p) => p.status == status).toList();
    }
    return grouped;
  }
  return {};
});
