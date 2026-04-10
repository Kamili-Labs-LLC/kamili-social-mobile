class SocialConnection {
  final String id;
  final String platform;
  final String platformAccountId;
  final String name;
  final String? platformUsername;
  final bool? isActive;
  final List<String>? scopes;
  final String? expiresAt;
  final String status;
  final String? lastValidatedAt;
  final String? createdAt;
  final String? updatedAt;

  const SocialConnection({
    required this.id,
    required this.platform,
    required this.platformAccountId,
    required this.name,
    this.platformUsername,
    this.isActive,
    this.scopes,
    this.expiresAt,
    required this.status,
    this.lastValidatedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory SocialConnection.fromJson(Map<String, dynamic> json) {
    return SocialConnection(
      id: json['id'] as String,
      platform: json['platform'] as String,
      platformAccountId: json['platformAccountId'] as String,
      name: json['name'] as String,
      platformUsername: json['platformUsername'] as String?,
      isActive: json['isActive'] as bool?,
      scopes: (json['scopes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      expiresAt: json['expiresAt'] as String?,
      status: json['status'] as String,
      lastValidatedAt: json['lastValidatedAt'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'platform': platform,
      'platformAccountId': platformAccountId,
      'name': name,
      if (platformUsername != null) 'platformUsername': platformUsername,
      if (isActive != null) 'isActive': isActive,
      if (scopes != null) 'scopes': scopes,
      if (expiresAt != null) 'expiresAt': expiresAt,
      'status': status,
      if (lastValidatedAt != null) 'lastValidatedAt': lastValidatedAt,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  SocialConnection copyWith({
    String? id,
    String? platform,
    String? platformAccountId,
    String? name,
    String? platformUsername,
    bool? isActive,
    List<String>? scopes,
    String? expiresAt,
    String? status,
    String? lastValidatedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return SocialConnection(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      platformAccountId: platformAccountId ?? this.platformAccountId,
      name: name ?? this.name,
      platformUsername: platformUsername ?? this.platformUsername,
      isActive: isActive ?? this.isActive,
      scopes: scopes ?? this.scopes,
      expiresAt: expiresAt ?? this.expiresAt,
      status: status ?? this.status,
      lastValidatedAt: lastValidatedAt ?? this.lastValidatedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'SocialConnection(id: $id, platform: $platform, name: $name, status: $status)';
}
