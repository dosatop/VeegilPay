import 'package:dio/dio.dart';
import 'package:veegil_pay/core/constants/api_constants.dart';
import 'package:veegil_pay/core/errors/api_error_handler.dart';
import 'package:veegil_pay/core/errors/app_exception.dart';
import 'package:veegil_pay/core/network/dio_client.dart';
import 'package:veegil_pay/features/deposit/model/deposit_request.dart';
import 'package:veegil_pay/features/transfer/models/transfer_request.dart';
import 'package:veegil_pay/features/withdraw/model/withdraw_request.dart';
class TransactionApi {
  final DioClient dioClient;

  TransactionApi(this.dioClient);

  Future<void> deposit(
    DepositRequest request,
    String idempotencyKey,
  ) async {
    try {
      await dioClient.dio.post(
        "/accounts/deposit",
        data: request.toJson(),
        options: Options(
          headers: {
            ApiConstants.idempotencyKey: idempotencyKey,
          },
        ),
      );
    } on DioException catch (e) {
      throw AppException(
        ApiErrorHandler.getCode(e),
      );
    }
  }


  Future<void> withdraw(
    WithdrawRequest request,
    String idempotencyKey,
  ) async {
    try {
      await dioClient.dio.post(
        '/accounts/withdraw',
        data: request.toJson(),
        options: Options(
          headers: {
            ApiConstants.idempotencyKey: idempotencyKey,
          },
        ),
      );
    } on DioException catch (e) {
      throw AppException(
        ApiErrorHandler.getCode(e),
      );
    }
  }


  Future<void> transfer(
    TransferRequest request,
    String idempotencyKey,
  ) async {
    try {
      await dioClient.dio.post(
        '/accounts/transfer',
        data: request.toJson(),
        options: Options(
          headers: {
            ApiConstants.idempotencyKey: idempotencyKey,
          },
        ),
      );
    } on DioException catch (e) {
      throw AppException(
        ApiErrorHandler.getCode(e),
      );
    }
  }


  Future<List<dynamic>> getTransactions() async {
    try {
      final response = await dioClient.dio.get('/transactions');

      return response.data['data'];
    } on DioException catch (e) {
      throw AppException(
        ApiErrorHandler.getCode(e),
      );
    }
  }
}