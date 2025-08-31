import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../shared/domain/entities/plot.dart';
import '../repositories/plot_repository.dart';

class GetFarmPlots implements UseCase<List<Plot>, GetFarmPlotsParams> {
  final PlotRepository repository;

  const GetFarmPlots(this.repository);

  @override
  Future<Either<Failure, List<Plot>>> call(GetFarmPlotsParams params) async {
    return await repository.getFarmPlots(params.farmId);
  }
}

class GetFarmPlotsParams extends Equatable {
  final String farmId;

  const GetFarmPlotsParams({required this.farmId});

  @override
  List<Object> get props => [farmId];
}
