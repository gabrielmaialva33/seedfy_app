// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is TaskState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TaskState()';
  }
}

/// @nodoc
class $TaskStateCopyWith<$Res> {
  $TaskStateCopyWith(TaskState _, $Res Function(TaskState) __);
}

/// Adds pattern-matching-related methods to [TaskState].
extension TaskStatePatterns on TaskState {
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
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_TasksLoaded value)? tasksLoaded,
    TResult Function(_PendingTasksLoaded value)? pendingTasksLoaded,
    TResult Function(_TodayTasksLoaded value)? todayTasksLoaded,
    TResult Function(_OverdueTasksLoaded value)? overdueTasksLoaded,
    TResult Function(_TaskCreated value)? taskCreated,
    TResult Function(_TaskUpdated value)? taskUpdated,
    TResult Function(_TaskCompleted value)? taskCompleted,
    TResult Function(_TaskDeleted value)? taskDeleted,
    TResult Function(_StatsLoaded value)? statsLoaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial(_that);
      case _Loading() when loading != null:
        return loading(_that);
      case _TasksLoaded() when tasksLoaded != null:
        return tasksLoaded(_that);
      case _PendingTasksLoaded() when pendingTasksLoaded != null:
        return pendingTasksLoaded(_that);
      case _TodayTasksLoaded() when todayTasksLoaded != null:
        return todayTasksLoaded(_that);
      case _OverdueTasksLoaded() when overdueTasksLoaded != null:
        return overdueTasksLoaded(_that);
      case _TaskCreated() when taskCreated != null:
        return taskCreated(_that);
      case _TaskUpdated() when taskUpdated != null:
        return taskUpdated(_that);
      case _TaskCompleted() when taskCompleted != null:
        return taskCompleted(_that);
      case _TaskDeleted() when taskDeleted != null:
        return taskDeleted(_that);
      case _StatsLoaded() when statsLoaded != null:
        return statsLoaded(_that);
      case _Error() when error != null:
        return error(_that);
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
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_TasksLoaded value) tasksLoaded,
    required TResult Function(_PendingTasksLoaded value) pendingTasksLoaded,
    required TResult Function(_TodayTasksLoaded value) todayTasksLoaded,
    required TResult Function(_OverdueTasksLoaded value) overdueTasksLoaded,
    required TResult Function(_TaskCreated value) taskCreated,
    required TResult Function(_TaskUpdated value) taskUpdated,
    required TResult Function(_TaskCompleted value) taskCompleted,
    required TResult Function(_TaskDeleted value) taskDeleted,
    required TResult Function(_StatsLoaded value) statsLoaded,
    required TResult Function(_Error value) error,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial():
        return initial(_that);
      case _Loading():
        return loading(_that);
      case _TasksLoaded():
        return tasksLoaded(_that);
      case _PendingTasksLoaded():
        return pendingTasksLoaded(_that);
      case _TodayTasksLoaded():
        return todayTasksLoaded(_that);
      case _OverdueTasksLoaded():
        return overdueTasksLoaded(_that);
      case _TaskCreated():
        return taskCreated(_that);
      case _TaskUpdated():
        return taskUpdated(_that);
      case _TaskCompleted():
        return taskCompleted(_that);
      case _TaskDeleted():
        return taskDeleted(_that);
      case _StatsLoaded():
        return statsLoaded(_that);
      case _Error():
        return error(_that);
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
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_TasksLoaded value)? tasksLoaded,
    TResult? Function(_PendingTasksLoaded value)? pendingTasksLoaded,
    TResult? Function(_TodayTasksLoaded value)? todayTasksLoaded,
    TResult? Function(_OverdueTasksLoaded value)? overdueTasksLoaded,
    TResult? Function(_TaskCreated value)? taskCreated,
    TResult? Function(_TaskUpdated value)? taskUpdated,
    TResult? Function(_TaskCompleted value)? taskCompleted,
    TResult? Function(_TaskDeleted value)? taskDeleted,
    TResult? Function(_StatsLoaded value)? statsLoaded,
    TResult? Function(_Error value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial(_that);
      case _Loading() when loading != null:
        return loading(_that);
      case _TasksLoaded() when tasksLoaded != null:
        return tasksLoaded(_that);
      case _PendingTasksLoaded() when pendingTasksLoaded != null:
        return pendingTasksLoaded(_that);
      case _TodayTasksLoaded() when todayTasksLoaded != null:
        return todayTasksLoaded(_that);
      case _OverdueTasksLoaded() when overdueTasksLoaded != null:
        return overdueTasksLoaded(_that);
      case _TaskCreated() when taskCreated != null:
        return taskCreated(_that);
      case _TaskUpdated() when taskUpdated != null:
        return taskUpdated(_that);
      case _TaskCompleted() when taskCompleted != null:
        return taskCompleted(_that);
      case _TaskDeleted() when taskDeleted != null:
        return taskDeleted(_that);
      case _StatsLoaded() when statsLoaded != null:
        return statsLoaded(_that);
      case _Error() when error != null:
        return error(_that);
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
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Task> tasks)? tasksLoaded,
    TResult Function(List<Task> tasks)? pendingTasksLoaded,
    TResult Function(List<Task> tasks)? todayTasksLoaded,
    TResult Function(List<Task> tasks)? overdueTasksLoaded,
    TResult Function(Task task)? taskCreated,
    TResult Function(Task task)? taskUpdated,
    TResult Function(Task task)? taskCompleted,
    TResult Function()? taskDeleted,
    TResult Function(Map<String, dynamic> stats)? statsLoaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial();
      case _Loading() when loading != null:
        return loading();
      case _TasksLoaded() when tasksLoaded != null:
        return tasksLoaded(_that.tasks);
      case _PendingTasksLoaded() when pendingTasksLoaded != null:
        return pendingTasksLoaded(_that.tasks);
      case _TodayTasksLoaded() when todayTasksLoaded != null:
        return todayTasksLoaded(_that.tasks);
      case _OverdueTasksLoaded() when overdueTasksLoaded != null:
        return overdueTasksLoaded(_that.tasks);
      case _TaskCreated() when taskCreated != null:
        return taskCreated(_that.task);
      case _TaskUpdated() when taskUpdated != null:
        return taskUpdated(_that.task);
      case _TaskCompleted() when taskCompleted != null:
        return taskCompleted(_that.task);
      case _TaskDeleted() when taskDeleted != null:
        return taskDeleted();
      case _StatsLoaded() when statsLoaded != null:
        return statsLoaded(_that.stats);
      case _Error() when error != null:
        return error(_that.message);
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
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Task> tasks) tasksLoaded,
    required TResult Function(List<Task> tasks) pendingTasksLoaded,
    required TResult Function(List<Task> tasks) todayTasksLoaded,
    required TResult Function(List<Task> tasks) overdueTasksLoaded,
    required TResult Function(Task task) taskCreated,
    required TResult Function(Task task) taskUpdated,
    required TResult Function(Task task) taskCompleted,
    required TResult Function() taskDeleted,
    required TResult Function(Map<String, dynamic> stats) statsLoaded,
    required TResult Function(String message) error,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial():
        return initial();
      case _Loading():
        return loading();
      case _TasksLoaded():
        return tasksLoaded(_that.tasks);
      case _PendingTasksLoaded():
        return pendingTasksLoaded(_that.tasks);
      case _TodayTasksLoaded():
        return todayTasksLoaded(_that.tasks);
      case _OverdueTasksLoaded():
        return overdueTasksLoaded(_that.tasks);
      case _TaskCreated():
        return taskCreated(_that.task);
      case _TaskUpdated():
        return taskUpdated(_that.task);
      case _TaskCompleted():
        return taskCompleted(_that.task);
      case _TaskDeleted():
        return taskDeleted();
      case _StatsLoaded():
        return statsLoaded(_that.stats);
      case _Error():
        return error(_that.message);
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
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Task> tasks)? tasksLoaded,
    TResult? Function(List<Task> tasks)? pendingTasksLoaded,
    TResult? Function(List<Task> tasks)? todayTasksLoaded,
    TResult? Function(List<Task> tasks)? overdueTasksLoaded,
    TResult? Function(Task task)? taskCreated,
    TResult? Function(Task task)? taskUpdated,
    TResult? Function(Task task)? taskCompleted,
    TResult? Function()? taskDeleted,
    TResult? Function(Map<String, dynamic> stats)? statsLoaded,
    TResult? Function(String message)? error,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial();
      case _Loading() when loading != null:
        return loading();
      case _TasksLoaded() when tasksLoaded != null:
        return tasksLoaded(_that.tasks);
      case _PendingTasksLoaded() when pendingTasksLoaded != null:
        return pendingTasksLoaded(_that.tasks);
      case _TodayTasksLoaded() when todayTasksLoaded != null:
        return todayTasksLoaded(_that.tasks);
      case _OverdueTasksLoaded() when overdueTasksLoaded != null:
        return overdueTasksLoaded(_that.tasks);
      case _TaskCreated() when taskCreated != null:
        return taskCreated(_that.task);
      case _TaskUpdated() when taskUpdated != null:
        return taskUpdated(_that.task);
      case _TaskCompleted() when taskCompleted != null:
        return taskCompleted(_that.task);
      case _TaskDeleted() when taskDeleted != null:
        return taskDeleted();
      case _StatsLoaded() when statsLoaded != null:
        return statsLoaded(_that.stats);
      case _Error() when error != null:
        return error(_that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Initial implements TaskState {
  const _Initial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Initial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TaskState.initial()';
  }
}

