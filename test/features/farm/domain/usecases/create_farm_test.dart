import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seedfy_app/core/errors/failures.dart';
import 'package:seedfy_app/features/farm/domain/repositories/farm_repository.dart';
import 'package:seedfy_app/features/farm/domain/usecases/create_farm.dart';
import 'package:seedfy_app/shared/domain/entities/farm.dart';

class MockFarmRepository extends Mock implements FarmRepository {}

void main() {
  late CreateFarm createFarm;
  late MockFarmRepository mockFarmRepository;

  setUp(() {
    mockFarmRepository = MockFarmRepository();
    createFarm = CreateFarm(mockFarmRepository);
  });

  group('CreateFarm UseCase', () {
    final testFarm = Farm(
      id: '',
      name: 'Test Farm',
      description: 'A test farm for unit testing',
      location: 'Test Location',
      ownerId: 'user123',
      createdAt: DateTime(2023, 1, 1),
    );

    final createdFarm = testFarm.copyWith(id: 'farm123');

    test('should create farm when repository call is successful', () async {
      // Arrange
      when(() => mockFarmRepository.createFarm(testFarm))
          .thenAnswer((_) async => Right(createdFarm));

      // Act
      final result = await createFarm(CreateFarmParams(farm: testFarm));

      // Assert
      expect(result, equals(Right(createdFarm)));
      verify(() => mockFarmRepository.createFarm(testFarm)).called(1);
      verifyNoMoreInteractions(mockFarmRepository);
    });

    test('should return ServerFailure when repository call fails', () async {
      // Arrange
      const failure = ServerFailure('Failed to create farm');
      when(() => mockFarmRepository.createFarm(testFarm))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await createFarm(CreateFarmParams(farm: testFarm));

      // Assert
      expect(result, equals(const Left(failure)));
      verify(() => mockFarmRepository.createFarm(testFarm)).called(1);
      verifyNoMoreInteractions(mockFarmRepository);
    });

    test('should return ValidationFailure when farm data is invalid', () async {
      // Arrange
      const failure = ValidationFailure('Farm name cannot be empty');
      when(() => mockFarmRepository.createFarm(testFarm))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await createFarm(CreateFarmParams(farm: testFarm));

      // Assert
      expect(result, equals(const Left(failure)));
      verify(() => mockFarmRepository.createFarm(testFarm)).called(1);
    });

    test('should return NetworkFailure when network is unavailable', () async {
      // Arrange
      const failure = NetworkFailure('No internet connection');
      when(() => mockFarmRepository.createFarm(testFarm))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await createFarm(CreateFarmParams(farm: testFarm));

      // Assert
      expect(result, equals(const Left(failure)));
      verify(() => mockFarmRepository.createFarm(testFarm)).called(1);
    });

    group('Edge cases', () {
      test('should handle farm with minimal data', () async {
        // Arrange
        final minimalFarm = Farm(
          id: '',
          name: 'Minimal Farm',
          description: '',
          location: '',
          ownerId: 'user123',
          createdAt: DateTime.now(),
        );
        final createdMinimalFarm = minimalFarm.copyWith(id: 'minimal123');

        when(() => mockFarmRepository.createFarm(minimalFarm))
            .thenAnswer((_) async => Right(createdMinimalFarm));

        // Act
        final result = await createFarm(CreateFarmParams(farm: minimalFarm));

        // Assert
        expect(result, equals(Right(createdMinimalFarm)));
      });

      test('should handle farm with special characters in name', () async {
        // Arrange
        final specialFarm = testFarm.copyWith(
          name: 'Farm & Garden! 123 @#\$%',
        );
        final createdSpecialFarm = specialFarm.copyWith(id: 'special123');

        when(() => mockFarmRepository.createFarm(specialFarm))
            .thenAnswer((_) async => Right(createdSpecialFarm));

        // Act
        final result = await createFarm(CreateFarmParams(farm: specialFarm));

        // Assert
        expect(result, equals(Right(createdSpecialFarm)));
      });

      test('should handle very long farm name', () async {
        // Arrange
        final longName = 'A' * 1000; // Very long name
        final longNameFarm = testFarm.copyWith(name: longName);
        
        const failure = ValidationFailure('Farm name too long');
        when(() => mockFarmRepository.createFarm(longNameFarm))
            .thenAnswer((_) async => const Left(failure));

        // Act
        final result = await createFarm(CreateFarmParams(farm: longNameFarm));

        // Assert
        expect(result, equals(const Left(failure)));
      });
    });
  });

  group('CreateFarmParams', () {
    test('should be equal when farms are the same', () {
      final farm = Farm(
        id: '1',
        name: 'Test Farm',
        description: 'Test',
        location: 'Test Location',
        ownerId: 'user123',
        createdAt: DateTime(2023, 1, 1),
      );

      final params1 = CreateFarmParams(farm: farm);
      final params2 = CreateFarmParams(farm: farm);

      expect(params1, equals(params2));
      expect(params1.hashCode, equals(params2.hashCode));
    });

    test('should not be equal when farms are different', () {
      final farm1 = Farm(
        id: '1',
        name: 'Test Farm 1',
        description: 'Test 1',
        location: 'Location 1',
        ownerId: 'user123',
        createdAt: DateTime(2023, 1, 1),
      );

      final farm2 = Farm(
        id: '2',
        name: 'Test Farm 2',
        description: 'Test 2',
        location: 'Location 2',
        ownerId: 'user456',
        createdAt: DateTime(2023, 1, 2),
      );

      final params1 = CreateFarmParams(farm: farm1);
      final params2 = CreateFarmParams(farm: farm2);

      expect(params1, isNot(equals(params2)));
    });

    test('should have correct props', () {
      final farm = Farm(
        id: '1',
        name: 'Test Farm',
        description: 'Test',
        location: 'Test Location',
        ownerId: 'user123',
        createdAt: DateTime(2023, 1, 1),
      );

      final params = CreateFarmParams(farm: farm);

      expect(params.props, equals([farm]));
    });
  });
}