import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor for logging HTTP requests and responses in debug mode.
class AppLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      _logRequest(options);
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      _logResponse(response);
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      _logError(err);
    }
    super.onError(err, handler);
  }

  void _logRequest(RequestOptions options) {
    final buffer = StringBuffer();
    buffer.writeln(
      '╔══════════════════════════════════════════════════════════',
    );
    buffer.writeln('║ REQUEST');
    buffer.writeln(
      '╠══════════════════════════════════════════════════════════',
    );
    buffer.writeln('║ ${options.method.toUpperCase()} ${options.uri}');
    buffer.writeln(
      '╠══════════════════════════════════════════════════════════',
    );

    if (options.headers.isNotEmpty) {
      buffer.writeln('║ Headers:');
      options.headers.forEach((key, value) {
        if (key.toLowerCase() != 'authorization') {
          buffer.writeln('║   $key: $value');
        } else {
          buffer.writeln('║   $key: [HIDDEN]');
        }
      });
    }

    if (options.queryParameters.isNotEmpty) {
      buffer.writeln('║ Query Parameters:');
      options.queryParameters.forEach((key, value) {
        buffer.writeln('║   $key: $value');
      });
    }

    if (options.data != null) {
      buffer.writeln('║ Body: ${_formatData(options.data)}');
    }

    buffer.writeln(
      '╚══════════════════════════════════════════════════════════',
    );

    developer.log(buffer.toString(), name: 'HTTP');
  }

  void _logResponse(Response response) {
    final buffer = StringBuffer();
    buffer.writeln(
      '╔══════════════════════════════════════════════════════════',
    );
    buffer.writeln('║ RESPONSE');
    buffer.writeln(
      '╠══════════════════════════════════════════════════════════',
    );
    buffer.writeln('║ ${response.statusCode} ${response.requestOptions.uri}');
    buffer.writeln(
      '╠══════════════════════════════════════════════════════════',
    );
    buffer.writeln('║ Data: ${_formatData(response.data)}');
    buffer.writeln(
      '╚══════════════════════════════════════════════════════════',
    );

    developer.log(buffer.toString(), name: 'HTTP');
  }

  void _logError(DioException error) {
    final buffer = StringBuffer();
    buffer.writeln(
      '╔══════════════════════════════════════════════════════════',
    );
    buffer.writeln('║ ERROR');
    buffer.writeln(
      '╠══════════════════════════════════════════════════════════',
    );
    buffer.writeln('║ ${error.type.name}: ${error.message}');
    buffer.writeln(
      '║ ${error.requestOptions.method} ${error.requestOptions.uri}',
    );

    if (error.response != null) {
      buffer.writeln('║ Status: ${error.response?.statusCode}');
      buffer.writeln('║ Data: ${_formatData(error.response?.data)}');
    }

    buffer.writeln(
      '╚══════════════════════════════════════════════════════════',
    );

    developer.log(buffer.toString(), name: 'HTTP', level: 1000);
  }

  String _formatData(dynamic data) {
    if (data == null) return 'null';

    final str = data.toString();
    if (str.length > 500) {
      return '${str.substring(0, 500)}... [truncated]';
    }
    return str;
  }
}
