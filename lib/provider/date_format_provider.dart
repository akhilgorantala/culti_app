import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DateFormatProvider extends ChangeNotifier {
  bool _is24HourFormat = true;

  bool get is24HourFormat => _is24HourFormat;

  String formatTime() {
    final now = DateTime.now();
    final format = _is24HourFormat ? 'HH:mm' : 'hh:mm a';
    return DateFormat(format).format(now);
  }
}
