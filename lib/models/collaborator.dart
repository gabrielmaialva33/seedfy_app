enum CollaboratorPermission {
  view,
  edit;

  String get displayName {
    switch (this) {
      case CollaboratorPermission.view:
        return 'view';
      case CollaboratorPermission.edit:
        return 'edit';
    }
  }

  String getLocalizedName(String languageCode) {
    final isPortuguese = languageCode == 'pt';
    switch (this) {
      case CollaboratorPermission.view:
        return isPortuguese ? 'Visualizar' : 'View';
      case CollaboratorPermission.edit:
        return isPortuguese ? 'Editar' : 'Edit';
    }
  }
}

enum CollaboratorStatus {
  pending,
  active,
  revoked;

  String get displayName {
    switch (this) {
      case CollaboratorStatus.pending:
        return 'pending';
      case CollaboratorStatus.active:
        return 'active';
      case CollaboratorStatus.revoked:
        return 'revoked';
    }
  }

  String getLocalizedName(String languageCode) {
    final isPortuguese = languageCode == 'pt';
    switch (this) {
      case CollaboratorStatus.pending:
        return isPortuguese ? 'Pendente' : 'Pending';
      case CollaboratorStatus.active:
        return isPortuguese ? 'Ativo' : 'Active';
      case CollaboratorStatus.revoked:
        return isPortuguese ? 'Revogado' : 'Revoked';
    }
  }
}

class Collaborator {
  final String id;
  final String farmId;
  final String? userId;
  final String email;
  final String? name;
  final CollaboratorPermission permission;
  final CollaboratorStatus status;
  final String? inviteToken;
  final DateTime? inviteExpiresAt;
  final DateTime createdAt;
  final DateTime? acceptedAt;

  const Collaborator({
    required this.id,
    required this.farmId,
    this.userId,
    required this.email,
    this.name,
    required this.permission,
    required this.status,
    this.inviteToken,
    this.inviteExpiresAt,
    required this.createdAt,
    this.acceptedAt,
  });

  factory Collaborator.fromJson(Map<String, dynamic> json) {
    return Collaborator(
      id: json['id'],
      farmId: json['farm_id'],
      userId: json['user_id'],
      email: json['email'],
      name: json['name'],
      permission: CollaboratorPermission.values.firstWhere(
        (p) => p.displayName == json['permission'],
        orElse: () => CollaboratorPermission.view,
      ),
      status: CollaboratorStatus.values.firstWhere(
        (s) => s.displayName == json['status'],
        orElse: () => CollaboratorStatus.pending,
      ),
      inviteToken: json['invite_token'],
      inviteExpiresAt: json['invite_expires_at'] != null
          ? DateTime.parse(json['invite_expires_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      acceptedAt: json['accepted_at'] != null
          ? DateTime.parse(json['accepted_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farm_id': farmId,
      'user_id': userId,
      'email': email,
      'name': name,
      'permission': permission.displayName,
      'status': status.displayName,
      'invite_token': inviteToken,
      'invite_expires_at': inviteExpiresAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'accepted_at': acceptedAt?.toIso8601String(),
    };
  }

  Collaborator copyWith({
    String? id,
    String? farmId,
    String? userId,
    String? email,
    String? name,
    CollaboratorPermission? permission,
    CollaboratorStatus? status,
    String? inviteToken,
    DateTime? inviteExpiresAt,
    DateTime? createdAt,
    DateTime? acceptedAt,
  }) {
    return Collaborator(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      permission: permission ?? this.permission,
      status: status ?? this.status,
      inviteToken: inviteToken ?? this.inviteToken,
      inviteExpiresAt: inviteExpiresAt ?? this.inviteExpiresAt,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
    );
  }

  bool get isInviteValid {
    if (inviteExpiresAt == null) return false;
    return DateTime.now().isBefore(inviteExpiresAt!) && status == CollaboratorStatus.pending;
  }

  bool get canEdit => permission == CollaboratorPermission.edit && status == CollaboratorStatus.active;
  bool get canView => status == CollaboratorStatus.active;
}