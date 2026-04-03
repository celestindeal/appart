import 'package:intl/intl.dart';

/// Extensions utilitaires sur les nombres.
extension NumExtensions on num {
  /// Formate le nombre en devise euro avec le locale français.
  /// ```dart
  /// 1500.50.toCurrency // '1 500,50 €'
  /// ```
  String get toCurrency {
    final formatter = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: '€',
      decimalDigits: 2,
    );
    return formatter.format(this);
  }

  /// Formate le nombre en pourcentage.
  /// ```dart
  /// 0.156.toPercentage // '15,6 %'
  /// 85.toPercentage    // '85 %' (si déjà en %)
  /// ```
  String toPercentage({int decimalDigits = 1, bool fromDecimal = true}) {
    final value = fromDecimal ? this * 100 : this;
    final formatter = NumberFormat.decimalPatternDigits(
      locale: 'fr_FR',
      decimalDigits: decimalDigits,
    );
    return '${formatter.format(value)}\u00A0%';
  }

  /// Formate le nombre en version compacte.
  /// ```dart
  /// 1500000.toCompact // '1,5 M'
  /// ```
  String get toCompact {
    final formatter = NumberFormat.compact(locale: 'fr_FR');
    return formatter.format(this);
  }
}
