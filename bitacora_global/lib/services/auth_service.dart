import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_config.dart';

/// Servicio de autenticación utilizando Supabase Auth
class AuthService {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Usuario actual
  User? get currentUser => _client.auth.currentUser;

  /// Stream de cambios de autenticación
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Iniciar sesión con email y contraseña
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Registrar nuevo usuario
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? displayName,
    String? phoneNumber,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {'display_name': displayName, 'phone_number': phoneNumber},
    );
  }

  /// Iniciar sesión con Google
  Future<bool> signInWithGoogle() async {
    final response = await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.bitacora://login-callback/',
    );
    return response;
  }

  /// Iniciar sesión con Apple
  Future<bool> signInWithApple() async {
    final response = await _client.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: 'io.supabase.bitacora://login-callback/',
    );
    return response;
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Enviar email para restablecer contraseña
  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  /// Actualizar contraseña
  Future<UserResponse> updatePassword(String newPassword) async {
    return await _client.auth.updateUser(UserAttributes(password: newPassword));
  }

  /// Verificar si el email ya existe
  Future<bool> emailExists(String email) async {
    // Supabase no tiene método directo, pero podemos intentar recuperación
    // y ver si tiene error
    try {
      await _client.auth.resetPasswordForEmail(email);
      return true;
    } catch (e) {
      return false;
    }
  }
}
