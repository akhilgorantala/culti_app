import 'package:flutter/cupertino.dart';

class UpdateFirmwareProvider extends ChangeNotifier {
  bool _isFirmwareUpdated = false;

  bool get isFirmwareUpdated => _isFirmwareUpdated;

  void setFirmwareUpdated(bool value) {
    _isFirmwareUpdated = value;
    notifyListeners();
  }
}
