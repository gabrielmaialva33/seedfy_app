// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthEvent()';
  }
}

/// @nodoc
class $AuthEventCopyWith<$Res> {
  $AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}

/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
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
    TResult Function(AuthLoginRequested value)? loginRequested,
    TResult Function(AuthSignupRequested value)? signupRequested,
    TResult Function(AuthLogoutRequested value)? logoutRequested,
    TResult Function(AuthCheckRequested value)? checkRequested,
    TResult Function(AuthResetPasswordRequested value)? resetPasswordRequested,
    TResult Function(AuthUserChanged value)? userChanged,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AuthLoginRequested() when loginRequested != null:
        return loginRequested(_that);
      case AuthSignupRequested() when signupRequested != null:
        return signupRequested(_that);
      case AuthLogoutRequested() when logoutRequested != null:
        return logoutRequested(_that);
      case AuthCheckRequested() when checkRequested != null:
        return checkRequested(_that);
      case AuthResetPasswordRequested() when resetPasswordRequested != null:
        return resetPasswordRequested(_that);
      case AuthUserChanged() when userChanged != null:
        return userChanged(_that);
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
    required TResult Function(AuthLoginRequested value) loginRequested,
    required TResult Function(AuthSignupRequested value) signupRequested,
    required TResult Function(AuthLogoutRequested value) logoutRequested,
    required TResult Function(AuthCheckRequested value) checkRequested,
    required TResult Function(AuthResetPasswordRequested value)
        resetPasswordRequested,
    required TResult Function(AuthUserChanged value) userChanged,
  }) {
    final _that = this;
    switch (_that) {
      case AuthLoginRequested():
        return loginRequested(_that);
      case AuthSignupRequested():
        return signupRequested(_that);
      case AuthLogoutRequested():
        return logoutRequested(_that);
      case AuthCheckRequested():
        return checkRequested(_that);
      case AuthResetPasswordRequested():
        return resetPasswordRequested(_that);
      case AuthUserChanged():
        return userChanged(_that);
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
    TResult? Function(AuthLoginRequested value)? loginRequested,
    TResult? Function(AuthSignupRequested value)? signupRequested,
    TResult? Function(AuthLogoutRequested value)? logoutRequested,
    TResult? Function(AuthCheckRequested value)? checkRequested,
    TResult? Function(AuthResetPasswordRequested value)? resetPasswordRequested,
    TResult? Function(AuthUserChanged value)? userChanged,
  }) {
    final _that = this;
    switch (_that) {
      case AuthLoginRequested() when loginRequested != null:
        return loginRequested(_that);
      case AuthSignupRequested() when signupRequested != null:
        return signupRequested(_that);
      case AuthLogoutRequested() when logoutRequested != null:
        return logoutRequested(_that);
      case AuthCheckRequested() when checkRequested != null:
        return checkRequested(_that);
      case AuthResetPasswordRequested() when resetPasswordRequested != null:
        return resetPasswordRequested(_that);
      case AuthUserChanged() when userChanged != null:
        return userChanged(_that);
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
    TResult Function(String email, String password)? loginRequested,
    TResult Function(String email, String password, String name, String phone,
            String city, String state, String locale)?
        signupRequested,
    TResult Function()? logoutRequested,
    TResult Function()? checkRequested,
    TResult Function(String email)? resetPasswordRequested,
    TResult Function(UserEntity? user)? userChanged,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AuthLoginRequested() when loginRequested != null:
        return loginRequested(_that.email, _that.password);
      case AuthSignupRequested() when signupRequested != null:
        return signupRequested(_that.email, _that.password, _that.name,
            _that.phone, _that.city, _that.state, _that.locale);
      case AuthLogoutRequested() when logoutRequested != null:
        return logoutRequested();
      case AuthCheckRequested() when checkRequested != null:
        return checkRequested();
      case AuthResetPasswordRequested() when resetPasswordRequested != null:
        return resetPasswordRequested(_that.email);
      case AuthUserChanged() when userChanged != null:
        return userChanged(_that.user);
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
    required TResult Function(String email, String password) loginRequested,
    required TResult Function(String email, String password, String name,
            String phone, String city, String state, String locale)
        signupRequested,
    required TResult Function() logoutRequested,
    required TResult Function() checkRequested,
    required TResult Function(String email) resetPasswordRequested,
    required TResult Function(UserEntity? user) userChanged,
  }) {
    final _that = this;
    switch (_that) {
      case AuthLoginRequested():
        return loginRequested(_that.email, _that.password);
      case AuthSignupRequested():
        return signupRequested(_that.email, _that.password, _that.name,
            _that.phone, _that.city, _that.state, _that.locale);
      case AuthLogoutRequested():
        return logoutRequested();
      case AuthCheckRequested():
        return checkRequested();
      case AuthResetPasswordRequested():
        return resetPasswordRequested(_that.email);
      case AuthUserChanged():
        return userChanged(_that.user);
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
    TResult? Function(String email, String password)? loginRequested,
    TResult? Function(String email, String password, String name, String phone,
            String city, String state, String locale)?
        signupRequested,
    TResult? Function()? logoutRequested,
    TResult? Function()? checkRequested,
    TResult? Function(String email)? resetPasswordRequested,
    TResult? Function(UserEntity? user)? userChanged,
  }) {
    final _that = this;
    switch (_that) {
      case AuthLoginRequested() when loginRequested != null:
        return loginRequested(_that.email, _that.password);
      case AuthSignupRequested() when signupRequested != null:
        return signupRequested(_that.email, _that.password, _that.name,
            _that.phone, _that.city, _that.state, _that.locale);
      case AuthLogoutRequested() when logoutRequested != null:
        return logoutRequested();
      case AuthCheckRequested() when checkRequested != null:
        return checkRequested();
      case AuthResetPasswordRequested() when resetPasswordRequested != null:
        return resetPasswordRequested(_that.email);
      case AuthUserChanged() when userChanged != null:
        return userChanged(_that.user);
      case _:
        return null;
    }
  }
}

