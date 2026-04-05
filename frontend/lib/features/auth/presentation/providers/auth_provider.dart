import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

/// Provider du repository d'authentification.
/// Doit être surchargé (override) au démarrage de l'app avec l'implémentation concrète.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError(
    'authRepositoryProvider doit être surchargé avec une implémentation concrète.',
  );
});

/// État d'authentification de l'application.
/// Utilisé par le [AuthNotifier] et observé par le routeur pour les redirections.
sealed class AuthState {
  const AuthState();
}

/// État initial : la vérification d'auth n'a pas encore été lancée.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Chargement en cours (login, register ou vérification de token).
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// L'utilisateur est connecté. Contient ses informations.
class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);
}

/// L'utilisateur n'est pas connecté (pas de token ou token expiré).
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Une erreur s'est produite lors de l'authentification.
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

/// Notifier qui gère les transitions d'état d'authentification.
/// Toutes les actions (login, register, logout, check) passent par ici.
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthInitial());

  bool _isBusy = false;

  Future<void> checkAuthStatus() async {
    if (_isBusy) return;
    _isBusy = true;
    state = const AuthLoading();
    try {
      final user = await _repository.getCurrentUser();
      if (state is AuthUnauthenticated) return;
      if (user != null) {
        state = AuthAuthenticated(user);
      } else {
        state = const AuthUnauthenticated();
      }
    } catch (e) {
      if (state is! AuthUnauthenticated) {
        state = const AuthUnauthenticated();
      }
    } finally {
      _isBusy = false;
    }
  }

  Future<void> login(String email, String password) async {
    state = const AuthLoading();
    try {
      final user = await _repository.login(email, password);
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(_extractErrorMessage(e));
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    state = const AuthLoading();
    try {
      final user = await _repository.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(_extractErrorMessage(e));
    }
  }

  Future<void> logout() async {
    if (state is AuthUnauthenticated) return;
    state = const AuthLoading();
    try {
      await _repository.logout();
    } catch (_) {}
    state = const AuthUnauthenticated();
    _isBusy = false;
  }

  String _extractErrorMessage(dynamic error) {
    final msg = error.toString();
    if (msg.contains('DioException')) {
      if (msg.contains('connection refused') ||
          msg.contains('SocketException') ||
          msg.contains('XMLHttpRequest') ||
          msg.contains('connectionError') ||
          msg.contains('connectionTimeout')) {
        return 'Impossible de se connecter au serveur. Vérifiez que le backend est lancé.';
      }
      if (msg.contains('401')) {
        return 'Email ou mot de passe incorrect.';
      }
      if (msg.contains('409')) {
        return 'Cet email est déjà utilisé.';
      }
    }
    return 'Une erreur est survenue. Veuillez réessayer.';
  }
}

/// Provider principal de l'état d'authentification.
/// Le routeur et les pages observent ce provider pour réagir aux changements.
final authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

/// Provider de l'utilisateur connecté (null si non connecté).
final currentUserProvider = Provider<UserEntity?>((ref) {
  final authState = ref.watch(authStateProvider);
  if (authState is AuthAuthenticated) {
    return authState.user;
  }
  return null;
});

/// Provider booléen : true si l'utilisateur est authentifié.
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState is AuthAuthenticated;
});
