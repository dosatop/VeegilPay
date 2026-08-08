import 'package:dio/dio.dart';
import 'package:veegil_pay/core/errors/api_error_handler.dart';
import 'package:veegil_pay/core/errors/app_exception.dart';
import 'package:veegil_pay/features/auth/models/signup_request.dart';
import 'package:veegil_pay/features/auth/models/user_response.dart';

import '../../../core/network/dio_client.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class AuthApi {
  final DioClient dioClient;

  AuthApi(this.dioClient);

  Future<LogInResponse> signup(SignupRequest request) async {
    try {
      final response = await dioClient.dio.post(
        '/auth/signup',
        data: request.toJson(),
      );

      return LogInResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw AppException(ApiErrorHandler.getCode(error));
    }
  }

  Future<LogInResponse> login(LogInRequest request) async {
    try {
      final response = await dioClient.dio.post(
        '/auth/login',
        data: request.toJson(),
      );

      return LogInResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw AppException(ApiErrorHandler.getCode(error));
    }
  }

  Future<UserResponse> getUser() async {
    try {
      final response = await dioClient.dio.get('/auth/me');

      return UserResponse.fromJson(response.data);
    } on DioException catch (error) {
      throw AppException(ApiErrorHandler.getCode(error));
    }
  }
}
