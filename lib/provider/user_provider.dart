import 'package:culti_app/core/utils/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  final SharedPreferences sharedPreferences;

  UserProvider({required this.sharedPreferences});

  Future<String?> isLogin() async {
    String? data = sharedPreferences.getString(AppConstants.USERNAME);
    return data;
  }
}
