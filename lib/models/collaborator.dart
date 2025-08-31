class Collaborator {
  final String id;
  final String farmId;
  final String profileId;
  final String name;
  final String email;
  final String role;
  final DateTime createdAt;

  const Collaborator({
    required this.id,
    required this.farmId,
    required this.profileId,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  factory Collaborator.fromJson(Map<String, dynamic> json) {
    return Collaborator(
      id: json['id'],
      farmId: json['farm_id'],
      profileId: json['profile_id'],
      name: json['profile']?['name'] ?? json['name'] ?? '',
      email: json['profile']?['email'] ?? json['email'] ?? '',
      role: json['role'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farm_id': farmId,
      'profile_id': profileId,
      'name': name,
      'email': email,
      'role': role,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get isEditor => role == 'editor';
  bool get isViewer => role == 'viewer';
}