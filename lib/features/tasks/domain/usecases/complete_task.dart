import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../shared/domain/entities/task.dart';
import '../repositories/task_repository.dart';

class CompleteTask implements UseCase<Task, CompleteTaskParams> {
  final TaskRepository repository;

  const CompleteTask(this.repository);

  @override
  Future<Either<Failure, Task>> call(CompleteTaskParams params) async {
    return await repository.completeTask(
      params.taskId,
      notes: params.notes,
      actualMinutes: params.actualMinutes,
    );
  }
}

class CompleteTaskParams extends Equatable {
  final String taskId;
  final String? notes;
  final int? actualMinutes;

  const CompleteTaskParams({
    required this.taskId,
    this.notes,
    this.actualMinutes,
  });

  @override
  List<Object?> get props => [taskId, notes, actualMinutes];
}