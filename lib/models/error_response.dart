class ErrorResponse {
  final int errorCode;
  final String message;

  const ErrorResponse({
    required this.errorCode,
    required this.message,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      errorCode: json['errorCode'] as int,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'errorCode': errorCode,
      'message': message,
    };
  }

  @override
  String toString() => 'ErrorResponse(errorCode: $errorCode, message: $message)';
}

class AuthException implements Exception {
  final int errorCode;
  final String message;

  const AuthException(this.errorCode, this.message);

  @override
  String toString() => 'AuthException(errorCode: $errorCode, message: $message)';
}
