import 'post.dart';

class Collection {
  final String id;
  final String name;
  final String? description;
  final String? color;
  final int postCount;
  final List<Post>? posts;
  final String? createdAt;
  final String? updatedAt;

  const Collection({
    required this.id,
    required this.name,
    this.description,
    this.color,
    required this.postCount,
    this.posts,
    this.createdAt,
    this.updatedAt,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      color: json['color'] as String?,
      postCount: json['postCount'] as int? ?? 0,
      posts: (json['posts'] as List<dynamic>?)
          ?.map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (color != null) 'color': color,
      'postCount': postCount,
      if (posts != null) 'posts': posts!.map((e) => e.toJson()).toList(),
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  Collection copyWith({
    String? id,
    String? name,
    String? description,
    String? color,
    int? postCount,
    List<Post>? posts,
    String? createdAt,
    String? updatedAt,
  }) {
    return Collection(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      postCount: postCount ?? this.postCount,
      posts: posts ?? this.posts,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Collection(id: $id, name: $name, postCount: $postCount)';
}
