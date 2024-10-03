import 'package:culti_app/core/utils/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  final SharedPreferences sharedPreferences;

  UserProvider({required this.sharedPreferences});

  String getUserName() {
    String? data = sharedPreferences.getString(AppConstants.USERNAME);
    return data ?? '';
  }

  String getMacAddress() {
    String? data =
        sharedPreferences.getString(AppConstants.SELECTED_MACADDRESS);
    return data ?? '';
  }

  String getVersionUrl() {
    String? data = sharedPreferences.getString(AppConstants.FIRMWARE_URL);
    return data ?? '';
  }

  String getVersion() {
    String? data = sharedPreferences.getString(AppConstants.VERSION);
    return data ?? '';
  }
}
