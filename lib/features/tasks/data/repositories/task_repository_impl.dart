import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../shared/domain/entities/task.dart' as entities;
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_datasource.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<entities.Task>>> getUserTasks() async {
    return await _getTasks(() => remoteDataSource.getUserTasks());
  }

  @override
  Future<Either<Failure, List<entities.Task>>> getFarmTasks(String farmId) async {
    return await _getTasks(() => remoteDataSource.getFarmTasks(farmId));
  }

  @override
  Future<Either<Failure, List<entities.Task>>> getPlantingTasks(
      String plantingId) async {
    return await _getTasks(() => remoteDataSource.getPlantingTasks(plantingId));
  }

  @override
  Future<Either<Failure, List<entities.Task>>> getPendingTasks() async {
    return await _getTasks(() => remoteDataSource.getPendingTasks());
  }

  @override
  Future<Either<Failure, List<entities.Task>>> getTodayTasks() async {
    return await _getTasks(() => remoteDataSource.getTodayTasks());
  }

  @override
  Future<Either<Failure, List<entities.Task>>> getOverdueTasks() async {
    return await _getTasks(() => remoteDataSource.getOverdueTasks());
  }

  @override
  Future<Either<Failure, entities.Task>> createTask(entities.Task task) async {
    if (await networkInfo.isConnected) {
      try {
        final createdTask = await remoteDataSource.createTask(task);
        return Right(createdTask);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Server error'));
      } catch (e) {
        return Left(ServerFailure('Unknown error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, entities.Task>> updateTask(entities.Task task) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedTask = await remoteDataSource.updateTask(task);
        return Right(updatedTask);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Server error'));
      } catch (e) {
        return Left(ServerFailure('Unknown error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, entities.Task>> completeTask(String taskId,
      {String? notes, int? actualMinutes}) async {
    if (await networkInfo.isConnected) {
      try {
        final completedTask = await remoteDataSource.completeTask(
          taskId,
          notes: notes,
          actualMinutes: actualMinutes,
        );
        return Right(completedTask);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Server error'));
      } catch (e) {
        return Left(ServerFailure('Unknown error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteTask(taskId);
        return const Right(null);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Server error'));
      } catch (e) {
        return Left(ServerFailure('Unknown error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getTaskStats() async {
    if (await networkInfo.isConnected) {
      try {
        final stats = await remoteDataSource.getTaskStats();
        return Right(stats);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Server error'));
      } catch (e) {
        return Left(ServerFailure('Unknown error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  /// Helper method to reduce code duplication for getting tasks
  Future<Either<Failure, List<entities.Task>>> _getTasks(
      Future<List<Task>> Function() getTasksFunction) async {
    if (await networkInfo.isConnected) {
      try {
        final tasks = await getTasksFunction();
        return Right(tasks);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? 'Server error'));
      } catch (e) {
        return Left(ServerFailure('Unknown error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
