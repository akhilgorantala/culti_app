import 'package:culti_app/core/utils/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/dio/dio_client.dart';
import '../model/api_response.dart';

class AuthRepository {
  final SharedPreferences sharedPreferences;
  final DioClient dioClient;

  AuthRepository({required this.sharedPreferences, required this.dioClient});

  Future<ApiResponse> login(String userName, String password) async {
    try {
      var data = FormData.fromMap({'username': userName, 'password': password});
      Response response = await dioClient.post(
        AppConstants.LOGIN,
        data: data,
      );
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(e.response);
    } catch (e) {
      return ApiResponse.withError(e.toString());
    }
  }
}
