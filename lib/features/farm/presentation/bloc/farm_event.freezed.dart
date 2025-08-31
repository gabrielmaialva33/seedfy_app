// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'farm_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FarmEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is FarmEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'FarmEvent()';
  }
}

/// @nodoc
class $FarmEventCopyWith<$Res> {
  $FarmEventCopyWith(FarmEvent _, $Res Function(FarmEvent) __);
}

/// Adds pattern-matching-related methods to [FarmEvent].
extension FarmEventPatterns on FarmEvent {
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
    TResult Function(_GetUserFarms value)? getUserFarms,
    TResult Function(_GetFarmDetails value)? getFarmDetails,
    TResult Function(_CreateFarm value)? createFarm,
    TResult Function(_UpdateFarm value)? updateFarm,
    TResult Function(_DeleteFarm value)? deleteFarm,
    TResult Function(_RefreshFarms value)? refreshFarms,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GetUserFarms() when getUserFarms != null:
        return getUserFarms(_that);
      case _GetFarmDetails() when getFarmDetails != null:
        return getFarmDetails(_that);
      case _CreateFarm() when createFarm != null:
        return createFarm(_that);
      case _UpdateFarm() when updateFarm != null:
        return updateFarm(_that);
      case _DeleteFarm() when deleteFarm != null:
        return deleteFarm(_that);
      case _RefreshFarms() when refreshFarms != null:
        return refreshFarms(_that);
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
    required TResult Function(_GetUserFarms value) getUserFarms,
    required TResult Function(_GetFarmDetails value) getFarmDetails,
    required TResult Function(_CreateFarm value) createFarm,
    required TResult Function(_UpdateFarm value) updateFarm,
    required TResult Function(_DeleteFarm value) deleteFarm,
    required TResult Function(_RefreshFarms value) refreshFarms,
  }) {
    final _that = this;
    switch (_that) {
      case _GetUserFarms():
        return getUserFarms(_that);
      case _GetFarmDetails():
        return getFarmDetails(_that);
      case _CreateFarm():
        return createFarm(_that);
      case _UpdateFarm():
        return updateFarm(_that);
      case _DeleteFarm():
        return deleteFarm(_that);
      case _RefreshFarms():
        return refreshFarms(_that);
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
    TResult? Function(_GetUserFarms value)? getUserFarms,
    TResult? Function(_GetFarmDetails value)? getFarmDetails,
    TResult? Function(_CreateFarm value)? createFarm,
    TResult? Function(_UpdateFarm value)? updateFarm,
    TResult? Function(_DeleteFarm value)? deleteFarm,
    TResult? Function(_RefreshFarms value)? refreshFarms,
  }) {
    final _that = this;
    switch (_that) {
      case _GetUserFarms() when getUserFarms != null:
        return getUserFarms(_that);
      case _GetFarmDetails() when getFarmDetails != null:
        return getFarmDetails(_that);
      case _CreateFarm() when createFarm != null:
        return createFarm(_that);
      case _UpdateFarm() when updateFarm != null:
        return updateFarm(_that);
      case _DeleteFarm() when deleteFarm != null:
        return deleteFarm(_that);
      case _RefreshFarms() when refreshFarms != null:
        return refreshFarms(_that);
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
    TResult Function()? getUserFarms,
    TResult Function(String farmId)? getFarmDetails,
    TResult Function(Farm farm)? createFarm,
    TResult Function(Farm farm)? updateFarm,
    TResult Function(String farmId)? deleteFarm,
    TResult Function()? refreshFarms,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GetUserFarms() when getUserFarms != null:
        return getUserFarms();
      case _GetFarmDetails() when getFarmDetails != null:
        return getFarmDetails(_that.farmId);
      case _CreateFarm() when createFarm != null:
        return createFarm(_that.farm);
      case _UpdateFarm() when updateFarm != null:
        return updateFarm(_that.farm);
      case _DeleteFarm() when deleteFarm != null:
        return deleteFarm(_that.farmId);
      case _RefreshFarms() when refreshFarms != null:
        return refreshFarms();
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
    required TResult Function() getUserFarms,
    required TResult Function(String farmId) getFarmDetails,
    required TResult Function(Farm farm) createFarm,
    required TResult Function(Farm farm) updateFarm,
    required TResult Function(String farmId) deleteFarm,
    required TResult Function() refreshFarms,
  }) {
    final _that = this;
    switch (_that) {
      case _GetUserFarms():
        return getUserFarms();
      case _GetFarmDetails():
        return getFarmDetails(_that.farmId);
      case _CreateFarm():
        return createFarm(_that.farm);
      case _UpdateFarm():
        return updateFarm(_that.farm);
      case _DeleteFarm():
        return deleteFarm(_that.farmId);
      case _RefreshFarms():
        return refreshFarms();
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
    TResult? Function()? getUserFarms,
    TResult? Function(String farmId)? getFarmDetails,
    TResult? Function(Farm farm)? createFarm,
    TResult? Function(Farm farm)? updateFarm,
    TResult? Function(String farmId)? deleteFarm,
    TResult? Function()? refreshFarms,
  }) {
    final _that = this;
    switch (_that) {
      case _GetUserFarms() when getUserFarms != null:
        return getUserFarms();
      case _GetFarmDetails() when getFarmDetails != null:
        return getFarmDetails(_that.farmId);
      case _CreateFarm() when createFarm != null:
        return createFarm(_that.farm);
      case _UpdateFarm() when updateFarm != null:
        return updateFarm(_that.farm);
      case _DeleteFarm() when deleteFarm != null:
        return deleteFarm(_that.farmId);
      case _RefreshFarms() when refreshFarms != null:
        return refreshFarms();
      case _:
        return null;
    }
  }
}