/// @nodoc

class AuthLoginRequested implements AuthEvent {
  const AuthLoginRequested({required this.email, required this.password});

  final String email;
  final String password;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthLoginRequestedCopyWith<AuthLoginRequested> get copyWith =>
      _$AuthLoginRequestedCopyWithImpl<AuthLoginRequested>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthLoginRequested &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, password);

  @override
  String toString() {
    return 'AuthEvent.loginRequested(email: $email, password: $password)';
  }
}

/// @nodoc
abstract mixin class $AuthLoginRequestedCopyWith<$Res>
    implements $AuthEventCopyWith<$Res> {
  factory $AuthLoginRequestedCopyWith(
          AuthLoginRequested value, $Res Function(AuthLoginRequested) _then) =
      _$AuthLoginRequestedCopyWithImpl;
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class _$AuthLoginRequestedCopyWithImpl<$Res>
    implements $AuthLoginRequestedCopyWith<$Res> {
  _$AuthLoginRequestedCopyWithImpl(this._self, this._then);

  final AuthLoginRequested _self;
  final $Res Function(AuthLoginRequested) _then;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? email = null,
    Object? password = null,
  }) {
    return _then(AuthLoginRequested(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class AuthSignupRequested implements AuthEvent {
  const AuthSignupRequested(
      {required this.email,
      required this.password,
      required this.name,
      required this.phone,
      required this.city,
      required this.state,
      this.locale = 'pt-BR'});

  final String email;
  final String password;
  final String name;
  final String phone;
  final String city;
  final String state;
  @JsonKey()
  final String locale;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthSignupRequestedCopyWith<AuthSignupRequested> get copyWith =>
      _$AuthSignupRequestedCopyWithImpl<AuthSignupRequested>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthSignupRequested &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.locale, locale) || other.locale == locale));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, email, password, name, phone, city, state, locale);

  @override
  String toString() {
    return 'AuthEvent.signupRequested(email: $email, password: $password, name: $name, phone: $phone, city: $city, state: $state, locale: $locale)';
  }
}

/// @nodoc
abstract mixin class $AuthSignupRequestedCopyWith<$Res>
    implements $AuthEventCopyWith<$Res> {
  factory $AuthSignupRequestedCopyWith(
          AuthSignupRequested value, $Res Function(AuthSignupRequested) _then) =
      _$AuthSignupRequestedCopyWithImpl;
  @useResult
  $Res call(
      {String email,
      String password,
      String name,
      String phone,
      String city,
      String state,
      String locale});
}

