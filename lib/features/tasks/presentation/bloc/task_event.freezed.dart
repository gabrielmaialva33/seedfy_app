// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is TaskEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TaskEvent()';
  }
}

/// @nodoc
class $TaskEventCopyWith<$Res> {
  $TaskEventCopyWith(TaskEvent _, $Res Function(TaskEvent) __);
}

/// Adds pattern-matching-related methods to [TaskEvent].
extension TaskEventPatterns on TaskEvent {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_GetUserTasks value)? getUserTasks,
    TResult Function(_GetFarmTasks value)? getFarmTasks,
    TResult Function(_GetPendingTasks value)? getPendingTasks,
    TResult Function(_GetTodayTasks value)? getTodayTasks,
    TResult Function(_GetOverdueTasks value)? getOverdueTasks,
    TResult Function(_CreateTask value)? createTask,
    TResult Function(_UpdateTask value)? updateTask,
    TResult Function(_CompleteTask value)? completeTask,
    TResult Function(_DeleteTask value)? deleteTask,
    TResult Function(_GetTaskStats value)? getTaskStats,
    TResult Function(_RefreshTasks value)? refreshTasks,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GetUserTasks() when getUserTasks != null:
        return getUserTasks(_that);
      case _GetFarmTasks() when getFarmTasks != null:
        return getFarmTasks(_that);
      case _GetPendingTasks() when getPendingTasks != null:
        return getPendingTasks(_that);
      case _GetTodayTasks() when getTodayTasks != null:
        return getTodayTasks(_that);
      case _GetOverdueTasks() when getOverdueTasks != null:
        return getOverdueTasks(_that);
      case _CreateTask() when createTask != null:
        return createTask(_that);
      case _UpdateTask() when updateTask != null:
        return updateTask(_that);
      case _CompleteTask() when completeTask != null:
        return completeTask(_that);
      case _DeleteTask() when deleteTask != null:
        return deleteTask(_that);
      case _GetTaskStats() when getTaskStats != null:
        return getTaskStats(_that);
      case _RefreshTasks() when refreshTasks != null:
        return refreshTasks(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_GetUserTasks value) getUserTasks,
    required TResult Function(_GetFarmTasks value) getFarmTasks,
    required TResult Function(_GetPendingTasks value) getPendingTasks,
    required TResult Function(_GetTodayTasks value) getTodayTasks,
    required TResult Function(_GetOverdueTasks value) getOverdueTasks,
    required TResult Function(_CreateTask value) createTask,
    required TResult Function(_UpdateTask value) updateTask,
    required TResult Function(_CompleteTask value) completeTask,
    required TResult Function(_DeleteTask value) deleteTask,
    required TResult Function(_GetTaskStats value) getTaskStats,
    required TResult Function(_RefreshTasks value) refreshTasks,
  }) {
    final _that = this;
    switch (_that) {
      case _GetUserTasks():
        return getUserTasks(_that);
      case _GetFarmTasks():
        return getFarmTasks(_that);
      case _GetPendingTasks():
        return getPendingTasks(_that);
      case _GetTodayTasks():
        return getTodayTasks(_that);
      case _GetOverdueTasks():
        return getOverdueTasks(_that);
      case _CreateTask():
        return createTask(_that);
      case _UpdateTask():
        return updateTask(_that);
      case _CompleteTask():
        return completeTask(_that);
      case _DeleteTask():
        return deleteTask(_that);
      case _GetTaskStats():
        return getTaskStats(_that);
      case _RefreshTasks():
        return refreshTasks(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_GetUserTasks value)? getUserTasks,
    TResult? Function(_GetFarmTasks value)? getFarmTasks,
    TResult? Function(_GetPendingTasks value)? getPendingTasks,
    TResult? Function(_GetTodayTasks value)? getTodayTasks,
    TResult? Function(_GetOverdueTasks value)? getOverdueTasks,
    TResult? Function(_CreateTask value)? createTask,
    TResult? Function(_UpdateTask value)? updateTask,
    TResult? Function(_CompleteTask value)? completeTask,
    TResult? Function(_DeleteTask value)? deleteTask,
    TResult? Function(_GetTaskStats value)? getTaskStats,
    TResult? Function(_RefreshTasks value)? refreshTasks,
  }) {
    final _that = this;
    switch (_that) {
      case _GetUserTasks() when getUserTasks != null:
        return getUserTasks(_that);
      case _GetFarmTasks() when getFarmTasks != null:
        return getFarmTasks(_that);
      case _GetPendingTasks() when getPendingTasks != null:
        return getPendingTasks(_that);
      case _GetTodayTasks() when getTodayTasks != null:
        return getTodayTasks(_that);
      case _GetOverdueTasks() when getOverdueTasks != null:
        return getOverdueTasks(_that);
      case _CreateTask() when createTask != null:
        return createTask(_that);
      case _UpdateTask() when updateTask != null:
        return updateTask(_that);
      case _CompleteTask() when completeTask != null:
        return completeTask(_that);
      case _DeleteTask() when deleteTask != null:
        return deleteTask(_that);
      case _GetTaskStats() when getTaskStats != null:
        return getTaskStats(_that);
      case _RefreshTasks() when refreshTasks != null:
        return refreshTasks(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getUserTasks,
    TResult Function(String farmId)? getFarmTasks,
    TResult Function()? getPendingTasks,
    TResult Function()? getTodayTasks,
    TResult Function()? getOverdueTasks,
    TResult Function(Task task)? createTask,
    TResult Function(Task task)? updateTask,
    TResult Function(String taskId, String? notes, int? actualMinutes)?
        completeTask,
    TResult Function(String taskId)? deleteTask,
    TResult Function()? getTaskStats,
    TResult Function()? refreshTasks,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GetUserTasks() when getUserTasks != null:
        return getUserTasks();
      case _GetFarmTasks() when getFarmTasks != null:
        return getFarmTasks(_that.farmId);
      case _GetPendingTasks() when getPendingTasks != null:
        return getPendingTasks();
      case _GetTodayTasks() when getTodayTasks != null:
        return getTodayTasks();
      case _GetOverdueTasks() when getOverdueTasks != null:
        return getOverdueTasks();
      case _CreateTask() when createTask != null:
        return createTask(_that.task);
      case _UpdateTask() when updateTask != null:
        return updateTask(_that.task);
      case _CompleteTask() when completeTask != null:
        return completeTask(_that.taskId, _that.notes, _that.actualMinutes);
      case _DeleteTask() when deleteTask != null:
        return deleteTask(_that.taskId);
      case _GetTaskStats() when getTaskStats != null:
        return getTaskStats();
      case _RefreshTasks() when refreshTasks != null:
        return refreshTasks();
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getUserTasks,
    required TResult Function(String farmId) getFarmTasks,
    required TResult Function() getPendingTasks,
    required TResult Function() getTodayTasks,
    required TResult Function() getOverdueTasks,
    required TResult Function(Task task) createTask,
    required TResult Function(Task task) updateTask,
    required TResult Function(String taskId, String? notes, int? actualMinutes)
        completeTask,
    required TResult Function(String taskId) deleteTask,
    required TResult Function() getTaskStats,
    required TResult Function() refreshTasks,
  }) {
    final _that = this;
    switch (_that) {
      case _GetUserTasks():
        return getUserTasks();
      case _GetFarmTasks():
        return getFarmTasks(_that.farmId);
      case _GetPendingTasks():
        return getPendingTasks();
      case _GetTodayTasks():
        return getTodayTasks();
      case _GetOverdueTasks():
        return getOverdueTasks();
      case _CreateTask():
        return createTask(_that.task);
      case _UpdateTask():
        return updateTask(_that.task);
      case _CompleteTask():
        return completeTask(_that.taskId, _that.notes, _that.actualMinutes);
      case _DeleteTask():
        return deleteTask(_that.taskId);
      case _GetTaskStats():
        return getTaskStats();
      case _RefreshTasks():
        return refreshTasks();
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getUserTasks,
    TResult? Function(String farmId)? getFarmTasks,
    TResult? Function()? getPendingTasks,
    TResult? Function()? getTodayTasks,
    TResult? Function()? getOverdueTasks,
    TResult? Function(Task task)? createTask,
    TResult? Function(Task task)? updateTask,
    TResult? Function(String taskId, String? notes, int? actualMinutes)?
        completeTask,
    TResult? Function(String taskId)? deleteTask,
    TResult? Function()? getTaskStats,
    TResult? Function()? refreshTasks,
  }) {
    final _that = this;
    switch (_that) {
      case _GetUserTasks() when getUserTasks != null:
        return getUserTasks();
      case _GetFarmTasks() when getFarmTasks != null:
        return getFarmTasks(_that.farmId);
      case _GetPendingTasks() when getPendingTasks != null:
        return getPendingTasks();
      case _GetTodayTasks() when getTodayTasks != null:
        return getTodayTasks();
      case _GetOverdueTasks() when getOverdueTasks != null:
        return getOverdueTasks();
      case _CreateTask() when createTask != null:
        return createTask(_that.task);
      case _UpdateTask() when updateTask != null:
        return updateTask(_that.task);
      case _CompleteTask() when completeTask != null:
        return completeTask(_that.taskId, _that.notes, _that.actualMinutes);
      case _DeleteTask() when deleteTask != null:
        return deleteTask(_that.taskId);
      case _GetTaskStats() when getTaskStats != null:
        return getTaskStats();
      case _RefreshTasks() when refreshTasks != null:
        return refreshTasks();
      case _:
        return null;
    }
  }
}

