import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/posts/posts_list_screen.dart';
import '../screens/posts/post_detail_screen.dart';
import '../screens/posts/create_post_screen.dart';
import '../screens/posts/post_calendar_screen.dart';
import '../screens/inbox/inbox_screen.dart';
import '../screens/analytics/analytics_screen.dart';
import '../screens/social_connections/connections_screen.dart';
import '../screens/brands/brands_screen.dart';
import '../screens/brands/brand_detail_screen.dart';
import '../screens/collections/collections_screen.dart';
import '../screens/collections/collection_detail_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/settings/account_settings_screen.dart';
import '../screens/settings/notification_settings_screen.dart';
import '../screens/settings/subscription_screen.dart';
import 'route_names.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(Ref ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final isAuthenticated = authState is Authenticated;
      final isLoading = authState is AuthLoading;
      final currentPath = state.matchedLocation;

      if (isLoading) return null;

      final authRoutes = [
        RoutePaths.login,
        RoutePaths.signup,
        RoutePaths.forgotPassword,
        '/reset-password',
      ];
      final isOnAuthRoute = authRoutes.any((r) => currentPath.startsWith(r));
      final isOnSplash = currentPath == RoutePaths.splash;
      final isOnOnboarding = currentPath == RoutePaths.onboarding;

      if (isOnSplash) return null;

      if (!isAuthenticated && !isOnAuthRoute && !isOnOnboarding) {
        return RoutePaths.login;
      }

      if (isAuthenticated && (isOnAuthRoute || isOnOnboarding)) {
        return RoutePaths.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.signup,
        name: RouteNames.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        name: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RoutePaths.resetPassword,
        name: RouteNames.resetPassword,
        builder: (context, state) {
          final token = state.pathParameters['token'] ?? '';
          return ResetPasswordScreen(token: token);
        },
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => HomeScreen(child: child),
        routes: [
          GoRoute(
            path: RoutePaths.dashboard,
            name: RouteNames.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: RoutePaths.posts,
            name: RouteNames.posts,
            builder: (context, state) => const PostsListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                name: RouteNames.createPost,
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const CreatePostScreen(),
              ),
              GoRoute(
                path: ':id',
                name: RouteNames.postDetail,
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return PostDetailScreen(postId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: RoutePaths.postCalendar,
            name: RouteNames.postCalendar,
            builder: (context, state) => const PostCalendarScreen(),
          ),
          GoRoute(
            path: RoutePaths.inbox,
            name: RouteNames.inbox,
            builder: (context, state) => const InboxScreen(),
          ),
          GoRoute(
            path: RoutePaths.analytics,
            name: RouteNames.analytics,
            builder: (context, state) => const AnalyticsScreen(),
          ),
          GoRoute(
            path: RoutePaths.connections,
            name: RouteNames.connections,
            builder: (context, state) => const ConnectionsScreen(),
          ),
          GoRoute(
            path: RoutePaths.brands,
            name: RouteNames.brands,
            builder: (context, state) => const BrandsScreen(),
            routes: [
              GoRoute(
                path: ':id',
                name: RouteNames.brandDetail,
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return BrandDetailScreen(brandId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: RoutePaths.collections,
            name: RouteNames.collections,
            builder: (context, state) => const CollectionsScreen(),
            routes: [
              GoRoute(
                path: ':id',
                name: RouteNames.collectionDetail,
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return CollectionDetailScreen(collectionId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: RoutePaths.settings,
            name: RouteNames.settings,
            builder: (context, state) => const SettingsScreen(),
            routes: [
              GoRoute(
                path: 'account',
                name: RouteNames.accountSettings,
                builder: (context, state) => const AccountSettingsScreen(),
              ),
              GoRoute(
                path: 'notifications',
                name: RouteNames.notificationSettings,
                builder: (context, state) =>
                    const NotificationSettingsScreen(),
              ),
              GoRoute(
                path: 'subscription',
                name: RouteNames.subscriptionSettings,
                builder: (context, state) => const SubscriptionScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  return createRouter(ref);
});
