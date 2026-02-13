/// Base failure class for all application failures.
/// Provides centralized error handling throughout the app.
abstract class Failure {
  final String message;
  final String? code;
  final DateTime timestamp;

  Failure({required this.message, this.code, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

/// Network-related failures (no internet, timeout, etc.)
class NetworkFailure extends Failure {
  NetworkFailure({
    super.message =
        'Network connection failed. Please check your internet connection.',
    super.code = 'NETWORK_ERROR',
  });
}

/// Server-side failures (500, 502, 503, etc.)
class ServerFailure extends Failure {
  final int? statusCode;

  ServerFailure({
    super.message = 'Server error occurred. Please try again later.',
    super.code = 'SERVER_ERROR',
    this.statusCode,
  });
}

/// Authentication failures (401, 403)
class AuthenticationFailure extends Failure {
  AuthenticationFailure({
    super.message = 'Authentication failed. Please login again.',
    super.code = 'AUTH_ERROR',
  });
}

/// Validation failures (invalid input, format errors)
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  ValidationFailure({
    super.message = 'Invalid input provided.',
    super.code = 'VALIDATION_ERROR',
    this.fieldErrors,
  });
}

/// Cache-related failures (read/write errors)
class CacheFailure extends Failure {
  CacheFailure({
    super.message = 'Local storage error occurred.',
    super.code = 'CACHE_ERROR',
  });
}

/// Audio processing failures
class AudioProcessingFailure extends Failure {
  AudioProcessingFailure({
    super.message = 'Audio processing failed. Please try again.',
    super.code = 'AUDIO_PROCESSING_ERROR',
  });
}

/// Voice synthesis failures (ElevenLabs API errors)
class VoiceSynthesisFailure extends Failure {
  VoiceSynthesisFailure({
    super.message = 'Voice synthesis failed. Please try again.',
    super.code = 'VOICE_SYNTHESIS_ERROR',
  });
}

/// Rate limit failures (API quota exceeded)
class RateLimitFailure extends Failure {
  final Duration? retryAfter;

  RateLimitFailure({
    super.message = 'Rate limit exceeded. Please wait before trying again.',
    super.code = 'RATE_LIMIT_ERROR',
    this.retryAfter,
  });
}

/// Unknown/unexpected failures
class UnknownFailure extends Failure {
  final Object? originalError;
  final StackTrace? stackTrace;

  UnknownFailure({
    super.message = 'An unexpected error occurred.',
    super.code = 'UNKNOWN_ERROR',
    this.originalError,
    this.stackTrace,
  });
}

/// Permission failures (microphone, storage, etc.)
class PermissionFailure extends Failure {
  final String permissionType;

  PermissionFailure({
    super.message = 'Permission denied.',
    super.code = 'PERMISSION_ERROR',
    required this.permissionType,
  });
}