/// @nodoc

class _GetUserTasks implements TaskEvent {
  const _GetUserTasks();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _GetUserTasks);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TaskEvent.getUserTasks()';
  }
}

/// @nodoc

class _GetFarmTasks implements TaskEvent {
  const _GetFarmTasks(this.farmId);

  final String farmId;

  /// Create a copy of TaskEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GetFarmTasksCopyWith<_GetFarmTasks> get copyWith =>
      __$GetFarmTasksCopyWithImpl<_GetFarmTasks>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GetFarmTasks &&
            (identical(other.farmId, farmId) || other.farmId == farmId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, farmId);

  @override
  String toString() {
    return 'TaskEvent.getFarmTasks(farmId: $farmId)';
  }
}

/// @nodoc
abstract mixin class _$GetFarmTasksCopyWith<$Res>
    implements $TaskEventCopyWith<$Res> {
  factory _$GetFarmTasksCopyWith(
          _GetFarmTasks value, $Res Function(_GetFarmTasks) _then) =
      __$GetFarmTasksCopyWithImpl;
  @useResult
  $Res call({String farmId});
}

/// @nodoc
class __$GetFarmTasksCopyWithImpl<$Res>
    implements _$GetFarmTasksCopyWith<$Res> {
  __$GetFarmTasksCopyWithImpl(this._self, this._then);

  final _GetFarmTasks _self;
  final $Res Function(_GetFarmTasks) _then;

  /// Create a copy of TaskEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? farmId = null,
  }) {
    return _then(_GetFarmTasks(
      null == farmId
          ? _self.farmId
          : farmId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _GetPendingTasks implements TaskEvent {
  const _GetPendingTasks();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _GetPendingTasks);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TaskEvent.getPendingTasks()';
  }
}

/// @nodoc

class _GetTodayTasks implements TaskEvent {
  const _GetTodayTasks();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _GetTodayTasks);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TaskEvent.getTodayTasks()';
  }
}

