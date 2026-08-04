import 'package:veegil_pay/features/auth/models/signup_request.dart';

import '../../../core/network/dio_client.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class AuthApi {
  final DioClient dioClient;

  AuthApi(this.dioClient);

  Future<LogInResponse> signup(SignupRequest request) async {
    final response = await dioClient.dio.post(
      '/auth/signup',
      data: request.toJson(),
    );

    return LogInResponse.fromJson(response.data);
  }

  Future<LogInResponse> login(LogInRequest request) async {
    final response = await dioClient.dio.post(
      '/auth/login',
      data: request.toJson(),
    );

    return LogInResponse.fromJson(response.data);
  }

  Future<LogInResponse> getUser() async {
    final response = await dioClient.dio.get('/auth/me');

    return LogInResponse.fromJson(response.data);
  }
}
