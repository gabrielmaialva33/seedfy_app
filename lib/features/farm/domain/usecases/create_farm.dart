import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../shared/domain/entities/farm.dart';
import '../repositories/farm_repository.dart';

class CreateFarm implements UseCase<Farm, CreateFarmParams> {
  final FarmRepository repository;

  const CreateFarm(this.repository);

  @override
  Future<Either<Failure, Farm>> call(CreateFarmParams params) async {
    return await repository.createFarm(params.farm);
  }
}

class CreateFarmParams extends Equatable {
  final Farm farm;

  const CreateFarmParams({required this.farm});

  @override
  List<Object> get props => [farm];
}
