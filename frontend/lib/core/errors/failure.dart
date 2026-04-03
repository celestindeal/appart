import 'package:equatable/equatable.dart';

/// Classe de base pour les erreurs métier (pattern Either/Result).
abstract class Failure extends Equatable {
  const Failure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Erreur provenant du serveur distant.
class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Erreur serveur'});
}

/// Erreur de connexion réseau.
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Erreur de connexion réseau'});
}

/// Erreur de cache local.
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Erreur de cache local'});
}

/// Erreur d'authentification.
class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Erreur d\'authentification'});
}

/// Erreur de validation de données.
class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'Erreur de validation'});
}
