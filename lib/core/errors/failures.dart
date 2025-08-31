import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, [this.code]);

  @override
  List<Object?> get props => [message, code];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network connection error']);
}

// Auth failures
class AuthFailure extends Failure {
  const AuthFailure(super.message, [super.code]);
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure() : super('Invalid email or password', 'invalid_credentials');
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure() : super('User not found', 'user_not_found');
}

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure() : super('Email already in use', 'email_already_in_use');
}

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure() : super('Password is too weak', 'weak_password');
}

// Farm failures
class FarmFailure extends Failure {
  const FarmFailure(super.message, [super.code]);
}

class FarmNotFoundFailure extends FarmFailure {
  const FarmNotFoundFailure() : super('Farm not found', 'farm_not_found');
}

class FarmAccessDeniedFailure extends FarmFailure {
  const FarmAccessDeniedFailure() : super('Access denied to this farm', 'access_denied');
}

// Validation failures
class ValidationFailure extends Failure {
  final Map<String, String>? errors;
  
  const ValidationFailure(String message, [this.errors]) : super(message, 'validation_error');
  
  @override
  List<Object?> get props => [message, code, errors];
}