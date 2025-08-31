import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seedfy_app/core/errors/failures.dart';
import 'package:seedfy_app/features/auth/domain/entities/user_entity.dart';
import 'package:seedfy_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:seedfy_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:seedfy_app/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../../helpers/test_helper.dart';

void main() {
  late AuthBloc authBloc;
  late MockAuthRepository mockAuthRepository;
  late MockLoginUsecase mockLoginUsecase;
  late MockSignupUsecase mockSignupUsecase;

  setUpAll(() {
    registerFallbackValue(const LoginParams(
      email: 'test@example.com',
      password: 'password',
    ));
    registerFallbackValue(const SignupParams(
      email: 'test@example.com',
      password: 'password',
      name: 'Test',
      phone: '123',
      city: 'City',
      state: 'State',
    ));
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockLoginUsecase = MockLoginUsecase();
    mockSignupUsecase = MockSignupUsecase();
    
    // Setup auth state stream
    when(() => mockAuthRepository.authStateChanges)
        .thenAnswer((_) => const Stream.empty());

    authBloc = AuthBloc(
      loginUseCase: mockLoginUsecase,
      signupUseCase: mockSignupUsecase,
      authRepository: mockAuthRepository,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  final testUserEntity = UserEntity(
    id: TestData.userId,
    email: TestData.validEmail,
    name: TestData.validName,
    locale: 'pt-BR',
    city: 'São Paulo',
    state: 'SP',
    createdAt: DateTime.now(),
  );

  group('AuthBloc', () {
    test('initial state should be AuthState.initial', () {
      expect(authBloc.state, const AuthState.initial());
    });

    group('AuthLoginRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [loading, authenticated] when login is successful',
        build: () {
          when(() => mockLoginUsecase(any()))
              .thenAnswer((_) async => Right(testUserEntity));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthEvent.loginRequested(
          email: TestData.validEmail,
          password: TestData.validPassword,
        )),
        expect: () => [
          const AuthState.loading(),
          AuthState.authenticated(testUserEntity),
        ],
        verify: (bloc) {
          verify(() => mockLoginUsecase(const LoginParams(
            email: TestData.validEmail,
            password: TestData.validPassword,
          ))).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, error] when login fails',
        build: () {
          when(() => mockLoginUsecase(any()))
              .thenAnswer((_) async => const Left(ServerFailure('Login failed')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthEvent.loginRequested(
          email: TestData.validEmail,
          password: TestData.validPassword,
        )),
        expect: () => [
          const AuthState.loading(),
          const AuthState.error('Login failed'),
        ],
        verify: (bloc) {
          verify(() => mockLoginUsecase(const LoginParams(
            email: TestData.validEmail,
            password: TestData.validPassword,
          ))).called(1);
        },
      );
    });

    group('AuthSignupRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [loading, authenticated] when signup is successful',
        build: () {
          when(() => mockSignupUsecase(any()))
              .thenAnswer((_) async => Right(testUserEntity));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthEvent.signupRequested(
          email: TestData.validEmail,
          password: TestData.validPassword,
          name: TestData.validName,
          phone: '11999999999',
          city: 'São Paulo',
          state: 'SP',
          locale: 'pt-BR',
        )),
        expect: () => [
          const AuthState.loading(),
          AuthState.authenticated(testUserEntity),
        ],
        verify: (bloc) {
          verify(() => mockSignupUsecase(const SignupParams(
            email: TestData.validEmail,
            password: TestData.validPassword,
            name: TestData.validName,
            phone: '11999999999',
            city: 'São Paulo',
            state: 'SP',
            locale: 'pt-BR',
          ))).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, error] when signup fails',
        build: () {
          when(() => mockSignupUsecase(any()))
              .thenAnswer((_) async => const Left(ServerFailure('Signup failed')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthEvent.signupRequested(
          email: TestData.validEmail,
          password: TestData.validPassword,
          name: TestData.validName,
          phone: '11999999999',
          city: 'São Paulo',
          state: 'SP',
          locale: 'pt-BR',
        )),
        expect: () => [
          const AuthState.loading(),
          const AuthState.error('Signup failed'),
        ],
      );
    });

    group('AuthLogoutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [loading, unauthenticated] when logout is successful',
        build: () {
          when(() => mockAuthRepository.logout())
              .thenAnswer((_) async => const Right(unit));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthEvent.logoutRequested()),
        expect: () => [
          const AuthState.loading(),
          const AuthState.unauthenticated(),
        ],
        verify: (bloc) {
          verify(() => mockAuthRepository.logout()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, error] when logout fails',
        build: () {
          when(() => mockAuthRepository.logout())
              .thenAnswer((_) async => const Left(ServerFailure('Logout failed')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthEvent.logoutRequested()),
        expect: () => [
          const AuthState.loading(),
          const AuthState.error('Logout failed'),
        ],
      );
    });

    group('AuthCheckRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [loading, authenticated] when user is found',
        build: () {
          when(() => mockAuthRepository.getCurrentUser())
              .thenAnswer((_) async => Right(testUserEntity));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthEvent.checkRequested()),
        expect: () => [
          const AuthState.loading(),
          AuthState.authenticated(testUserEntity),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, unauthenticated] when no user is found',
        build: () {
          when(() => mockAuthRepository.getCurrentUser())
              .thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthEvent.checkRequested()),
        expect: () => [
          const AuthState.loading(),
          const AuthState.unauthenticated(),
        ],
      );
    });

    group('AuthResetPasswordRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [loading, passwordResetSent] when reset is successful',
        build: () {
          when(() => mockAuthRepository.resetPassword(any()))
              .thenAnswer((_) async => const Right(unit));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthEvent.resetPasswordRequested(
          email: TestData.validEmail,
        )),
        expect: () => [
          const AuthState.loading(),
          const AuthState.passwordResetSent(),
        ],
        verify: (bloc) {
          verify(() => mockAuthRepository.resetPassword(TestData.validEmail))
              .called(1);
        },
      );
    });
  });
}