/// @nodoc
class _$AuthSignupRequestedCopyWithImpl<$Res>
    implements $AuthSignupRequestedCopyWith<$Res> {
  _$AuthSignupRequestedCopyWithImpl(this._self, this._then);

  final AuthSignupRequested _self;
  final $Res Function(AuthSignupRequested) _then;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? name = null,
    Object? phone = null,
    Object? city = null,
    Object? state = null,
    Object? locale = null,
  }) {
    return _then(AuthSignupRequested(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      locale: null == locale
          ? _self.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class AuthLogoutRequested implements AuthEvent {
  const AuthLogoutRequested();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthLogoutRequested);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthEvent.logoutRequested()';
  }
}

/// @nodoc

class AuthCheckRequested implements AuthEvent {
  const AuthCheckRequested();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthCheckRequested);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthEvent.checkRequested()';
  }
}

/// @nodoc

class AuthResetPasswordRequested implements AuthEvent {
  const AuthResetPasswordRequested({required this.email});

  final String email;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthResetPasswordRequestedCopyWith<AuthResetPasswordRequested>
      get copyWith =>
          _$AuthResetPasswordRequestedCopyWithImpl<AuthResetPasswordRequested>(
              this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthResetPasswordRequested &&
            (identical(other.email, email) || other.email == email));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email);

  @override
  String toString() {
    return 'AuthEvent.resetPasswordRequested(email: $email)';
  }
}

/// @nodoc
abstract mixin class $AuthResetPasswordRequestedCopyWith<$Res>
    implements $AuthEventCopyWith<$Res> {
  factory $AuthResetPasswordRequestedCopyWith(AuthResetPasswordRequested value,
          $Res Function(AuthResetPasswordRequested) _then) =
      _$AuthResetPasswordRequestedCopyWithImpl;
  @useResult
  $Res call({String email});
}

/// @nodoc
class _$AuthResetPasswordRequestedCopyWithImpl<$Res>
    implements $AuthResetPasswordRequestedCopyWith<$Res> {
  _$AuthResetPasswordRequestedCopyWithImpl(this._self, this._then);

  final AuthResetPasswordRequested _self;
  final $Res Function(AuthResetPasswordRequested) _then;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? email = null,
  }) {
    return _then(AuthResetPasswordRequested(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class AuthUserChanged implements AuthEvent {
  const AuthUserChanged(this.user);

  final UserEntity? user;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthUserChangedCopyWith<AuthUserChanged> get copyWith =>
      _$AuthUserChangedCopyWithImpl<AuthUserChanged>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthUserChanged &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  @override
  String toString() {
    return 'AuthEvent.userChanged(user: $user)';
  }
}

/// @nodoc
abstract mixin class $AuthUserChangedCopyWith<$Res>
    implements $AuthEventCopyWith<$Res> {
  factory $AuthUserChangedCopyWith(
          AuthUserChanged value, $Res Function(AuthUserChanged) _then) =
      _$AuthUserChangedCopyWithImpl;
  @useResult
  $Res call({UserEntity? user});
}

/// @nodoc
class _$AuthUserChangedCopyWithImpl<$Res>
    implements $AuthUserChangedCopyWith<$Res> {
  _$AuthUserChangedCopyWithImpl(this._self, this._then);

  final AuthUserChanged _self;
  final $Res Function(AuthUserChanged) _then;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? user = freezed,
  }) {
    return _then(AuthUserChanged(
      freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserEntity?,
    ));
  }
}

/// @nodoc
mixin _$AuthState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthState()';
  }
}

/// @nodoc
class $AuthStateCopyWith<$Res> {
  $AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}

