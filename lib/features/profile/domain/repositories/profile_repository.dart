import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../features/auth/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, UserEntity>> updateProfile(UserEntity user);

  Future<Either<Failure, void>> updatePassword(
      String currentPassword, String newPassword);

  Future<Either<Failure, void>> deleteAccount();
}
