/// Base exception class for all application exceptions.
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  const AppException({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() => 'AppException(message: $message, code: $code)';
}

/// Network exception thrown when network operations fail.
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Network operation failed',
    super.code = 'NETWORK_EXCEPTION',
    super.originalException,
  });
}

/// Server exception thrown when server returns error response.
class ServerException extends AppException {
  final int? statusCode;
  final Map<String, dynamic>? responseBody;

  const ServerException({
    super.message = 'Server returned an error',
    super.code = 'SERVER_EXCEPTION',
    super.originalException,
    this.statusCode,
    this.responseBody,
  });
}

/// Cache exception thrown when local storage operations fail.
class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache operation failed',
    super.code = 'CACHE_EXCEPTION',
    super.originalException,
  });
}

/// Authentication exception thrown when auth operations fail.
class AuthenticationException extends AppException {
  const AuthenticationException({
    super.message = 'Authentication failed',
    super.code = 'AUTH_EXCEPTION',
    super.originalException,
  });
}

/// Audio exception thrown when audio processing fails.
class AudioException extends AppException {
  const AudioException({
    super.message = 'Audio processing failed',
    super.code = 'AUDIO_EXCEPTION',
    super.originalException,
  });
}

/// Voice synthesis exception for ElevenLabs API failures.
class VoiceSynthesisException extends AppException {
  const VoiceSynthesisException({
    super.message = 'Voice synthesis failed',
    super.code = 'VOICE_SYNTHESIS_EXCEPTION',
    super.originalException,
  });
}

/// Permission exception thrown when permissions are denied.
class PermissionException extends AppException {
  final String permissionType;

  const PermissionException({
    super.message = 'Permission denied',
    super.code = 'PERMISSION_EXCEPTION',
    super.originalException,
    required this.permissionType,
  });
}
