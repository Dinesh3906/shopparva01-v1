import 'dart:async';

import 'package:dio/dio.dart';

import '../../core/constants.dart';

class ApiClient {
  ApiClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppConstants.apiBaseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        ) {
    _dio.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
      _RetryInterceptor(_dio),
    ]);
  }

  final Dio _dio;

  Dio get dio => _dio;
}

class _RetryInterceptor extends Interceptor {
  _RetryInterceptor(this._dio);

  final Dio _dio;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // Simple one-shot retry for idempotent GETs.
    if (err.requestOptions.method.toUpperCase() == 'GET' &&
        err.requestOptions.extra['retried'] != true) {
      final options = err.requestOptions..extra['retried'] = true;
      try {
        final response = await _dio.fetch(options);
        return handler.resolve(response);
      } catch (_) {
        // Fall through to default error handling below.
      }
    }
    return handler.next(err);
  }
}
