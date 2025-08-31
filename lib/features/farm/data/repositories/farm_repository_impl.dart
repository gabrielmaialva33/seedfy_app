import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../shared/domain/entities/bed.dart';
import '../../../../shared/domain/entities/farm.dart';
import '../../../../shared/domain/entities/planting.dart';
import '../../../../shared/domain/entities/plot.dart';
import '../../domain/repositories/farm_repository.dart';
import '../datasources/farm_remote_datasource.dart';

class FarmRepositoryImpl implements FarmRepository {
  final FarmRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const FarmRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Farm>>> getUserFarms() async {
    if (await networkInfo.isConnected) {
      try {
        final farms = await remoteDataSource.getUserFarms();
        return Right(farms);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unknown error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Farm>> getFarm(String farmId) async {
    if (await networkInfo.isConnected) {
      try {
        final farm = await remoteDataSource.getFarm(farmId);
        return Right(farm);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unknown error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Farm>> createFarm(Farm farm) async {
    if (await networkInfo.isConnected) {
      try {
        final createdFarm = await remoteDataSource.createFarm(farm);
        return Right(createdFarm);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unknown error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Farm>> updateFarm(Farm farm) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedFarm = await remoteDataSource.updateFarm(farm);
        return Right(updatedFarm);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unknown error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFarm(String farmId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteFarm(farmId);
        return const Right(null);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unknown error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Plot>>> getFarmPlots(String farmId) async {
    if (await networkInfo.isConnected) {
      try {
        final plots = await remoteDataSource.getFarmPlots(farmId);
        return Right(plots);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unknown error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Bed>>> getFarmBeds(String farmId) async {
    if (await networkInfo.isConnected) {
      try {
        final beds = await remoteDataSource.getFarmBeds(farmId);
        return Right(beds);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unknown error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Planting>>> getFarmPlantings(
      String farmId) async {
    if (await networkInfo.isConnected) {
      try {
        final plantings = await remoteDataSource.getFarmPlantings(farmId);
        return Right(plantings);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unknown error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getFarmStats(
      String farmId) async {
    if (await networkInfo.isConnected) {
      try {
        final stats = await remoteDataSource.getFarmStats(farmId);
        return Right(stats);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unknown error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
