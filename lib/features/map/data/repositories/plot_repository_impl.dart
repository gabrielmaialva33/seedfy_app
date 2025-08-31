import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../shared/domain/entities/bed.dart';
import '../../../../shared/domain/entities/planting.dart';
import '../../../../shared/domain/entities/plot.dart';
import '../../domain/repositories/plot_repository.dart';
import '../datasources/plot_remote_datasource.dart';

class PlotRepositoryImpl implements PlotRepository {
  final PlotRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const PlotRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Plot>>> getFarmPlots(String farmId) async {
    if (await networkInfo.isConnected) {
      try {
        final plots = await remoteDataSource.getFarmPlots(farmId);
        return Right(plots);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message ?? 'Authentication error'));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Server error'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Plot>> getPlot(String plotId) async {
    if (await networkInfo.isConnected) {
      try {
        final plot = await remoteDataSource.getPlot(plotId);
        return Right(plot);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message ?? 'Authentication error'));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Server error'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Plot>> createPlot(Plot plot) async {
    if (await networkInfo.isConnected) {
      try {
        final createdPlot = await remoteDataSource.createPlot(plot);
        return Right(createdPlot);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message ?? 'Authentication error'));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Server error'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Plot>> updatePlot(Plot plot) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedPlot = await remoteDataSource.updatePlot(plot);
        return Right(updatedPlot);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message ?? 'Authentication error'));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Server error'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePlot(String plotId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deletePlot(plotId);
        return const Right(null);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message ?? 'Authentication error'));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Server error'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Bed>>> getPlotBeds(String plotId) async {
    if (await networkInfo.isConnected) {
      try {
        final beds = await remoteDataSource.getPlotBeds(plotId);
        return Right(beds);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message ?? 'Authentication error'));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Server error'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Bed>> createBed(Bed bed) async {
    if (await networkInfo.isConnected) {
      try {
        final createdBed = await remoteDataSource.createBed(bed);
        return Right(createdBed);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message ?? 'Authentication error'));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Server error'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Bed>> updateBed(Bed bed) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedBed = await remoteDataSource.updateBed(bed);
        return Right(updatedBed);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message ?? 'Authentication error'));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Server error'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBed(String bedId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteBed(bedId);
        return const Right(null);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message ?? 'Authentication error'));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Server error'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Planting>>> getBedPlantings(String bedId) async {
    if (await networkInfo.isConnected) {
      try {
        final plantings = await remoteDataSource.getBedPlantings(bedId);
        return Right(plantings);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message ?? 'Authentication error'));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Server error'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
