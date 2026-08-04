import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:veegil_pay/core/network/dio_provider.dart';
import 'package:veegil_pay/features/deposit/model/deposit_request.dart';
import 'package:veegil_pay/features/transaction/data/transaction_api.dart';
import 'package:veegil_pay/features/transaction/data/transaction_repository.dart';

final transactionRepositoryProvider =
    Provider<TransactionRepository>((ref) {
  final dio = ref.read(dioClientProvider);

  return TransactionRepository(
    TransactionApi(dio),
  );
});

class TransactionNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> deposit(DepositRequest request) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(transactionRepositoryProvider);

      await repository.deposit(
        request,
        const Uuid().v4(),
      );

      state = const AsyncData(null);

      return true;
    } catch (e, s) {
      state = AsyncError(e, s);
      return false;
    }
  }
}

final transactionProvider =
    AsyncNotifierProvider<TransactionNotifier, void>(
  TransactionNotifier.new,
);