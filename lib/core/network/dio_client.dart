import 'package:dio/dio.dart';
import 'package:veegil_pay/core/storage/secure_storage_service.dart';

import '../constants/api_constants.dart';
import '../utils/app_logger.dart';

class DioClient {
  final SecureStorageService secureStorage;

  late final Dio dio;

  DioClient(this.secureStorage) {
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

        onError: (error, handler) {
          AppLogger.logger.e('''
              ERROR
              ${error.message}
              ${error.requestOptions.uri}
              Response: ${error.response?.data}
            ''');

          return handler.next(error);
        },
      ),
    );
  }
}