/// @nodoc

class _GetUserFarms implements FarmEvent {
  const _GetUserFarms();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _GetUserFarms);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'FarmEvent.getUserFarms()';
  }
}

/// @nodoc

class _GetFarmDetails implements FarmEvent {
  const _GetFarmDetails(this.farmId);

  final String farmId;

  /// Create a copy of FarmEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GetFarmDetailsCopyWith<_GetFarmDetails> get copyWith =>
      __$GetFarmDetailsCopyWithImpl<_GetFarmDetails>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GetFarmDetails &&
            (identical(other.farmId, farmId) || other.farmId == farmId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, farmId);

  @override
  String toString() {
    return 'FarmEvent.getFarmDetails(farmId: $farmId)';
  }
}

/// @nodoc
abstract mixin class _$GetFarmDetailsCopyWith<$Res>
    implements $FarmEventCopyWith<$Res> {
  factory _$GetFarmDetailsCopyWith(
          _GetFarmDetails value, $Res Function(_GetFarmDetails) _then) =
      __$GetFarmDetailsCopyWithImpl;
  @useResult
  $Res call({String farmId});
}

/// @nodoc
class __$GetFarmDetailsCopyWithImpl<$Res>
    implements _$GetFarmDetailsCopyWith<$Res> {
  __$GetFarmDetailsCopyWithImpl(this._self, this._then);

  final _GetFarmDetails _self;
  final $Res Function(_GetFarmDetails) _then;

  /// Create a copy of FarmEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? farmId = null,
  }) {
    return _then(_GetFarmDetails(
      null == farmId
          ? _self.farmId
          : farmId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _CreateFarm implements FarmEvent {
  const _CreateFarm(this.farm);

  final Farm farm;

  /// Create a copy of FarmEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreateFarmCopyWith<_CreateFarm> get copyWith =>
      __$CreateFarmCopyWithImpl<_CreateFarm>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreateFarm &&
            (identical(other.farm, farm) || other.farm == farm));
  }

  @override
  int get hashCode => Object.hash(runtimeType, farm);

  @override
  String toString() {
    return 'FarmEvent.createFarm(farm: $farm)';
  }
}

/// @nodoc
abstract mixin class _$CreateFarmCopyWith<$Res>
    implements $FarmEventCopyWith<$Res> {
  factory _$CreateFarmCopyWith(
          _CreateFarm value, $Res Function(_CreateFarm) _then) =
      __$CreateFarmCopyWithImpl;
  @useResult
  $Res call({Farm farm});
}

/// @nodoc
class __$CreateFarmCopyWithImpl<$Res> implements _$CreateFarmCopyWith<$Res> {
  __$CreateFarmCopyWithImpl(this._self, this._then);

  final _CreateFarm _self;
  final $Res Function(_CreateFarm) _then;

  /// Create a copy of FarmEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? farm = null,
  }) {
    return _then(_CreateFarm(
      null == farm
          ? _self.farm
          : farm // ignore: cast_nullable_to_non_nullable
              as Farm,
    ));
  }
}

