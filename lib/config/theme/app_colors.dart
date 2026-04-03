import 'package:flutter/material.dart';

/// Palette de couleurs de l'application ImmoManager.
/// Inspirée d'un design professionnel immobilier : bleu confiance + accents modernes.
abstract final class AppColors {
  // ── Primary ──────────────────────────────────────────────
  static const Color primary = Color(0xFF1A56DB);
  static const Color primaryLight = Color(0xFF3F83F8);
  static const Color primaryDark = Color(0xFF1E40AF);
  static const Color primarySurface = Color(0xFFEBF5FF);

  // ── Secondary ────────────────────────────────────────────
  static const Color secondary = Color(0xFF0E9F6E);
  static const Color secondaryLight = Color(0xFF31C48D);
  static const Color secondaryDark = Color(0xFF046C4E);
  static const Color secondarySurface = Color(0xFFF3FAF7);

  // ── Accent ───────────────────────────────────────────────
  static const Color accent = Color(0xFFF59E0B);
  static const Color accentLight = Color(0xFFFBBF24);
  static const Color accentDark = Color(0xFFD97706);

  // ── Neutrals ─────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F4F6);
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);
  static const Color disabled = Color(0xFF9CA3AF);

  // ── Text ─────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);

  // ── Status ───────────────────────────────────────────────
  static const Color success = Color(0xFF0E9F6E);
  static const Color successLight = Color(0xFFDEF7EC);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFDF6B2);
  static const Color error = Color(0xFFE02424);
  static const Color errorLight = Color(0xFFFDE8E8);
  static const Color info = Color(0xFF1A56DB);
  static const Color infoLight = Color(0xFFEBF5FF);

  // ── Dark Mode ────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF111827);
  static const Color darkSurface = Color(0xFF1F2937);
  static const Color darkSurfaceVariant = Color(0xFF374151);
  static const Color darkBorder = Color(0xFF4B5563);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFFD1D5DB);
  static const Color darkTextTertiary = Color(0xFF9CA3AF);

  // ── Charts & Graphs ──────────────────────────────────────
  static const List<Color> chartColors = [
    Color(0xFF1A56DB),
    Color(0xFF0E9F6E),
    Color(0xFFF59E0B),
    Color(0xFFE02424),
    Color(0xFF7C3AED),
    Color(0xFFEC4899),
    Color(0xFF06B6D4),
    Color(0xFFF97316),
  ];
}
