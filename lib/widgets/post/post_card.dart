import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import 'post_status_badge.dart';
import 'platform_icon.dart';

class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback? onTap;

  const PostCard({
    super.key,
    required this.post,
    this.onTap,
  });

  String get _text {
    final content = post['content'] as Map<String, dynamic>?;
    final defaultContent = content?['default'] as Map<String, dynamic>?;
    return (defaultContent?['text'] as String?) ?? '';
  }

  List<dynamic> get _media {
    final content = post['content'] as Map<String, dynamic>?;
    final defaultContent = content?['default'] as Map<String, dynamic>?;
    return (defaultContent?['media'] as List<dynamic>?) ?? [];
  }

  List<String> get _platforms {
    final ids = post['targetConnectionIds'] as List<dynamic>?;
    if (ids == null) return [];
    return ids.map((e) => e.toString()).toList();
  }

  String? get _displayTime {
    final published = post['publishedAt'] as String?;
    final scheduled = post['scheduledAt'] as String?;
    final created = post['createdAt'] as String?;

    final dateStr = published ?? scheduled ?? created;
    if (dateStr == null) return null;

    try {
      final date = DateTime.parse(dateStr);
      if (published != null) {
        return 'Published ${DateFormat.yMMMd().add_jm().format(date)}';
      } else if (scheduled != null) {
        return 'Scheduled ${DateFormat.yMMMd().add_jm().format(date)}';
      }
      return DateFormat.yMMMd().format(date);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = (post['status'] as String?) ?? 'DRAFT';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: KamiliColors.borderLight),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PostStatusBadge(status: status),
                    if (_text.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        _text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: KamiliColors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (_platforms.isNotEmpty) ...[
                          ..._platforms.take(5).map(
                                (p) => Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: PlatformIcon(
                                    platform: p,
                                    size: 18,
                                  ),
                                ),
                              ),
                          if (_platforms.length > 5)
                            Text(
                              '+${_platforms.length - 5}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: KamiliColors.textSecondary,
                              ),
                            ),
                        ],
                        const Spacer(),
                        if (_displayTime != null)
                          Text(
                            _displayTime!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: KamiliColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_media.isNotEmpty) ...[
                const SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildThumbnail(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    final firstMedia = _media.first;
    final url = firstMedia is Map ? (firstMedia['url'] as String?) : null;

    if (url == null || url.isEmpty) {
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: KamiliColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.image_outlined,
          color: KamiliColors.textSecondary,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      width: 64,
      height: 64,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        width: 64,
        height: 64,
        color: KamiliColors.surface,
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: 64,
        height: 64,
        color: KamiliColors.surface,
        child: const Icon(
          Icons.broken_image_outlined,
          color: KamiliColors.textSecondary,
        ),
      ),
    );
  }
}
