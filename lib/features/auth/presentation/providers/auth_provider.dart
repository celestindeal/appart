import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

/// Provider du repository d'authentification.
/// Doit etre surchargé (override) au démarrage de l'app avec l'implémentation concrète.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError(
    'authRepositoryProvider doit etre surchargé avec une implémentation concrète.',
  );
});

/// État de l'authentification.
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

/// Notifier pour gérer l'état d'authentification.
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthInitial());

  /// Vérifie si l'utilisateur est déjà connecté au démarrage.
  Future<void> checkAuthStatus() async {
    state = const AuthLoading();
    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        state = AuthAuthenticated(user);
      } else {
        state = const AuthUnauthenticated();
      }
    } catch (e) {
      state = const AuthUnauthenticated();
    }
  }

  /// Connexion avec email et mot de passe.
  Future<void> login(String email, String password) async {
    state = const AuthLoading();
    try {
      final user = await _repository.login(email, password);
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  /// Inscription d'un nouvel utilisateur.
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
      state = AuthError(e.toString());
    }
  }

  /// Déconnexion.
  Future<void> logout() async {
    state = const AuthLoading();
    try {
      await _repository.logout();
    } catch (_) {
      // On déconnecte localement dans tous les cas.
    }
    state = const AuthUnauthenticated();
  }
}

/// Provider principal de l'état d'authentification.
final authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

/// Provider de l'utilisateur courant (null si non connecté).
final currentUserProvider = Provider<UserEntity?>((ref) {
  final authState = ref.watch(authStateProvider);
  if (authState is AuthAuthenticated) {
    return authState.user;
  }
  return null;
});

/// Provider booléen indiquant si l'utilisateur est authentifié.
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState is AuthAuthenticated;
});
