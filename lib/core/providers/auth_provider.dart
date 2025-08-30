import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/supabase_service.dart';
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
  
  Future<String?> signUp({
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
      );
      
      if (response.user != null) {
        await SupabaseService.client.from('profiles').insert({
          'id': response.user!.id,
          'name': name,
          'email': email,
          'phone': phone,
          'city': city,
          'state': state,
          'locale': locale ?? 'pt-BR',
        });
      }
      
      return null;
    } catch (e) {
      return e.toString();
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
      
      await SupabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
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
  }
}