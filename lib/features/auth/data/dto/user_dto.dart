import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String email,
    required String name,
    String? phone,
    required String locale,
    required String city,
    required String state,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    id: json['id'] as String,
    email: json['email'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String?,
    locale: json['locale'] as String,
    city: json['city'] as String,
    state: json['state'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] != null 
        ? DateTime.parse(json['updated_at'] as String) 
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'phone': phone,
    'locale': locale,
    'city': city,
    'state': state,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}