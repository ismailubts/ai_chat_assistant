import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import 'exceptions.dart';
import 'failures.dart';

/// Centralized error handler for the entire application.
/// Maps exceptions to failures and provides user-friendly messages.
class ErrorHandler {
  const ErrorHandler._();

  /// Maps [DioException] to appropriate [Failure].
  static Failure handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkFailure(
          message: 'Connection timeout. Please check your internet connection.',
          code: 'CONNECTION_TIMEOUT',
        );

      case DioExceptionType.sendTimeout:
        return NetworkFailure(
          message: 'Request timeout. Please try again.',
          code: 'SEND_TIMEOUT',
        );

      case DioExceptionType.receiveTimeout:
        return NetworkFailure(
          message: 'Server response timeout. Please try again.',
          code: 'RECEIVE_TIMEOUT',
        );

      case DioExceptionType.badCertificate:
        return NetworkFailure(
          message: 'Security certificate error. Please contact support.',
          code: 'BAD_CERTIFICATE',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.cancel:
        return NetworkFailure(
          message: 'Request was cancelled.',
          code: 'REQUEST_CANCELLED',
        );

      case DioExceptionType.connectionError:
        return NetworkFailure(
          message: 'Unable to connect to server. Please check your connection.',
          code: 'CONNECTION_ERROR',
        );

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return NetworkFailure(
            message: 'No internet connection available.',
            code: 'NO_INTERNET',
          );
        }
        return UnknownFailure(
          message: 'An unexpected network error occurred.',
          originalError: error,
        );
    }
  }

  /// Handles HTTP error responses.
  static Failure _handleBadResponse(Response? response) {
    if (response == null) {
      return ServerFailure(
        message: 'Empty response from server.',
        code: 'EMPTY_RESPONSE',
      );
    }

    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    switch (statusCode) {
      case 400:
        return ValidationFailure(
          message: _extractErrorMessage(data) ?? 'Invalid request.',
          code: 'BAD_REQUEST',
        );

      case 401:
        return AuthenticationFailure(
          message: 'Session expired. Please login again.',
          code: 'UNAUTHORIZED',
        );

      case 403:
        return AuthenticationFailure(
          message: 'Access denied. You don\'t have permission.',
          code: 'FORBIDDEN',
        );

      case 404:
        return ServerFailure(
          message: 'Resource not found.',
          code: 'NOT_FOUND',
          statusCode: statusCode,
        );

      case 422:
        return ValidationFailure(
          message: _extractErrorMessage(data) ?? 'Validation failed.',
          code: 'UNPROCESSABLE_ENTITY',
          fieldErrors: _extractFieldErrors(data),
        );

      case 429:
        return RateLimitFailure(
          message: 'Too many requests. Please wait before trying again.',
          code: 'RATE_LIMIT_EXCEEDED',
          retryAfter: _extractRetryAfter(response),
        );

      case 500:
        return ServerFailure(
          message: 'Internal server error. Please try again later.',
          code: 'INTERNAL_SERVER_ERROR',
          statusCode: statusCode,
        );

      case 502:
        return ServerFailure(
          message: 'Bad gateway. Please try again later.',
          code: 'BAD_GATEWAY',
          statusCode: statusCode,
        );

      case 503:
        return ServerFailure(
          message: 'Service temporarily unavailable.',
          code: 'SERVICE_UNAVAILABLE',
          statusCode: statusCode,
        );

      default:
        return ServerFailure(
          message: 'Server error occurred.',
          code: 'HTTP_$statusCode',
          statusCode: statusCode,
        );
    }
  }

  /// Maps any exception to a [Failure].
  static Failure handleException(Object exception, [StackTrace? stackTrace]) {
    if (exception is DioException) {
      return handleDioError(exception);
    }

    if (exception is NetworkException) {
      return NetworkFailure(message: exception.message);
    }

    if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        statusCode: exception.statusCode,
      );
    }

    if (exception is CacheException) {
      return CacheFailure(message: exception.message);
    }

    if (exception is AuthenticationException) {
      return AuthenticationFailure(message: exception.message);
    }

    if (exception is AudioException) {
      return AudioProcessingFailure(message: exception.message);
    }

    if (exception is VoiceSynthesisException) {
      return VoiceSynthesisFailure(message: exception.message);
    }

    if (exception is PermissionException) {
      return PermissionFailure(
        message: exception.message,
        permissionType: exception.permissionType,
      );
    }

    if (exception is SocketException) {
      return NetworkFailure(
        message: 'No internet connection.',
        code: 'SOCKET_EXCEPTION',
      );
    }

    if (exception is TimeoutException) {
      return NetworkFailure(message: 'Request timed out.', code: 'TIMEOUT');
    }

    if (exception is FormatException) {
      return ValidationFailure(
        message: 'Invalid data format.',
        code: 'FORMAT_ERROR',
      );
    }

    return UnknownFailure(
      message: exception.toString(),
      originalError: exception,
      stackTrace: stackTrace,
    );
  }

  /// Extracts error message from response data.
  static String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['error_description'] as String?;
    }

    if (data is String) {
      return data;
    }

    return null;
  }

  /// Extracts field-specific errors from response data.
  static Map<String, String>? _extractFieldErrors(dynamic data) {
    if (data == null || data is! Map<String, dynamic>) return null;

    final errors = data['errors'];
    if (errors == null || errors is! Map<String, dynamic>) return null;

    return errors.map((key, value) {
      if (value is List && value.isNotEmpty) {
        return MapEntry(key, value.first.toString());
      }
      return MapEntry(key, value.toString());
    });
  }

  /// Extracts retry-after duration from response headers.
  static Duration? _extractRetryAfter(Response response) {
    final retryAfter = response.headers.value('retry-after');
    if (retryAfter == null) return null;

    final seconds = int.tryParse(retryAfter);
    if (seconds != null) {
      return Duration(seconds: seconds);
    }

    return null;
  }
}

/// Extension for easy failure message display.
extension FailureExtension on Failure {
  /// Returns a user-friendly message suitable for UI display.
  String get userMessage {
    if (message.isNotEmpty) return message;
    return 'Something went wrong. Please try again.';
  }

  /// Returns whether the error is recoverable by retry.
  bool get isRetryable {
    return this is NetworkFailure ||
        this is ServerFailure ||
        this is RateLimitFailure;
  }
}
