import 'package:culti_app/core/utils/app_constants.dart';
import 'package:culti_app/core/utils/utils.dart';
import 'package:culti_app/model/api_response.dart';
import 'package:culti_app/model/auth_response.dart';
import 'package:culti_app/model/token_auth_response.dart';
import 'package:esp_smartconfig/esp_smartconfig.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/dio/dio_client.dart';
import '../repo/auth_repository.dart';

class ConfigureProvider extends ChangeNotifier {
  final AuthRepository repository;
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  ConfigureProvider({
    required this.repository,
    required this.dioClient,
    required this.sharedPreferences,
  });

  final TextEditingController userName = TextEditingController();
  final TextEditingController userPassword = TextEditingController();

  bool? _isConfig;

  bool? get isConfig => _isConfig;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isDemo = false;

  bool get isDemo => _isDemo;

  Future<bool> startPro(String ssid, bssid, password) async {
    String? data = sharedPreferences.getString(AppConstants.USERNAME);

    bool isSuccess = false;

    final provisioner = Provisioner.espTouchV2();

    provisioner.listen((response) {
      print("Device ${response.bssidText} connected to WiFi!");
      _isConfig = true;
      isSuccess = true; // Update isSuccess to true on successful connection
      notifyListeners(); // Notify listeners about the change in isConfig state
    });

    try {
      await provisioner.start(ProvisioningRequest.fromStrings(
        ssid: ssid,
        bssid: bssid,
        password: password,
        encryptionKey: 'secret key aes!!',
        reservedData: data, //13 bytes
      ));

      // Wait for a specific duration for the provisioning process to complete
      await Future.delayed(const Duration(seconds: 30));

      if (!isSuccess) {
        // Check if provisioning was not successful
        print("Provisioning timeout or failed.");
        _isConfig = false;
        notifyListeners(); // Notify listeners about the change in isConfig state
      }
    } catch (e) {
      print("Error during provisioning: $e");
      _isConfig = false;
      isSuccess = false; // Explicitly set isSuccess to false on exception
      notifyListeners(); // Ensure listeners are notified in case of an exception
    } finally {
      provisioner
          .stop(); // Stop the provisioning process in both success and failure cases
    }

    return isSuccess; // Return the isSuccess flag indicating the outcome
  }

  Future<bool> login() async {
    _isLoading = true;
    notifyListeners();
    sharedPreferences.clear();
    bool isLoginSuccess = false;
    ApiResponse apiResponse =
        await repository.login(userName.text, userPassword.text);
    late AuthResponse data;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      Map<String, dynamic> response = apiResponse.response?.data;

      if (response['success'] == true) {
        data = AuthResponse.fromJson(response);
        if (data.username == 'demoaccount') {
          _isDemo = true;
          showToast('Demo Account!');
        }
        sharedPreferences.setString(AppConstants.USERNAME, data.username);
        sharedPreferences.setString(AppConstants.VERSION, data.firmwareVersion);
        sharedPreferences.setString(
            AppConstants.FIRMWARE_URL, data.firmwareUrl);
        isLoginSuccess = true;
      } else {
        isLoginSuccess = false;
        showToast('Your Username or Password Incorrect!');
      }
    } else {
      isLoginSuccess = false;
      showToast('Your Username or Password Incorrect!');
    }

    _isLoading = false;
    notifyListeners();

    return isLoginSuccess;
  }

  Future<void> tokenLogin() async {
    ApiResponse apiResponse =
        await repository.tokenLogin(userName.text, userPassword.text);
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      Map<String, dynamic> response = apiResponse.response?.data;
      TokenAuthResponse data = TokenAuthResponse.fromJson(response);
      sharedPreferences.setString(AppConstants.TOKEN, data.token);
      print(data.token);
      print('iam here');
      dioClient.updateToken(data.token);
    }
  }
}
