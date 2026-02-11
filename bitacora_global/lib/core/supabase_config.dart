import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

/// Configuración y cliente singleton de Supabase
class SupabaseConfig {
  // Credenciales de Supabase - Proyecto: Bitacora Digital (daldtoaoqaxyiqgkfoin)
  // Dashboard: https://supabase.com/dashboard/project/daldtoaoqaxyiqgkfoin/settings/api
  static const String supabaseUrl = 'https://daldtoaoqaxyiqgkfoin.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRhbGR0b2FvcWF4eWlxZ2tmb2luIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA3NjE0NDYsImV4cCI6MjA4NjMzNzQ0Nn0.Kwnu4-2jIgCBEbQm88OQ_vBcJavNdvRL9FoUqo451PU';

  static bool _initialized = false;

  /// Inicializa Supabase - llamar en main.dart antes de runApp
  static Future<void> initialize() async {
    if (_initialized) return;

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: false,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.error,
      ),
    );

    _initialized = true;

    if (kDebugMode) {
      print('✅ Supabase inicializado correctamente');
    }
  }

  /// Cliente de Supabase singleton
  static SupabaseClient get client => Supabase.instance.client;

  /// Usuario actual autenticado
  static User? get currentUser => client.auth.currentUser;

  /// Sesión actual
  static Session? get currentSession => client.auth.currentSession;

  /// ¿Hay usuario autenticado?
  static bool get isAuthenticated => currentUser != null;

  /// Stream de cambios de autenticación
  static Stream<AuthState> get authStateChanges =>
      client.auth.onAuthStateChange;
}
