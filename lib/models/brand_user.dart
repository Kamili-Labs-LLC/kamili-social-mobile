class BrandUser {
  final String id;
  final String userEmail;
  final String userName;
  final String role;
  final String status;
  final String? lastActiveAt;
  final bool? isShared;
  final BrandRef? brand;
  final InvitedByRef? invitedBy;
  final String? createdAt;
  final String? updatedAt;

  const BrandUser({
    required this.id,
    required this.userEmail,
    required this.userName,
    required this.role,
    required this.status,
    this.lastActiveAt,
    this.isShared,
    this.brand,
    this.invitedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory BrandUser.fromJson(Map<String, dynamic> json) {
    return BrandUser(
      id: json['id'] as String,
      userEmail: json['userEmail'] as String,
      userName: json['userName'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      lastActiveAt: json['lastActiveAt'] as String?,
      isShared: json['isShared'] as bool?,
      brand: json['brand'] != null
          ? BrandRef.fromJson(json['brand'] as Map<String, dynamic>)
          : null,
      invitedBy: json['invitedBy'] != null
          ? InvitedByRef.fromJson(json['invitedBy'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userEmail': userEmail,
      'userName': userName,
      'role': role,
      'status': status,
      if (lastActiveAt != null) 'lastActiveAt': lastActiveAt,
      if (isShared != null) 'isShared': isShared,
      if (brand != null) 'brand': brand!.toJson(),
      if (invitedBy != null) 'invitedBy': invitedBy!.toJson(),
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  @override
  String toString() =>
      'BrandUser(id: $id, userName: $userName, role: $role, status: $status)';
}

class BrandRef {
  final String id;
  final String name;

  const BrandRef({required this.id, required this.name});

  factory BrandRef.fromJson(Map<String, dynamic> json) {
    return BrandRef(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class InvitedByRef {
  final String id;
  final String name;

  const InvitedByRef({required this.id, required this.name});

  factory InvitedByRef.fromJson(Map<String, dynamic> json) {
    return InvitedByRef(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
