/// Constantes globales de l'application.
abstract final class AppConstants {
  // ── API ──────────────────────────────────────────────────
  static const String apiBaseUrl = 'http://localhost:5000/api';
  static const String mediaBaseUrl = 'http://localhost:5000';
  static const Duration apiTimeout = Duration(seconds: 30);

  // ── Storage Keys ─────────────────────────────────────────
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String themeKey = 'app_theme';
  static const String localeKey = 'app_locale';
  static const String onboardingKey = 'onboarding_completed';

  // ── Pagination ───────────────────────────────────────────
  static const int defaultPageSize = 20;

  // ── App Info ─────────────────────────────────────────────
  static const String appName = 'ImmoManager';
  static const String appVersion = '1.0.0';

  // ── Formats ──────────────────────────────────────────────
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String currencySymbol = '€';
  static const String currencyLocale = 'fr_FR';

  // ── Validation ───────────────────────────────────────────
  static const int minPasswordLength = 8;
  static const int maxNameLength = 100;
  static const int maxDescriptionLength = 2000;
  static const int maxAddressLength = 500;

  // ── File Upload ──────────────────────────────────────────
  static const int maxFileSizeMb = 25;
  static const List<String> allowedDocumentExtensions = [
    'pdf',
    'doc',
    'docx',
    'jpg',
    'jpeg',
    'png',
    'xls',
    'xlsx',
  ];

  // ── Notifications ────────────────────────────────────────
  static const int rentReminderDaysBefore = 3;
  static const int leaseExpiryReminderDays = 30;
}