/// @nodoc

class _GetOverdueTasks implements TaskEvent {
  const _GetOverdueTasks();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _GetOverdueTasks);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TaskEvent.getOverdueTasks()';
  }
}

/// @nodoc

class _CreateTask implements TaskEvent {
  const _CreateTask(this.task);

  final Task task;

  /// Create a copy of TaskEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreateTaskCopyWith<_CreateTask> get copyWith =>
      __$CreateTaskCopyWithImpl<_CreateTask>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreateTask &&
            (identical(other.task, task) || other.task == task));
  }

  @override
  int get hashCode => Object.hash(runtimeType, task);

  @override
  String toString() {
    return 'TaskEvent.createTask(task: $task)';
  }
}

/// @nodoc
abstract mixin class _$CreateTaskCopyWith<$Res>
    implements $TaskEventCopyWith<$Res> {
  factory _$CreateTaskCopyWith(
          _CreateTask value, $Res Function(_CreateTask) _then) =
      __$CreateTaskCopyWithImpl;
  @useResult
  $Res call({Task task});
}

/// @nodoc
class __$CreateTaskCopyWithImpl<$Res> implements _$CreateTaskCopyWith<$Res> {
  __$CreateTaskCopyWithImpl(this._self, this._then);

  final _CreateTask _self;
  final $Res Function(_CreateTask) _then;

  /// Create a copy of TaskEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? task = null,
  }) {
    return _then(_CreateTask(
      null == task
          ? _self.task
          : task // ignore: cast_nullable_to_non_nullable
              as Task,
    ));
  }
}

/// @nodoc

class _UpdateTask implements TaskEvent {
  const _UpdateTask(this.task);

  final Task task;

  /// Create a copy of TaskEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UpdateTaskCopyWith<_UpdateTask> get copyWith =>
      __$UpdateTaskCopyWithImpl<_UpdateTask>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UpdateTask &&
            (identical(other.task, task) || other.task == task));
  }

  @override
  int get hashCode => Object.hash(runtimeType, task);

  @override
  String toString() {
    return 'TaskEvent.updateTask(task: $task)';
  }
}

