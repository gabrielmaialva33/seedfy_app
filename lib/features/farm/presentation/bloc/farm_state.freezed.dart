// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'farm_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FarmState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is FarmState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'FarmState()';
  }
}

/// @nodoc
class $FarmStateCopyWith<$Res> {
  $FarmStateCopyWith(FarmState _, $Res Function(FarmState) __);
}

/// Adds pattern-matching-related methods to [FarmState].
extension FarmStatePatterns on FarmState {
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
    TResult Function(_FarmsLoaded value)? farmsLoaded,
    TResult Function(_FarmDetailsLoaded value)? farmDetailsLoaded,
    TResult Function(_FarmCreated value)? farmCreated,
    TResult Function(_FarmUpdated value)? farmUpdated,
    TResult Function(_FarmDeleted value)? farmDeleted,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial(_that);
      case _Loading() when loading != null:
        return loading(_that);
      case _FarmsLoaded() when farmsLoaded != null:
        return farmsLoaded(_that);
      case _FarmDetailsLoaded() when farmDetailsLoaded != null:
        return farmDetailsLoaded(_that);
      case _FarmCreated() when farmCreated != null:
        return farmCreated(_that);
      case _FarmUpdated() when farmUpdated != null:
        return farmUpdated(_that);
      case _FarmDeleted() when farmDeleted != null:
        return farmDeleted(_that);
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
    required TResult Function(_FarmsLoaded value) farmsLoaded,
    required TResult Function(_FarmDetailsLoaded value) farmDetailsLoaded,
    required TResult Function(_FarmCreated value) farmCreated,
    required TResult Function(_FarmUpdated value) farmUpdated,
    required TResult Function(_FarmDeleted value) farmDeleted,
    required TResult Function(_Error value) error,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial():
        return initial(_that);
      case _Loading():
        return loading(_that);
      case _FarmsLoaded():
        return farmsLoaded(_that);
      case _FarmDetailsLoaded():
        return farmDetailsLoaded(_that);
      case _FarmCreated():
        return farmCreated(_that);
      case _FarmUpdated():
        return farmUpdated(_that);
      case _FarmDeleted():
        return farmDeleted(_that);
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
    TResult? Function(_FarmsLoaded value)? farmsLoaded,
    TResult? Function(_FarmDetailsLoaded value)? farmDetailsLoaded,
    TResult? Function(_FarmCreated value)? farmCreated,
    TResult? Function(_FarmUpdated value)? farmUpdated,
    TResult? Function(_FarmDeleted value)? farmDeleted,
    TResult? Function(_Error value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial(_that);
      case _Loading() when loading != null:
        return loading(_that);
      case _FarmsLoaded() when farmsLoaded != null:
        return farmsLoaded(_that);
      case _FarmDetailsLoaded() when farmDetailsLoaded != null:
        return farmDetailsLoaded(_that);
      case _FarmCreated() when farmCreated != null:
        return farmCreated(_that);
      case _FarmUpdated() when farmUpdated != null:
        return farmUpdated(_that);
      case _FarmDeleted() when farmDeleted != null:
        return farmDeleted(_that);
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
    TResult Function(List<Farm> farms)? farmsLoaded,
    TResult Function(FarmDetailsResult details)? farmDetailsLoaded,
    TResult Function(Farm farm)? farmCreated,
    TResult Function(Farm farm)? farmUpdated,
    TResult Function()? farmDeleted,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial();
      case _Loading() when loading != null:
        return loading();
      case _FarmsLoaded() when farmsLoaded != null:
        return farmsLoaded(_that.farms);
      case _FarmDetailsLoaded() when farmDetailsLoaded != null:
        return farmDetailsLoaded(_that.details);
      case _FarmCreated() when farmCreated != null:
        return farmCreated(_that.farm);
      case _FarmUpdated() when farmUpdated != null:
        return farmUpdated(_that.farm);
      case _FarmDeleted() when farmDeleted != null:
        return farmDeleted();
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
    required TResult Function(List<Farm> farms) farmsLoaded,
    required TResult Function(FarmDetailsResult details) farmDetailsLoaded,
    required TResult Function(Farm farm) farmCreated,
    required TResult Function(Farm farm) farmUpdated,
    required TResult Function() farmDeleted,
    required TResult Function(String message) error,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial():
        return initial();
      case _Loading():
        return loading();
      case _FarmsLoaded():
        return farmsLoaded(_that.farms);
      case _FarmDetailsLoaded():
        return farmDetailsLoaded(_that.details);
      case _FarmCreated():
        return farmCreated(_that.farm);
      case _FarmUpdated():
        return farmUpdated(_that.farm);
      case _FarmDeleted():
        return farmDeleted();
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
    TResult? Function(List<Farm> farms)? farmsLoaded,
    TResult? Function(FarmDetailsResult details)? farmDetailsLoaded,
    TResult? Function(Farm farm)? farmCreated,
    TResult? Function(Farm farm)? farmUpdated,
    TResult? Function()? farmDeleted,
    TResult? Function(String message)? error,
  }) {
    final _that = this;
    switch (_that) {
      case _Initial() when initial != null:
        return initial();
      case _Loading() when loading != null:
        return loading();
      case _FarmsLoaded() when farmsLoaded != null:
        return farmsLoaded(_that.farms);
      case _FarmDetailsLoaded() when farmDetailsLoaded != null:
        return farmDetailsLoaded(_that.details);
      case _FarmCreated() when farmCreated != null:
        return farmCreated(_that.farm);
      case _FarmUpdated() when farmUpdated != null:
        return farmUpdated(_that.farm);
      case _FarmDeleted() when farmDeleted != null:
        return farmDeleted();
      case _Error() when error != null:
        return error(_that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Initial implements FarmState {
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
    return 'FarmState.initial()';
  }
}

/// @nodoc

class _Loading implements FarmState {
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
    return 'FarmState.loading()';
  }
}

/// @nodoc

class _FarmsLoaded implements FarmState {
  const _FarmsLoaded(final List<Farm> farms) : _farms = farms;

  final List<Farm> _farms;
  List<Farm> get farms {
    if (_farms is EqualUnmodifiableListView) return _farms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_farms);
  }

  /// Create a copy of FarmState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FarmsLoadedCopyWith<_FarmsLoaded> get copyWith =>
      __$FarmsLoadedCopyWithImpl<_FarmsLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FarmsLoaded &&
            const DeepCollectionEquality().equals(other._farms, _farms));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_farms));

  @override
  String toString() {
    return 'FarmState.farmsLoaded(farms: $farms)';
  }
}

