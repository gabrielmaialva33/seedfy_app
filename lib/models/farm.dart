class Farm {
  final String id;
  final String ownerId;
  final String name;
  final DateTime createdAt;

  const Farm({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.createdAt,
  });

  factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
      id: json['id'],
      ownerId: json['owner_id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}