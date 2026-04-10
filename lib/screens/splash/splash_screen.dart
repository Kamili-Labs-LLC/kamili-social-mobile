import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../router/route_names.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    // Wait for minimum splash duration and onboarding check in parallel
    final results = await Future.wait([
      Future.delayed(AppConstants.splashDuration),
      SharedPreferences.getInstance(),
    ]);
    if (!mounted) return;

    final prefs = results[1] as SharedPreferences;
    final onboardingComplete =
        prefs.getBool(AppConstants.onboardingCompleteKey) ?? false;

    if (!onboardingComplete) {
      context.go(RoutePaths.onboarding);
      return;
    }

    // Wait for auth initialization to complete before navigating
    final authState = await _waitForAuthReady();
    if (!mounted) return;

    if (authState is Authenticated) {
      context.go(RoutePaths.dashboard);
    } else {
      context.go(RoutePaths.login);
    }
  }

  /// Returns the resolved auth state, waiting if still loading.
  Future<AuthState> _waitForAuthReady() async {
    final current = ref.read(authProvider);
    if (current is! AuthLoading) return current;

    final completer = Completer<AuthState>();
    final sub = ref.listenManual(authProvider, (_, next) {
      if (next is! AuthLoading && !completer.isCompleted) {
        completer.complete(next);
      }
    });
    final result = await completer.future;
    sub.close();
    return result;
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KamiliColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset(
            'assets/images/kamili-social-logo.png',
            width: 200,
          ),
        ),
      ),
    );
  }
}