/// @nodoc
abstract mixin class _$FarmsLoadedCopyWith<$Res>
    implements $FarmStateCopyWith<$Res> {
  factory _$FarmsLoadedCopyWith(
          _FarmsLoaded value, $Res Function(_FarmsLoaded) _then) =
      __$FarmsLoadedCopyWithImpl;
  @useResult
  $Res call({List<Farm> farms});
}

/// @nodoc
class __$FarmsLoadedCopyWithImpl<$Res> implements _$FarmsLoadedCopyWith<$Res> {
  __$FarmsLoadedCopyWithImpl(this._self, this._then);

  final _FarmsLoaded _self;
  final $Res Function(_FarmsLoaded) _then;

  /// Create a copy of FarmState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? farms = null,
  }) {
    return _then(_FarmsLoaded(
      null == farms
          ? _self._farms
          : farms // ignore: cast_nullable_to_non_nullable
              as List<Farm>,
    ));
  }
}

/// @nodoc

class _FarmDetailsLoaded implements FarmState {
  const _FarmDetailsLoaded(this.details);

  final FarmDetailsResult details;

  /// Create a copy of FarmState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FarmDetailsLoadedCopyWith<_FarmDetailsLoaded> get copyWith =>
      __$FarmDetailsLoadedCopyWithImpl<_FarmDetailsLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FarmDetailsLoaded &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, details);

  @override
  String toString() {
    return 'FarmState.farmDetailsLoaded(details: $details)';
  }
}

/// @nodoc
abstract mixin class _$FarmDetailsLoadedCopyWith<$Res>
    implements $FarmStateCopyWith<$Res> {
  factory _$FarmDetailsLoadedCopyWith(
          _FarmDetailsLoaded value, $Res Function(_FarmDetailsLoaded) _then) =
      __$FarmDetailsLoadedCopyWithImpl;
  @useResult
  $Res call({FarmDetailsResult details});
}

