import 'post_content.dart';
import 'social_connection.dart';

class PostRecurrence {
  final String? rrule;
  final String? parentPostId;
  final bool isRecurringParent;
  final bool isRecurringInstance;
  final String? instanceDate;
  final bool isException;
  final List<String>? excludedDates;
  final String? recurrenceEndDate;
  final bool? aiRegenerate;
  final bool? aiAutoPublish;

  const PostRecurrence({
    this.rrule,
    this.parentPostId,
    required this.isRecurringParent,
    required this.isRecurringInstance,
    this.instanceDate,
    required this.isException,
    this.excludedDates,
    this.recurrenceEndDate,
    this.aiRegenerate,
    this.aiAutoPublish,
  });

  factory PostRecurrence.fromJson(Map<String, dynamic> json) {
    return PostRecurrence(
      rrule: json['rrule'] as String?,
      parentPostId: json['parentPostId'] as String?,
      isRecurringParent: json['isRecurringParent'] as bool? ?? false,
      isRecurringInstance: json['isRecurringInstance'] as bool? ?? false,
      instanceDate: json['instanceDate'] as String?,
      isException: json['isException'] as bool? ?? false,
      excludedDates:
          (json['excludedDates'] as List<dynamic>?)?.map((e) => e as String).toList(),
      recurrenceEndDate: json['recurrenceEndDate'] as String?,
      aiRegenerate: json['aiRegenerate'] as bool?,
      aiAutoPublish: json['aiAutoPublish'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (rrule != null) 'rrule': rrule,
      if (parentPostId != null) 'parentPostId': parentPostId,
      'isRecurringParent': isRecurringParent,
      'isRecurringInstance': isRecurringInstance,
      if (instanceDate != null) 'instanceDate': instanceDate,
      'isException': isException,
      if (excludedDates != null) 'excludedDates': excludedDates,
      if (recurrenceEndDate != null) 'recurrenceEndDate': recurrenceEndDate,
      if (aiRegenerate != null) 'aiRegenerate': aiRegenerate,
      if (aiAutoPublish != null) 'aiAutoPublish': aiAutoPublish,
    };
  }
}

class Post {
  final String id;
  final String status;
  final PostContent? content;
  final List<SocialConnection>? targetConnections;
  final String? scheduledAt;
  final String? publishedAt;
  final String? failReason;
  final int? retryCount;
  final List<String>? tags;
  final bool? isTemplate;
  final int? notesCount;
  final PostRecurrence? recurrence;
  final String? createdBy;
  final String? createdAt;
  final String? updatedAt;

  const Post({
    required this.id,
    required this.status,
    this.content,
    this.targetConnections,
    this.scheduledAt,
    this.publishedAt,
    this.failReason,
    this.retryCount,
    this.tags,
    this.isTemplate,
    this.notesCount,
    this.recurrence,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      status: json['status'] as String,
      content: json['content'] != null
          ? PostContent.fromJson(json['content'] as Map<String, dynamic>)
          : null,
      targetConnections: (json['targetConnections'] as List<dynamic>?)
          ?.map((e) => SocialConnection.fromJson(e as Map<String, dynamic>))
          .toList(),
      scheduledAt: json['scheduledAt'] as String?,
      publishedAt: json['publishedAt'] as String?,
      failReason: json['failReason'] as String?,
      retryCount: json['retryCount'] as int?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      isTemplate: json['isTemplate'] as bool?,
      notesCount: json['notesCount'] as int?,
      recurrence: json['recurrence'] != null
          ? PostRecurrence.fromJson(json['recurrence'] as Map<String, dynamic>)
          : null,
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      if (content != null) 'content': content!.toJson(),
      if (targetConnections != null)
        'targetConnections': targetConnections!.map((e) => e.toJson()).toList(),
      if (scheduledAt != null) 'scheduledAt': scheduledAt,
      if (publishedAt != null) 'publishedAt': publishedAt,
      if (failReason != null) 'failReason': failReason,
      if (retryCount != null) 'retryCount': retryCount,
      if (tags != null) 'tags': tags,
      if (isTemplate != null) 'isTemplate': isTemplate,
      if (notesCount != null) 'notesCount': notesCount,
      if (recurrence != null) 'recurrence': recurrence!.toJson(),
      if (createdBy != null) 'createdBy': createdBy,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  Post copyWith({
    String? id,
    String? status,
    PostContent? content,
    List<SocialConnection>? targetConnections,
    String? scheduledAt,
    String? publishedAt,
    String? failReason,
    int? retryCount,
    List<String>? tags,
    bool? isTemplate,
    int? notesCount,
    PostRecurrence? recurrence,
    String? createdBy,
    String? createdAt,
    String? updatedAt,
  }) {
    return Post(
      id: id ?? this.id,
      status: status ?? this.status,
      content: content ?? this.content,
      targetConnections: targetConnections ?? this.targetConnections,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      publishedAt: publishedAt ?? this.publishedAt,
      failReason: failReason ?? this.failReason,
      retryCount: retryCount ?? this.retryCount,
      tags: tags ?? this.tags,
      isTemplate: isTemplate ?? this.isTemplate,
      notesCount: notesCount ?? this.notesCount,
      recurrence: recurrence ?? this.recurrence,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Post(id: $id, status: $status)';
}
