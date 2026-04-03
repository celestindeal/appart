import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/properties/presentation/pages/properties_list_page.dart';
import '../../features/properties/presentation/pages/property_detail_page.dart';
import '../../features/properties/presentation/pages/property_form_page.dart';
import '../../features/properties/presentation/pages/profitability_calculator_page.dart';
import '../../features/purchase/presentation/pages/purchase_projects_page.dart';
import '../../features/purchase/presentation/pages/purchase_detail_page.dart';
import '../../features/renovation/presentation/pages/renovation_projects_page.dart';
import '../../features/renovation/presentation/pages/renovation_detail_page.dart';
import '../../features/tenants/presentation/pages/tenants_list_page.dart';
import '../../features/tenants/presentation/pages/tenant_detail_page.dart';
import '../../features/tenants/presentation/pages/tenant_form_page.dart';
import '../../features/business/presentation/pages/business_dashboard_page.dart';
import '../../features/business/presentation/pages/accounting_page.dart';
import '../../features/business/presentation/pages/contacts_page.dart';
import '../../core/widgets/app_shell.dart';

/// Noms des routes pour la navigation type-safe.
abstract final class RouteNames {
  // Auth
  static const String login = 'login';
  static const String register = 'register';

  // Dashboard
  static const String dashboard = 'dashboard';

  // Properties
  static const String properties = 'properties';
  static const String propertyDetail = 'property-detail';
  static const String propertyCreate = 'property-create';
  static const String propertyEdit = 'property-edit';
  static const String profitabilityCalculator = 'profitability-calculator';

  // Purchase
  static const String purchaseProjects = 'purchase-projects';
  static const String purchaseDetail = 'purchase-detail';

  // Renovation
  static const String renovationProjects = 'renovation-projects';
  static const String renovationDetail = 'renovation-detail';

  // Tenants
  static const String tenants = 'tenants';
  static const String tenantDetail = 'tenant-detail';
  static const String tenantCreate = 'tenant-create';
  static const String tenantEdit = 'tenant-edit';

  // Business
  static const String business = 'business';
  static const String accounting = 'accounting';
  static const String contacts = 'contacts';
}

/// Chemins des routes.
abstract final class RoutePaths {
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/';
  static const String properties = '/properties';
  static const String propertyDetail = '/properties/:id';
  static const String propertyCreate = '/properties/create';
  static const String propertyEdit = '/properties/:id/edit';
  static const String profitabilityCalculator = '/calculator';
  static const String purchaseProjects = '/purchases';
  static const String purchaseDetail = '/purchases/:id';
  static const String renovationProjects = '/renovations';
  static const String renovationDetail = '/renovations/:id';
  static const String tenants = '/tenants';
  static const String tenantDetail = '/tenants/:id';
  static const String tenantCreate = '/tenants/create';
  static const String tenantEdit = '/tenants/:id/edit';
  static const String business = '/business';
  static const String accounting = '/business/accounting';
  static const String contacts = '/business/contacts';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Provider du GoRouter qui réagit à l'état d'authentification.
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.login,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthenticated = authState is AuthAuthenticated;
      final isOnAuthPage = state.matchedLocation == RoutePaths.login ||
          state.matchedLocation == RoutePaths.register;

      // Pas encore initialisé → rester sur la page actuelle.
      if (authState is AuthInitial || authState is AuthLoading) {
        return null;
      }

      // Non connecté et pas sur une page d'auth → rediriger vers login.
      if (!isAuthenticated && !isOnAuthPage) {
        return RoutePaths.login;
      }

      // Connecté mais sur une page d'auth → rediriger vers dashboard.
      if (isAuthenticated && isOnAuthPage) {
        return RoutePaths.dashboard;
      }

      return null;
    },
    routes: [
      // ── Auth routes (sans shell) ───────────────────────────
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.register,
        builder: (context, state) => const RegisterPage(),
      ),

      // ── Main app routes (avec shell/navigation) ────────────
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: RoutePaths.dashboard,
            name: RouteNames.dashboard,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardPage(),
            ),
          ),
          GoRoute(
            path: RoutePaths.properties,
            name: RouteNames.properties,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PropertiesListPage(),
            ),
            routes: [
              GoRoute(
                path: 'create',
                name: RouteNames.propertyCreate,
                builder: (context, state) => const PropertyFormPage(),
              ),
              GoRoute(
                path: ':id',
                name: RouteNames.propertyDetail,
                builder: (context, state) => PropertyDetailPage(
                  propertyId: state.pathParameters['id']!,
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: RouteNames.propertyEdit,
                    builder: (context, state) => PropertyFormPage(
                      propertyId: state.pathParameters['id'],
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: RoutePaths.profitabilityCalculator,
            name: RouteNames.profitabilityCalculator,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfitabilityCalculatorPage(),
            ),
          ),
          GoRoute(
            path: RoutePaths.purchaseProjects,
            name: RouteNames.purchaseProjects,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PurchaseProjectsPage(),
            ),
            routes: [
              GoRoute(
                path: ':id',
                name: RouteNames.purchaseDetail,
                builder: (context, state) => PurchaseDetailPage(
                  projectId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: RoutePaths.renovationProjects,
            name: RouteNames.renovationProjects,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: RenovationProjectsPage(),
            ),
            routes: [
              GoRoute(
                path: ':id',
                name: RouteNames.renovationDetail,
                builder: (context, state) => RenovationDetailPage(
                  projectId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: RoutePaths.tenants,
            name: RouteNames.tenants,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TenantsListPage(),
            ),
            routes: [
              GoRoute(
                path: 'create',
                name: RouteNames.tenantCreate,
                builder: (context, state) => const TenantFormPage(),
              ),
              GoRoute(
                path: ':id',
                name: RouteNames.tenantDetail,
                builder: (context, state) => TenantDetailPage(
                  tenantId: state.pathParameters['id']!,
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: RouteNames.tenantEdit,
                    builder: (context, state) => TenantFormPage(
                      tenantId: state.pathParameters['id'],
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: RoutePaths.business,
            name: RouteNames.business,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: BusinessDashboardPage(),
            ),
            routes: [
              GoRoute(
                path: 'accounting',
                name: RouteNames.accounting,
                builder: (context, state) => const AccountingPage(),
              ),
              GoRoute(
                path: 'contacts',
                name: RouteNames.contacts,
                builder: (context, state) => const ContactsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
