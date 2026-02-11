import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/supabase_config.dart';
import '../../models/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

/// Controlador de autenticación para Supabase
class AuthController extends ChangeNotifier {
  static final AuthController _instance = AuthController._internal();
  factory AuthController() => _instance;

  AuthController._internal() {
    _init();
  }

  UserProfile? _userProfile;
  supabase.User? _supabaseUser;

  UserProfile? get userProfile => _userProfile;
  supabase.User? get supabaseUser => _supabaseUser;
  bool get loggedIn => _supabaseUser != null;

  Future<void> _init() async {
    _supabaseUser = SupabaseConfig.client.auth.currentUser;
    if (_supabaseUser != null) {
      await refreshUserProfile();
    }

    SupabaseConfig.client.auth.onAuthStateChange.listen((data) async {
      _supabaseUser = data.session?.user;
      if (_supabaseUser != null) {
        await refreshUserProfile();
      } else {
        _userProfile = null;
        notifyListeners();
      }
    });
  }

  Future<void> refreshUserProfile() async {
    if (_supabaseUser == null) return;

    try {
      final response = await SupabaseConfig.client
          .from('users')
          .select()
          .eq('id', _supabaseUser!.id)
          .maybeSingle();

      if (response != null) {
        _userProfile = UserProfile.fromJson(response);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error refreshing user profile: $e');
    }
  }

  Future<void> logOut() async {
    await SupabaseConfig.client.auth.signOut();
  }
}

// Global getters para compatibilidad con FlutterFlow
String get currentUserEmail =>
    SupabaseConfig.client.auth.currentUser?.email ?? '';
String get currentUserUid => SupabaseConfig.client.auth.currentUser?.id ?? '';
String get currentUserDisplayName =>
    AuthController().userProfile?.displayName ?? currentUserEmail;
String get currentUserPhoto => AuthController().userProfile?.photoUrl ?? '';
UserProfile? get currentUserDocument => AuthController().userProfile;

// Action para actualizar el estado de auth
Future signOut() => AuthController().logOut();
