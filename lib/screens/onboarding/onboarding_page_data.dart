import 'package:flutter/material.dart';

class OnboardingPageData {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String>? platforms;

  const OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.platforms,
  });

  static const List<OnboardingPageData> pages = [
    OnboardingPageData(
      title: 'Publish Everywhere',
      subtitle:
          'Schedule and publish to all your social networks from one dashboard.',
      icon: Icons.public,
      platforms: [
        'facebook',
        'instagram',
        'twitter',
        'linkedin',
        'pinterest',
        'tiktok',
        'youtube',
        'threads',
      ],
    ),
    OnboardingPageData(
      title: 'Smart Scheduling',
      subtitle:
          'Plan your content calendar, set optimal posting times, and let Kamili handle the rest.',
      icon: Icons.calendar_month,
    ),
    OnboardingPageData(
      title: 'Track Performance',
      subtitle:
          'Monitor engagement, track analytics, and optimize your social media strategy with AI.',
      icon: Icons.insights,
    ),
  ];
}
