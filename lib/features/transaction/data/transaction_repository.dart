import 'package:veegil_pay/features/deposit/model/deposit_request.dart';
import 'package:veegil_pay/features/transaction/data/transaction_api.dart';
import 'package:veegil_pay/features/transaction/model/transaction_model.dart';
import 'package:veegil_pay/features/transfer/models/transfer_request.dart';
import 'package:veegil_pay/features/withdraw/model/withdraw_request.dart';

class TransactionRepository {
  final TransactionApi api;

  TransactionRepository(this.api);

  Future<void> deposit(DepositRequest request, String idempotencyKey) {
    return api.deposit(request, idempotencyKey);
  }

  Future<void> withdraw(WithdrawRequest request, String idempotencyKey) {
    return api.withdraw(request, idempotencyKey);
  }

  Future<void> transfer(TransferRequest request, String key) async {
    await api.transfer(request, key);
  }

  Future<List<TransactionModel>> getTransactions() async {
    final response = await api.getTransactions();

    return response.map((item) => TransactionModel.fromJson(item)).toList();
  }
}
