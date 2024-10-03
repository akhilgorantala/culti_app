import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:wifi_iot/wifi_iot.dart';

class WifiProvider extends ChangeNotifier {
  final TextEditingController ssid = TextEditingController();
  final TextEditingController bssid = TextEditingController();
  final TextEditingController password = TextEditingController();

  int? frequency;

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
    notifyListeners();
  }

  void getFrequency() async {
    var value = await WiFiForIoTPlugin.getFrequency();
    value = int.parse(value.toString()[0]);
    frequency = value;
    notifyListeners();
  }
}
