import '../../config/constants/app_constants.dart';

/// Validateurs de formulaires réutilisables.
abstract final class Validators {
  /// Valide une adresse e-mail.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'L\'adresse e-mail est requise';
    }
    final regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!regex.hasMatch(value.trim())) {
      return 'Veuillez saisir une adresse e-mail valide';
    }
    return null;
  }

  /// Valide un mot de passe.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < AppConstants.minPasswordLength) {
      return 'Le mot de passe doit contenir au moins '
          '${AppConstants.minPasswordLength} caractères';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins une majuscule';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins un chiffre';
    }
    return null;
  }

  /// Valide un champ obligatoire.
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Ce champ'} est requis';
    }
    return null;
  }

  /// Valide un numéro de téléphone français.
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le numéro de téléphone est requis';
    }
    final cleaned = value.replaceAll(RegExp(r'[\s.-]'), '');
    final regex = RegExp(r'^(?:\+33|0)[1-9]\d{8}$');
    if (!regex.hasMatch(cleaned)) {
      return 'Veuillez saisir un numéro de téléphone valide';
    }
    return null;
  }

  /// Valide un code postal français (5 chiffres).
  static String? validatePostalCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le code postal est requis';
    }
    final regex = RegExp(r'^\d{5}$');
    if (!regex.hasMatch(value.trim())) {
      return 'Veuillez saisir un code postal valide (5 chiffres)';
    }
    return null;
  }

  /// Valide un prix (nombre positif).
  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le montant est requis';
    }
    final cleaned = value.replaceAll(RegExp(r'[\s€,]'), '.').replaceAll(' ', '');
    final number = double.tryParse(cleaned);
    if (number == null) {
      return 'Veuillez saisir un montant valide';
    }
    if (number < 0) {
      return 'Le montant ne peut pas être négatif';
    }
    return null;
  }
}
