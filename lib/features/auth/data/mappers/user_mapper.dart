import '../../domain/entities/user_entity.dart';
import '../dto/user_dto.dart';

class UserMapper {
  static UserEntity toEntity(UserDto dto) {
    return UserEntity(
      id: dto.id,
      email: dto.email,
      name: dto.name,
      phone: dto.phone,
      locale: dto.locale,
      city: dto.city,
      state: dto.state,
      createdAt: dto.createdAt,
    );
  }

  static UserDto toDto(UserEntity entity) {
    return UserDto(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      phone: entity.phone,
      locale: entity.locale,
      city: entity.city,
      state: entity.state,
      createdAt: entity.createdAt,
    );
  }
}
