import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../config/theme.dart';

class PlatformUtils {
  PlatformUtils._();

  static String displayName(String platform) {
    return AppConstants.platformDisplayNames[platform.toLowerCase()] ??
        platform;
  }

  static Color color(String platform) {
    return KamiliColors.platformColor(platform);
  }

  static IconData icon(String platform) {
    switch (platform.toLowerCase()) {
      case 'facebook':
        return Icons.facebook;
      case 'instagram':
        return Icons.camera_alt;
      case 'twitter':
        return Icons.close; // X
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

  static int? characterLimit(String platform) {
    switch (platform.toLowerCase()) {
      case 'twitter':
        return 280;
      case 'linkedin':
        return 3000;
      case 'instagram':
        return 2200;
      case 'facebook':
        return 63206;
      case 'pinterest':
        return 500;
      case 'tiktok':
        return 2200;
      case 'youtube':
        return 5000;
      default:
        return null;
    }
  }
}
