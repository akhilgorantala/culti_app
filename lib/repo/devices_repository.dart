import 'package:culti_app/core/network/dio/dio_client.dart';
import 'package:culti_app/core/utils/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/api_response.dart';

class DevicesRepository {
  final SharedPreferences sharedPreferences;
  final DioClient dioClient;

  DevicesRepository({required this.sharedPreferences, required this.dioClient});

  Future<ApiResponse> getDevices() async {
    try {
      Response response = await dioClient.get(
        AppConstants.URL_GET_POST_DEVICES + AppConstants.GET_DEVICES,
        useAuth: true,
      );
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(e.response);
    } catch (e) {
      return ApiResponse.withError(e.toString());
    }
  }

  Future<ApiResponse> addDevice(String deviceName, macAddress) async {
    try {
      Response response = await dioClient.post(
        '${AppConstants.URL_GET_POST_DEVICES}${AppConstants.ADD_DEVICES}?device_name=$deviceName&mac_address=$macAddress',
        useAuth: true,
      );
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(e.response);
    } catch (e) {
      return ApiResponse.withError(e.toString());
    }
  }
}
