import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veegil_pay/core/errors/app_exception.dart';
import 'package:veegil_pay/features/auth/models/signup_request.dart';
import 'package:veegil_pay/features/dashboard/provider/dashboard_provider.dart';
import '../../../core/network/dio_provider.dart';
import '../data/auth_api.dart';
import '../data/auth_repository.dart';
import '../models/login_request.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dioClient = ref.read(dioClientProvider);

  final authApi = AuthApi(dioClient);

  final storage = ref.read(secureStorageProvider);

  return AuthRepository(authApi: authApi, storage: storage);
});

class AuthNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> login(LogInRequest request) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(authRepositoryProvider);

      final response = await repository.login(request);

      ref.read(userProvider.notifier).state = response.user;

      state = const AsyncData(null);

      return null;
    } catch (error, stackTrace) {
    
      state = AsyncError(error, stackTrace);

      if (error is DioException) {
        if (error.type == DioExceptionType.connectionError ||
            error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout) {
          return "NETWORK_ERROR";
        }
      }

      if (error is AppException) {
        return error.code;
      }

      return "UNKNOWN_ERROR";
    }
  }

  Future<String?> signup(SignupRequest request) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(authRepositoryProvider);

      final response = await repository.signup(request);

      ref.read(userProvider.notifier).state = response.user;

      state = const AsyncData(null);

      return null;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);

      if (error is DioException && error.error == "NETWORK_ERROR") {
        return "NETWORK_ERROR";
      }

      if (error is AppException) {
        return error.code;
      }

      return "SIGNUP_FAILED";
    }
  }

  Future<bool> refreshUser() async {
    try {
      final repository = ref.read(authRepositoryProvider);

      final response = await repository.getUser();

      ref.read(userProvider.notifier).state = response.user;

      return true;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return false;
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(authRepositoryProvider);

      await repository.logout();

      ref.read(userProvider.notifier).state = null;

      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, void>(
  AuthNotifier.new,
);
