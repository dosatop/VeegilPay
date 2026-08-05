import 'package:veegil_pay/features/auth/models/signup_request.dart';
import 'package:veegil_pay/features/auth/models/user_response.dart';

import '../../../core/storage/secure_storage_service.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import 'auth_api.dart';

class AuthRepository {
  final AuthApi authApi;
  final SecureStorageService storage;

  AuthRepository({required this.authApi, required this.storage});

  Future<LogInResponse> login(LogInRequest request) async {
    final response = await authApi.login(request);

    await _saveAuthData(response);

    return response;
  }

  Future<LogInResponse> signup(SignupRequest request) async {
    final response = await authApi.signup(request);

    await _saveAuthData(response);

    return response;
  }

  Future<void> _saveAuthData(LogInResponse response) async {
    await storage.saveToken(response.token);

    await storage.saveAccountNumber(response.user.phoneNumber);
  }

  Future<UserResponse> getUser() async {
    return await authApi.getUser();
  }

  Future<void> logout() async {
    await storage.clear();
  }
}
