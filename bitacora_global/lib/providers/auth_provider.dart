import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';
import '../services/bitacora_service.dart';

/// Provider de autenticación para manejar el estado del usuario.
/// Usa Supabase Realtime para mantener el perfil actualizado automáticamente.
class AuthProvider extends ChangeNotifier {
  final BitacoraService _service = BitacoraService();
  UserProfile? _currentUser;
  bool _isLoading = true;
  String? _error;
  StreamSubscription<UserProfile?>? _profileSubscription;

  UserProfile? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get error => _error;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    _isLoading = true;
    notifyListeners();

    // Escuchar cambios de autenticación.
    // En Supabase Flutter v2, onAuthStateChange emite `initialSession`
    // inmediatamente, así que NO necesitamos chequear currentSession aparte.
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      if ((event == AuthChangeEvent.initialSession ||
              event == AuthChangeEvent.signedIn ||
              event == AuthChangeEvent.tokenRefreshed) &&
          session != null) {
        _subscribeToProfile(session.user.id);
      } else if (event == AuthChangeEvent.signedOut) {
        _profileSubscription?.cancel();
        _profileSubscription = null;
        _currentUser = null;
        _isLoading = false;
        notifyListeners();
      } else if (event == AuthChangeEvent.initialSession &&
          session == null) {
        // No hay sesión activa
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  String? _subscribedUserId;

  /// Suscribirse al perfil del usuario vía Realtime
  void _subscribeToProfile(String userId) {
    // Evitar re-suscripción innecesaria al mismo usuario
    if (_subscribedUserId == userId && _profileSubscription != null) return;

    _profileSubscription?.cancel();
    _profileSubscription = null;
    _subscribedUserId = userId;

    try {
      _profileSubscription = _service.streamUserProfile(userId).listen(
        (profile) {
          _currentUser = profile;
          _isLoading = false;
          _error = null;
          notifyListeners();
        },
        onError: (e) {
          debugPrint('⚠️ Error en stream de perfil: $e');
          // En caso de error del stream, intentar carga one-shot
          _loadProfileFallback(userId);
        },
      );
    } catch (e) {
      debugPrint('⚠️ No se pudo crear stream de perfil: $e');
      _loadProfileFallback(userId);
    }
  }

  /// Fallback: cargar perfil con consulta one-shot si el stream falla
  Future<void> _loadProfileFallback(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();
      if (response != null) {
        _currentUser = UserProfile.fromJson(response);
      }
    } catch (e) {
      _error = 'Error cargando perfil: $e';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _subscribeToProfile(response.user!.id);
        return true;
      }
    } catch (e) {
      _error = 'Error de inicio de sesión: $e';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> signOut() async {
    _profileSubscription?.cancel();
    _profileSubscription = null;
    _subscribedUserId = null;
    await Supabase.instance.client.auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _profileSubscription?.cancel();
    super.dispose();
  }
}
