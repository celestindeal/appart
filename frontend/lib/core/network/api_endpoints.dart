/// Constantes des endpoints API organisées par fonctionnalité.
abstract final class ApiEndpoints {
  // ── Auth ──────────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';

  // ── Properties (Biens) ────────────────────────────────────
  static const String properties = '/properties';
  static String propertyById(String id) => '/properties/$id';
  static const String propertiesSearch = '/properties/search';
  static String propertyProfitability(String id) =>
      '/properties/$id/profitability';

  // ── Purchase (Achats) ─────────────────────────────────────
  static const String purchases = '/purchases';
  static String purchaseById(String id) => '/purchases/$id';
  static String purchaseMilestones(String id) => '/purchases/$id/milestones';

  // ── Renovation (Travaux) ──────────────────────────────────
  static const String renovations = '/renovations';
  static String renovationById(String id) => '/renovations/$id';
  static String renovationTasks(String id) => '/renovations/$id/tasks';
  static String renovationBudget(String id) => '/renovations/$id/budget';

  // ── Tenants (Locataires) ──────────────────────────────────
  static const String tenants = '/tenants';
  static String tenantById(String id) => '/tenants/$id';
  static String tenantDocuments(String id) => '/tenants/$id/documents';
  static String tenantPayments(String id) => '/tenants/$id/payments';
  static String tenantReminders(String id) => '/tenants/$id/reminders';

  // ── Business (Gestion) ────────────────────────────────────
  static const String accounting = '/business/accounting';
  static const String contacts = '/business/contacts';
  static const String calendar = '/business/calendar';
}
