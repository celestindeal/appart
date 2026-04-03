import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme/app_colors.dart';

/// Scaffold principal avec navigation responsive.
/// Bottom navigation sur mobile, NavigationRail sur desktop.
class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  static const _tabs = <_NavTab>[
    _NavTab(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
      path: '/',
    ),
    _NavTab(
      icon: Icons.home_work_outlined,
      activeIcon: Icons.home_work,
      label: 'Biens',
      path: '/properties',
    ),
    _NavTab(
      icon: Icons.people_outline,
      activeIcon: Icons.people,
      label: 'Locataires',
      path: '/tenants',
    ),
    _NavTab(
      icon: Icons.construction_outlined,
      activeIcon: Icons.construction,
      label: 'Travaux',
      path: '/renovations',
    ),
    _NavTab(
      icon: Icons.business_center_outlined,
      activeIcon: Icons.business_center,
      label: 'Gestion',
      path: '/business',
    ),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    for (var i = _tabs.length - 1; i >= 0; i--) {
      if (_tabs[i].path == '/' && location == '/') return i;
      if (_tabs[i].path != '/' && location.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  void _onTabSelected(BuildContext context, int index) {
    context.go(_tabs[index].path);
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _currentIndex(context);
    final isDesktop = MediaQuery.sizeOf(context).width >= 800;

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (i) => _onTabSelected(context, i),
              labelType: NavigationRailLabelType.all,
              backgroundColor: AppColors.surface,
              selectedIconTheme: const IconThemeData(color: AppColors.primary),
              selectedLabelTextStyle: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedIconTheme:
                  const IconThemeData(color: AppColors.textSecondary),
              unselectedLabelTextStyle: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Icon(
                  Icons.apartment,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              destinations: _tabs
                  .map(
                    (tab) => NavigationRailDestination(
                      icon: Icon(tab.icon),
                      selectedIcon: Icon(tab.activeIcon),
                      label: Text(tab.label),
                    ),
                  )
                  .toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }

    // Mobile : Bottom Navigation Bar
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (i) => _onTabSelected(context, i),
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primarySurface,
        destinations: _tabs
            .map(
              (tab) => NavigationDestination(
                icon: Icon(tab.icon),
                selectedIcon: Icon(tab.activeIcon, color: AppColors.primary),
                label: tab.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

/// Modèle interne pour les onglets de navigation.
class _NavTab {
  const _NavTab({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.path,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String path;
}
