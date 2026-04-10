class AiGenerationResult {
  final String? text;
  final List<String>? hashtags;
  final List<String> responses;
  final List<String>? suggestions;
  final String? historyId;
  final int? creditsUsed;
  final int? creditsRemaining;

  const AiGenerationResult({
    this.text,
    this.hashtags,
    this.responses = const [],
    this.suggestions,
    this.historyId,
    this.creditsUsed,
    this.creditsRemaining,
  });

  factory AiGenerationResult.fromJson(Map<String, dynamic> json) {
    return AiGenerationResult(
      text: json['text'] as String?,
      hashtags:
          (json['hashtags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      responses: List<String>.from(json['responses'] ?? json['suggestions'] ?? []),
      suggestions:
          (json['suggestions'] as List<dynamic>?)?.map((e) => e as String).toList(),
      historyId: json['historyId'] as String?,
      creditsUsed: json['creditsUsed'] as int?,
      creditsRemaining: json['creditsRemaining'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (text != null) 'text': text,
      if (hashtags != null) 'hashtags': hashtags,
      'responses': responses,
      if (suggestions != null) 'suggestions': suggestions,
      if (historyId != null) 'historyId': historyId,
      if (creditsUsed != null) 'creditsUsed': creditsUsed,
      if (creditsRemaining != null) 'creditsRemaining': creditsRemaining,
    };
  }

  @override
  String toString() {
    final preview = text != null && text!.length > 50
        ? text!.substring(0, 50)
        : text ?? '';
    return 'AiGenerationResult(text: $preview, responses: ${responses.length})';
  }
}

class AiTone {
  final String value;
  final String label;
  final String? emoji;

  const AiTone({
    required this.value,
    required this.label,
    this.emoji,
  });

  factory AiTone.fromJson(Map<String, dynamic> json) {
    return AiTone(
      value: json['value'] as String? ?? '',
      label: json['label'] as String? ?? json['value'] as String? ?? '',
      emoji: json['emoji'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'label': label,
      if (emoji != null) 'emoji': emoji,
    };
  }

  @override
  String toString() => 'AiTone(value: $value, label: $label)';
}

class AiHistoryItem {
  final String id;
  final String prompt;
  final List<String> responses;
  final String? generatedText;
  final String? tone;
  final String? platform;
  final int? creditsUsed;
  final String? createdAt;

  const AiHistoryItem({
    required this.id,
    required this.prompt,
    this.responses = const [],
    this.generatedText,
    this.tone,
    this.platform,
    this.creditsUsed,
    this.createdAt,
  });

  factory AiHistoryItem.fromJson(Map<String, dynamic> json) {
    return AiHistoryItem(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      prompt: json['prompt'] as String? ?? '',
      responses: List<String>.from(json['responses'] ?? []),
      generatedText: json['generatedText'] as String?,
      tone: json['tone'] as String?,
      platform: json['platform'] as String?,
      creditsUsed: json['creditsUsed'] as int?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prompt': prompt,
      'responses': responses,
      if (generatedText != null) 'generatedText': generatedText,
      if (tone != null) 'tone': tone,
      if (platform != null) 'platform': platform,
      if (creditsUsed != null) 'creditsUsed': creditsUsed,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }

  @override
  String toString() => 'AiHistoryItem(id: $id, tone: $tone, platform: $platform)';
}
