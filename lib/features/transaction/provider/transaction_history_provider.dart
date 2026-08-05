import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../data/transaction_api.dart';
import '../data/transaction_repository.dart';
import '../model/transaction_model.dart';

final transactionHistoryRepositoryProvider = Provider<TransactionRepository>((
  ref,
) {
  final dio = ref.read(dioClientProvider);

  return TransactionRepository(TransactionApi(dio));
});

final transactionHistoryProvider =
    AsyncNotifierProvider<TransactionHistoryNotifier, List<TransactionModel>>(
      TransactionHistoryNotifier.new,
    );

class TransactionHistoryNotifier extends AsyncNotifier<List<TransactionModel>> {
  @override
  Future<List<TransactionModel>> build() async {
    final repository = ref.read(transactionHistoryRepositoryProvider);

    return repository.getTransactions();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(transactionHistoryRepositoryProvider);

      final transactions = await repository.getTransactions();

      state = AsyncData(transactions);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}
