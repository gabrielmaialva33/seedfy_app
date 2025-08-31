import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/entities/task.dart';

part 'task_event.freezed.dart';

@freezed
class TaskEvent with _$TaskEvent {
  const factory TaskEvent.getUserTasks() = _GetUserTasks;

  const factory TaskEvent.getFarmTasks(String farmId) = _GetFarmTasks;

  const factory TaskEvent.getPendingTasks() = _GetPendingTasks;

  const factory TaskEvent.getTodayTasks() = _GetTodayTasks;

  const factory TaskEvent.getOverdueTasks() = _GetOverdueTasks;

  const factory TaskEvent.createTask(Task task) = _CreateTask;

  const factory TaskEvent.updateTask(Task task) = _UpdateTask;

  const factory TaskEvent.completeTask({
    required String taskId,
    String? notes,
    int? actualMinutes,
  }) = _CompleteTask;

  const factory TaskEvent.deleteTask(String taskId) = _DeleteTask;

  const factory TaskEvent.getTaskStats() = _GetTaskStats;

  const factory TaskEvent.refreshTasks() = _RefreshTasks;
}
