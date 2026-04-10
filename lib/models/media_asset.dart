class MediaAsset {
  final String id;
  final String? filename;
  final String? mimeType;
  final int? fileSize;
  final String? type;
  final String? storageUrl;
  final String? thumbnailUrl;
  final int? width;
  final int? height;
  final String? altText;
  final String? createdAt;

  const MediaAsset({
    required this.id,
    this.filename,
    this.mimeType,
    this.fileSize,
    this.type,
    this.storageUrl,
    this.thumbnailUrl,
    this.width,
    this.height,
    this.altText,
    this.createdAt,
  });

  factory MediaAsset.fromJson(Map<String, dynamic> json) {
    return MediaAsset(
      id: json['id'] as String,
      filename: json['filename'] as String?,
      mimeType: json['mimeType'] as String?,
      fileSize: json['fileSize'] as int?,
      type: json['type'] as String?,
      storageUrl: json['storageUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      altText: json['altText'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (filename != null) 'filename': filename,
      if (mimeType != null) 'mimeType': mimeType,
      if (fileSize != null) 'fileSize': fileSize,
      if (type != null) 'type': type,
      if (storageUrl != null) 'storageUrl': storageUrl,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (altText != null) 'altText': altText,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }

  @override
  String toString() => 'MediaAsset(id: $id, filename: $filename, type: $type)';
}
