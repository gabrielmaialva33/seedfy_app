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
  
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final response = await SupabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw Exception('Login failed');
      }
      
      _user = response.user;
      await _loadUserProfile();
      
      // Also sign in with Firebase anonymously for data storage
      try {
        await FirebaseService.signInAnonymously();
      } catch (e) {
        debugPrint('Firebase anonymous sign in failed: $e');
      }
      
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> signOut() async {
    await SupabaseService.client.auth.signOut();
    _user = null;
    _profile = null;
    try {
      await FirebaseService.signOut();
    } catch (e) {
      debugPrint('Firebase sign out failed: $e');
    }
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    try {
      await SupabaseService.client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Failed to send reset email: ${e.toString()}');
    }
  }

  Future<void> updateProfile(UserProfile updatedProfile) async {
    if (_user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await SupabaseService.client
          .from('profiles')
          .update(updatedProfile.toJson())
          .eq('id', _user!.id);

      _profile = updatedProfile;
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> hasCompletedOnboarding() async {
    if (_profile == null) return false;
    
    try {
      // Check if user has any farms (indicates onboarding completed)
      final response = await SupabaseService.client
          .from('farms')
          .select('id')
          .eq('owner_id', _profile!.id)
          .limit(1);

      return response.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking onboarding status: $e');
      return false;
    }
  }
}