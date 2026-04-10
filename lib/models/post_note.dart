class PostNote {
  final String id;
  final String content;
  final PostNoteAccount? account;
  final String? createdAt;
  final String? updatedAt;

  const PostNote({
    required this.id,
    required this.content,
    this.account,
    this.createdAt,
    this.updatedAt,
  });

  factory PostNote.fromJson(Map<String, dynamic> json) {
    return PostNote(
      id: json['id'] as String,
      content: json['content'] as String,
      account: json['account'] != null
          ? PostNoteAccount.fromJson(json['account'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      if (account != null) 'account': account!.toJson(),
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  @override
  String toString() => 'PostNote(id: $id, content: $content)';
}

class PostNoteAccount {
  final String id;
  final String name;

  const PostNoteAccount({required this.id, required this.name});

  factory PostNoteAccount.fromJson(Map<String, dynamic> json) {
    return PostNoteAccount(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