/// @nodoc

class _Loading implements TaskState {
  const _Loading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _Loading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TaskState.loading()';
  }
}

/// @nodoc

class _TasksLoaded implements TaskState {
  const _TasksLoaded(final List<Task> tasks) : _tasks = tasks;

  final List<Task> _tasks;
  List<Task> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
// ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TasksLoadedCopyWith<_TasksLoaded> get copyWith =>
      __$TasksLoadedCopyWithImpl<_TasksLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TasksLoaded &&
            const DeepCollectionEquality().equals(other._tasks, _tasks));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_tasks));

  @override
  String toString() {
    return 'TaskState.tasksLoaded(tasks: $tasks)';
  }
}

/// @nodoc
abstract mixin class _$TasksLoadedCopyWith<$Res>
    implements $TaskStateCopyWith<$Res> {
  factory _$TasksLoadedCopyWith(
          _TasksLoaded value, $Res Function(_TasksLoaded) _then) =
      __$TasksLoadedCopyWithImpl;
  @useResult
  $Res call({List<Task> tasks});
}

/// @nodoc
class __$TasksLoadedCopyWithImpl<$Res> implements _$TasksLoadedCopyWith<$Res> {
  __$TasksLoadedCopyWithImpl(this._self, this._then);

  final _TasksLoaded _self;
  final $Res Function(_TasksLoaded) _then;

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? tasks = null,
  }) {
    return _then(_TasksLoaded(
      null == tasks
          ? _self._tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<Task>,
    ));
  }
}

