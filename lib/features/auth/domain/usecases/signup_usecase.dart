import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(SignupParams params) {
    return repository.signup(
      email: params.email,
      password: params.password,
      name: params.name,
      phone: params.phone,
      city: params.city,
      state: params.state,
      locale: params.locale,
    );
  }
}

class SignupParams extends Equatable {
  final String email;
  final String password;
  final String name;
  final String phone;
  final String city;
  final String state;
  final String locale;

  const SignupParams({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.city,
    required this.state,
    this.locale = 'pt-BR',
  });

  @override
  List<Object> get props => [email, password, name, phone, city, state, locale];
}