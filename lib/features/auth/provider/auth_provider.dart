import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  Future<bool> login(LogInRequest request) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(authRepositoryProvider);

      final response = await repository.login(request);

      ref.read(userProvider.notifier).state = response.user;

      state = const AsyncData(null);

      return true;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);

      return false;
    }
  }

  Future<bool> signup(SignupRequest request) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(authRepositoryProvider);

      final response = await repository.signup(request);

      // Save user after signup
      ref.read(userProvider.notifier).state = response.user;

      state = const AsyncData(null);

      return true;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);

      return false;
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

      // Clear user
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
