import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:kamili_social/config/constants.dart';
import 'package:kamili_social/config/env.dart';
import 'package:kamili_social/graphql/mutations/auth_mutations.dart';
import 'package:kamili_social/services/secure_storage_service.dart';
import 'package:kamili_social/utils/token_utils.dart';

class GraphQLClientService {
  GraphQLClientService._internal();

  static final GraphQLClientService _instance =
      GraphQLClientService._internal();

  factory GraphQLClientService() => _instance;

  static GraphQLClientService get instance => _instance;

  final SecureStorageService _storage = SecureStorageService.instance;

  final StreamController<void> _logoutController =
      StreamController<void>.broadcast();

  Stream<void> get onLogout => _logoutController.stream;

  bool _isRefreshing = false;

  late final ValueNotifier<GraphQLClient> _clientNotifier;
  bool _initialized = false;

  ValueNotifier<GraphQLClient> get client {
    if (!_initialized) {
      _initialize();
    }
    return _clientNotifier;
  }

  void _initialize() {
    _initialized = true;

    final httpLink = HttpLink(Env.graphqlEndpoint);

    final authLink = AuthLink(getToken: () async {
      final token =
          await _storage.read(AppConstants.accessTokenKey);
      if (token == null) return null;

      if (TokenUtils.isTokenExpired(token)) {
        final refreshed = await _handleTokenRefresh();
        if (!refreshed) return null;
        final newToken =
            await _storage.read(AppConstants.accessTokenKey);
        return newToken != null ? 'Bearer $newToken' : null;
      }

      return 'Bearer $token';
    });

    final responseCheckLink = _ResponseCheckLink(
      onUnauthorized: () => handleUnauthorized(),
    );

    final errorLink = ErrorLink(
      onGraphQLError: (request, forward, response) {
        final errors = response.errors;
        if (errors != null) {
          for (final error in errors) {
            final code = error.extensions?['code'];
            if (code == 'UNAUTHENTICATED') {
              handleUnauthorized();
              break;
            }
          }
        }
        return null;
      },
      onException: (request, forward, exception) {
        if (exception is ServerException) {
          final statusCode = exception.statusCode;
          if (statusCode == 401 || statusCode == 403) {
            handleUnauthorized();
          }
        }
        return null;
      },
    );

    // Link chain: errorLink -> responseCheckLink -> authLink -> httpLink
    final link = Link.from([
      errorLink,
      responseCheckLink,
      authLink,
      httpLink,
    ]);

    _clientNotifier = ValueNotifier(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );
  }

  Future<void> handleUnauthorized() async {
    if (_isRefreshing) return;

    final refreshed = await _handleTokenRefresh();
    if (!refreshed) {
      await _clearTokensAndLogout();
    }
  }

  Future<bool> _handleTokenRefresh() async {
    if (_isRefreshing) return false;
    _isRefreshing = true;

    try {
      final refreshToken =
          await _storage.read(AppConstants.refreshTokenKey);

      if (refreshToken == null || TokenUtils.isTokenExpired(refreshToken)) {
        return false;
      }

      // Make a raw HTTP call to avoid going through the link chain
      final response = await http.post(
        Uri.parse(Env.graphqlEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
        },
        body: jsonEncode({
          'query': refreshTokenMutation,
        }),
      );

      if (response.statusCode != 200) {
        return false;
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>?;

      if (data == null) return false;

      final result = data['refreshToken'] as Map<String, dynamic>?;
      if (result == null) return false;

      if (result['__typename'] == 'Error') {
        return false;
      }

      final newAccessToken = result['accessToken'] as String?;
      final newRefreshToken = result['refreshToken'] as String?;

      if (newAccessToken == null || newRefreshToken == null) {
        return false;
      }

      await _storage.write(AppConstants.accessTokenKey, newAccessToken);
      await _storage.write(AppConstants.refreshTokenKey, newRefreshToken);

      return true;
    } catch (e) {
      debugPrint('Token refresh failed: $e');
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _clearTokensAndLogout() async {
    await _storage.delete(AppConstants.accessTokenKey);
    await _storage.delete(AppConstants.refreshTokenKey);
    await _storage.delete(AppConstants.accountKey);
    _logoutController.add(null);
  }

  void dispose() {
    _logoutController.close();
  }
}

/// Custom link that inspects GraphQL response data for 401 error codes
/// embedded in union-type error responses.
class _ResponseCheckLink extends Link {
  final VoidCallback onUnauthorized;

  _ResponseCheckLink({required this.onUnauthorized});

  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    if (forward == null) {
      return const Stream.empty();
    }

    return forward(request).map((response) {
      _checkResponseForUnauthorized(response.data);
      return response;
    });
  }

  void _checkResponseForUnauthorized(Map<String, dynamic>? data) {
    if (data == null) return;

    for (final value in data.values) {
      if (value is Map<String, dynamic>) {
        final typename = value['__typename'];
        final errorCode = value['errorCode'];

        if (errorCode == 401) {
          onUnauthorized();
          return;
        }

        if (typename == 'Error' && errorCode == 401) {
          onUnauthorized();
          return;
        }
      }
    }
  }
}
