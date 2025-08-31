import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/exceptions.dart' as core_exceptions;
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../features/auth/domain/entities/user_entity.dart';
import '../../../../features/auth/data/dto/user_dto.dart';
import '../../../../features/auth/data/mappers/user_mapper.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final SupabaseClient supabaseClient;
  final NetworkInfo networkInfo;

  const ProfileRepositoryImpl({
    required this.supabaseClient,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        final user = supabaseClient.auth.currentUser;
        if (user == null) {
          throw core_exceptions.AuthException('User not authenticated');
        }

        final response = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single();

        final userDto = UserDto.fromJson(response);
        final userEntity = UserMapper.toEntity(userDto);
        return Right(userEntity);
      } on core_exceptions.AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on PostgrestException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(UserEntity user) async {
    if (await networkInfo.isConnected) {
      try {
        final currentUser = supabaseClient.auth.currentUser;
        if (currentUser == null) {
          throw core_exceptions.AuthException('User not authenticated');
        }

        final response = await supabaseClient
            .from('profiles')
            .update(UserMapper.toDto(user).toJson())
            .eq('id', currentUser.id)
            .select()
            .single();

        final updatedUserDto = UserDto.fromJson(response);
        final updatedUser = UserMapper.toEntity(updatedUserDto);
        return Right(updatedUser);
      } on core_exceptions.AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on PostgrestException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword(
      String currentPassword, String newPassword) async {
    if (await networkInfo.isConnected) {
      try {
        await supabaseClient.auth.updateUser(
          UserAttributes(password: newPassword),
        );
        return const Right(null);
      } on core_exceptions.AuthException catch (e) {
        return Left(AuthFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    if (await networkInfo.isConnected) {
      try {
        final user = supabaseClient.auth.currentUser;
        if (user == null) {
          throw core_exceptions.AuthException('User not authenticated');
        }

        await supabaseClient.from('profiles').delete().eq('id', user.id);
        await supabaseClient.auth.signOut();
        return const Right(null);
      } on core_exceptions.AuthException catch (e) {
        return Left(AuthFailure(e.message));
      } on PostgrestException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
