import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seedfy_app/core/errors/failures.dart';
import 'package:seedfy_app/features/tasks/domain/repositories/task_repository.dart';
import 'package:seedfy_app/features/tasks/domain/usecases/complete_task.dart';
import 'package:seedfy_app/shared/domain/entities/task.dart' as entities;

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late CompleteTask completeTask;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    completeTask = CompleteTask(mockTaskRepository);
  });

  group('CompleteTask UseCase', () {
    final testTask = entities.Task(
      id: 'task123',
      plantingId: 'planting1',
      title: 'Water plants',
      description: 'Water all vegetables',
      type: entities.TaskType.water,
      status: entities.TaskStatus.pending,
      dueDate: DateTime(2023, 1, 15),
      done: false,
      createdAt: DateTime(2023, 1, 1),
      estimatedMinutes: 30,
    );

    final completedTask = testTask.copyWith(
      status: entities.TaskStatus.completed,
      completedAt: DateTime(2023, 1, 15),
      actualMinutes: 45,
      notes: 'Task completed successfully',
    );

    group('Successful completion', () {
      test('should complete task with notes and actual minutes', () async {
        // Arrange
        const taskId = 'task123';
        const notes = 'Task completed successfully';
        const actualMinutes = 45;

        when(() => mockTaskRepository.completeTask(
              taskId,
              notes: notes,
              actualMinutes: actualMinutes,
            )).thenAnswer((_) async => Right(completedTask));

        // Act
        final result = await completeTask(const CompleteTaskParams(
          taskId: taskId,
          notes: notes,
          actualMinutes: actualMinutes,
        ));

        // Assert
        expect(result, equals(Right(completedTask)));
        verify(() => mockTaskRepository.completeTask(
              taskId,
              notes: notes,
              actualMinutes: actualMinutes,
            )).called(1);
        verifyNoMoreInteractions(mockTaskRepository);
      });

      test('should complete task without notes or actual minutes', () async {
        // Arrange
        const taskId = 'task123';
        final basicCompletedTask =
            testTask.copyWith(status: entities.TaskStatus.completed);

        when(() => mockTaskRepository.completeTask(
              taskId,
              notes: null,
              actualMinutes: null,
            )).thenAnswer((_) async => Right(basicCompletedTask));

        // Act
        final result =
            await completeTask(const CompleteTaskParams(taskId: taskId));

        // Assert
        expect(result, equals(Right(basicCompletedTask)));
        verify(() => mockTaskRepository.completeTask(
              taskId,
              notes: null,
              actualMinutes: null,
            )).called(1);
      });

      test('should complete task with only notes', () async {
        // Arrange
        const taskId = 'task123';
        const notes = 'Completed with no issues';
        final taskWithNotes = testTask.copyWith(
          status: entities.TaskStatus.completed,
          notes: notes,
        );

        when(() => mockTaskRepository.completeTask(
              taskId,
              notes: notes,
              actualMinutes: null,
            )).thenAnswer((_) async => Right(taskWithNotes));

        // Act
        final result = await completeTask(const CompleteTaskParams(
          taskId: taskId,
          notes: notes,
        ));

        // Assert
        expect(result, equals(Right(taskWithNotes)));
        verify(() => mockTaskRepository.completeTask(
              taskId,
              notes: notes,
              actualMinutes: null,
            )).called(1);
      });

      test('should complete task with only actual minutes', () async {
        // Arrange
        const taskId = 'task123';
        const actualMinutes = 25;
        final taskWithMinutes = testTask.copyWith(
          status: entities.TaskStatus.completed,
          actualMinutes: actualMinutes,
        );

        when(() => mockTaskRepository.completeTask(
              taskId,
              notes: null,
              actualMinutes: actualMinutes,
            )).thenAnswer((_) async => Right(taskWithMinutes));

        // Act
        final result = await completeTask(const CompleteTaskParams(
          taskId: taskId,
          actualMinutes: actualMinutes,
        ));

        // Assert
        expect(result, equals(Right(taskWithMinutes)));
        verify(() => mockTaskRepository.completeTask(
              taskId,
              notes: null,
              actualMinutes: actualMinutes,
            )).called(1);
      });
    });

    group('Failure cases', () {
      test('should return NotFoundFailure when task does not exist', () async {
        // Arrange
        const taskId = 'nonexistent';
        const failure = ValidationFailure('Task not found');

        when(() => mockTaskRepository.completeTask(
              taskId,
              notes: null,
              actualMinutes: null,
            )).thenAnswer((_) async => const Left(failure));

        // Act
        final result =
            await completeTask(const CompleteTaskParams(taskId: taskId));

        // Assert
        expect(result, equals(const Left(failure)));
        verify(() => mockTaskRepository.completeTask(
              taskId,
              notes: null,
              actualMinutes: null,
            )).called(1);
      });

      test('should return ValidationFailure when task is already completed',
          () async {
        // Arrange
        const taskId = 'completed_task';
        const failure = ValidationFailure('Task is already completed');

        when(() => mockTaskRepository.completeTask(
              taskId,
              notes: null,
              actualMinutes: null,
            )).thenAnswer((_) async => const Left(failure));

        // Act
        final result =
            await completeTask(const CompleteTaskParams(taskId: taskId));

        // Assert
        expect(result, equals(const Left(failure)));
        verify(() => mockTaskRepository.completeTask(
              taskId,
              notes: null,
              actualMinutes: null,
            )).called(1);
      });

      test('should return ServerFailure when server error occurs', () async {
        // Arrange
        const taskId = 'task123';
        const failure = ServerFailure('Server error occurred');

        when(() => mockTaskRepository.completeTask(
              taskId,
              notes: null,
              actualMinutes: null,
            )).thenAnswer((_) async => const Left(failure));

        // Act
        final result =
            await completeTask(const CompleteTaskParams(taskId: taskId));

        // Assert
        expect(result, equals(const Left(failure)));
        verify(() => mockTaskRepository.completeTask(
              taskId,
              notes: null,
              actualMinutes: null,
            )).called(1);
      });

      test('should return NetworkFailure when network is unavailable',
          () async {
        // Arrange
        const taskId = 'task123';
        const failure = NetworkFailure('No internet connection');

        when(() => mockTaskRepository.completeTask(
              taskId,
              notes: null,
              actualMinutes: null,
            )).thenAnswer((_) async => const Left(failure));

        // Act
        final result =
            await completeTask(const CompleteTaskParams(taskId: taskId));

        // Assert
        expect(result, equals(const Left(failure)));
        verify(() => mockTaskRepository.completeTask(
              taskId,
              notes: null,
              actualMinutes: null,
            )).called(1);
      });
    });

    group('Edge cases', () {
      test('should handle very long notes', () async {
        // Arrange
        const taskId = 'task123';
        final longNotes = 'A' * 2000; // Very long notes
        final taskWithLongNotes = testTask.copyWith(
          status: entities.TaskStatus.completed,
          notes: longNotes,
        );

        when(() => mockTaskRepository.completeTask(
              taskId,
              notes: longNotes,
              actualMinutes: null,
            )).thenAnswer((_) async => Right(taskWithLongNotes));

        // Act
        final result = await completeTask(CompleteTaskParams(
          taskId: taskId,
          notes: longNotes,
        ));

        // Assert
        expect(result, equals(Right(taskWithLongNotes)));
      });

      test('should handle negative actual minutes', () async {
        // Arrange
        const taskId = 'task123';
        const negativeMinutes = -10;
        const failure = ValidationFailure('Actual minutes cannot be negative');

        when(() => mockTaskRepository.completeTask(
              taskId,
              notes: null,
              actualMinutes: negativeMinutes,
            )).thenAnswer((_) async => const Left(failure));

        // Act
        final result = await completeTask(const CompleteTaskParams(
          taskId: taskId,
          actualMinutes: negativeMinutes,
        ));

        // Assert
        expect(result, equals(const Left(failure)));
      });

      test('should handle zero actual minutes', () async {
        // Arrange
        const taskId = 'task123';
        const zeroMinutes = 0;
        final taskWithZeroMinutes = testTask.copyWith(
          status: entities.TaskStatus.completed,
          actualMinutes: zeroMinutes,
        );

        when(() => mockTaskRepository.completeTask(
              taskId,
              notes: null,
              actualMinutes: zeroMinutes,
            )).thenAnswer((_) async => Right(taskWithZeroMinutes));

        // Act
        final result = await completeTask(const CompleteTaskParams(
          taskId: taskId,
          actualMinutes: zeroMinutes,
        ));

        // Assert
        expect(result, equals(Right(taskWithZeroMinutes)));
      });

      test('should handle empty string notes', () async {
        // Arrange
        const taskId = 'task123';
        const emptyNotes = '';
        final taskWithEmptyNotes = testTask.copyWith(
          status: entities.TaskStatus.completed,
          notes: emptyNotes,
        );

        when(() => mockTaskRepository.completeTask(
              taskId,
              notes: emptyNotes,
              actualMinutes: null,
            )).thenAnswer((_) async => Right(taskWithEmptyNotes));

        // Act
        final result = await completeTask(const CompleteTaskParams(
          taskId: taskId,
          notes: emptyNotes,
        ));

        // Assert
        expect(result, equals(Right(taskWithEmptyNotes)));
      });

      test('should handle special characters in task ID', () async {
        // Arrange
        const specialTaskId = 'task-123_@#\$%';
        final taskWithSpecialId = testTask.copyWith(
          id: specialTaskId,
          status: entities.TaskStatus.completed,
        );

        when(() => mockTaskRepository.completeTask(
              specialTaskId,
              notes: null,
              actualMinutes: null,
            )).thenAnswer((_) async => Right(taskWithSpecialId));

        // Act
        final result = await completeTask(const CompleteTaskParams(
          taskId: specialTaskId,
        ));

        // Assert
        expect(result, equals(Right(taskWithSpecialId)));
      });
    });
  });

  group('CompleteTaskParams', () {
    test('should be equal when all parameters are the same', () {
      const params1 = CompleteTaskParams(
        taskId: 'task123',
        notes: 'Test notes',
        actualMinutes: 30,
      );
      const params2 = CompleteTaskParams(
        taskId: 'task123',
        notes: 'Test notes',
        actualMinutes: 30,
      );

      expect(params1, equals(params2));
      expect(params1.hashCode, equals(params2.hashCode));
    });

    test('should not be equal when task IDs are different', () {
      const params1 = CompleteTaskParams(taskId: 'task123');
      const params2 = CompleteTaskParams(taskId: 'task456');

      expect(params1, isNot(equals(params2)));
    });

    test('should not be equal when notes are different', () {
      const params1 = CompleteTaskParams(
        taskId: 'task123',
        notes: 'Notes 1',
      );
      const params2 = CompleteTaskParams(
        taskId: 'task123',
        notes: 'Notes 2',
      );

      expect(params1, isNot(equals(params2)));
    });

    test('should not be equal when actual minutes are different', () {
      const params1 = CompleteTaskParams(
        taskId: 'task123',
        actualMinutes: 30,
      );
      const params2 = CompleteTaskParams(
        taskId: 'task123',
        actualMinutes: 45,
      );

      expect(params1, isNot(equals(params2)));
    });

    test('should handle null values correctly in equality', () {
      const params1 = CompleteTaskParams(
        taskId: 'task123',
        notes: null,
        actualMinutes: null,
      );
      const params2 = CompleteTaskParams(taskId: 'task123');

      expect(params1, equals(params2));
    });

    test('should have correct props', () {
      const params = CompleteTaskParams(
        taskId: 'task123',
        notes: 'Test notes',
        actualMinutes: 30,
      );

      expect(params.props, equals(['task123', 'Test notes', 30]));
    });

    test('should have correct props with nulls', () {
      const params = CompleteTaskParams(taskId: 'task123');

      expect(params.props, equals(['task123', null, null]));
    });
  });
}
