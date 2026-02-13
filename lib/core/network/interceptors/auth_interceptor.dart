import 'dart:io';

import 'package:dio/dio.dart';

/// Interceptor for handling authentication headers.
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add any default headers or modify request before sending
    options.headers.putIfAbsent(
      HttpHeaders.acceptLanguageHeader,
      () => 'en-US',
    );

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 errors globally (e.g., token refresh or logout)
    if (err.response?.statusCode == 401) {
      // Token expired - could trigger logout or token refresh here
      // For now, just pass the error along
    }

    super.onError(err, handler);
  }
}
