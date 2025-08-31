import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seedfy_app/core/errors/failures.dart';
import 'package:seedfy_app/core/usecases/usecase.dart';
import 'package:seedfy_app/features/farm/domain/usecases/create_farm.dart';
import 'package:seedfy_app/features/farm/domain/usecases/get_farm_details.dart';
import 'package:seedfy_app/features/farm/domain/usecases/get_user_farms.dart';
import 'package:seedfy_app/features/farm/presentation/bloc/farm_bloc.dart';
import 'package:seedfy_app/features/farm/presentation/bloc/farm_event.dart';
import 'package:seedfy_app/features/farm/presentation/bloc/farm_state.dart';
import 'package:seedfy_app/shared/domain/entities/farm.dart';

class MockGetUserFarms extends Mock implements GetUserFarms {}

class MockCreateFarm extends Mock implements CreateFarm {}

class MockGetFarmDetails extends Mock implements GetFarmDetails {}

class FakeFarm extends Fake implements Farm {}

void main() {
  late FarmBloc farmBloc;
  late MockGetUserFarms mockGetUserFarms;
  late MockCreateFarm mockCreateFarm;
  late MockGetFarmDetails mockGetFarmDetails;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(FakeFarm());
  });

  setUp(() {
    mockGetUserFarms = MockGetUserFarms();
    mockCreateFarm = MockCreateFarm();
    mockGetFarmDetails = MockGetFarmDetails();

    farmBloc = FarmBloc(
      getUserFarms: mockGetUserFarms,
      createFarm: mockCreateFarm,
      getFarmDetails: mockGetFarmDetails,
    );
  });

  tearDown(() {
    farmBloc.close();
  });

  group('FarmBloc', () {
    final testFarm = Farm(
      id: '1',
      name: 'Test Farm',
      ownerId: 'user123',
      createdAt: DateTime(2023, 1, 1),
    );

    final testFarms = [testFarm];

    test('initial state is FarmState.initial', () {
      expect(farmBloc.state, equals(const FarmState.initial()));
    });

    group('GetUserFarms', () {
      blocTest<FarmBloc, FarmState>(
        'emits [loading, farmsLoaded] when getUserFarms succeeds',
        build: () {
          when(() => mockGetUserFarms(any()))
              .thenAnswer((_) async => Right(testFarms));
          return farmBloc;
        },
        act: (bloc) => bloc.add(const FarmEvent.getUserFarms()),
        expect: () => [
          const FarmState.loading(),
          FarmState.farmsLoaded(testFarms),
        ],
        verify: (_) {
          verify(() => mockGetUserFarms(any())).called(1);
        },
      );

      blocTest<FarmBloc, FarmState>(
        'emits [loading, error] when getUserFarms fails',
        build: () {
          when(() => mockGetUserFarms(any())).thenAnswer(
              (_) async => const Left(ServerFailure('Server error')));
          return farmBloc;
        },
        act: (bloc) => bloc.add(const FarmEvent.getUserFarms()),
        expect: () => [
          const FarmState.loading(),
          const FarmState.error('Server error'),
        ],
        verify: (_) {
          verify(() => mockGetUserFarms(any())).called(1);
        },
      );
    });

    group('GetFarmDetails', () {
      const farmId = 'farm123';
      final farmDetails = FarmDetailsResult(
        farm: testFarm,
        plots: [],
        beds: [],
        plantings: [],
        stats: {},
      );

      blocTest<FarmBloc, FarmState>(
        'emits [loading, farmDetailsLoaded] when getFarmDetails succeeds',
        build: () {
          when(() => mockGetFarmDetails(
                  const GetFarmDetailsParams(farmId: farmId)))
              .thenAnswer((_) async => Right(farmDetails));
          return farmBloc;
        },
        act: (bloc) => bloc.add(const FarmEvent.getFarmDetails(farmId)),
        expect: () => [
          const FarmState.loading(),
          FarmState.farmDetailsLoaded(farmDetails),
        ],
        verify: (_) {
          verify(() => mockGetFarmDetails(
              const GetFarmDetailsParams(farmId: farmId))).called(1);
        },
      );

      blocTest<FarmBloc, FarmState>(
        'emits [loading, error] when getFarmDetails fails',
        build: () {
          when(() => mockGetFarmDetails(
                  const GetFarmDetailsParams(farmId: farmId)))
              .thenAnswer(
                  (_) async => const Left(ServerFailure('Farm not found')));
          return farmBloc;
        },
        act: (bloc) => bloc.add(const FarmEvent.getFarmDetails(farmId)),
        expect: () => [
          const FarmState.loading(),
          const FarmState.error('Farm not found'),
        ],
        verify: (_) {
          verify(() => mockGetFarmDetails(
              const GetFarmDetailsParams(farmId: farmId))).called(1);
        },
      );
    });

    group('CreateFarm', () {
      blocTest<FarmBloc, FarmState>(
        'emits [loading, farmCreated, loading, farmsLoaded] when createFarm succeeds',
        build: () {
          when(() => mockCreateFarm(CreateFarmParams(farm: testFarm)))
              .thenAnswer((_) async => Right(testFarm));
          when(() => mockGetUserFarms(any()))
              .thenAnswer((_) async => Right(testFarms));
          return farmBloc;
        },
        act: (bloc) => bloc.add(FarmEvent.createFarm(testFarm)),
        expect: () => [
          const FarmState.loading(),
          FarmState.farmCreated(testFarm),
          const FarmState.loading(),
          FarmState.farmsLoaded(testFarms),
        ],
        verify: (_) {
          verify(() => mockCreateFarm(CreateFarmParams(farm: testFarm)))
              .called(1);
          verify(() => mockGetUserFarms(any())).called(1);
        },
      );

      blocTest<FarmBloc, FarmState>(
        'emits [loading, error] when createFarm fails',
        build: () {
          when(() => mockCreateFarm(CreateFarmParams(farm: testFarm)))
              .thenAnswer(
                  (_) async => const Left(ServerFailure('Create failed')));
          return farmBloc;
        },
        act: (bloc) => bloc.add(FarmEvent.createFarm(testFarm)),
        expect: () => [
          const FarmState.loading(),
          const FarmState.error('Create failed'),
        ],
        verify: (_) {
          verify(() => mockCreateFarm(CreateFarmParams(farm: testFarm)))
              .called(1);
          verifyNever(() => mockGetUserFarms(NoParams()));
        },
      );
    });

    group('RefreshFarms', () {
      blocTest<FarmBloc, FarmState>(
        'emits [farmsLoaded] when refreshFarms succeeds (no loading state)',
        build: () {
          when(() => mockGetUserFarms(any()))
              .thenAnswer((_) async => Right(testFarms));
          return farmBloc;
        },
        act: (bloc) => bloc.add(const FarmEvent.refreshFarms()),
        expect: () => [
          FarmState.farmsLoaded(testFarms),
        ],
        verify: (_) {
          verify(() => mockGetUserFarms(any())).called(1);
        },
      );

      blocTest<FarmBloc, FarmState>(
        'emits [error] when refreshFarms fails',
        build: () {
          when(() => mockGetUserFarms(any())).thenAnswer(
              (_) async => const Left(NetworkFailure('No internet')));
          return farmBloc;
        },
        act: (bloc) => bloc.add(const FarmEvent.refreshFarms()),
        expect: () => [
          const FarmState.error('No internet'),
        ],
        verify: (_) {
          verify(() => mockGetUserFarms(any())).called(1);
        },
      );
    });

    group('UpdateFarm', () {
      blocTest<FarmBloc, FarmState>(
        'emits [error] for unimplemented updateFarm',
        build: () => farmBloc,
        act: (bloc) => bloc.add(FarmEvent.updateFarm(testFarm)),
        expect: () => [
          const FarmState.error('Update farm not implemented'),
        ],
      );
    });

    group('DeleteFarm', () {
      blocTest<FarmBloc, FarmState>(
        'emits [error] for unimplemented deleteFarm',
        build: () => farmBloc,
        act: (bloc) => bloc.add(const FarmEvent.deleteFarm('farm123')),
        expect: () => [
          const FarmState.error('Delete farm not implemented'),
        ],
      );
    });

    group('Multiple events', () {
      final farmDetails = FarmDetailsResult(
        farm: testFarm,
        plots: [],
        beds: [],
        plantings: [],
        stats: {},
      );

      blocTest<FarmBloc, FarmState>(
        'handles multiple events correctly',
        build: () {
          when(() => mockGetUserFarms(any()))
              .thenAnswer((_) async => Right(testFarms));
          when(() =>
                  mockGetFarmDetails(const GetFarmDetailsParams(farmId: '1')))
              .thenAnswer((_) async => Right(farmDetails));
          return farmBloc;
        },
        act: (bloc) {
          bloc.add(const FarmEvent.getUserFarms());
          bloc.add(const FarmEvent.getFarmDetails('1'));
        },
        expect: () => [
          const FarmState.loading(),
          FarmState.farmsLoaded(testFarms),
          const FarmState.loading(),
          FarmState.farmDetailsLoaded(farmDetails),
        ],
      );
    });

    group('Edge cases', () {
      blocTest<FarmBloc, FarmState>(
        'handles empty farms list correctly',
        build: () {
          when(() => mockGetUserFarms(any()))
              .thenAnswer((_) async => const Right([]));
          return farmBloc;
        },
        act: (bloc) => bloc.add(const FarmEvent.getUserFarms()),
        expect: () => [
          const FarmState.loading(),
          const FarmState.farmsLoaded([]),
        ],
      );

      blocTest<FarmBloc, FarmState>(
        'handles invalid farm ID gracefully',
        build: () {
          when(() => mockGetFarmDetails(
                  const GetFarmDetailsParams(farmId: 'invalid')))
              .thenAnswer(
                  (_) async => const Left(ServerFailure('Farm not found')));
          return farmBloc;
        },
        act: (bloc) => bloc.add(const FarmEvent.getFarmDetails('invalid')),
        expect: () => [
          const FarmState.loading(),
          const FarmState.error('Farm not found'),
        ],
      );
    });
  });
}
