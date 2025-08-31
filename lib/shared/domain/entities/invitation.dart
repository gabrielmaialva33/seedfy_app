class Invitation {
  final String id;
  final String farmId;
  final String farmName;
  final String inviterName;
  final String inviterEmail;
  final String inviteeEmail;
  final String role;
  final String status;
  final String? token;
  final DateTime createdAt;
  final DateTime? expiresAt;

  const Invitation({
    required this.id,
    required this.farmId,
    required this.farmName,
    required this.inviterName,
    required this.inviterEmail,
    required this.inviteeEmail,
    required this.role,
    required this.status,
    this.token,
    required this.createdAt,
    this.expiresAt,
  });

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      id: json['id'],
      farmId: json['farm_id'],
      farmName: json['farm_name'] ?? '',
      inviterName: json['inviter_name'] ?? '',
      inviterEmail: json['inviter_email'] ?? '',
      inviteeEmail: json['invitee_email'],
      role: json['role'],
      status: json['status'],
      token: json['token'],
      createdAt: DateTime.parse(json['created_at']),
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farm_id': farmId,
      'farm_name': farmName,
      'inviter_name': inviterName,
      'inviter_email': inviterEmail,
      'invitee_email': inviteeEmail,
      'role': role,
      'status': status,
      'token': token,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
    };
  }
}
