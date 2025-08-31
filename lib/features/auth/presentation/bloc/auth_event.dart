part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loginRequested({
    required String email,
    required String password,
  }) = AuthLoginRequested;

  const factory AuthEvent.signupRequested({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String city,
    required String state,
    @Default('pt-BR') String locale,
  }) = AuthSignupRequested;

  const factory AuthEvent.logoutRequested() = AuthLogoutRequested;

  const factory AuthEvent.checkRequested() = AuthCheckRequested;

  const factory AuthEvent.resetPasswordRequested({
    required String email,
  }) = AuthResetPasswordRequested;

  const factory AuthEvent.userChanged(UserEntity? user) = AuthUserChanged;
}