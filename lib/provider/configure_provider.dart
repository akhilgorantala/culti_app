import 'dart:io';

import 'package:appspector/appspector.dart';
import 'package:culti_app/core/utils/app_constants.dart';
import 'package:culti_app/core/utils/utils.dart';
import 'package:culti_app/model/api_response.dart';
import 'package:culti_app/model/auth_response.dart';
import 'package:esp_smartconfig/esp_smartconfig.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_iot/wifi_iot.dart';

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

  final TextEditingController ssid = TextEditingController();
  final TextEditingController bssid = TextEditingController();
  final TextEditingController password = TextEditingController();

  final TextEditingController userName = TextEditingController();
  final TextEditingController userPassword = TextEditingController();

  int? frequency;

  bool? _isConfig;

  bool? get isConfig => _isConfig;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isDemo = false;

  bool get isDemo => _isDemo;

  Future<bool> startPro() async {
    String? data = sharedPreferences.getString(AppConstants.USERNAME);

    bool isSuccess = false;

    final provisioner = Provisioner.espTouchV2();

    provisioner.listen((response) {
      Logger.d('DEVICE PROVISIONED', response.bssidText);
      print("Device ${response.bssidText} connected to WiFi!");
      _isConfig = true;
      isSuccess = true; // Update isSuccess to true on successful connection
      notifyListeners(); // Notify listeners about the change in isConfig state
    });

    try {
      await provisioner.start(ProvisioningRequest.fromStrings(
        ssid: ssid.text,
        bssid: bssid.text,
        password: password.text,
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
      Logger.d('Provision Not Done', e.toString());
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

    bool isLoginSuccess = false;

    ApiResponse apiResponse =
        await repository.login(userName.text, userPassword.text);

    late AuthResponse data;

    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      data = AuthResponse.fromJson(apiResponse.response?.data);

      if (data.username == 'demoaccount') {
        _isDemo = true;
        showToast('Demo Account!');
      }

      sharedPreferences.setString(AppConstants.USERNAME, data.username);

      isLoginSuccess = true;
    } else {
      isLoginSuccess = false;
      showToast('Your Username or Password Incorrect!');
    }

    _isLoading = false;
    notifyListeners();

    return isLoginSuccess;
  }

  Future<void> getssid() async {
    if (!Platform.isAndroid) {
      final info = NetworkInfo();
      final wifiName = await info.getWifiName();
      final wifiBSSID = await info.getWifiBSSID();

      ssid.text = wifiName!;
      bssid.text = wifiBSSID!;
    } else {
      final ssidvalue = await WiFiForIoTPlugin.getSSID();
      final bssidvalue = await WiFiForIoTPlugin.getBSSID();

      ssid.text = ssidvalue!;
      bssid.text = bssidvalue!;
    }

    Logger.d("SSID", ssid.text);
    Logger.d("BSSID", bssid.text);

    notifyListeners();
  }

  void getFrequency() async {
    var value = await WiFiForIoTPlugin.getFrequency();
    value = int.parse(value.toString()[0]);
    frequency = value;
    Logger.d('FREQUENCY', value.toString());
    notifyListeners();
  }
}
