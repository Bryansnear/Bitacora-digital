import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

// Supabase
import 'core/app_initializer.dart';
import 'core/app_router.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/bitacora_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  // Inicializar Supabase
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

  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider();
    _bitacoraProvider = BitacoraProvider();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authProvider),
        ChangeNotifierProvider.value(value: _bitacoraProvider),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          // Crear router con el provider de auth
          final router = AppRouter.createRouter(authProvider);

          return MaterialApp.router(
            title: 'Bitácora Digital',
            debugShowCheckedModeBanner: false,
            scrollBehavior: _CustomScrollBehavior(),

            // Tema
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF1E88E5),
                brightness: Brightness.light,
              ),
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
              ),
              cardTheme: CardThemeData(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            // Localization (español)
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('es', 'ES'),
            ],
            locale: const Locale('es', 'ES'),

            // Router
            routerConfig: router,
          );
        },
      ),
    );
  }
}

/// Scroll behavior que permite arrastrar con mouse (para web)
class _CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
