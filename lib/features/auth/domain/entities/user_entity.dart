import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String locale;
  final String city;
  final String state;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    required this.locale,
    required this.city,
    required this.state,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, name, phone, locale, city, state, createdAt];
}