import 'package:flutter/material.dart';
import '../../config/theme.dart';

class PostStatusBadge extends StatelessWidget {
  final String status;

  const PostStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: config.borderColor != null
            ? Border.all(color: config.borderColor!)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (config.showLoading) ...[
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor:
                    AlwaysStoppedAnimation<Color>(config.foregroundColor),
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            config.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: config.foregroundColor,
            ),
          ),
        ],
      ),
    );
  }

  _BadgeConfig _getConfig() {
    switch (status.toUpperCase()) {
      case 'DRAFT':
        return _BadgeConfig(
          label: 'Draft',
          backgroundColor: KamiliColors.surface,
          foregroundColor: KamiliColors.textSecondary,
        );
      case 'SCHEDULED':
        return _BadgeConfig(
          label: 'Scheduled',
          backgroundColor: KamiliColors.primary.withValues(alpha: 0.1),
          foregroundColor: KamiliColors.primary,
        );
      case 'PUBLISHED':
        return _BadgeConfig(
          label: 'Published',
          backgroundColor: KamiliColors.success.withValues(alpha: 0.1),
          foregroundColor: KamiliColors.success,
        );
      case 'FAILED':
        return _BadgeConfig(
          label: 'Failed',
          backgroundColor: KamiliColors.error.withValues(alpha: 0.1),
          foregroundColor: KamiliColors.error,
        );
      case 'PENDING_APPROVAL':
        return _BadgeConfig(
          label: 'Pending',
          backgroundColor: KamiliColors.warning.withValues(alpha: 0.1),
          foregroundColor: KamiliColors.warning,
        );
      case 'REJECTED':
        return _BadgeConfig(
          label: 'Rejected',
          backgroundColor: Colors.transparent,
          foregroundColor: KamiliColors.error,
          borderColor: KamiliColors.error,
        );
      case 'PUBLISHING':
        return _BadgeConfig(
          label: 'Publishing',
          backgroundColor: KamiliColors.primary.withValues(alpha: 0.1),
          foregroundColor: KamiliColors.primary,
          showLoading: true,
        );
      default:
        return _BadgeConfig(
          label: status,
          backgroundColor: KamiliColors.surface,
          foregroundColor: KamiliColors.textSecondary,
        );
    }
  }
}

class _BadgeConfig {
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final bool showLoading;

  const _BadgeConfig({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
    this.showLoading = false,
  });
}
