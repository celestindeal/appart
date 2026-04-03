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

  /// Vérifie si l'utilisateur a un token valide au démarrage.
  /// Appelle GET /auth/me pour valider le JWT stocké en local.
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
  /// En cas de succès, passe en AuthAuthenticated (le routeur redirige vers le dashboard).
  Future<void> login(String email, String password) async {
    state = const AuthLoading();
    try {
      final user = await _repository.login(email, password);
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(_extractErrorMessage(e));
    }
  }

  /// Inscription d'un nouvel utilisateur.
  /// L'utilisateur est automatiquement connecté après inscription.
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

  /// Déconnexion de l'utilisateur.
  /// Supprime les tokens en local et révoque côté serveur.
  Future<void> logout() async {
    state = const AuthLoading();
    try {
      await _repository.logout();
    } catch (_) {
      // On déconnecte localement dans tous les cas.
    }
    state = const AuthUnauthenticated();
  }

  /// Extrait un message d'erreur lisible depuis une exception Dio ou autre.
  String _extractErrorMessage(dynamic error) {
    if (error.toString().contains('DioException')) {
      if (error.toString().contains('connection refused') ||
          error.toString().contains('SocketException')) {
        return 'Impossible de se connecter au serveur. Vérifiez que le backend est lancé.';
      }
      if (error.toString().contains('401')) {
        return 'Email ou mot de passe incorrect.';
      }
      if (error.toString().contains('409')) {
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
