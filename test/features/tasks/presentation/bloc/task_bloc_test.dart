import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seedfy_app/core/errors/failures.dart';
import 'package:seedfy_app/core/usecases/usecase.dart';
import 'package:seedfy_app/features/tasks/domain/repositories/task_repository.dart';
import 'package:seedfy_app/features/tasks/domain/usecases/complete_task.dart';
import 'package:seedfy_app/features/tasks/domain/usecases/create_task.dart';
import 'package:seedfy_app/features/tasks/domain/usecases/get_user_tasks.dart';
import 'package:seedfy_app/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:seedfy_app/features/tasks/presentation/bloc/task_event.dart';
import 'package:seedfy_app/features/tasks/presentation/bloc/task_state.dart';
import 'package:seedfy_app/shared/domain/entities/task.dart' as entities;

class MockGetUserTasks extends Mock implements GetUserTasks {}

class MockCreateTask extends Mock implements CreateTask {}

class MockCompleteTask extends Mock implements CompleteTask {}

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late TaskBloc taskBloc;
  late MockGetUserTasks mockGetUserTasks;
  late MockCreateTask mockCreateTask;
  late MockCompleteTask mockCompleteTask;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockGetUserTasks = MockGetUserTasks();
    mockCreateTask = MockCreateTask();
    mockCompleteTask = MockCompleteTask();
    mockTaskRepository = MockTaskRepository();

    taskBloc = TaskBloc(
      getUserTasks: mockGetUserTasks,
      createTask: mockCreateTask,
      completeTask: mockCompleteTask,
      taskRepository: mockTaskRepository,
    );
  });

  tearDown(() {
    taskBloc.close();
  });

  group('TaskBloc', () {
    final testTask = entities.Task(
      id: '1',
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

    final testTasks = [testTask];
    final testStats = TaskStats(
      totalTasks: 10,
      completedTasks: 5,
      pendingTasks: 3,
      overdueTasks: 2,
      completionRate: 0.5,
    );

    test('initial state is TaskState.initial', () {
      expect(taskBloc.state, equals(const TaskState.initial()));
    });

    group('GetUserTasks', () {
      blocTest<TaskBloc, TaskState>(
        'emits [loading, tasksLoaded] when getUserTasks succeeds',
        build: () {
          when(() => mockGetUserTasks(NoParams()))
              .thenAnswer((_) async => Right(testTasks));
          return taskBloc;
        },
        act: (bloc) => bloc.add(const TaskEvent.getUserTasks()),
        expect: () => [
          const TaskState.loading(),
          TaskState.tasksLoaded(testTasks),
        ],
        verify: (_) {
          verify(() => mockGetUserTasks(NoParams())).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emits [loading, error] when getUserTasks fails',
        build: () {
          when(() => mockGetUserTasks(NoParams())).thenAnswer(
              (_) async => const Left(ServerFailure('Server error')));
          return taskBloc;
        },
        act: (bloc) => bloc.add(const TaskEvent.getUserTasks()),
        expect: () => [
          const TaskState.loading(),
          const TaskState.error('Server error'),
        ],
      );
    });

    group('GetFarmTasks', () {
      const farmId = 'farm123';

      blocTest<TaskBloc, TaskState>(
        'emits [loading, tasksLoaded] when getFarmTasks succeeds',
        build: () {
          when(() => mockTaskRepository.getFarmTasks(farmId))
              .thenAnswer((_) async => Right(testTasks));
          return taskBloc;
        },
        act: (bloc) => bloc.add(const TaskEvent.getFarmTasks(farmId)),
        expect: () => [
          const TaskState.loading(),
          TaskState.tasksLoaded(testTasks),
        ],
        verify: (_) {
          verify(() => mockTaskRepository.getFarmTasks(farmId)).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emits [loading, error] when getFarmTasks fails',
        build: () {
          when(() => mockTaskRepository.getFarmTasks(farmId)).thenAnswer(
              (_) async => const Left(NotFoundFailure('Farm not found')));
          return taskBloc;
        },
        act: (bloc) => bloc.add(const TaskEvent.getFarmTasks(farmId)),
        expect: () => [
          const TaskState.loading(),
          const TaskState.error('Farm not found'),
        ],
      );
    });

    group('GetPendingTasks', () {
      blocTest<TaskBloc, TaskState>(
        'emits [loading, tasksLoaded] when getPendingTasks succeeds',
        build: () {
          when(() => mockTaskRepository.getPendingTasks())
              .thenAnswer((_) async => Right(testTasks));
          return taskBloc;
        },
        act: (bloc) => bloc.add(const TaskEvent.getPendingTasks()),
        expect: () => [
          const TaskState.loading(),
          TaskState.tasksLoaded(testTasks),
        ],
      );
    });

    group('GetTodayTasks', () {
      blocTest<TaskBloc, TaskState>(
        'emits [loading, tasksLoaded] when getTodayTasks succeeds',
        build: () {
          when(() => mockTaskRepository.getTodayTasks())
              .thenAnswer((_) async => Right(testTasks));
          return taskBloc;
        },
        act: (bloc) => bloc.add(const TaskEvent.getTodayTasks()),
        expect: () => [
          const TaskState.loading(),
          TaskState.tasksLoaded(testTasks),
        ],
      );
    });

    group('GetOverdueTasks', () {
      blocTest<TaskBloc, TaskState>(
        'emits [loading, tasksLoaded] when getOverdueTasks succeeds',
        build: () {
          when(() => mockTaskRepository.getOverdueTasks())
              .thenAnswer((_) async => Right(testTasks));
          return taskBloc;
        },
        act: (bloc) => bloc.add(const TaskEvent.getOverdueTasks()),
        expect: () => [
          const TaskState.loading(),
          TaskState.tasksLoaded(testTasks),
        ],
      );
    });

    group('CreateTask', () {
      blocTest<TaskBloc, TaskState>(
        'emits [loading, taskCreated, loading, tasksLoaded] when createTask succeeds',
        build: () {
          when(() => mockCreateTask(CreateTaskParams(task: testTask)))
              .thenAnswer((_) async => Right(testTask));
          when(() => mockGetUserTasks(NoParams()))
              .thenAnswer((_) async => Right(testTasks));
          return taskBloc;
        },
        act: (bloc) => bloc.add(TaskEvent.createTask(testTask)),
        expect: () => [
          const TaskState.loading(),
          TaskState.taskCreated(testTask),
          const TaskState.loading(),
          TaskState.tasksLoaded(testTasks),
        ],
        verify: (_) {
          verify(() => mockCreateTask(CreateTaskParams(task: testTask)))
              .called(1);
          verify(() => mockGetUserTasks(NoParams())).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emits [loading, error] when createTask fails',
        build: () {
          when(() => mockCreateTask(CreateTaskParams(task: testTask)))
              .thenAnswer((_) async =>
                  const Left(ValidationFailure('Invalid task data')));
          return taskBloc;
        },
        act: (bloc) => bloc.add(TaskEvent.createTask(testTask)),
        expect: () => [
          const TaskState.loading(),
          const TaskState.error('Invalid task data'),
        ],
        verify: (_) {
          verify(() => mockCreateTask(CreateTaskParams(task: testTask)))
              .called(1);
          verifyNever(() => mockGetUserTasks(NoParams()));
        },
      );
    });

    group('CompleteTask', () {
      const taskId = 'task123';
      const notes = 'Task completed successfully';
      const actualMinutes = 45;

      blocTest<TaskBloc, TaskState>(
        'emits [loading, taskCompleted, loading, tasksLoaded] when completeTask succeeds',
        build: () {
          when(() => mockCompleteTask(const CompleteTaskParams(
                    taskId: taskId,
                    notes: notes,
                    actualMinutes: actualMinutes,
                  )))
              .thenAnswer((_) async =>
                  Right(testTask.copyWith(status: entities.TaskStatus.completed)));
          when(() => mockGetUserTasks(NoParams()))
              .thenAnswer((_) async => Right(testTasks));
          return taskBloc;
        },
        act: (bloc) => bloc
            .add(const TaskEvent.completeTask(taskId, notes, actualMinutes)),
        expect: () => [
          const TaskState.loading(),
          TaskState.taskCompleted(
              testTask.copyWith(status: entities.TaskStatus.completed)),
          const TaskState.loading(),
          TaskState.tasksLoaded(testTasks),
        ],
        verify: (_) {
          verify(() => mockCompleteTask(const CompleteTaskParams(
                taskId: taskId,
                notes: notes,
                actualMinutes: actualMinutes,
              ))).called(1);
          verify(() => mockGetUserTasks(NoParams())).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emits [loading, error] when completeTask fails',
        build: () {
          when(() => mockCompleteTask(const CompleteTaskParams(
                    taskId: taskId,
                    notes: notes,
                    actualMinutes: actualMinutes,
                  )))
              .thenAnswer(
                  (_) async => const Left(NotFoundFailure('Task not found')));
          return taskBloc;
        },
        act: (bloc) => bloc
            .add(const TaskEvent.completeTask(taskId, notes, actualMinutes)),
        expect: () => [
          const TaskState.loading(),
          const TaskState.error('Task not found'),
        ],
      );
    });

    group('UpdateTask', () {
      final updatedTask = testTask.copyWith(title: 'Updated task');

      blocTest<TaskBloc, TaskState>(
        'emits [loading, taskUpdated, loading, tasksLoaded] when updateTask succeeds',
        build: () {
          when(() => mockTaskRepository.updateTask(updatedTask))
              .thenAnswer((_) async => Right(updatedTask));
          when(() => mockGetUserTasks(NoParams()))
              .thenAnswer((_) async => Right([updatedTask]));
          return taskBloc;
        },
        act: (bloc) => bloc.add(TaskEvent.updateTask(updatedTask)),
        expect: () => [
          const TaskState.loading(),
          TaskState.taskUpdated(updatedTask),
          const TaskState.loading(),
          TaskState.tasksLoaded([updatedTask]),
        ],
      );
    });

    group('DeleteTask', () {
      const taskId = 'task123';

      blocTest<TaskBloc, TaskState>(
        'emits [loading, taskDeleted, loading, tasksLoaded] when deleteTask succeeds',
        build: () {
          when(() => mockTaskRepository.deleteTask(taskId))
              .thenAnswer((_) async => const Right(null));
          when(() => mockGetUserTasks(NoParams()))
              .thenAnswer((_) async => const Right([]));
          return taskBloc;
        },
        act: (bloc) => bloc.add(const TaskEvent.deleteTask(taskId)),
        expect: () => [
          const TaskState.loading(),
          const TaskState.taskDeleted(),
          const TaskState.loading(),
          const TaskState.tasksLoaded([]),
        ],
      );
    });

    group('GetTaskStats', () {
      blocTest<TaskBloc, TaskState>(
        'emits [loading, statsLoaded] when getTaskStats succeeds',
        build: () {
          when(() => mockTaskRepository.getTaskStats())
              .thenAnswer((_) async => Right(testStats));
          return taskBloc;
        },
        act: (bloc) => bloc.add(const TaskEvent.getTaskStats()),
        expect: () => [
          const TaskState.loading(),
          TaskState.statsLoaded(testStats),
        ],
      );
    });

    group('RefreshTasks', () {
      blocTest<TaskBloc, TaskState>(
        'emits [tasksLoaded] when refreshTasks succeeds (no loading state)',
        build: () {
          when(() => mockGetUserTasks(NoParams()))
              .thenAnswer((_) async => Right(testTasks));
          return taskBloc;
        },
        act: (bloc) => bloc.add(const TaskEvent.refreshTasks()),
        expect: () => [
          TaskState.tasksLoaded(testTasks),
        ],
      );

      blocTest<TaskBloc, TaskState>(
        'emits [error] when refreshTasks fails',
        build: () {
          when(() => mockGetUserTasks(NoParams())).thenAnswer(
              (_) async => const Left(NetworkFailure('No internet')));
          return taskBloc;
        },
        act: (bloc) => bloc.add(const TaskEvent.refreshTasks()),
        expect: () => [
          const TaskState.error('No internet'),
        ],
      );
    });

    group('Edge cases', () {
      blocTest<TaskBloc, TaskState>(
        'handles empty tasks list correctly',
        build: () {
          when(() => mockGetUserTasks(NoParams()))
              .thenAnswer((_) async => const Right([]));
          return taskBloc;
        },
        act: (bloc) => bloc.add(const TaskEvent.getUserTasks()),
        expect: () => [
          const TaskState.loading(),
          const TaskState.tasksLoaded([]),
        ],
      );

      blocTest<TaskBloc, TaskState>(
        'handles task with null optional fields',
        build: () {
          final taskWithNulls = testTask.copyWith(
            description: null,
            estimatedMinutes: null,
          );
          when(() => mockCreateTask(CreateTaskParams(task: taskWithNulls)))
              .thenAnswer((_) async => Right(taskWithNulls));
          when(() => mockGetUserTasks(NoParams()))
              .thenAnswer((_) async => Right([taskWithNulls]));
          return taskBloc;
        },
        act: (bloc) => bloc.add(TaskEvent.createTask(taskWithNulls)),
        expect: () => [
          const TaskState.loading(),
          TaskState.taskCreated(taskWithNulls),
          const TaskState.loading(),
          TaskState.tasksLoaded([taskWithNulls]),
        ],
      );
    });

    group('Multiple operations', () {
      blocTest<TaskBloc, TaskState>(
        'handles rapid sequential events correctly',
        build: () {
          when(() => mockGetUserTasks(NoParams()))
              .thenAnswer((_) async => Right(testTasks));
          when(() => mockTaskRepository.getPendingTasks())
              .thenAnswer((_) async => Right(testTasks));
          return taskBloc;
        },
        act: (bloc) {
          bloc.add(const TaskEvent.getUserTasks());
          bloc.add(const TaskEvent.getPendingTasks());
        },
        expect: () => [
          const TaskState.loading(),
          TaskState.tasksLoaded(testTasks),
          const TaskState.loading(),
          TaskState.tasksLoaded(testTasks),
        ],
      );
    });
  });
}
