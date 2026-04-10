class AppConstants {
  AppConstants._();

  // Animation durations
  static const Duration splashDuration = Duration(milliseconds: 1500);
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Duration staggerDelay = Duration(milliseconds: 150);
  static const Duration fadeInDuration = Duration(milliseconds: 1000);
  static const Duration fadeInFast = Duration(milliseconds: 300);

  // Pagination
  static const int defaultPageSize = 20;

  // Media
  static const int maxFileSize = 100 * 1024 * 1024; // 100MB
  static const int maxFiles = 10;
  static const List<String> supportedImageTypes = ['jpeg', 'jpg', 'png', 'gif', 'webp'];
  static const List<String> supportedVideoTypes = ['mp4', 'webm', 'mov'];

  // Supported platforms
  static const List<String> socialPlatforms = [
    'facebook',
    'instagram',
    'twitter',
    'linkedin',
    'pinterest',
    'tiktok',
    'youtube',
  ];

  // Platform display names
  static const Map<String, String> platformDisplayNames = {
    'facebook': 'Facebook',
    'instagram': 'Instagram',
    'twitter': 'X (Twitter)',
    'linkedin': 'LinkedIn',
    'pinterest': 'Pinterest',
    'tiktok': 'TikTok',
    'youtube': 'YouTube',
    'threads': 'Threads',
  };

  // Post statuses
  static const Map<String, String> postStatusLabels = {
    'DRAFT': 'Draft',
    'SCHEDULED': 'Scheduled',
    'PUBLISHING': 'Publishing',
    'PUBLISHED': 'Published',
    'FAILED': 'Failed',
    'PENDING_APPROVAL': 'Pending Approval',
    'REJECTED': 'Rejected',
  };

  // Plans
  static const Map<String, String> planLabels = {
    'FREE': 'Free',
    'SOLO': 'Solo',
    'PREMIUM': 'Premium',
  };

  // Secure storage keys
  static const String accessTokenKey = 'accessToken';
  static const String refreshTokenKey = 'refreshToken';
  static const String accountKey = 'account';
  static const String onboardingCompleteKey = 'onboardingComplete';
  static const String selectedBrandIdKey = 'selectedBrandId';
}
