/// Extensions utilitaires sur les chaînes de caractères.
extension StringExtensions on String {
  /// Met la première lettre en majuscule.
  /// ```dart
  /// 'bonjour'.capitalize // 'Bonjour'
  /// ```
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Vérifie si la chaîne est un e-mail valide.
  bool get isValidEmail {
    final regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return regex.hasMatch(this);
  }

  /// Vérifie si la chaîne est un numéro de téléphone français valide.
  bool get isValidPhone {
    final regex = RegExp(r'^(?:\+33|0)\s?[1-9](?:[\s.-]?\d{2}){4}$');
    return regex.hasMatch(replaceAll(' ', ''));
  }

  /// Convertit la chaîne en slug URL.
  /// ```dart
  /// 'Mon Bel Appartement!'.toSlug // 'mon-bel-appartement'
  /// ```
  String get toSlug {
    return toLowerCase()
        .replaceAll(RegExp(r'[àáâãäå]'), 'a')
        .replaceAll(RegExp(r'[èéêë]'), 'e')
        .replaceAll(RegExp(r'[ìíîï]'), 'i')
        .replaceAll(RegExp(r'[òóôõö]'), 'o')
        .replaceAll(RegExp(r'[ùúûü]'), 'u')
        .replaceAll(RegExp(r'[ç]'), 'c')
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'[\s]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  /// Tronque la chaîne à [maxLength] caractères avec des points de suspension.
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }
}
