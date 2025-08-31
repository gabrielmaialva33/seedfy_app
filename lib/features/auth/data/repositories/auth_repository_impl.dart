import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../mappers/user_mapper.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    if (!(await networkInfo.isConnected)) {
      return const Left(NetworkFailure());
    }

    try {
      final userDto = await remoteDataSource.login(email, password);
      return Right(UserMapper.toEntity(userDto));
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login credentials')) {
        return const Left(InvalidCredentialsFailure());
      }
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signup({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String city,
    required String state,
    String locale = 'pt-BR',
  }) async {
    if (!(await networkInfo.isConnected)) {
      return const Left(NetworkFailure());
    }

    try {
      final userDto = await remoteDataSource.signup(
        email: email,
        password: password,
        name: name,
        phone: phone,
        city: city,
        state: state,
        locale: locale,
      );
      return Right(UserMapper.toEntity(userDto));
    } on AuthException catch (e) {
      if (e.message.contains('already registered')) {
        return const Left(EmailAlreadyInUseFailure());
      }
      if (e.message.contains('weak')) {
        return const Left(WeakPasswordFailure());
      }
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final userDto = remoteDataSource.getCurrentUser();
      if (userDto == null) return const Right(null);
      return Right(UserMapper.toEntity(userDto));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return remoteDataSource.authStateChanges.map((dto) {
      if (dto == null) return null;
      return UserMapper.toEntity(dto);
    });
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    if (!(await networkInfo.isConnected)) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.resetPassword(email);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}