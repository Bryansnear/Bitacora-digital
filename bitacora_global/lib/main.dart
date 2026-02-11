import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/app_initializer.dart';
import 'core/app_router.dart';
import 'providers/auth_provider.dart';
import 'providers/bitacora_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  // Capturar errores de Futures no esperados (ej. Realtime WebSocket)
  FlutterError.onError = (details) {
    debugPrint('⚠️ FlutterError: ${details.exception}');
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('⚠️ Platform error: $error');
    return true; // Marcar como manejado para evitar crash
  };

  await AppInitializer.initialize();

  runApp(const BitacoraApp());
}

class BitacoraApp extends StatefulWidget {
  const BitacoraApp({super.key});

  @override
  State<BitacoraApp> createState() => _BitacoraAppState();
}

class _BitacoraAppState extends State<BitacoraApp> {
  late AuthProvider _authProvider;
  late BitacoraProvider _bitacoraProvider;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider();
    _bitacoraProvider = BitacoraProvider();
    // Crear el router UNA sola vez para evitar cerrar StreamSinks internos
    _router = AppRouter.createRouter(_authProvider);
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authProvider),
        ChangeNotifierProvider.value(value: _bitacoraProvider),
      ],
      child: MaterialApp.router(
        title: 'Bitacora Digital',
        debugShowCheckedModeBanner: false,
        scrollBehavior: _CustomScrollBehavior(),
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1E88E5),
            brightness: Brightness.light,
          ),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es', 'ES')],
        locale: const Locale('es', 'ES'),
        routerConfig: _router,
      ),
    );
  }
}

class _CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
