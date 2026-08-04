import 'package:veegil_pay/features/deposit/model/deposit_request.dart';
import 'package:veegil_pay/features/transaction/data/transaction_api.dart';

class TransactionRepository {
  final TransactionApi api;

  TransactionRepository(this.api);

  Future<void> deposit(
    DepositRequest request,
    String idempotencyKey,
  ) {
    return api.deposit(request, idempotencyKey);
  }
}