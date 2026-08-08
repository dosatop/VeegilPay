import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:veegil_pay/core/errors/app_exception.dart';
import 'package:veegil_pay/core/network/dio_provider.dart';
import 'package:veegil_pay/features/deposit/model/deposit_request.dart';
import 'package:veegil_pay/features/transfer/models/transfer_request.dart';
import 'package:veegil_pay/features/withdraw/model/withdraw_request.dart';
import 'package:veegil_pay/features/transaction/data/transaction_api.dart';
import 'package:veegil_pay/features/transaction/data/transaction_repository.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final dio = ref.read(dioClientProvider);

  return TransactionRepository(TransactionApi(dio));
});

class TransactionNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> deposit(DepositRequest request) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(transactionRepositoryProvider);

      await repository.deposit(request, const Uuid().v4());

      state = const AsyncData(null);

      return true;
    } catch (e, s) {
      state = AsyncError(e, s);

      return false;
    }
  }

  Future<bool> withdraw(WithdrawRequest request) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(transactionRepositoryProvider);

      await repository.withdraw(request, const Uuid().v4());

      state = const AsyncData(null);

      return true;
    } catch (e, s) {
      state = AsyncError(e, s);

      return false;
    }
  }

  Future<String?> transfer(TransferRequest request) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(transactionRepositoryProvider);

      await repository.transfer(request, const Uuid().v4());

      state = const AsyncData(null);

      return null;
    } on AppException catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return e.code;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);

      return "TRANSFER_FAILED";
    }
  }
}

final transactionProvider = AsyncNotifierProvider<TransactionNotifier, void>(
  TransactionNotifier.new,
);
