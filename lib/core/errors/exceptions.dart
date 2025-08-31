class ServerException implements Exception {
  final String? message;
  final String? code;

  ServerException([this.message, this.code]);
}

class CacheException implements Exception {
  final String? message;

  CacheException([this.message]);
}

class NetworkException implements Exception {
  final String? message;

  NetworkException([this.message]);
}

class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException(this.message, [this.code]);
}

class ValidationException implements Exception {
  final String message;
  final Map<String, String>? errors;

  ValidationException(this.message, [this.errors]);
}