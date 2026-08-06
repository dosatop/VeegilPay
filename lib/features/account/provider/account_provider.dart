import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:veegil_pay/features/transfer/models/directory_user.dart';

import '../../../core/network/dio_provider.dart';
import '../data/account_api.dart';

final accountApiProvider = Provider<AccountApi>((ref) {
  final dioClient = ref.read(dioClientProvider);

  return AccountApi(dioClient);
});

final accountUsersProvider =
    StateNotifierProvider<AccountUsersNotifier, List<DirectoryUser>>((ref) {
      return AccountUsersNotifier(ref.read(accountApiProvider));
    });

class AccountUsersNotifier extends StateNotifier<List<DirectoryUser>> {
  final AccountApi api;

  AccountUsersNotifier(this.api) : super([]);

  Future<void> loadUsers() async {
    try {
      final users = await api.getUsers();

      state = users;
    } catch (e) {
      state = [];
    }
  }
}
