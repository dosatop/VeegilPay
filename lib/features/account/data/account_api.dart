import 'package:dio/dio.dart';
import 'package:veegil_pay/core/errors/api_error_handler.dart';
import 'package:veegil_pay/core/errors/app_exception.dart';
import 'package:veegil_pay/core/network/dio_client.dart';
import 'package:veegil_pay/features/transfer/models/directory_user.dart';

class AccountApi {
  final DioClient dioClient;

  AccountApi(this.dioClient);


  Future<List<DirectoryUser>> getUsers() async {
    try {
      final response = await dioClient.dio.get(
        '/auth/users',
      );


      final List data = response.data['data'];


      return data
          .map(
            (json) => DirectoryUser.fromJson(json),
          )
          .toList();


    } on DioException catch (e) {
      throw AppException(
        ApiErrorHandler.getCode(e),
      );
    }
  }
}