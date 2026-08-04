import 'package:dio/dio.dart';
import 'package:veegil_pay/core/constants/api_constants.dart';
import 'package:veegil_pay/core/network/dio_client.dart';
import 'package:veegil_pay/features/deposit/model/deposit_request.dart';

class TransactionApi {
  final DioClient dioClient;

  TransactionApi(this.dioClient);

  Future<void> deposit(DepositRequest request, String idempotencyKey) async {
    await dioClient.dio.post(
      "/accounts/deposit",
      data: request.toJson(),
      options: Options(headers: {ApiConstants.idempotencyKey: idempotencyKey}),
    );
  }
}
