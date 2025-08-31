import 'dart:convert';
import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:seedfy_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:seedfy_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:seedfy_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:seedfy_app/shared/data/datasources/supabase_service.dart';

// Mock classes
class MockAuthRepository extends Mock implements AuthRepository {}

class MockSupabaseService extends Mock implements SupabaseService {}

class MockLoginUsecase extends Mock implements LoginUseCase {}

class MockSignupUsecase extends Mock implements SignupUseCase {}

// Test data helpers
class TestHelper {
  static String fixture(String name) {
    final dir = Directory.current.path;
    return File('$dir/test/fixtures/$name').readAsStringSync();
  }

  static Map<String, dynamic> fixtureJson(String name) {
    return json.decode(fixture(name));
  }
}

// Common test data
class TestData {
  static const String validEmail = 'test@seedfy.com';
  static const String validPassword = 'Password123!';
  static const String validName = 'Test User';
  static const String userId = 'test-user-id';
  static const String accessToken = 'test-access-token';
}