/// @nodoc
abstract mixin class _$UpdateTaskCopyWith<$Res>
    implements $TaskEventCopyWith<$Res> {
  factory _$UpdateTaskCopyWith(
          _UpdateTask value, $Res Function(_UpdateTask) _then) =
      __$UpdateTaskCopyWithImpl;
  @useResult
  $Res call({Task task});
}

/// @nodoc
class __$UpdateTaskCopyWithImpl<$Res> implements _$UpdateTaskCopyWith<$Res> {
  __$UpdateTaskCopyWithImpl(this._self, this._then);

  final _UpdateTask _self;
  final $Res Function(_UpdateTask) _then;

  /// Create a copy of TaskEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? task = null,
  }) {
    return _then(_UpdateTask(
      null == task
          ? _self.task
          : task // ignore: cast_nullable_to_non_nullable
              as Task,
    ));
  }
}

/// @nodoc

class _CompleteTask implements TaskEvent {
  const _CompleteTask({required this.taskId, this.notes, this.actualMinutes});

  final String taskId;
  final String? notes;
  final int? actualMinutes;

  /// Create a copy of TaskEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CompleteTaskCopyWith<_CompleteTask> get copyWith =>
      __$CompleteTaskCopyWithImpl<_CompleteTask>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CompleteTask &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.actualMinutes, actualMinutes) ||
                other.actualMinutes == actualMinutes));
  }

  @override
  int get hashCode => Object.hash(runtimeType, taskId, notes, actualMinutes);

  @override
  String toString() {
    return 'TaskEvent.completeTask(taskId: $taskId, notes: $notes, actualMinutes: $actualMinutes)';
  }
}

/// @nodoc
abstract mixin class _$CompleteTaskCopyWith<$Res>
    implements $TaskEventCopyWith<$Res> {
  factory _$CompleteTaskCopyWith(
          _CompleteTask value, $Res Function(_CompleteTask) _then) =
      __$CompleteTaskCopyWithImpl;
  @useResult
  $Res call({String taskId, String? notes, int? actualMinutes});
}

/// @nodoc
class __$CompleteTaskCopyWithImpl<$Res>
    implements _$CompleteTaskCopyWith<$Res> {
  __$CompleteTaskCopyWithImpl(this._self, this._then);

  final _CompleteTask _self;
  final $Res Function(_CompleteTask) _then;

  /// Create a copy of TaskEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? taskId = null,
    Object? notes = freezed,
    Object? actualMinutes = freezed,
  }) {
    return _then(_CompleteTask(
      taskId: null == taskId
          ? _self.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      actualMinutes: freezed == actualMinutes
          ? _self.actualMinutes
          : actualMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _DeleteTask implements TaskEvent {
  const _DeleteTask(this.taskId);

  final String taskId;

  /// Create a copy of TaskEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DeleteTaskCopyWith<_DeleteTask> get copyWith =>
      __$DeleteTaskCopyWithImpl<_DeleteTask>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DeleteTask &&
            (identical(other.taskId, taskId) || other.taskId == taskId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, taskId);

  @override
  String toString() {
    return 'TaskEvent.deleteTask(taskId: $taskId)';
  }
}

/// @nodoc
abstract mixin class _$DeleteTaskCopyWith<$Res>
    implements $TaskEventCopyWith<$Res> {
  factory _$DeleteTaskCopyWith(
          _DeleteTask value, $Res Function(_DeleteTask) _then) =
      __$DeleteTaskCopyWithImpl;
  @useResult
  $Res call({String taskId});
}

/// @nodoc
class __$DeleteTaskCopyWithImpl<$Res> implements _$DeleteTaskCopyWith<$Res> {
  __$DeleteTaskCopyWithImpl(this._self, this._then);

  final _DeleteTask _self;
  final $Res Function(_DeleteTask) _then;

  /// Create a copy of TaskEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? taskId = null,
  }) {
    return _then(_DeleteTask(
      null == taskId
          ? _self.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _GetTaskStats implements TaskEvent {
  const _GetTaskStats();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _GetTaskStats);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TaskEvent.getTaskStats()';
  }
}

/// @nodoc

class _RefreshTasks implements TaskEvent {
  const _RefreshTasks();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _RefreshTasks);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TaskEvent.refreshTasks()';
  }
}

// dart format on