/// @nodoc
class __$FarmDetailsLoadedCopyWithImpl<$Res>
    implements _$FarmDetailsLoadedCopyWith<$Res> {
  __$FarmDetailsLoadedCopyWithImpl(this._self, this._then);

  final _FarmDetailsLoaded _self;
  final $Res Function(_FarmDetailsLoaded) _then;

  /// Create a copy of FarmState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? details = null,
  }) {
    return _then(_FarmDetailsLoaded(
      null == details
          ? _self.details
          : details // ignore: cast_nullable_to_non_nullable
              as FarmDetailsResult,
    ));
  }
}

/// @nodoc

class _FarmCreated implements FarmState {
  const _FarmCreated(this.farm);

  final Farm farm;

  /// Create a copy of FarmState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FarmCreatedCopyWith<_FarmCreated> get copyWith =>
      __$FarmCreatedCopyWithImpl<_FarmCreated>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FarmCreated &&
            (identical(other.farm, farm) || other.farm == farm));
  }

  @override
  int get hashCode => Object.hash(runtimeType, farm);

  @override
  String toString() {
    return 'FarmState.farmCreated(farm: $farm)';
  }
}

/// @nodoc
abstract mixin class _$FarmCreatedCopyWith<$Res>
    implements $FarmStateCopyWith<$Res> {
  factory _$FarmCreatedCopyWith(
          _FarmCreated value, $Res Function(_FarmCreated) _then) =
      __$FarmCreatedCopyWithImpl;
  @useResult
  $Res call({Farm farm});
}

/// @nodoc
class __$FarmCreatedCopyWithImpl<$Res> implements _$FarmCreatedCopyWith<$Res> {
  __$FarmCreatedCopyWithImpl(this._self, this._then);

  final _FarmCreated _self;
  final $Res Function(_FarmCreated) _then;

  /// Create a copy of FarmState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? farm = null,
  }) {
    return _then(_FarmCreated(
      null == farm
          ? _self.farm
          : farm // ignore: cast_nullable_to_non_nullable
              as Farm,
    ));
  }
}

/// @nodoc

class _FarmUpdated implements FarmState {
  const _FarmUpdated(this.farm);

  final Farm farm;

  /// Create a copy of FarmState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FarmUpdatedCopyWith<_FarmUpdated> get copyWith =>
      __$FarmUpdatedCopyWithImpl<_FarmUpdated>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FarmUpdated &&
            (identical(other.farm, farm) || other.farm == farm));
  }

  @override
  int get hashCode => Object.hash(runtimeType, farm);

  @override
  String toString() {
    return 'FarmState.farmUpdated(farm: $farm)';
  }
}

/// @nodoc
abstract mixin class _$FarmUpdatedCopyWith<$Res>
    implements $FarmStateCopyWith<$Res> {
  factory _$FarmUpdatedCopyWith(
          _FarmUpdated value, $Res Function(_FarmUpdated) _then) =
      __$FarmUpdatedCopyWithImpl;
  @useResult
  $Res call({Farm farm});
}

/// @nodoc
class __$FarmUpdatedCopyWithImpl<$Res> implements _$FarmUpdatedCopyWith<$Res> {
  __$FarmUpdatedCopyWithImpl(this._self, this._then);

  final _FarmUpdated _self;
  final $Res Function(_FarmUpdated) _then;

  /// Create a copy of FarmState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? farm = null,
  }) {
    return _then(_FarmUpdated(
      null == farm
          ? _self.farm
          : farm // ignore: cast_nullable_to_non_nullable
              as Farm,
    ));
  }
}

/// @nodoc

class _FarmDeleted implements FarmState {
  const _FarmDeleted();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _FarmDeleted);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'FarmState.farmDeleted()';
  }
}

/// @nodoc

class _Error implements FarmState {
  const _Error(this.message);

  final String message;

  /// Create a copy of FarmState
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
    return 'FarmState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $FarmStateCopyWith<$Res> {
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

  /// Create a copy of FarmState
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
