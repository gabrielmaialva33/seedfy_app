import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/entities/task.dart' as entities;

abstract class TaskRepository {
  /// Get all tasks for the current user
  Future<Either<Failure, List<entities.Task>>> getUserTasks();

  /// Get tasks for a specific farm
  Future<Either<Failure, List<entities.Task>>> getFarmTasks(String farmId);

  /// Get tasks for a specific planting
  Future<Either<Failure, List<entities.Task>>> getPlantingTasks(String plantingId);

  /// Get pending tasks (not done)
  Future<Either<Failure, List<entities.Task>>> getPendingTasks();

  /// Get today's tasks
  Future<Either<Failure, List<entities.Task>>> getTodayTasks();

  /// Get overdue tasks
  Future<Either<Failure, List<entities.Task>>> getOverdueTasks();

  /// Create a new task
  Future<Either<Failure, entities.Task>> createTask(Task task);

  /// Update an existing task
  Future<Either<Failure, entities.Task>> updateTask(Task task);

  /// Mark task as completed
  Future<Either<Failure, entities.Task>> completeTask(String taskId,
      {String? notes, int? actualMinutes});

  /// Delete a task
  Future<Either<Failure, void>> deleteTask(String taskId);

  /// Get task statistics
  Future<Either<Failure, Map<String, dynamic>>> getTaskStats();
}
