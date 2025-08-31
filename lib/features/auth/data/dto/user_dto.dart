class UserDto {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String locale;
  final String city;
  final String state;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserDto({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    required this.locale,
    required this.city,
    required this.state,
    required this.createdAt,
    this.updatedAt,
  });

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

  UserDto copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? locale,
    String? city,
    String? state,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserDto(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      locale: locale ?? this.locale,
      city: city ?? this.city,
      state: state ?? this.state,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserDto &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.phone == phone &&
        other.locale == locale &&
        other.city == city &&
        other.state == state &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      email,
      name,
      phone,
      locale,
      city,
      state,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserDto(id: $id, email: $email, name: $name, phone: $phone, '
           'locale: $locale, city: $city, state: $state, '
           'createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}