/// @nodoc

class _UpdateFarm implements FarmEvent {
  const _UpdateFarm(this.farm);

  final Farm farm;

  /// Create a copy of FarmEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UpdateFarmCopyWith<_UpdateFarm> get copyWith =>
      __$UpdateFarmCopyWithImpl<_UpdateFarm>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UpdateFarm &&
            (identical(other.farm, farm) || other.farm == farm));
  }

  @override
  int get hashCode => Object.hash(runtimeType, farm);

  @override
  String toString() {
    return 'FarmEvent.updateFarm(farm: $farm)';
  }
}

/// @nodoc
abstract mixin class _$UpdateFarmCopyWith<$Res>
    implements $FarmEventCopyWith<$Res> {
  factory _$UpdateFarmCopyWith(
          _UpdateFarm value, $Res Function(_UpdateFarm) _then) =
      __$UpdateFarmCopyWithImpl;
  @useResult
  $Res call({Farm farm});
}

/// @nodoc
class __$UpdateFarmCopyWithImpl<$Res> implements _$UpdateFarmCopyWith<$Res> {
  __$UpdateFarmCopyWithImpl(this._self, this._then);

  final _UpdateFarm _self;
  final $Res Function(_UpdateFarm) _then;

  /// Create a copy of FarmEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? farm = null,
  }) {
    return _then(_UpdateFarm(
      null == farm
          ? _self.farm
          : farm // ignore: cast_nullable_to_non_nullable
              as Farm,
    ));
  }
}

/// @nodoc

class _DeleteFarm implements FarmEvent {
  const _DeleteFarm(this.farmId);

  final String farmId;

  /// Create a copy of FarmEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DeleteFarmCopyWith<_DeleteFarm> get copyWith =>
      __$DeleteFarmCopyWithImpl<_DeleteFarm>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DeleteFarm &&
            (identical(other.farmId, farmId) || other.farmId == farmId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, farmId);

  @override
  String toString() {
    return 'FarmEvent.deleteFarm(farmId: $farmId)';
  }
}

/// @nodoc
abstract mixin class _$DeleteFarmCopyWith<$Res>
    implements $FarmEventCopyWith<$Res> {
  factory _$DeleteFarmCopyWith(
          _DeleteFarm value, $Res Function(_DeleteFarm) _then) =
      __$DeleteFarmCopyWithImpl;
  @useResult
  $Res call({String farmId});
}

/// @nodoc
class __$DeleteFarmCopyWithImpl<$Res> implements _$DeleteFarmCopyWith<$Res> {
  __$DeleteFarmCopyWithImpl(this._self, this._then);

  final _DeleteFarm _self;
  final $Res Function(_DeleteFarm) _then;

  /// Create a copy of FarmEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? farmId = null,
  }) {
    return _then(_DeleteFarm(
      null == farmId
          ? _self.farmId
          : farmId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _RefreshFarms implements FarmEvent {
  const _RefreshFarms();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _RefreshFarms);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'FarmEvent.refreshFarms()';
  }
}

// dart format on