/// @nodoc

class _PendingTasksLoaded implements TaskState {
  const _PendingTasksLoaded(final List<Task> tasks) : _tasks = tasks;

  final List<Task> _tasks;
  List<Task> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
// ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PendingTasksLoadedCopyWith<_PendingTasksLoaded> get copyWith =>
      __$PendingTasksLoadedCopyWithImpl<_PendingTasksLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PendingTasksLoaded &&
            const DeepCollectionEquality().equals(other._tasks, _tasks));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_tasks));

  @override
  String toString() {
    return 'TaskState.pendingTasksLoaded(tasks: $tasks)';
  }
}

/// @nodoc
abstract mixin class _$PendingTasksLoadedCopyWith<$Res>
    implements $TaskStateCopyWith<$Res> {
  factory _$PendingTasksLoadedCopyWith(
          _PendingTasksLoaded value, $Res Function(_PendingTasksLoaded) _then) =
      __$PendingTasksLoadedCopyWithImpl;
  @useResult
  $Res call({List<Task> tasks});
}

/// @nodoc
class __$PendingTasksLoadedCopyWithImpl<$Res>
    implements _$PendingTasksLoadedCopyWith<$Res> {
  __$PendingTasksLoadedCopyWithImpl(this._self, this._then);

  final _PendingTasksLoaded _self;
  final $Res Function(_PendingTasksLoaded) _then;

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? tasks = null,
  }) {
    return _then(_PendingTasksLoaded(
      null == tasks
          ? _self._tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<Task>,
    ));
  }
}

/// @nodoc

class _TodayTasksLoaded implements TaskState {
  const _TodayTasksLoaded(final List<Task> tasks) : _tasks = tasks;

  final List<Task> _tasks;
  List<Task> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
// ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TodayTasksLoadedCopyWith<_TodayTasksLoaded> get copyWith =>
      __$TodayTasksLoadedCopyWithImpl<_TodayTasksLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TodayTasksLoaded &&
            const DeepCollectionEquality().equals(other._tasks, _tasks));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_tasks));

  @override
  String toString() {
    return 'TaskState.todayTasksLoaded(tasks: $tasks)';
  }
}

