class Website {
  final String id;
  final String name;
  final String siteKey;
  final String siteKeyStatus;
  final bool autoPostEnabled;
  final String? lastUsedAt;
  final String? domain;
  final String? createdAt;
  final String? updatedAt;

  const Website({
    required this.id,
    required this.name,
    required this.siteKey,
    required this.siteKeyStatus,
    required this.autoPostEnabled,
    this.lastUsedAt,
    this.domain,
    this.createdAt,
    this.updatedAt,
  });

  factory Website.fromJson(Map<String, dynamic> json) {
    return Website(
      id: json['id'] as String,
      name: json['name'] as String,
      siteKey: json['siteKey'] as String,
      siteKeyStatus: json['siteKeyStatus'] as String,
      autoPostEnabled: json['autoPostEnabled'] as bool? ?? false,
      lastUsedAt: json['lastUsedAt'] as String?,
      domain: json['domain'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'siteKey': siteKey,
      'siteKeyStatus': siteKeyStatus,
      'autoPostEnabled': autoPostEnabled,
      if (lastUsedAt != null) 'lastUsedAt': lastUsedAt,
      if (domain != null) 'domain': domain,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  Website copyWith({
    String? id,
    String? name,
    String? siteKey,
    String? siteKeyStatus,
    bool? autoPostEnabled,
    String? lastUsedAt,
    String? domain,
    String? createdAt,
    String? updatedAt,
  }) {
    return Website(
      id: id ?? this.id,
      name: name ?? this.name,
      siteKey: siteKey ?? this.siteKey,
      siteKeyStatus: siteKeyStatus ?? this.siteKeyStatus,
      autoPostEnabled: autoPostEnabled ?? this.autoPostEnabled,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      domain: domain ?? this.domain,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Website(id: $id, name: $name, domain: $domain)';
}
