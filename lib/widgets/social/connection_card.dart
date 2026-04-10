import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../post/platform_icon.dart';

class ConnectionCard extends StatelessWidget {
  final Map<String, dynamic> connection;
  final VoidCallback? onTap;

  const ConnectionCard({
    super.key,
    required this.connection,
    this.onTap,
  });

  Color get _statusColor {
    switch ((connection['status'] as String?)?.toUpperCase()) {
      case 'CONNECTED':
        return KamiliColors.success;
      case 'ERROR':
        return KamiliColors.error;
      case 'RECONNECT_REQUIRED':
        return KamiliColors.warning;
      default:
        return KamiliColors.textSecondary;
    }
  }

  String get _statusLabel {
    switch ((connection['status'] as String?)?.toUpperCase()) {
      case 'CONNECTED':
        return 'Connected';
      case 'ERROR':
        return 'Error';
      case 'RECONNECT_REQUIRED':
        return 'Reconnect required';
      default:
        return connection['status'] as String? ?? 'Unknown';
    }
  }

  String _platformDisplayName(String platform) {
    switch (platform.toLowerCase()) {
      case 'facebook':
        return 'Facebook';
      case 'instagram':
        return 'Instagram';
      case 'twitter':
        return 'X (Twitter)';
      case 'linkedin':
        return 'LinkedIn';
      case 'pinterest':
        return 'Pinterest';
      case 'tiktok':
        return 'TikTok';
      case 'youtube':
        return 'YouTube';
      case 'threads':
        return 'Threads';
      default:
        return platform;
    }
  }

  String? get _lastValidated {
    final dateStr = connection['lastValidatedAt'] as String?;
    if (dateStr == null) return null;
    try {
      final date = DateTime.parse(dateStr);
      return 'Validated ${DateFormat.yMMMd().format(date)}';
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final platform = (connection['platform'] as String?) ?? '';
    final name = (connection['name'] as String?) ?? 'Unknown';

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
            children: [
              PlatformIcon(platform: platform, size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: KamiliColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _platformDisplayName(platform),
                      style: const TextStyle(
                        fontSize: 13,
                        color: KamiliColors.textSecondary,
                      ),
                    ),
                    if (_lastValidated != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        _lastValidated!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: KamiliColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _statusLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _statusColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
