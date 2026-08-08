import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:veegil_pay/features/auth/provider/auth_provider.dart'
    show authProvider;
import 'package:veegil_pay/router/app_router.dart';

import '../storage/secure_storage_service.dart';
import 'dio_client.dart';

final secureStorageProvider = Provider((ref) {
  return SecureStorageService();
});

final routerProvider = Provider<GoRouter>((ref) {
  return appRouter(true);
});

final dioClientProvider = Provider((ref) {
  final storage = ref.read(secureStorageProvider);

  return DioClient(storage, () async {
    await ref.read(authProvider.notifier).logout();
    ref.read(routerProvider).go('/loginOrSignup');
  });
});
