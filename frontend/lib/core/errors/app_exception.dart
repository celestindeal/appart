/// Exceptions personnalisées de l'application ImmoManager.

/// Exception de base de l'application.
class AppException implements Exception {
  const AppException({
    required this.message,
    this.statusCode,
  });

  final String message;
  final int? statusCode;

  @override
  String toString() => 'AppException(message: $message, statusCode: $statusCode)';
}

/// Exception liée au réseau (pas de connexion, timeout, etc.).
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Erreur de connexion réseau',
    super.statusCode,
  });

  @override
  String toString() => 'NetworkException(message: $message, statusCode: $statusCode)';
}

/// Exception retournée par le serveur (5xx, réponses inattendues).
class ServerException extends AppException {
  const ServerException({
    super.message = 'Erreur serveur',
    super.statusCode,
  });

  @override
  String toString() => 'ServerException(message: $message, statusCode: $statusCode)';
}

/// Exception liée au cache local (lecture/écriture échouée).
class CacheException extends AppException {
  const CacheException({
    super.message = 'Erreur de cache local',
    super.statusCode,
  });

  @override
  String toString() => 'CacheException(message: $message, statusCode: $statusCode)';
}

/// Exception liée à l'authentification (token expiré, non autorisé).
class AuthException extends AppException {
  const AuthException({
    super.message = 'Erreur d\'authentification',
    super.statusCode,
  });

  @override
  String toString() => 'AuthException(message: $message, statusCode: $statusCode)';
}

/// Exception de validation de données (formulaire, entrée utilisateur).
class ValidationException extends AppException {
  const ValidationException({
    super.message = 'Erreur de validation',
    super.statusCode,
  });

  @override
  String toString() => 'ValidationException(message: $message, statusCode: $statusCode)';
}
