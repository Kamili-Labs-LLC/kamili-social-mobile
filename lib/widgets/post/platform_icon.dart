import 'package:flutter/material.dart';
import '../../config/theme.dart';

class PlatformIcon extends StatelessWidget {
  final String platform;
  final double size;
  final bool showBackground;

  const PlatformIcon({
    super.key,
    required this.platform,
    this.size = 24,
    this.showBackground = true,
  });

  IconData get _icon {
    switch (platform.toLowerCase()) {
      case 'facebook':
        return Icons.facebook;
      case 'instagram':
        return Icons.camera_alt;
      case 'twitter':
        return Icons.close;
      case 'linkedin':
        return Icons.work;
      case 'pinterest':
        return Icons.push_pin;
      case 'tiktok':
        return Icons.music_note;
      case 'youtube':
        return Icons.play_arrow;
      case 'threads':
        return Icons.alternate_email;
      default:
        return Icons.public;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = KamiliColors.platformColor(platform);

    if (!showBackground) {
      return Icon(_icon, size: size, color: color);
    }

    return Container(
      width: size + 8,
      height: size + 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(
        _icon,
        size: size * 0.6,
        color: Colors.white,
      ),
    );
  }
}
