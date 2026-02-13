import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';
import '../services/storage_service.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

/// Centralized HTTP client using Dio.
/// Handles all API communications with proper configuration and interceptors.
class DioClient {
  late final Dio _dio;
  final StorageService storageService;

  DioClient({required this.storageService}) {
    _dio = Dio(_baseOptions);
    _setupInterceptors();
  }

  /// Factory constructor for testing with custom Dio instance.
  @visibleForTesting
  DioClient.forTesting(Dio dio, {required this.storageService}) : _dio = dio;

  /// Base options for Dio configuration.
  BaseOptions get _baseOptions => BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: Duration(milliseconds: ApiConstants.connectTimeout),
    receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
    sendTimeout: Duration(milliseconds: ApiConstants.sendTimeout),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
    },
    validateStatus: (status) => status != null && status < 500,
    responseType: ResponseType.json,
  );

  /// Sets up request/response interceptors.
  void _setupInterceptors() {
    _dio.interceptors.addAll([
      _AuthInterceptor(storageService: storageService),
      RetryInterceptor(dio: _dio),
      if (kDebugMode) AppLoggingInterceptor(),
    ]);
  }

  /// The underlying Dio instance.
  Dio get dio => _dio;

  /// GET request.
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// POST request.
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// PUT request.
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// PATCH request.
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// DELETE request.
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Upload file with multipart form data.
  Future<Response<T>> uploadFile<T>(
    String path, {
    required String filePath,
    required String fileFieldName,
    Map<String, dynamic>? additionalData,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    final file = await MultipartFile.fromFile(
      filePath,
      filename: filePath.split('/').last,
    );

    final formData = FormData.fromMap({
      fileFieldName: file,
      if (additionalData != null) ...additionalData,
    });

    return _dio.post<T>(
      path,
      data: formData,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
  }

  /// Download file to specified path.
  Future<Response> downloadFile(
    String url,
    String savePath, {
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.download(
      url,
      savePath,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }
}

/// Auth interceptor that adds OpenAI API key from storage.
class _AuthInterceptor extends Interceptor {
  final StorageService storageService;

  _AuthInterceptor({required this.storageService});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final apiKey = storageService.getString(StorageKeys.apiKey);
    if (apiKey != null && apiKey.isNotEmpty) {
      options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiKey';
    }
    handler.next(options);
  }
}
