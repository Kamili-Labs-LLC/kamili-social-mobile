import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/account.dart';
import '../services/auth_service.dart';
import '../services/secure_storage_service.dart';
import '../config/constants.dart';
import '../utils/token_utils.dart';

// Auth states
sealed class AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final Account account;
  Authenticated(this.account);
}

class Unauthenticated extends AuthState {}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final SecureStorageService _storage;
  StreamSubscription<void>? _logoutSubscription;

  AuthNotifier(this._authService, this._storage) : super(AuthLoading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final accessToken = await _storage.read(AppConstants.accessTokenKey);
      final refreshToken = await _storage.read(AppConstants.refreshTokenKey);
      final accountJson = await _storage.read(AppConstants.accountKey);

      if (accessToken == null || refreshToken == null || accountJson == null) {
        state = Unauthenticated();
        return;
      }

      if (TokenUtils.isTokenExpired(accessToken)) {
        if (TokenUtils.isTokenExpired(refreshToken)) {
          await _storage.deleteAll();
          state = Unauthenticated();
          return;
        }
        final refreshed = await _authService.refreshTokens();
        if (!refreshed) {
          await _storage.deleteAll();
          state = Unauthenticated();
          return;
        }
      }

      final account = await _authService.validateSession();
      if (account != null) {
        state = Authenticated(account);
      } else {
        await _storage.deleteAll();
        state = Unauthenticated();
      }
    } catch (e) {
      await _storage.deleteAll();
      state = Unauthenticated();
    }
  }

  Future<void> login(String email, String password) async {
    state = AuthLoading();
    try {
      final account = await _authService.signIn(email, password);
      state = Authenticated(account);
    } catch (e) {
      state = Unauthenticated();
      rethrow;
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String plan,
  ) async {
    state = AuthLoading();
    try {
      final account = await _authService.signUp(name, email, password, plan);
      state = Authenticated(account);
    } catch (e) {
      state = Unauthenticated();
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.signOut();
    } catch (_) {
      // Continue logout even if API call fails
    }
    await _storage.deleteAll();
    state = Unauthenticated();
  }

  Future<bool> refreshTokens() async {
    try {
      return await _authService.refreshTokens();
    } catch (e) {
      await logout();
      return false;
    }
  }

  void listenToLogout(Stream<void> logoutStream) {
    _logoutSubscription?.cancel();
    _logoutSubscription = logoutStream.listen((_) {
      _storage.deleteAll();
      state = Unauthenticated();
    });
  }

  @override
  void dispose() {
    _logoutSubscription?.cancel();
    super.dispose();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthNotifier(authService, storage);
});
