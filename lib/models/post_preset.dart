class PostPreset {
  final String id;
  final String name;
  final String platform;
  final Map<String, dynamic> settings;
  final bool isDefault;
  final String? createdBy;
  final String? createdAt;
  final String? updatedAt;

  const PostPreset({
    required this.id,
    required this.name,
    required this.platform,
    required this.settings,
    required this.isDefault,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory PostPreset.fromJson(Map<String, dynamic> json) {
    return PostPreset(
      id: json['id'] as String,
      name: json['name'] as String,
      platform: json['platform'] as String,
      settings: json['settings'] is Map<String, dynamic>
          ? json['settings'] as Map<String, dynamic>
          : <String, dynamic>{},
      isDefault: json['isDefault'] as bool? ?? false,
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'platform': platform,
      'settings': settings,
      'isDefault': isDefault,
      if (createdBy != null) 'createdBy': createdBy,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  @override
  String toString() =>
      'PostPreset(id: $id, name: $name, platform: $platform, isDefault: $isDefault)';
}
