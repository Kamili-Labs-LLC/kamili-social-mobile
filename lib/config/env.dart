class Env {
  Env._();

  static const String graphqlEndpoint = String.fromEnvironment(
    'GRAPHQL_ENDPOINT',
    defaultValue: 'http://localhost:4001/graphql',
  );

  static String get apiBaseUrl => graphqlEndpoint.replaceAll('/graphql', '');
  static String get mediaUploadUrl => '$apiBaseUrl/api/media/upload';
  static String get mediaUrl => '$apiBaseUrl/api/media';
  static String get aiGenerateUrl => '$apiBaseUrl/api/ai/generate';
  static String get aiTonesUrl => '$apiBaseUrl/api/ai/tones';
  static String get aiHistoryUrl => '$apiBaseUrl/api/ai/history';
  static String get aiProvidersUrl => '$apiBaseUrl/api/ai/providers';
  static String get aiSuggestUrl => '$apiBaseUrl/api/ai-suggest/variations';
  static String get oauthBaseUrl => '$apiBaseUrl/api/oauth';

  static const String oauthCallbackScheme = 'kamilisocial';
}
