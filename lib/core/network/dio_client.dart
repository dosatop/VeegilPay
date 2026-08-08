import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:veegil_pay/core/storage/secure_storage_service.dart';

import '../constants/api_constants.dart';
import '../utils/app_logger.dart';

class DioClient {
  final SecureStorageService secureStorage;
  final VoidCallback onLogout;

  late final Dio dio;

  DioClient(this.secureStorage, this.onLogout) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),

        headers: {
          ApiConstants.accept: ApiConstants.applicationJson,
          ApiConstants.contentType: ApiConstants.applicationJson,
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await secureStorage.getToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          AppLogger.logger.i('''
              REQUEST
              ${options.method} ${options.uri}
              Headers: ${options.headers}
              Data: ${options.data}
            ''');

          return handler.next(options);
        },

        onResponse: (response, handler) {
          AppLogger.logger.i('''
              RESPONSE
              ${response.statusCode}
              ${response.requestOptions.uri}
              Data: ${response.data}
            ''');

          return handler.next(response);
        },

        onError: (error, handler) async {
          AppLogger.logger.e('''
              ERROR
              ${error.message}
              ${error.requestOptions.uri}
              Response: ${error.response?.data}
            ''');

          if (error.type == DioExceptionType.connectionError ||
              error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout) {
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                type: error.type,
                error: "NETWORK_ERROR",
                message: "No internet connection",
              ),
            );
          }

          if (error.response?.statusCode == 401 &&
              !error.requestOptions.path.contains('/auth/login')) {
            await secureStorage.clear();

            onLogout();
          }

          return handler.next(error);
        },
      ),
    );
  }
}
