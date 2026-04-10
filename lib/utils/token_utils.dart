import 'package:jwt_decoder/jwt_decoder.dart';

class TokenUtils {
  TokenUtils._();

  /// Returns true if the token is expired or invalid.
  static bool isTokenExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (_) {
      return true;
    }
  }

  /// Returns the expiration DateTime of the token.
  /// Returns DateTime(0) if the token is invalid or has no exp claim.
  static DateTime getTokenExpiration(String token) {
    try {
      return JwtDecoder.getExpirationDate(token);
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }
}
