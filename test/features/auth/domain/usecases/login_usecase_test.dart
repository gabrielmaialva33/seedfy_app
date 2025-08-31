import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seedfy_app/core/errors/failures.dart';
import 'package:seedfy_app/features/auth/domain/entities/user_entity.dart';
import 'package:seedfy_app/features/auth/domain/usecases/login_usecase.dart';

import '../../../../helpers/test_helper.dart';

void main() {
  late LoginUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LoginUseCase(mockAuthRepository);
  });

  final testUserEntity = UserEntity(
    id: 'test-id',
    email: 'test@seedfy.com',
    name: 'Test User',
    locale: 'pt-BR',
    city: 'São Paulo',
    state: 'SP',
    createdAt: DateTime.now(),
  );

  const testParams = LoginParams(
    email: 'test@seedfy.com',
    password: 'password123',
  );

  group('LoginUseCase', () {
    test('should return UserEntity when login is successful', () async {
      // Arrange
      when(() => mockAuthRepository.login(any(), any()))
          .thenAnswer((_) async => Right(testUserEntity));

      // Act
      final result = await usecase.call(testParams);

      // Assert
      expect(result, Right(testUserEntity));
      verify(() => mockAuthRepository.login(
            testParams.email,
            testParams.password,
          ));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Failure when login fails', () async {
      // Arrange
      const testFailure = ServerFailure('Login failed');
      when(() => mockAuthRepository.login(any(), any()))
          .thenAnswer((_) async => const Left(testFailure));

      // Act
      final result = await usecase.call(testParams);

      // Assert
      expect(result, const Left(testFailure));
      verify(() => mockAuthRepository.login(
            testParams.email,
            testParams.password,
          ));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should pass correct parameters to repository', () async {
      // Arrange
      when(() => mockAuthRepository.login(any(), any()))
          .thenAnswer((_) async => Right(testUserEntity));

      // Act
      await usecase.call(testParams);

      // Assert
      verify(() => mockAuthRepository.login(
            'test@seedfy.com',
            'password123',
          ));
    });
  });

  group('LoginParams', () {
    test('should be a subclass of Equatable', () {
      expect(testParams, isA<Equatable>());
    });

    test('should have correct props', () {
      expect(testParams.props, [testParams.email, testParams.password]);
    });
  });
}
