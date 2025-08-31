import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/entities/task.dart';

part 'task_state.freezed.dart';

@freezed
class TaskState with _$TaskState {
  const factory TaskState.initial() = _Initial;
  const factory TaskState.loading() = _Loading;
  const factory TaskState.tasksLoaded(List<Task> tasks) = _TasksLoaded;
  const factory TaskState.pendingTasksLoaded(List<Task> tasks) = _PendingTasksLoaded;
  const factory TaskState.todayTasksLoaded(List<Task> tasks) = _TodayTasksLoaded;
  const factory TaskState.overdueTasksLoaded(List<Task> tasks) = _OverdueTasksLoaded;
  const factory TaskState.taskCreated(Task task) = _TaskCreated;
  const factory TaskState.taskUpdated(Task task) = _TaskUpdated;
  const factory TaskState.taskCompleted(Task task) = _TaskCompleted;
  const factory TaskState.taskDeleted() = _TaskDeleted;
  const factory TaskState.statsLoaded(Map<String, dynamic> stats) = _StatsLoaded;
  const factory TaskState.error(String message) = _Error;
}