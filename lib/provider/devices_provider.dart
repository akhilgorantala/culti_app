import 'package:culti_app/core/utils/app_constants.dart';
import 'package:culti_app/model/api_response.dart';
import 'package:culti_app/model/get_devices_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repo/devices_repository.dart';

class DevicesProvider extends ChangeNotifier {
  final SharedPreferences sharedPreferences;
  final DevicesRepository devicesRepository;

  DevicesProvider({
    required this.sharedPreferences,
    required this.devicesRepository,
  });

  GetDevicesResponse? _devices;
  GetDevicesResponse? get devices => _devices;

  TextEditingController deviceName = TextEditingController();
  TextEditingController macAddress = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _selectedDevice = "";
  String get selectedDevice => _selectedDevice;

  String _selectedMacAddress = "";
  String get selectedMacAddress => _selectedMacAddress;

  set setDevice(String value) {
    _selectedDevice = value;
    notifyListeners();
  }

  void setMacAddress(String value) {
    _selectedMacAddress = value;
    //34:98:7A:8B:59:E3
    String cleanedValue = value.replaceAll(':', '').replaceAll(' ', '');
    print(cleanedValue);
    sharedPreferences.setString(AppConstants.SELECTED_MACADDRESS, cleanedValue);
    notifyListeners();
  }

  Future<void> getDevices() async {
    _isLoading = true;
    notifyListeners();
    ApiResponse response = await devicesRepository.getDevices();

    late GetDevicesResponse data;

    print(response.response?.statusCode);
    if (response.response?.statusCode == 200) {
      data = GetDevicesResponse.fromJson(response.response!.data);
      _devices = data;
      setMacAddress(data.devices[0].macAddress);
      print('iam at selected device');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addDevice(String deviceName, macAddress) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse response =
        await devicesRepository.addDevice(deviceName, macAddress);

    if (response.response?.statusCode == 200) {
      // getDevices();
    }
    _isLoading = false;
    notifyListeners();
  }
}
