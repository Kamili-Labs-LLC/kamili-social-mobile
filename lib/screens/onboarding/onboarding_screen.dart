import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../router/route_names.dart';
import '../../widgets/common/kamili_button.dart';
import '../../widgets/post/platform_icon.dart';

class _OnboardingPage {
  final String title;
  final String subtitle;
  final Widget visual;

  const _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.visual,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _animController;
  late Animation<double> _visualOpacity;
  late Animation<Offset> _visualSlide;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subtitleOpacity;
  late Animation<Offset> _subtitleSlide;

  late final List<_OnboardingPage> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _OnboardingPage(
        title: 'Publish Everywhere',
        subtitle:
            'Schedule and publish to all your social networks from one dashboard.',
        visual: _buildPlatformGrid(),
      ),
      _OnboardingPage(
        title: 'Smart Scheduling',
        subtitle:
            'Plan your content calendar, set optimal posting times, and let Kamili handle the rest.',
        visual: _buildCircleIcon(Icons.calendar_month),
      ),
      _OnboardingPage(
        title: 'Track Performance',
        subtitle:
            'Monitor engagement, track analytics, and optimize your social media strategy with AI.',
        visual: _buildCircleIcon(Icons.insights),
      ),
    ];

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _setupAnimations();
    _animController.forward();
  }

  void _setupAnimations() {
    // Visual: 0ms delay, slide from +30px
    _visualOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );
    _visualSlide = Tween<Offset>(
      begin: const Offset(0, 30),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Title: 150ms delay (0.15 of 1000ms)
    _titleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.15, 1.0, curve: Curves.easeInOut),
      ),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 20),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.15, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Subtitle: 300ms delay (0.3 of 1000ms)
    _subtitleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );
    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 20),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  Widget _buildPlatformGrid() {
    const platforms = [
      'facebook',
      'instagram',
      'twitter',
      'linkedin',
      'pinterest',
      'tiktok',
      'youtube',
      'threads',
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: platforms.map((platform) {
        return PlatformIcon(
          platform: platform,
          size: 48,
          showBackground: true,
        );
      }).toList(),
    );
  }

  Widget _buildCircleIcon(IconData icon) {
    return Container(
      width: 120,
      height: 120,
      decoration: const BoxDecoration(
        color: KamiliColors.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 56,
        color: Colors.white,
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.onboardingCompleteKey, true);
    if (mounted) {
      context.go(RoutePaths.login);
    }
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _animController.reset();
    _animController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return AnimatedBuilder(
                    animation: _animController,
                    builder: (context, _) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          children: [
                            // 40% top: Visual centered
                            Expanded(
                              flex: 4,
                              child: Center(
                                child: Opacity(
                                  opacity: _visualOpacity.value,
                                  child: Transform.translate(
                                    offset: _visualSlide.value,
                                    child: page.visual,
                                  ),
                                ),
                              ),
                            ),
                            // Title
                            Opacity(
                              opacity: _titleOpacity.value,
                              child: Transform.translate(
                                offset: _titleSlide.value,
                                child: Text(
                                  page.title,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: KamiliColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Subtitle
                            Opacity(
                              opacity: _subtitleOpacity.value,
                              child: Transform.translate(
                                offset: _subtitleSlide.value,
                                child: Text(
                                  page.subtitle,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: KamiliColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                            // Bottom spacer
                            const Expanded(flex: 3, child: SizedBox()),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // Bottom controls
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: KamiliColors.primary,
                      dotColor: KamiliColors.borderLight,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (isLastPage)
                    KamiliButton(
                      label: 'Get Started',
                      onPressed: _completeOnboarding,
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: _completeOnboarding,
                          child: const Text('Skip'),
                        ),
                        KamiliButton(
                          label: 'Next',
                          fullWidth: false,
                          onPressed: () {
                            _pageController.nextPage(
                              duration: AppConstants.pageTransitionDuration,
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
