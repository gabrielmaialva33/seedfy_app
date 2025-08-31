import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../shared/domain/entities/bed.dart';
import '../../../../shared/domain/entities/farm.dart';
import '../../../../shared/domain/entities/planting.dart';
import '../../../../shared/domain/entities/plot.dart';
import '../repositories/farm_repository.dart';

class GetFarmDetails
    implements UseCase<FarmDetailsResult, GetFarmDetailsParams> {
  final FarmRepository repository;

  const GetFarmDetails(this.repository);

  @override
  Future<Either<Failure, FarmDetailsResult>> call(
      GetFarmDetailsParams params) async {
    try {
      final farmResult = await repository.getFarm(params.farmId);
      if (farmResult.isLeft()) {
        return farmResult.fold(
            (failure) => Left(failure), (_) => throw Exception());
      }

      final plotsResult = await repository.getFarmPlots(params.farmId);
      if (plotsResult.isLeft()) {
        return plotsResult.fold(
            (failure) => Left(failure), (_) => throw Exception());
      }

      final bedsResult = await repository.getFarmBeds(params.farmId);
      if (bedsResult.isLeft()) {
        return bedsResult.fold(
            (failure) => Left(failure), (_) => throw Exception());
      }

      final plantingsResult = await repository.getFarmPlantings(params.farmId);
      if (plantingsResult.isLeft()) {
        return plantingsResult.fold(
            (failure) => Left(failure), (_) => throw Exception());
      }

      final statsResult = await repository.getFarmStats(params.farmId);
      if (statsResult.isLeft()) {
        return statsResult.fold(
            (failure) => Left(failure), (_) => throw Exception());
      }

      return Right(FarmDetailsResult(
        farm: farmResult.fold((_) => throw Exception(), (farm) => farm),
        plots: plotsResult.fold((_) => throw Exception(), (plots) => plots),
        beds: bedsResult.fold((_) => throw Exception(), (beds) => beds),
        plantings: plantingsResult.fold(
            (_) => throw Exception(), (plantings) => plantings),
        stats: statsResult.fold((_) => throw Exception(), (stats) => stats),
      ));
    } catch (e) {
      return Left(ServerFailure('Failed to get farm details: ${e.toString()}'));
    }
  }
}

class GetFarmDetailsParams extends Equatable {
  final String farmId;

  const GetFarmDetailsParams({required this.farmId});

  @override
  List<Object> get props => [farmId];
}

class FarmDetailsResult extends Equatable {
  final Farm farm;
  final List<Plot> plots;
  final List<Bed> beds;
  final List<Planting> plantings;
  final Map<String, dynamic> stats;

  const FarmDetailsResult({
    required this.farm,
    required this.plots,
    required this.beds,
    required this.plantings,
    required this.stats,
  });

  @override
  List<Object> get props => [farm, plots, beds, plantings, stats];
}
