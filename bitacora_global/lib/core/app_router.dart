import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/setup_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/guardia/home_guardia_screen.dart';
import '../screens/guardia/apertura_screen.dart';
import '../screens/guardia/registro_screen.dart';
import '../screens/guardia/novedad_screen.dart';
import '../screens/guardia/cierre_screen.dart';
import '../screens/guardia/visitasall_screen.dart';
import '../screens/guardia/supervision_relevo_screen.dart';
import '../screens/admin/dashboard_screen.dart';
import '../screens/admin/bitacora_detail_screen.dart';
import '../screens/admin/instituciones_screen.dart';
import '../screens/admin/sucursales_screen.dart';
import '../screens/admin/vigilantes_screen.dart';
import '../screens/shared/profile_screen.dart';
import '../core/app_initializer.dart';

/// Router principal de la aplicación
class AppRouter {
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      refreshListenable: authProvider,
      initialLocation: '/',
      debugLogDiagnostics: true,
      redirect: (context, state) {
        final isAuthenticated = authProvider.isAuthenticated;
        final isLoading = authProvider.isLoading;
        final isLoginRoute = state.matchedLocation == '/login';
        final isSetupRoute = state.matchedLocation == '/setup';

        // Si está cargando, no redirigir (excepto si está en setup sin necesitarlo)
        if (isLoading) {
          // Sacar de /setup inmediatamente si ya no se necesita
          if (isSetupRoute && !AppInitializer.needsSetup) {
            return '/login';
          }
          return null;
        }

        // Si necesita setup inicial, ir a setup
        if (AppInitializer.needsSetup && !isSetupRoute) {
          return '/setup';
        }

        // Si NO necesita setup pero está en setup, salir de ahí
        if (!AppInitializer.needsSetup && isSetupRoute) {
          return isAuthenticated ? '/' : '/login';
        }

        // Si no está autenticado y no está en login, ir a login
        if (!isAuthenticated && !isLoginRoute) {
          return '/login';
        }

        // Si está autenticado y está en login, ir a home
        if (isAuthenticated && isLoginRoute) {
          return '/';
        }

        return null;
      },
      routes: [
        // Ruta inicial - redirige según rol
        GoRoute(
          path: '/',
          builder: (context, state) {
            final authProvider = context.read<AuthProvider>();
            final user = authProvider.currentUser;

            // Determinar pantalla según rol
            if (user?.rol == 'administrador' || user?.rol == 'jefe_seguridad') {
              return const DashboardScreen();
            }
            return const HomeGuardiaScreen();
          },
        ),

        // Auth
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/setup',
          name: 'setup',
          builder: (context, state) => const SetupScreen(),
        ),
        GoRoute(
          path: '/forgot-password',
          name: 'forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),

        // Guardia
        GoRoute(
          path: '/guardia',
          name: 'guardia-home',
          builder: (context, state) => const HomeGuardiaScreen(),
          routes: [
            GoRoute(
              path: 'apertura',
              name: 'apertura',
              builder: (context, state) => const AperturaScreen(),
            ),
            GoRoute(
              path: 'registro',
              name: 'registro',
              builder: (context, state) => const RegistroScreen(),
            ),
            GoRoute(
              path: 'novedad',
              name: 'novedad',
              builder: (context, state) => const NovedadScreen(),
            ),
            GoRoute(
              path: 'cierre',
              name: 'cierre',
              builder: (context, state) => const CierreScreen(),
            ),
            GoRoute(
              path: 'visitasall',
              name: 'visitasall',
              builder: (context, state) => const VisitasAllScreen(),
            ),
            GoRoute(
              path: 'supervision',
              name: 'supervision',
              builder: (context, state) =>
                  const SupervisionRelevoScreen(),
            ),
          ],
        ),

        // Admin
        GoRoute(
          path: '/admin',
          name: 'admin-dashboard',
          builder: (context, state) => const DashboardScreen(),
          routes: [
            GoRoute(
              path: 'bitacora/:id',
              name: 'bitacora-detail',
              builder: (context, state) {
                final bitacoraId = state.pathParameters['id']!;
                return BitacoraDetailScreen(bitacoraId: bitacoraId);
              },
            ),
            GoRoute(
              path: 'instituciones',
              name: 'instituciones',
              builder: (context, state) => const InstitucionesScreen(),
            ),
            GoRoute(
              path: 'sucursales/:institucionId',
              name: 'sucursales',
              builder: (context, state) {
                final institucionId = state.pathParameters['institucionId']!;
                final nombre = state.uri.queryParameters['nombre'];
                return SucursalesScreen(
                  institucionId: institucionId,
                  institucionNombre: nombre,
                );
              },
            ),
            GoRoute(
              path: 'vigilantes',
              name: 'vigilantes',
              builder: (context, state) => const VigilantesScreen(),
            ),
          ],
        ),

        // Shared
        GoRoute(
          path: '/perfil',
          name: 'perfil',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Página no encontrada: ${state.uri}'),
        ),
      ),
    );
  }
}
