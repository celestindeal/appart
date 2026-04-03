import 'package:intl/intl.dart';

/// Extensions utilitaires sur DateTime.
extension DateExtensions on DateTime {
  /// Formate en date française : « 02 avril 2026 ».
  String get toFrenchDate {
    return DateFormat('dd MMMM yyyy', 'fr_FR').format(this);
  }

  /// Formate en date et heure françaises : « 02 avril 2026 à 14:30 ».
  String get toFrenchDateTime {
    return '${DateFormat('dd MMMM yyyy', 'fr_FR').format(this)} à ${DateFormat('HH:mm').format(this)}';
  }

  /// Retourne une durée relative en français : « il y a 3 jours ».
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'à l\'instant';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return 'il y a $minutes min';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return 'il y a $hours h';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return 'il y a $days j';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'il y a $weeks sem.';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'il y a $months mois';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'il y a $years an${years > 1 ? 's' : ''}';
    }
  }

  /// Vérifie si la date est aujourd'hui.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Vérifie si deux dates tombent le même jour.
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Calcule le nombre de jours restants jusqu'à une date future.
  /// Retourne un nombre négatif si la date est dans le passé.
  int get daysUntil {
    final now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final target = DateTime(year, month, day);
    return target.difference(now).inDays;
  }
}
