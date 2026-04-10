class RouteNames {
  RouteNames._();

  // Auth
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String signup = 'signup';
  static const String forgotPassword = 'forgotPassword';
  static const String resetPassword = 'resetPassword';

  // Main tabs
  static const String dashboard = 'dashboard';
  static const String posts = 'posts';
  static const String inbox = 'inbox';
  static const String analytics = 'analytics';
  static const String settings = 'settings';

  // Posts sub-routes
  static const String postDetail = 'postDetail';
  static const String createPost = 'createPost';
  static const String postCalendar = 'postCalendar';

  // Connections
  static const String connections = 'connections';

  // Brands
  static const String brands = 'brands';
  static const String brandDetail = 'brandDetail';

  // Collections
  static const String collections = 'collections';
  static const String collectionDetail = 'collectionDetail';

  // Settings sub-routes
  static const String accountSettings = 'accountSettings';
  static const String notificationSettings = 'notificationSettings';
  static const String subscriptionSettings = 'subscriptionSettings';
}

class RoutePaths {
  RoutePaths._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password/:token';

  static const String dashboard = '/dashboard';
  static const String posts = '/posts';
  static const String postDetail = '/posts/:id';
  static const String createPost = '/posts/create';
  static const String postCalendar = '/calendar';
  static const String inbox = '/inbox';
  static const String analytics = '/analytics';
  static const String connections = '/connections';
  static const String brands = '/brands';
  static const String brandDetail = '/brands/:id';
  static const String collections = '/collections';
  static const String collectionDetail = '/collections/:id';
  static const String settings = '/settings';
  static const String accountSettings = '/settings/account';
  static const String notificationSettings = '/settings/notifications';
  static const String subscriptionSettings = '/settings/subscription';
}