/// @nodoc
abstract mixin class _$TodayTasksLoadedCopyWith<$Res>
    implements $TaskStateCopyWith<$Res> {
  factory _$TodayTasksLoadedCopyWith(
          _TodayTasksLoaded value, $Res Function(_TodayTasksLoaded) _then) =
      __$TodayTasksLoadedCopyWithImpl;
  @useResult
  $Res call({List<Task> tasks});
}

/// @nodoc
class __$TodayTasksLoadedCopyWithImpl<$Res>
    implements _$TodayTasksLoadedCopyWith<$Res> {
  __$TodayTasksLoadedCopyWithImpl(this._self, this._then);

  final _TodayTasksLoaded _self;
  final $Res Function(_TodayTasksLoaded) _then;

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? tasks = null,
  }) {
    return _then(_TodayTasksLoaded(
      null == tasks
          ? _self._tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<Task>,
    ));
  }
}

/// @nodoc

class _OverdueTasksLoaded implements TaskState {
  const _OverdueTasksLoaded(final List<Task> tasks) : _tasks = tasks;

  final List<Task> _tasks;
  List<Task> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
// ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OverdueTasksLoadedCopyWith<_OverdueTasksLoaded> get copyWith =>
      __$OverdueTasksLoadedCopyWithImpl<_OverdueTasksLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OverdueTasksLoaded &&
            const DeepCollectionEquality().equals(other._tasks, _tasks));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_tasks));

  @override
  String toString() {
    return 'TaskState.overdueTasksLoaded(tasks: $tasks)';
  }
}

/// @nodoc
abstract mixin class _$OverdueTasksLoadedCopyWith<$Res>
    implements $TaskStateCopyWith<$Res> {
  factory _$OverdueTasksLoadedCopyWith(
          _OverdueTasksLoaded value, $Res Function(_OverdueTasksLoaded) _then) =
      __$OverdueTasksLoadedCopyWithImpl;
  @useResult
  $Res call({List<Task> tasks});
}

/// @nodoc
class __$OverdueTasksLoadedCopyWithImpl<$Res>
    implements _$OverdueTasksLoadedCopyWith<$Res> {
  __$OverdueTasksLoadedCopyWithImpl(this._self, this._then);

  final _OverdueTasksLoaded _self;
  final $Res Function(_OverdueTasksLoaded) _then;

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? tasks = null,
  }) {
    return _then(_OverdueTasksLoaded(
      null == tasks
          ? _self._tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<Task>,
    ));
  }
}

/// @nodoc

class _TaskCreated implements TaskState {
  const _TaskCreated(this.task);

  final Task task;

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TaskCreatedCopyWith<_TaskCreated> get copyWith =>
      __$TaskCreatedCopyWithImpl<_TaskCreated>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TaskCreated &&
            (identical(other.task, task) || other.task == task));
  }

  @override
  int get hashCode => Object.hash(runtimeType, task);

  @override
  String toString() {
    return 'TaskState.taskCreated(task: $task)';
  }
}

/// @nodoc
abstract mixin class _$TaskCreatedCopyWith<$Res>
    implements $TaskStateCopyWith<$Res> {
  factory _$TaskCreatedCopyWith(
          _TaskCreated value, $Res Function(_TaskCreated) _then) =
      __$TaskCreatedCopyWithImpl;
  @useResult
  $Res call({Task task});
}

/// @nodoc
class __$TaskCreatedCopyWithImpl<$Res> implements _$TaskCreatedCopyWith<$Res> {
  __$TaskCreatedCopyWithImpl(this._self, this._then);

  final _TaskCreated _self;
  final $Res Function(_TaskCreated) _then;

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? task = null,
  }) {
    return _then(_TaskCreated(
      null == task
          ? _self.task
          : task // ignore: cast_nullable_to_non_nullable
              as Task,
    ));
  }
}

/// @nodoc

class _TaskUpdated implements TaskState {
  const _TaskUpdated(this.task);

  final Task task;

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TaskUpdatedCopyWith<_TaskUpdated> get copyWith =>
      __$TaskUpdatedCopyWithImpl<_TaskUpdated>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TaskUpdated &&
            (identical(other.task, task) || other.task == task));
  }

  @override
  int get hashCode => Object.hash(runtimeType, task);

  @override
  String toString() {
    return 'TaskState.taskUpdated(task: $task)';
  }
}

