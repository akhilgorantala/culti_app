import 'package:flutter/cupertino.dart';
import 'package:system_date_time_format/system_date_time_format.dart';

class DateTimeFormat extends ChangeNotifier {
  String _timeFormat = "";
  String get timeFormat => _timeFormat;

  void checkTimeFormat(BuildContext context) async {
    final patterns = SystemDateTimeFormat.of(context);
    final timePattern = patterns.timePattern;
    _timeFormat = timePattern!;
    print('Time Format: $timePattern');
    notifyListeners();
  }
}
