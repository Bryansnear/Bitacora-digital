import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';
import '../models/user_profile.dart';

/// Controlador de autenticación con Supabase
class AuthController extends ChangeNotifier {
  static final AuthController _instance = AuthController._internal();
  factory AuthController() => _instance;
  AuthController._internal();

  UserProfile? _currentProfile;
  bool _isLoading = false;
  String? _error;

  UserProfile? get currentProfile => _currentProfile;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => SupabaseConfig.currentUser != null;
  String? get error => _error;
  String? get userId => SupabaseConfig.currentUser?.id;

  /// Iniciar sesión con email/password
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await SupabaseConfig.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        _error = 'Credenciales inválidas';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Cargar perfil del usuario
      await loadUserProfile();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Registrar nuevo usuario (solo admins pueden hacer esto)
  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
    String rol = 'vigilante',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await SupabaseConfig.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'display_name': displayName,
          'full_name': displayName,
        },
      );

      if (response.user == null) {
        _error = 'No se pudo crear el usuario';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Actualizar rol si no es vigilante (predeterminado)
      if (rol != 'vigilante') {
        await SupabaseConfig.client.from('users').update({
          'rol': rol,
        }).eq('id', response.user!.id);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    try {
      await SupabaseConfig.client.auth.signOut();
      _currentProfile = null;
      notifyListeners();
    } catch (e) {
      _error = _parseError(e);
      notifyListeners();
    }
  }

  /// Cargar perfil del usuario actual
  Future<void> loadUserProfile() async {
    final userId = SupabaseConfig.currentUser?.id;
    if (userId == null) {
      _currentProfile = null;
      return;
    }

    try {
      final response = await SupabaseConfig.client
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response != null) {
        _currentProfile = UserProfile.fromJson(response);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user profile: $e');
      }
    }
  }

  /// Enviar correo de recuperación de contraseña
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await SupabaseConfig.client.auth.resetPasswordForEmail(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Escuchar cambios de autenticación
  void listenToAuthChanges(void Function(AuthState) callback) {
    SupabaseConfig.client.auth.onAuthStateChange.listen(callback);
  }

  String _parseError(dynamic error) {
    final msg = error.toString().toLowerCase();
    if (msg.contains('invalid login credentials')) {
      return 'Correo o contraseña incorrectos';
    }
    if (msg.contains('email not confirmed')) {
      return 'Por favor confirma tu correo electrónico';
    }
    if (msg.contains('user already registered')) {
      return 'Este correo ya está registrado';
    }
    return 'Error: ${error.toString()}';
  }
}