/// @nodoc
abstract mixin class _$TaskUpdatedCopyWith<$Res>
    implements $TaskStateCopyWith<$Res> {
  factory _$TaskUpdatedCopyWith(
          _TaskUpdated value, $Res Function(_TaskUpdated) _then) =
      __$TaskUpdatedCopyWithImpl;
  @useResult
  $Res call({Task task});
}

/// @nodoc
class __$TaskUpdatedCopyWithImpl<$Res> implements _$TaskUpdatedCopyWith<$Res> {
  __$TaskUpdatedCopyWithImpl(this._self, this._then);

  final _TaskUpdated _self;
  final $Res Function(_TaskUpdated) _then;

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? task = null,
  }) {
    return _then(_TaskUpdated(
      null == task
          ? _self.task
          : task // ignore: cast_nullable_to_non_nullable
              as Task,
    ));
  }
}

/// @nodoc

class _TaskCompleted implements TaskState {
  const _TaskCompleted(this.task);

  final Task task;

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TaskCompletedCopyWith<_TaskCompleted> get copyWith =>
      __$TaskCompletedCopyWithImpl<_TaskCompleted>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TaskCompleted &&
            (identical(other.task, task) || other.task == task));
  }

  @override
  int get hashCode => Object.hash(runtimeType, task);

  @override
  String toString() {
    return 'TaskState.taskCompleted(task: $task)';
  }
}

/// @nodoc
abstract mixin class _$TaskCompletedCopyWith<$Res>
    implements $TaskStateCopyWith<$Res> {
  factory _$TaskCompletedCopyWith(
          _TaskCompleted value, $Res Function(_TaskCompleted) _then) =
      __$TaskCompletedCopyWithImpl;
  @useResult
  $Res call({Task task});
}

/// @nodoc
class __$TaskCompletedCopyWithImpl<$Res>
    implements _$TaskCompletedCopyWith<$Res> {
  __$TaskCompletedCopyWithImpl(this._self, this._then);

  final _TaskCompleted _self;
  final $Res Function(_TaskCompleted) _then;

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? task = null,
  }) {
    return _then(_TaskCompleted(
      null == task
          ? _self.task
          : task // ignore: cast_nullable_to_non_nullable
              as Task,
    ));
  }
}

/// @nodoc

class _TaskDeleted implements TaskState {
  const _TaskDeleted();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _TaskDeleted);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TaskState.taskDeleted()';
  }
}

/// @nodoc

class _StatsLoaded implements TaskState {
  const _StatsLoaded(final Map<String, dynamic> stats) : _stats = stats;

  final Map<String, dynamic> _stats;
  Map<String, dynamic> get stats {
    if (_stats is EqualUnmodifiableMapView) return _stats;
// ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_stats);
  }

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StatsLoadedCopyWith<_StatsLoaded> get copyWith =>
      __$StatsLoadedCopyWithImpl<_StatsLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StatsLoaded &&
            const DeepCollectionEquality().equals(other._stats, _stats));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_stats));

  @override
  String toString() {
    return 'TaskState.statsLoaded(stats: $stats)';
  }
}

/// @nodoc
abstract mixin class _$StatsLoadedCopyWith<$Res>
    implements $TaskStateCopyWith<$Res> {
  factory _$StatsLoadedCopyWith(
          _StatsLoaded value, $Res Function(_StatsLoaded) _then) =
      __$StatsLoadedCopyWithImpl;
  @useResult
  $Res call({Map<String, dynamic> stats});
}

/// @nodoc
class __$StatsLoadedCopyWithImpl<$Res> implements _$StatsLoadedCopyWith<$Res> {
  __$StatsLoadedCopyWithImpl(this._self, this._then);

  final _StatsLoaded _self;
  final $Res Function(_StatsLoaded) _then;

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? stats = null,
  }) {
    return _then(_StatsLoaded(
      null == stats
          ? _self._stats
          : stats // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _Error implements TaskState {
  const _Error(this.message);

  final String message;

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ErrorCopyWith<_Error> get copyWith =>
      __$ErrorCopyWithImpl<_Error>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Error &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'TaskState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $TaskStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) =
      __$ErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$ErrorCopyWithImpl<$Res> implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(_Error(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