/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AuthInitial() when initial != null:
        return initial(_that);
      case AuthLoading() when loading != null:
        return loading(_that);
      case AuthAuthenticated() when authenticated != null:
        return authenticated(_that);
      case AuthUnauthenticated() when unauthenticated != null:
        return unauthenticated(_that);
      case AuthError() when error != null:
        return error(_that);
      case AuthPasswordResetSent() when passwordResetSent != null:
        return passwordResetSent(_that);
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
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
  }) {
    final _that = this;
    switch (_that) {
      case AuthInitial():
        return initial(_that);
      case AuthLoading():
        return loading(_that);
      case AuthAuthenticated():
        return authenticated(_that);
      case AuthUnauthenticated():
        return unauthenticated(_that);
      case AuthError():
        return error(_that);
      case AuthPasswordResetSent():
        return passwordResetSent(_that);
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
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
  }) {
    final _that = this;
    switch (_that) {
      case AuthInitial() when initial != null:
        return initial(_that);
      case AuthLoading() when loading != null:
        return loading(_that);
      case AuthAuthenticated() when authenticated != null:
        return authenticated(_that);
      case AuthUnauthenticated() when unauthenticated != null:
        return unauthenticated(_that);
      case AuthError() when error != null:
        return error(_that);
      case AuthPasswordResetSent() when passwordResetSent != null:
        return passwordResetSent(_that);
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
    TResult Function(UserEntity user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String message)? error,
    TResult Function()? passwordResetSent,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AuthInitial() when initial != null:
        return initial();
      case AuthLoading() when loading != null:
        return loading();
      case AuthAuthenticated() when authenticated != null:
        return authenticated(_that.user);
      case AuthUnauthenticated() when unauthenticated != null:
        return unauthenticated();
      case AuthError() when error != null:
        return error(_that.message);
      case AuthPasswordResetSent() when passwordResetSent != null:
        return passwordResetSent();
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
    required TResult Function(UserEntity user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String message) error,
    required TResult Function() passwordResetSent,
  }) {
    final _that = this;
    switch (_that) {
      case AuthInitial():
        return initial();
      case AuthLoading():
        return loading();
      case AuthAuthenticated():
        return authenticated(_that.user);
      case AuthUnauthenticated():
        return unauthenticated();
      case AuthError():
        return error(_that.message);
      case AuthPasswordResetSent():
        return passwordResetSent();
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
    TResult? Function(UserEntity user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String message)? error,
    TResult? Function()? passwordResetSent,
  }) {
    final _that = this;
    switch (_that) {
      case AuthInitial() when initial != null:
        return initial();
      case AuthLoading() when loading != null:
        return loading();
      case AuthAuthenticated() when authenticated != null:
        return authenticated(_that.user);
      case AuthUnauthenticated() when unauthenticated != null:
        return unauthenticated();
      case AuthError() when error != null:
        return error(_that.message);
      case AuthPasswordResetSent() when passwordResetSent != null:
        return passwordResetSent();
      case _:
        return null;
    }
  }
}

/// @nodoc

class AuthInitial implements AuthState {
  const AuthInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthState.initial()';
  }
}

/// @nodoc

class AuthLoading implements AuthState {
  const AuthLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthState.loading()';
  }
}

/// @nodoc

class AuthAuthenticated implements AuthState {
  const AuthAuthenticated(this.user);

  final UserEntity user;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthAuthenticatedCopyWith<AuthAuthenticated> get copyWith =>
      _$AuthAuthenticatedCopyWithImpl<AuthAuthenticated>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthAuthenticated &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  @override
  String toString() {
    return 'AuthState.authenticated(user: $user)';
  }
}

/// @nodoc
abstract mixin class $AuthAuthenticatedCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory $AuthAuthenticatedCopyWith(
          AuthAuthenticated value, $Res Function(AuthAuthenticated) _then) =
      _$AuthAuthenticatedCopyWithImpl;
  @useResult
  $Res call({UserEntity user});
}

/// @nodoc
class _$AuthAuthenticatedCopyWithImpl<$Res>
    implements $AuthAuthenticatedCopyWith<$Res> {
  _$AuthAuthenticatedCopyWithImpl(this._self, this._then);

  final AuthAuthenticated _self;
  final $Res Function(AuthAuthenticated) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? user = null,
  }) {
    return _then(AuthAuthenticated(
      null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserEntity,
    ));
  }
}

/// @nodoc

class AuthUnauthenticated implements AuthState {
  const AuthUnauthenticated();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthUnauthenticated);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthState.unauthenticated()';
  }
}

/// @nodoc

class AuthError implements AuthState {
  const AuthError(this.message);

  final String message;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthErrorCopyWith<AuthError> get copyWith =>
      _$AuthErrorCopyWithImpl<AuthError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'AuthState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $AuthErrorCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory $AuthErrorCopyWith(AuthError value, $Res Function(AuthError) _then) =
      _$AuthErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$AuthErrorCopyWithImpl<$Res> implements $AuthErrorCopyWith<$Res> {
  _$AuthErrorCopyWithImpl(this._self, this._then);

  final AuthError _self;
  final $Res Function(AuthError) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(AuthError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class AuthPasswordResetSent implements AuthState {
  const AuthPasswordResetSent();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthPasswordResetSent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthState.passwordResetSent()';
  }
}

// dart format on
