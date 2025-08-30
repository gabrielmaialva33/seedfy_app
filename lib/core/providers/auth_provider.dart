import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../services/supabase_service.dart';
import '../../services/firebase_service.dart';
import '../../models/user_profile.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  UserProfile? _profile;
  bool _isLoading = false;
  
  User? get user => _user;
  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  
  AuthProvider() {
    _initialize();
  }
  
  void _initialize() {
    _user = SupabaseService.currentUser;
    if (_user != null) {
      _loadUserProfile();
    }
    
    SupabaseService.authStateChanges.listen((data) {
      _user = data.session?.user;
      if (_user != null) {
        _loadUserProfile();
      } else {
        _profile = null;
      }
      notifyListeners();
    });
  }
  
  Future<void> _loadUserProfile() async {
    if (_user == null) return;
    
    try {
      final response = await SupabaseService.client
          .from('profiles')
          .select()
          .eq('id', _user!.id)
          .single();
      
      _profile = UserProfile.fromJson(response);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }
  }
  
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String city,
    required String state,
    String? locale,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final response = await SupabaseService.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'phone': phone,
          'city': city,
          'state': state,
          'locale': locale ?? 'pt-BR',
        },
      );
      
      if (response.user == null) {
        throw Exception('Failed to create account');
      }
      
      _user = response.user;
      await Future.delayed(const Duration(milliseconds: 500)); // Wait for trigger
      await _loadUserProfile();
      
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Sign in with Supabase
      await SupabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      // Also sign in with Firebase anonymously for data storage
      try {
        await FirebaseService.signInAnonymously();
      } catch (e) {
        debugPrint('Firebase anonymous sign in failed: $e');
      }
      
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> signOut() async {
    await SupabaseService.client.auth.signOut();
    try {
      await FirebaseService.signOut();
    } catch (e) {
      debugPrint('Firebase sign out failed: $e');
    }
  }
}