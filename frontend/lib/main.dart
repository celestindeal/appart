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
import 'core/storage/token_cache.dart';
import 'features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/properties/data/datasources/property_remote_datasource_impl.dart';
import 'features/properties/data/repositories/property_repository_impl.dart';
import 'features/properties/presentation/providers/property_provider.dart';

/// Point d'entrée de l'application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);

  const secureStorage = FlutterSecureStorage();

  // Cache mémoire des tokens — contourne le bug OperationError de
  // flutter_secure_storage sur web en évitant les lectures répétées.
  final tokenCache = TokenCache(secureStorage: secureStorage);
  await tokenCache.loadFromStorage();

  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: AppConstants.apiTimeout,
      receiveTimeout: AppConstants.apiTimeout,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );

  final authRemoteDataSource = AuthRemoteDataSourceImpl(dio: dio);
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    tokenCache: tokenCache,
  );

  final propertyRemoteDatasource = PropertyRemoteDatasourceImpl(dio: dio);
  final propertyRepository = PropertyRepositoryImpl(
    remoteDatasource: propertyRemoteDatasource,
  );

  // Container unique partagé entre l'intercepteur et l'arbre widget.
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      propertyRepositoryProvider.overrideWithValue(propertyRepository),
    ],
  );

  // L'intercepteur utilise un Dio dédié pour le refresh (pas de récursion).
  // onAuthExpired force le logout quand le refresh token est invalide.
  dio.interceptors.addAll([
    AuthInterceptor(
      tokenCache: tokenCache,
      dio: dio,
      onAuthExpired: () {
        container.read(authStateProvider.notifier).logout();
      },
    ),
    LoggingInterceptor(),
  ]);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const ImmoManagerApp(),
    ),
  );
}

/// Widget racine de l'application.
class ImmoManagerApp extends ConsumerStatefulWidget {
  const ImmoManagerApp({super.key});

  @override
  ConsumerState<ImmoManagerApp> createState() => _ImmoManagerAppState();
}

class _ImmoManagerAppState extends ConsumerState<ImmoManagerApp> {
  bool _authChecked = false;

  @override
  Widget build(BuildContext context) {
    final router = ref.read(appRouterProvider);

    if (!_authChecked) {
      _authChecked = true;
      Future.microtask(
        () => ref.read(authStateProvider.notifier).checkAuthStatus(),
      );
    }

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
}
