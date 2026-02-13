import 'package:dio/dio.dart';

/// Interceptor for automatic retry on specific failures.
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final shouldRetry = _shouldRetry(err);
    final retryCount = _getRetryCount(err.requestOptions);

    if (shouldRetry && retryCount < maxRetries) {
      await Future.delayed(retryDelay * (retryCount + 1));

      try {
        final options = err.requestOptions;
        options.extra['retryCount'] = retryCount + 1;

        final response = await dio.fetch(options);
        return handler.resolve(response);
      } on DioException catch (e) {
        return super.onError(e, handler);
      }
    }

    return super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null &&
            err.response!.statusCode! >= 500 &&
            err.response!.statusCode! < 600);
  }

  int _getRetryCount(RequestOptions options) {
    return options.extra['retryCount'] as int? ?? 0;
  }
}
