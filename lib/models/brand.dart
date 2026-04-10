class Brand {
  final String id;
  final String name;
  final String? description;
  final String? logo;
  final String? websiteUrl;
  final String? wordpressUrl;
  final String? timezone;
  final String? primaryColor;
  final bool isActive;
  final bool? isShared;
  final String? userRole;
  final String? createdAt;
  final String? updatedAt;

  const Brand({
    required this.id,
    required this.name,
    this.description,
    this.logo,
    this.websiteUrl,
    this.wordpressUrl,
    this.timezone,
    this.primaryColor,
    required this.isActive,
    this.isShared,
    this.userRole,
    this.createdAt,
    this.updatedAt,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      logo: json['logo'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      wordpressUrl: json['wordpressUrl'] as String?,
      timezone: json['timezone'] as String?,
      primaryColor: json['primaryColor'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      isShared: json['isShared'] as bool?,
      userRole: json['userRole'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (logo != null) 'logo': logo,
      if (websiteUrl != null) 'websiteUrl': websiteUrl,
      if (wordpressUrl != null) 'wordpressUrl': wordpressUrl,
      if (timezone != null) 'timezone': timezone,
      if (primaryColor != null) 'primaryColor': primaryColor,
      'isActive': isActive,
      if (isShared != null) 'isShared': isShared,
      if (userRole != null) 'userRole': userRole,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  Brand copyWith({
    String? id,
    String? name,
    String? description,
    String? logo,
    String? websiteUrl,
    String? wordpressUrl,
    String? timezone,
    String? primaryColor,
    bool? isActive,
    bool? isShared,
    String? userRole,
    String? createdAt,
    String? updatedAt,
  }) {
    return Brand(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      wordpressUrl: wordpressUrl ?? this.wordpressUrl,
      timezone: timezone ?? this.timezone,
      primaryColor: primaryColor ?? this.primaryColor,
      isActive: isActive ?? this.isActive,
      isShared: isShared ?? this.isShared,
      userRole: userRole ?? this.userRole,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Brand(id: $id, name: $name, isActive: $isActive)';
}
