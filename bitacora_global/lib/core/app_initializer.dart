import 'package:flutter/foundation.dart';
import 'supabase_config.dart';

/// Inicializa la app y determina la ruta inicial
class AppInitializer {
  static bool _initialized = false;
  static bool _hasUsers = false;
  static bool _isLoggedIn = false;

  /// Inicializa Supabase y verifica estado
  static Future<void> initialize() async {
    // Siempre re-verificar (no cachear el estado previo)
    if (!_initialized) {
      await SupabaseConfig.initialize();
      _initialized = true;
    }

    // Verificar si hay usuarios en la BD
    _hasUsers = await _checkHasUsers();
    debugPrint('🔍 AppInitializer: _hasUsers = $_hasUsers');

    // Verificar si hay sesión activa
    _isLoggedIn = SupabaseConfig.currentUser != null;
    debugPrint('🔍 AppInitializer: _isLoggedIn = $_isLoggedIn');
    debugPrint('🔍 AppInitializer: needsSetup = ${!_hasUsers}');
  }

  /// Verifica si hay usuarios registrados (usa RPC SECURITY DEFINER para bypass RLS)
  static Future<bool> _checkHasUsers() async {
    // Método 1: RPC SECURITY DEFINER
    try {
      final result = await SupabaseConfig.client.rpc('check_has_users');
      debugPrint('🔍 check_has_users RPC raw result: $result (${result.runtimeType})');
      if (result == true) return true;
      if (result is bool) return result;
      if (result is int) return result > 0;
      if (result is String) return result.toLowerCase() == 'true';
      if (result != null) return true;
    } catch (e) {
      debugPrint('⚠️ check_has_users RPC error: $e');
    }

    // Método 2: Query directa (puede fallar por RLS si no hay sesión)
    try {
      final response =
          await SupabaseConfig.client.from('users').select('id').limit(1);
      debugPrint('🔍 Fallback users query: $response');
      if (response is List) return response.isNotEmpty;
    } catch (e) {
      debugPrint('⚠️ Fallback users query error: $e');
    }

    // Método 3: Contar auth users via query a auth.users no es posible, 
    // pero si hay sesión activa, es que hay al menos un usuario
    if (SupabaseConfig.currentUser != null) {
      debugPrint('🔍 Hay sesión activa, hay usuarios');
      return true;
    }

    debugPrint('⚠️ Todos los métodos fallaron, asumiendo sin usuarios');
    return false;
  }

  /// ¿Es la primera vez que se abre la app?
  static bool get needsSetup => !_hasUsers;

  /// ¿Hay sesión activa?
  static bool get isLoggedIn => _isLoggedIn;

  /// Marcar que el setup ya se completó (evita reconsultar con RLS)
  static void markSetupComplete() {
    _hasUsers = true;
  }

  /// Ruta inicial basada en el estado
  static String get initialRoute {
    if (!_hasUsers) {
      return '/setup';
    }
    if (_isLoggedIn) {
      return '/';
    }
    return '/login';
  }

  /// Refrescar estado después de setup
  static Future<void> refresh() async {
    _hasUsers = await _checkHasUsers();
    _isLoggedIn = SupabaseConfig.currentUser != null;
  }
}
