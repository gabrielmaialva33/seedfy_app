import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seedfy_app/core/errors/exceptions.dart';
import 'package:seedfy_app/core/errors/failures.dart';
import 'package:seedfy_app/core/network/network_info.dart';
import 'package:seedfy_app/features/farm/data/datasources/farm_remote_datasource.dart';
import 'package:seedfy_app/features/farm/data/repositories/farm_repository_impl.dart';
import 'package:seedfy_app/shared/domain/entities/bed.dart';
import 'package:seedfy_app/shared/domain/entities/farm.dart';
import 'package:seedfy_app/shared/domain/entities/planting.dart';
import 'package:seedfy_app/shared/domain/entities/plot.dart';

class MockFarmRemoteDataSource extends Mock implements FarmRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late FarmRepositoryImpl repository;
  late MockFarmRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockFarmRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = FarmRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('FarmRepositoryImpl', () {
    final testFarm = Farm(
      id: '1',
      name: 'Test Farm',
      ownerId: 'user123',
      createdAt: DateTime(2023, 1, 1),
    );

    final testFarms = [testFarm];

    group('getUserFarms', () {
      test('should return farms when device is online and call succeeds',
          () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getUserFarms())
            .thenAnswer((_) async => testFarms);

        // Act
        final result = await repository.getUserFarms();

        // Assert
        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.getUserFarms());
        expect(result, equals(Right(testFarms)));
      });

      test('should return NetworkFailure when device is offline', () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // Act
        final result = await repository.getUserFarms();

        // Assert
        verify(() => mockNetworkInfo.isConnected);
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result,
            equals(const Left(NetworkFailure('No internet connection'))));
      });

      test('should return AuthFailure when AuthException is thrown', () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getUserFarms())
            .thenThrow(AuthException('User not authenticated'));

        // Act
        final result = await repository.getUserFarms();

        // Assert
        verify(() => mockRemoteDataSource.getUserFarms());
        expect(
            result, equals(const Left(AuthFailure('User not authenticated'))));
      });

      test('should return ServerFailure when ServerException is thrown',
          () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getUserFarms())
            .thenThrow(ServerException('Server error'));

        // Act
        final result = await repository.getUserFarms();

        // Assert
        verify(() => mockRemoteDataSource.getUserFarms());
        expect(result, equals(const Left(ServerFailure('Server error'))));
      });

      test(
          'should return ServerFailure when ServerException with null message is thrown',
          () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getUserFarms())
            .thenThrow(ServerException());

        // Act
        final result = await repository.getUserFarms();

        // Assert
        verify(() => mockRemoteDataSource.getUserFarms());
        expect(result, equals(const Left(ServerFailure('Server error'))));
      });

      test('should return ServerFailure when unknown exception is thrown',
          () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getUserFarms())
            .thenThrow(Exception('Unknown error'));

        // Act
        final result = await repository.getUserFarms();

        // Assert
        verify(() => mockRemoteDataSource.getUserFarms());
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message.contains('Unknown error'), true),
          (_) => fail('Should return failure'),
        );
      });
    });

    group('getFarm', () {
      const farmId = 'farm123';

      test('should return farm when device is online and call succeeds',
          () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getFarm(farmId))
            .thenAnswer((_) async => testFarm);

        // Act
        final result = await repository.getFarm(farmId);

        // Assert
        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.getFarm(farmId));
        expect(result, equals(Right(testFarm)));
      });

      test('should return NetworkFailure when device is offline', () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // Act
        final result = await repository.getFarm(farmId);

        // Assert
        verify(() => mockNetworkInfo.isConnected);
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result,
            equals(const Left(NetworkFailure('No internet connection'))));
      });
    });

    group('createFarm', () {
      test('should return created farm when device is online and call succeeds',
          () async {
        // Arrange
        final createdFarm = testFarm.copyWith(id: 'new123');
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.createFarm(testFarm))
            .thenAnswer((_) async => createdFarm);

        // Act
        final result = await repository.createFarm(testFarm);

        // Assert
        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.createFarm(testFarm));
        expect(result, equals(Right(createdFarm)));
      });

      test('should return NetworkFailure when device is offline', () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // Act
        final result = await repository.createFarm(testFarm);

        // Assert
        verify(() => mockNetworkInfo.isConnected);
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result,
            equals(const Left(NetworkFailure('No internet connection'))));
      });
    });

    group('updateFarm', () {
      test('should return updated farm when device is online and call succeeds',
          () async {
        // Arrange
        final updatedFarm = testFarm.copyWith(name: 'Updated Farm');
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.updateFarm(updatedFarm))
            .thenAnswer((_) async => updatedFarm);

        // Act
        final result = await repository.updateFarm(updatedFarm);

        // Assert
        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.updateFarm(updatedFarm));
        expect(result, equals(Right(updatedFarm)));
      });

      test('should return NetworkFailure when device is offline', () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // Act
        final result = await repository.updateFarm(testFarm);

        // Assert
        verify(() => mockNetworkInfo.isConnected);
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result,
            equals(const Left(NetworkFailure('No internet connection'))));
      });
    });

    group('deleteFarm', () {
      const farmId = 'farm123';

      test('should return success when device is online and call succeeds',
          () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.deleteFarm(farmId))
            .thenAnswer((_) async {});

        // Act
        final result = await repository.deleteFarm(farmId);

        // Assert
        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.deleteFarm(farmId));
        expect(result, equals(const Right(null)));
      });

      test('should return NetworkFailure when device is offline', () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // Act
        final result = await repository.deleteFarm(farmId);

        // Assert
        verify(() => mockNetworkInfo.isConnected);
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result,
            equals(const Left(NetworkFailure('No internet connection'))));
      });
    });

    group('getFarmPlots', () {
      const farmId = 'farm123';
      final testPlots = [
        Plot(
          id: 'plot1',
          farmId: farmId,
          label: 'Test Plot',
          lengthM: 10.0,
          widthM: 8.0,
          pathGapM: 0.5,
          createdAt: DateTime(2023, 1, 1),
        ),
      ];

      test('should return plots when device is online and call succeeds',
          () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getFarmPlots(farmId))
            .thenAnswer((_) async => testPlots);

        // Act
        final result = await repository.getFarmPlots(farmId);

        // Assert
        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.getFarmPlots(farmId));
        expect(result, equals(Right(testPlots)));
      });

      test('should return NetworkFailure when device is offline', () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // Act
        final result = await repository.getFarmPlots(farmId);

        // Assert
        verify(() => mockNetworkInfo.isConnected);
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result,
            equals(const Left(NetworkFailure('No internet connection'))));
      });
    });

    group('getFarmBeds', () {
      const farmId = 'farm123';
      final testBeds = [
        Bed(
          id: 'bed1',
          plotId: 'plot1',
          x: 1,
          y: 1,
          widthM: 1.2,
          heightM: 2.0,
          createdAt: DateTime(2023, 1, 1),
        ),
      ];

      test('should return beds when device is online and call succeeds',
          () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getFarmBeds(farmId))
            .thenAnswer((_) async => testBeds);

        // Act
        final result = await repository.getFarmBeds(farmId);

        // Assert
        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.getFarmBeds(farmId));
        expect(result, equals(Right(testBeds)));
      });
    });

    group('getFarmPlantings', () {
      const farmId = 'farm123';
      final testPlantings = [
        Planting(
          id: 'planting1',
          bedId: 'bed1',
          cropId: 'crop1',
          sowingDate: DateTime(2023, 1, 1),
          harvestEstimate: DateTime(2023, 4, 1),
          quantity: 4,
        ),
      ];

      test('should return plantings when device is online and call succeeds',
          () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getFarmPlantings(farmId))
            .thenAnswer((_) async => testPlantings);

        // Act
        final result = await repository.getFarmPlantings(farmId);

        // Assert
        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.getFarmPlantings(farmId));
        expect(result, equals(Right(testPlantings)));
      });
    });

    group('getFarmStats', () {
      const farmId = 'farm123';
      final testStats = {
        'totalPlots': 5,
        'totalBeds': 20,
        'activePlantings': 15,
        'completedTasks': 25,
      };

      test('should return stats when device is online and call succeeds',
          () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getFarmStats(farmId))
            .thenAnswer((_) async => testStats);

        // Act
        final result = await repository.getFarmStats(farmId);

        // Assert
        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.getFarmStats(farmId));
        expect(result, equals(Right(testStats)));
      });

      test('should return NetworkFailure when device is offline', () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // Act
        final result = await repository.getFarmStats(farmId);

        // Assert
        verify(() => mockNetworkInfo.isConnected);
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result,
            equals(const Left(NetworkFailure('No internet connection'))));
      });
    });

    group('Edge cases and error handling', () {
      test('should handle empty farm list correctly', () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getUserFarms())
            .thenAnswer((_) async => <Farm>[]);

        // Act
        final result = await repository.getUserFarms();

        // Assert
        expect(result, equals(Right<Failure, List<Farm>>(const <Farm>[])));
      });

      test('should handle null responses gracefully', () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getFarmStats('farm123'))
            .thenAnswer((_) async => <String, dynamic>{});

        // Act
        final result = await repository.getFarmStats('farm123');

        // Assert
        expect(result, equals(Right<Failure, Map<String, dynamic>>(const <String, dynamic>{})));
      });

      test('should handle timeout exceptions', () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getUserFarms())
            .thenThrow(Exception('Timeout'));

        // Act
        final result = await repository.getUserFarms();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message.contains('Timeout'), true),
          (_) => fail('Should return failure'),
        );
      });

      test('should handle very large farm lists', () async {
        // Arrange
        final largeFarmList = List.generate(
            1000,
            (index) =>
                testFarm.copyWith(id: 'farm_$index', name: 'Farm $index'));

        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getUserFarms())
            .thenAnswer((_) async => largeFarmList);

        // Act
        final result = await repository.getUserFarms();

        // Assert
        expect(result, equals(Right(largeFarmList)));
        result.fold(
          (_) => fail('Should return success'),
          (farms) => expect(farms.length, equals(1000)),
        );
      });

      test('should handle network connection check failure', () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected)
            .thenThrow(Exception('Network check failed'));

        // Act
        final result = await repository.getUserFarms();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) =>
              expect(failure.message.contains('Network check failed'), true),
          (_) => fail('Should return failure'),
        );
      });
    });
  });
}
