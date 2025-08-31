import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../shared/domain/entities/task.dart' as entities;
import '../repositories/task_repository.dart';

class CreateTask implements UseCase<entities.Task, CreateTaskParams> {
  final TaskRepository repository;

  const CreateTask(this.repository);

  @override
  Future<Either<Failure, entities.Task>> call(CreateTaskParams params) async {
    return await repository.createTask(params.task);
  }
}

class CreateTaskParams extends Equatable {
  final entities.Task task;

  const CreateTaskParams({required this.task});

  @override
  List<Object> get props => [task];
}
