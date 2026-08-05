import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veegil_pay/core/network/dio_provider.dart';
import 'package:veegil_pay/features/auth/models/saved_login_state.dart';

class SavedLoginNotifier extends Notifier<SavedLoginState> {
  @override
  SavedLoginState build() {
    return const SavedLoginState();
  }

  Future<void> loadSavedLogin() async {
    final storage = ref.read(secureStorageProvider);

    final loginInfo = await storage.getLoginInfo();

    if (loginInfo != null) {
      state = state.copyWith(phoneNumber: loginInfo.phoneNumber);
    }
  }

  void clearSavedLogin() async {
    final storage = ref.read(secureStorageProvider);

    await storage.clearLoginInfo();

    state = const SavedLoginState(phoneNumber: null);
  }
}

final savedLoginProvider =
    NotifierProvider<SavedLoginNotifier, SavedLoginState>(
      SavedLoginNotifier.new,
    );
