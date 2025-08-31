import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/usecases/complete_task.dart';
import '../../domain/usecases/create_task.dart';
import '../../domain/usecases/get_user_tasks.dart';
import 'task_event.dart';
import 'task_state.dart';

@injectable
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetUserTasks getUserTasks;
  final GetPendingTasks getPendingTasks;
  final GetTodayTasks getTodayTasks;
  final GetOverdueTasks getOverdueTasks;
  final CreateTask createTask;
  final CompleteTask completeTask;
  final TaskRepository taskRepository;

  TaskBloc({
    required this.getUserTasks,
    required this.getPendingTasks,
    required this.getTodayTasks,
    required this.getOverdueTasks,
    required this.createTask,
    required this.completeTask,
    required this.taskRepository,
  }) : super(const TaskState.initial()) {
    on<_GetUserTasks>(_onGetUserTasks);
    on<_GetFarmTasks>(_onGetFarmTasks);
    on<_GetPendingTasks>(_onGetPendingTasks);
    on<_GetTodayTasks>(_onGetTodayTasks);
    on<_GetOverdueTasks>(_onGetOverdueTasks);
    on<_CreateTask>(_onCreateTask);
    on<_UpdateTask>(_onUpdateTask);
    on<_CompleteTask>(_onCompleteTask);
    on<_DeleteTask>(_onDeleteTask);
    on<_GetTaskStats>(_onGetTaskStats);
    on<_RefreshTasks>(_onRefreshTasks);
  }

  Future<void> _onGetUserTasks(
    _GetUserTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskState.loading());

    final result = await getUserTasks(NoParams());

    result.fold(
      (failure) => emit(TaskState.error(failure.message)),
      (tasks) => emit(TaskState.tasksLoaded(tasks)),
    );
  }

  Future<void> _onGetFarmTasks(
    _GetFarmTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskState.loading());

    final result = await taskRepository.getFarmTasks(event.farmId);

    result.fold(
      (failure) => emit(TaskState.error(failure.message)),
      (tasks) => emit(TaskState.tasksLoaded(tasks)),
    );
  }

  Future<void> _onGetPendingTasks(
    _GetPendingTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskState.loading());

    final result = await getPendingTasks(NoParams());

    result.fold(
      (failure) => emit(TaskState.error(failure.message)),
      (tasks) => emit(TaskState.pendingTasksLoaded(tasks)),
    );
  }

  Future<void> _onGetTodayTasks(
    _GetTodayTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskState.loading());

    final result = await getTodayTasks(NoParams());

    result.fold(
      (failure) => emit(TaskState.error(failure.message)),
      (tasks) => emit(TaskState.todayTasksLoaded(tasks)),
    );
  }

  Future<void> _onGetOverdueTasks(
    _GetOverdueTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskState.loading());

    final result = await getOverdueTasks(NoParams());

    result.fold(
      (failure) => emit(TaskState.error(failure.message)),
      (tasks) => emit(TaskState.overdueTasksLoaded(tasks)),
    );
  }

  Future<void> _onCreateTask(
    _CreateTask event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskState.loading());

    final result = await createTask(CreateTaskParams(task: event.task));

    result.fold(
      (failure) => emit(TaskState.error(failure.message)),
      (task) {
        emit(TaskState.taskCreated(task));
        // Refresh tasks list after creation
        add(const TaskEvent.getUserTasks());
      },
    );
  }

  Future<void> _onUpdateTask(
    _UpdateTask event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskState.loading());

    final result = await taskRepository.updateTask(event.task);

    result.fold(
      (failure) => emit(TaskState.error(failure.message)),
      (task) {
        emit(TaskState.taskUpdated(task));
        // Refresh tasks list after update
        add(const TaskEvent.getUserTasks());
      },
    );
  }

  Future<void> _onCompleteTask(
    _CompleteTask event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskState.loading());

    final result = await completeTask(CompleteTaskParams(
      taskId: event.taskId,
      notes: event.notes,
      actualMinutes: event.actualMinutes,
    ));

    result.fold(
      (failure) => emit(TaskState.error(failure.message)),
      (task) {
        emit(TaskState.taskCompleted(task));
        // Refresh tasks list after completion
        add(const TaskEvent.getUserTasks());
      },
    );
  }

  Future<void> _onDeleteTask(
    _DeleteTask event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskState.loading());

    final result = await taskRepository.deleteTask(event.taskId);

    result.fold(
      (failure) => emit(TaskState.error(failure.message)),
      (_) {
        emit(const TaskState.taskDeleted());
        // Refresh tasks list after deletion
        add(const TaskEvent.getUserTasks());
      },
    );
  }

  Future<void> _onGetTaskStats(
    _GetTaskStats event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskState.loading());

    final result = await taskRepository.getTaskStats();

    result.fold(
      (failure) => emit(TaskState.error(failure.message)),
      (stats) => emit(TaskState.statsLoaded(stats)),
    );
  }

  Future<void> _onRefreshTasks(
    _RefreshTasks event,
    Emitter<TaskState> emit,
  ) async {
    // Don't emit loading state for refresh to avoid UI flicker
    final result = await getUserTasks(NoParams());

    result.fold(
      (failure) => emit(TaskState.error(failure.message)),
      (tasks) => emit(TaskState.tasksLoaded(tasks)),
    );
  }
}
