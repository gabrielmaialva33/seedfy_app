import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../shared/domain/entities/farm.dart';
import '../repositories/farm_repository.dart';

class GetUserFarms implements UseCase<List<Farm>, NoParams> {
  final FarmRepository repository;

  const GetUserFarms(this.repository);

  @override
  Future<Either<Failure, List<Farm>>> call(NoParams params) async {
    return await repository.getUserFarms();
  }
}