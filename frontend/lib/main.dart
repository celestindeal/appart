import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'config/constants/app_constants.dart';
import 'config/routes/app_routes.dart';
import 'config/theme/app_theme.dart';
import 'core/network/interceptors/auth_interceptor.dart';
import 'core/network/interceptors/logging_interceptor.dart';
import 'features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

/// Point d'entrée de l'application.
/// Initialise les dépendances (Dio, stockage sécurisé, repository auth)
/// puis lance l'app Flutter avec Riverpod.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation du formatage des dates en français.
  await initializeDateFormatting('fr_FR', null);

  // Stockage sécurisé pour les tokens JWT.
  const secureStorage = FlutterSecureStorage();

  // Client HTTP Dio configuré avec l'URL de base de l'API.
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: AppConstants.apiTimeout,
      receiveTimeout: AppConstants.apiTimeout,
      sendTimeout: AppConstants.apiTimeout,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );

  // Ajout des intercepteurs : auth (JWT + refresh auto) et logging.
  dio.interceptors.addAll([
    AuthInterceptor(secureStorage: secureStorage, dio: dio),
    LoggingInterceptor(),
  ]);

  // Source de données distante pour l'authentification.
  final authRemoteDataSource = AuthRemoteDataSourceImpl(dio: dio);

  // Repository d'auth qui gère tokens + appels API.
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    secureStorage: secureStorage,
  );

  runApp(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
      ],
      child: const ImmoManagerApp(),
    ),
  );
}

/// Widget racine de l'application.
/// Configure le thème Material 3, le routeur GoRouter et la locale française.
/// Déclenche la vérification de l'état d'authentification au premier build.
class ImmoManagerApp extends ConsumerWidget {
  const ImmoManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Récupère le routeur qui réagit à l'état d'auth.
    final router = ref.watch(appRouterProvider);

    // Vérifie si l'utilisateur a un token valide au démarrage.
    ref.listen(authStateProvider, (previous, next) {});
    _checkAuth(ref);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      routerConfig: router,
      locale: const Locale('fr', 'FR'),
    );
  }

  /// Lance la vérification d'auth une seule fois au démarrage.
  void _checkAuth(WidgetRef ref) {
    final authState = ref.read(authStateProvider);
    if (authState is AuthInitial) {
      Future.microtask(
        () => ref.read(authStateProvider.notifier).checkAuthStatus(),
      );
    }
  }
}
