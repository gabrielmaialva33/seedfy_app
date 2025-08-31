import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../shared/domain/entities/task.dart' as entities;
import '../repositories/task_repository.dart';

class GetUserTasks implements UseCase<List<Task>, NoParams> {
  final TaskRepository repository;

  const GetUserTasks(this.repository);

  @override
  Future<Either<Failure, List<Task>>> call(NoParams params) async {
    return await repository.getUserTasks();
  }
}

class GetPendingTasks implements UseCase<List<Task>, NoParams> {
  final TaskRepository repository;

  const GetPendingTasks(this.repository);

  @override
  Future<Either<Failure, List<Task>>> call(NoParams params) async {
    return await repository.getPendingTasks();
  }
}

class GetTodayTasks implements UseCase<List<Task>, NoParams> {
  final TaskRepository repository;

  const GetTodayTasks(this.repository);

  @override
  Future<Either<Failure, List<Task>>> call(NoParams params) async {
    return await repository.getTodayTasks();
  }
}

class GetOverdueTasks implements UseCase<List<Task>, NoParams> {
  final TaskRepository repository;

  const GetOverdueTasks(this.repository);

  @override
  Future<Either<Failure, List<Task>>> call(NoParams params) async {
    return await repository.getOverdueTasks();
  }
}
