import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/entities/plot.dart';
import '../../../../shared/domain/entities/bed.dart';
import '../../../../shared/domain/entities/planting.dart';

abstract class PlotRepository {
  Future<Either<Failure, List<Plot>>> getFarmPlots(String farmId);
  Future<Either<Failure, Plot>> getPlot(String plotId);
  Future<Either<Failure, Plot>> createPlot(Plot plot);
  Future<Either<Failure, Plot>> updatePlot(Plot plot);
  Future<Either<Failure, void>> deletePlot(String plotId);
  Future<Either<Failure, List<Bed>>> getPlotBeds(String plotId);
  Future<Either<Failure, Bed>> createBed(Bed bed);
  Future<Either<Failure, Bed>> updateBed(Bed bed);
  Future<Either<Failure, void>> deleteBed(String bedId);
  Future<Either<Failure, List<Planting>>> getBedPlantings(String bedId);
}