import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:kamili_social/config/constants.dart';
import 'package:kamili_social/config/env.dart';
import 'package:kamili_social/graphql/client.dart';
import 'package:kamili_social/graphql/mutations/auth_mutations.dart';
import 'package:kamili_social/graphql/queries/account_queries.dart';
import 'package:kamili_social/models/account.dart';
import 'package:kamili_social/models/error_response.dart';
import 'package:kamili_social/services/secure_storage_service.dart';
import 'package:kamili_social/utils/token_utils.dart';

class AuthService {
  final GraphQLClientService _graphQLClientService;
  final SecureStorageService _storage;

  AuthService({
    GraphQLClientService? graphQLClientService,
    SecureStorageService? storage,
  })  : _graphQLClientService =
            graphQLClientService ?? GraphQLClientService.instance,
        _storage = storage ?? SecureStorageService.instance;

  GraphQLClient get _client => _graphQLClientService.client.value;

  /// Signs in with email and password. Returns the Account on success.
  Future<Account> signIn(String email, String password) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(signInMutation),
        variables: {
          'data': {
            'email': email,
            'password': password,
          },
        },
      ),
    );

    if (result.hasException) {
      throw _handleGraphQLException(result.exception!);
    }

    final data = result.data!['signIn'] as Map<String, dynamic>;

    if (data['__typename'] == 'Error') {
      throw AuthException(
        data['errorCode'] as int,
        data['message'] as String,
      );
    }

    final accessToken = data['accessToken'] as String;
    final refreshToken = data['refreshToken'] as String;
    final accountData = data['account'] as Map<String, dynamic>;
    final account = Account.fromJson(accountData);

    await _storage.write(AppConstants.accessTokenKey, accessToken);
    await _storage.write(AppConstants.refreshTokenKey, refreshToken);
    await _storage.write(AppConstants.accountKey, jsonEncode(account.toJson()));

    return account;
  }

  /// Signs up a new account. Returns the Account on success.
  Future<Account> signUp(
    String name,
    String email,
    String password,
    String plan,
  ) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(signUpMutation),
        variables: {
          'data': {
            'name': name,
            'email': email,
            'password': password,
            'plan': plan,
          },
        },
      ),
    );

    if (result.hasException) {
      throw _handleGraphQLException(result.exception!);
    }

    final data = result.data!['signUp'] as Map<String, dynamic>;

    if (data['__typename'] == 'Error') {
      throw AuthException(
        data['errorCode'] as int,
        data['message'] as String,
      );
    }

    final accessToken = data['accessToken'] as String;
    final refreshToken = data['refreshToken'] as String;
    final accountData = data['account'] as Map<String, dynamic>;
    final account = Account.fromJson(accountData);

    await _storage.write(AppConstants.accessTokenKey, accessToken);
    await _storage.write(AppConstants.refreshTokenKey, refreshToken);
    await _storage.write(AppConstants.accountKey, jsonEncode(account.toJson()));

    return account;
  }

  /// Signs out the current user. Clears all stored tokens.
  Future<void> signOut() async {
    final refreshToken =
        await _storage.read(AppConstants.refreshTokenKey);

    try {
      await _client.mutate(
        MutationOptions(
          document: gql(signOutMutation),
          variables: {
            'data': {
              'refreshToken': refreshToken ?? '',
            },
          },
        ),
      );
    } catch (e) {
      debugPrint('Sign out mutation failed: $e');
    }

    await _storage.delete(AppConstants.accessTokenKey);
    await _storage.delete(AppConstants.refreshTokenKey);
    await _storage.delete(AppConstants.accountKey);
  }

  /// Refreshes the access and refresh tokens. Returns true on success.
  /// Uses a raw HTTP call to bypass the GraphQL link chain, which would
  /// attach the (expired) access token instead of the refresh token.
  Future<bool> refreshTokens() async {
    try {
      final refreshToken =
          await _storage.read(AppConstants.refreshTokenKey);

      if (refreshToken == null || TokenUtils.isTokenExpired(refreshToken)) {
        return false;
      }

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

      if (response.statusCode != 200) return false;

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) return false;

      final result = data['refreshToken'] as Map<String, dynamic>?;
      if (result == null) return false;

      if (result['__typename'] == 'Error') return false;

      final newAccessToken = result['accessToken'] as String?;
      final newRefreshToken = result['refreshToken'] as String?;

      if (newAccessToken == null || newRefreshToken == null) return false;

      await _storage.write(AppConstants.accessTokenKey, newAccessToken);
      await _storage.write(AppConstants.refreshTokenKey, newRefreshToken);

      return true;
    } catch (e) {
      debugPrint('Token refresh failed: $e');
      return false;
    }
  }

  /// Sends a forgot password email. Returns the server message.
  Future<String> forgotPassword(String email) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(forgotPasswordMutation),
        variables: {
          'data': {
            'email': email,
          },
        },
      ),
    );

    if (result.hasException) {
      throw _handleGraphQLException(result.exception!);
    }

    final data = result.data!['forgotPassword'] as Map<String, dynamic>;

    if (data['__typename'] == 'Error') {
      throw AuthException(
        data['errorCode'] as int,
        data['message'] as String,
      );
    }

    return data['message'] as String;
  }

  /// Resets password with the given token. Returns the server message.
  Future<String> resetPassword(
    String token,
    String password,
    String confirmPassword,
  ) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(resetPasswordMutation),
        variables: {
          'data': {
            'token': token,
            'password': password,
            'confirmPassword': confirmPassword,
          },
        },
      ),
    );

    if (result.hasException) {
      throw _handleGraphQLException(result.exception!);
    }

    final data = result.data!['resetPassword'] as Map<String, dynamic>;

    if (data['__typename'] == 'Error') {
      throw AuthException(
        data['errorCode'] as int,
        data['message'] as String,
      );
    }

    return data['message'] as String;
  }

  /// Returns the stored Account from secure storage, or null if not found.
  Future<Account?> getStoredAccount() async {
    final accountJson =
        await _storage.read(AppConstants.accountKey);
    if (accountJson == null) return null;

    try {
      final json = jsonDecode(accountJson) as Map<String, dynamic>;
      return Account.fromJson(json);
    } catch (e) {
      debugPrint('Failed to parse stored account: $e');
      return null;
    }
  }

  /// Checks if the user is authenticated (tokens exist and are not expired).
  Future<bool> isAuthenticated() async {
    final accessToken =
        await _storage.read(AppConstants.accessTokenKey);
    final refreshToken =
        await _storage.read(AppConstants.refreshTokenKey);

    if (accessToken == null || refreshToken == null) return false;

    // If access token is valid, user is authenticated
    if (!TokenUtils.isTokenExpired(accessToken)) return true;

    // If access token expired but refresh token is still valid,
    // the user is still considered authenticated (token will refresh)
    if (!TokenUtils.isTokenExpired(refreshToken)) return true;

    return false;
  }

  /// Validates the current session by calling getAccount.
  /// Returns the Account if valid, null otherwise.
  Future<Account?> validateSession() async {
    try {
      final result = await _client.query(
        QueryOptions(
          document: gql(getAccountQuery),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) return null;

      final data = result.data?['getAccount'] as Map<String, dynamic>?;
      if (data == null) return null;

      if (data['__typename'] == 'Error') return null;

      final accountData = data['account'] as Map<String, dynamic>;
      final account = Account.fromJson(accountData);

      // Update stored account with latest data
      await _storage.write(
          AppConstants.accountKey, jsonEncode(account.toJson()));

      return account;
    } catch (e) {
      debugPrint('Session validation failed: $e');
      return null;
    }
  }

  Exception _handleGraphQLException(OperationException exception) {
    final graphqlErrors = exception.graphqlErrors;
    if (graphqlErrors.isNotEmpty) {
      final error = graphqlErrors.first;
      final code = error.extensions?['code'];
      if (code == 'UNAUTHENTICATED') {
        return const AuthException(401, 'Unauthenticated');
      }
      return AuthException(400, error.message);
    }

    if (exception.linkException != null) {
      return AuthException(
          500, 'Network error: ${exception.linkException.toString()}');
    }

    return const AuthException(500, 'An unexpected error occurred');
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});
