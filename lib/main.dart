import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:immo_manager/features/auth/data/datasources/AuthRemoteDataSourceImpl.dart';
import 'package:immo_manager/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:immo_manager/features/auth/presentation/providers/auth_provider.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'config/routes/app_routes.dart';
import 'config/theme/app_theme.dart';
import 'config/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('fr_FR', null);

  runApp(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          AuthRepositoryImpl(
            remoteDataSource: AuthRemoteDataSourceImpl(),
            secureStorage: FlutterSecureStorage(),
          ),
        ),
      ],
      child: const ImmoManagerApp(),
    ),
  );
}

class ImmoManagerApp extends ConsumerWidget {
  const ImmoManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      routerConfig: appRouter,
      locale: const Locale('fr', 'FR'),
    );
  }
}
