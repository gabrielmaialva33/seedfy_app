import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../shared/domain/entities/task.dart' as entities;

abstract class TaskRepository {
  /// Get all tasks for the current user
  Future<Either<Failure, List<Task>>> getUserTasks();

  /// Get tasks for a specific farm
  Future<Either<Failure, List<Task>>> getFarmTasks(String farmId);

  /// Get tasks for a specific planting
  Future<Either<Failure, List<Task>>> getPlantingTasks(String plantingId);

  /// Get pending tasks (not done)
  Future<Either<Failure, List<Task>>> getPendingTasks();

  /// Get today's tasks
  Future<Either<Failure, List<Task>>> getTodayTasks();

  /// Get overdue tasks
  Future<Either<Failure, List<Task>>> getOverdueTasks();

  /// Create a new task
  Future<Either<Failure, Task>> createTask(Task task);

  /// Update an existing task
  Future<Either<Failure, Task>> updateTask(Task task);

  /// Mark task as completed
  Future<Either<Failure, Task>> completeTask(String taskId,
      {String? notes, int? actualMinutes});

  /// Delete a task
  Future<Either<Failure, void>> deleteTask(String taskId);

  /// Get task statistics
  Future<Either<Failure, Map<String, dynamic>>> getTaskStats();
}
