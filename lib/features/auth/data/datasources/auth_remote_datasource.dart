import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/exceptions.dart' as app_exceptions;
import '../dto/user_dto.dart';

abstract class AuthRemoteDataSource {
  Future<UserDto> login(String email, String password);
  Future<UserDto> signup({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String city,
    required String state,
    String locale,
  });
  Future<void> logout();
  UserDto? getCurrentUser();
  Stream<UserDto?> get authStateChanges;
  Future<void> resetPassword(String email);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<UserDto> login(String email, String password) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw app_exceptions.AuthException('Login failed');
      }

      final profileData = await _getProfile(response.user!.id);
      return UserDto.fromJson(profileData);
    } catch (e) {
      throw app_exceptions.AuthException(e.toString());
    }
  }

  @override
  Future<UserDto> signup({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String city,
    required String state,
    String locale = 'pt-BR',
  }) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw app_exceptions.AuthException('Signup failed');
      }

      final profileData = {
        'id': response.user!.id,
        'email': email,
        'name': name,
        'phone': phone,
        'city': city,
        'state': state,
        'locale': locale,
        'created_at': DateTime.now().toIso8601String(),
      };

      await client.from('profiles').insert(profileData);

      return UserDto.fromJson(profileData);
    } catch (e) {
      throw app_exceptions.AuthException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      throw app_exceptions.AuthException(e.toString());
    }
  }

  @override
  UserDto? getCurrentUser() {
    final user = client.auth.currentUser;
    if (user == null) return null;

    // This is simplified - in production, fetch from profiles table
    return UserDto(
      id: user.id,
      email: user.email!,
      name: user.userMetadata?['name'] ?? '',
      phone: user.userMetadata?['phone'],
      city: user.userMetadata?['city'] ?? '',
      state: user.userMetadata?['state'] ?? '',
      locale: user.userMetadata?['locale'] ?? 'pt-BR',
      createdAt: DateTime.parse(user.createdAt),
    );
  }

  @override
  Stream<UserDto?> get authStateChanges {
    return client.auth.onAuthStateChange.asyncMap((state) async {
      if (state.session?.user == null) return null;
      
      try {
        final profileData = await _getProfile(state.session!.user.id);
        return UserDto.fromJson(profileData);
      } catch (_) {
        return null;
      }
    });
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw app_exceptions.AuthException(e.toString());
    }
  }

  Future<Map<String, dynamic>> _getProfile(String userId) async {
    try {
      final response = await client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      
      return response;
    } catch (e) {
      throw app_exceptions.ServerException('Failed to fetch profile');
    }
  }
}