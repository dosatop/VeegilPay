import 'package:flutter_riverpod/legacy.dart';
import 'package:veegil_pay/core/network/dio_provider.dart';
import 'package:veegil_pay/core/storage/secure_storage_service.dart';
import 'package:veegil_pay/features/auth/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) {
  return null;
});

final balanceVisibilityProvider =
    StateNotifierProvider<BalanceVisibilityNotifier, bool>((ref) {
      return BalanceVisibilityNotifier(ref.read(secureStorageProvider));
    });

class BalanceVisibilityNotifier extends StateNotifier<bool> {
  final SecureStorageService storage;

  BalanceVisibilityNotifier(this.storage) : super(true) {
    _load();
  }

  Future<void> _load() async {
    final saved = await storage.getBalanceVisibility();

    if (saved != null) {
      state = saved;
    }
  }

  Future<void> toggle() async {
    state = !state;

    await storage.saveBalanceVisibility(state);
  }
}
