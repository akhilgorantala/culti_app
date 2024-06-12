import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends ChangeNotifier {
  final SharedPreferences sharedPreferences;

  HomeProvider({required this.sharedPreferences});

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  int _fanControlAllIndividually = 0;

  int get fanControlAllIndividually => _fanControlAllIndividually;

  int _lightControlAllIndividually = 0;

  int get lightControlAllIndividually => _lightControlAllIndividually;

  int _startSecMin = 1;

  int get startSecMin => _startSecMin;

  int _stopSecMin = 1;

  int get stopSecMin => _stopSecMin;

  double _activeSliderValue1 = 50;

  double get activeSliderValue1 => _activeSliderValue1;

  double _activeSliderValue2 = 50;

  double get activeSliderValue2 => _activeSliderValue2;

  double _activeSliderValue3 = 50;

  double get activeSliderValue3 => _activeSliderValue3;

  final PageController _controller = PageController();

  PageController get controller => _controller;

  String? ledData;

  int _selectedLEDValue = 1;

  int get selectedLEDValue => _selectedLEDValue;

  String? fanData;

  int _selectedFANValue = 1;

  int get selectedFANValue => _selectedFANValue;

  Time _fanOn = Time(hour: 11, minute: 30);

  Time get fanOn => _fanOn;

  Time _fanOff = Time(hour: 11, minute: 30);

  Time get fanOff => _fanOff;

  Time _lightOn = Time(hour: 11, minute: 30);

  Time get lightOn => _lightOn;

  Time _lightOff = Time(hour: 11, minute: 30);

  Time get lightOff => _lightOff;

  void fanOnTimeChanged(Time newTime) {
    _fanOn = newTime;
    notifyListeners();
  }

  void fanOffTimeChanged(Time newTime) {
    _fanOff = newTime;
    notifyListeners();
  }

  void lightOnTimeChanged(Time newTime) {
    _lightOn = newTime;
    notifyListeners();
  }

  void lightOffTimeChanged(Time newTime) {
    _lightOff = newTime;
    notifyListeners();
  }

  void fanControlAllIndividuallyHandle(int value) {
    _fanControlAllIndividually = value;
    print(value);
    selectedFAN(value);
    notifyListeners();
  }

  void selectFAN(int value) {
    _selectedFANValue = value;
    print(value);
    notifyListeners();
  }

  void selectedFAN(int data) {
    if (data == 0) {
      fanData = '0';
      notifyListeners();
    } else if (data == 1) {
      fanData = '$_selectedFANValue';
      notifyListeners();
    }
  }

  void lightControlAllIndividuallyHandle(int value) {
    _lightControlAllIndividually = value;
    print(value);
    selectedLED(value);
    notifyListeners();
  }

  void selectLED(int value) {
    _selectedLEDValue = value;
    print(value);
    notifyListeners();
  }

  void selectedLED(int data) {
    if (data == 0) {
      ledData = '0';
      notifyListeners();
    } else if (data == 1) {
      ledData = '$_selectedLEDValue';
      notifyListeners();
    }
  }

  void startHandle(int value) {
    _startSecMin = value;
    notifyListeners();
  }

  void stopHandle(int value) {
    _stopSecMin = value;
    notifyListeners();
  }

  void lightFanSwitch(int value) {
    _selectedIndex = value;
    _controller.animateToPage(value,
        duration: const Duration(milliseconds: 100), curve: Curves.linear);
    notifyListeners();
  }

  void slider1(double value) {
    _activeSliderValue1 = value;
    print(value);
    notifyListeners();
  }

  void slider2(double value) {
    _activeSliderValue2 = value;
    print(value);
    notifyListeners();
  }

  void slider3(double value) {
    _activeSliderValue3 = value;
    notifyListeners();
  }

  String controlLight() {
    String data =
        '{"LED Number":$ledData,"On time":"${_lightOn.hour}:${_lightOn.minute}","Off time":"${_lightOff.hour}:${_lightOff.minute}","Power(%)":${_activeSliderValue2.toInt()},"Dim Up/Down":"${_lightDimUpDown}M","Dim(%)":${_activeSliderValue1.toInt()}}';
    saveControlLight(
        ledData.toString(),
        _lightOn.hour.toString(),
        _lightOn.minute.toString(),
        _lightOff.hour.toString(),
        _lightOff.minute.toString(),
        _activeSliderValue2.toString(),
        _lightDimUpDown.toString(),
        _activeSliderValue1.toString());
    return data;
  }

  void getControlLight() {
    ledData = sharedPreferences.getString('ledData') ?? ledData;
    _lightOn = Time(
        hour: int.tryParse(sharedPreferences.getString('lightOnHour') ?? '') ??
            _lightOn.hour,
        minute:
            int.tryParse(sharedPreferences.getString('lightOnMinute') ?? '') ??
                _lightOn.minute);
    _lightOff = Time(
        hour: int.tryParse(sharedPreferences.getString('lightOffHour') ?? '') ??
            _lightOff.hour,
        minute:
            int.tryParse(sharedPreferences.getString('lightOffMinute') ?? '') ??
                _lightOff.minute);
    _activeSliderValue2 = double.tryParse(
            sharedPreferences.getString('activeSliderValue2') ?? '') ??
        _activeSliderValue2;
    _lightDimUpDown =
        int.tryParse(sharedPreferences.getString('lightDimUpDown') ?? '') ??
            _lightDimUpDown;
    _activeSliderValue1 = double.tryParse(
            sharedPreferences.getString('activeSliderValue1') ?? '') ??
        _activeSliderValue1;
  }

  void getControlFan() {
    fanData = sharedPreferences.getString('fanData') ?? fanData;
    _fanOn = Time(
        hour: int.tryParse(sharedPreferences.getString('fanOnHour') ?? '') ??
            _fanOn.hour,
        minute:
            int.tryParse(sharedPreferences.getString('fanOnMinute') ?? '') ??
                _fanOn.minute);
    _fanOff = Time(
        hour: int.tryParse(sharedPreferences.getString('fanOffHour') ?? '') ??
            _fanOff.hour,
        minute:
            int.tryParse(sharedPreferences.getString('fanOffMinute') ?? '') ??
                _fanOff.minute);
    _activeSliderValue3 = double.tryParse(
            sharedPreferences.getString('activeSliderValue3') ?? '') ??
        _activeSliderValue3;
    _fanStart = int.tryParse(sharedPreferences.getString('fanStart') ?? '') ??
        _fanStart;
    _fanStop =
        int.tryParse(sharedPreferences.getString('fanStop') ?? '') ?? _fanStop;
  }

  void saveControlLight(
      String ledData,
      String lightOnHour,
      String lightOnMinute,
      String lightOffHour,
      String lightOffMinute,
      String activeSliderValue2,
      String lightDimUpDown,
      String activeSliderValue1) {
    sharedPreferences.setString('ledData', ledData);
    sharedPreferences.setString('lightOnHour', lightOnHour);
    sharedPreferences.setString('lightOnMinute', lightOnMinute);
    sharedPreferences.setString('lightOffHour', lightOffHour);
    sharedPreferences.setString('lightOffMinute', lightOffMinute);
    sharedPreferences.setString('activeSliderValue2', activeSliderValue2);
    sharedPreferences.setString('lightDimUpDown', lightDimUpDown);
    sharedPreferences.setString('activeSliderValue1', activeSliderValue1);
  }

  void saveControlFan(
      String fanData,
      String fanOnHour,
      String fanOnMinute,
      String fanOffHour,
      String fanOffMinute,
      String activeSliderValue3,
      String fanStart,
      String fanStop) {
    sharedPreferences.setString('fanData', fanData);
    sharedPreferences.setString('fanOnHour', fanOnHour);
    sharedPreferences.setString('fanOnMinute', fanOnMinute);
    sharedPreferences.setString('fanOffHour', fanOffHour);
    sharedPreferences.setString('fanOffMinute', fanOffMinute);
    sharedPreferences.setString('activeSliderValue3', activeSliderValue3);
    sharedPreferences.setString('fanStart', fanStart);
    sharedPreferences.setString('fanStop', fanStop);
  }

  String controlFanPump() {
    String startTimeUnit = _startSecMin == 1 ? 'S' : 'M';
    String stopTimeUnit = _stopSecMin == 1 ? 'S' : 'M';
    String data =
        '{"FAN Number":$fanData,"On time":"${_fanOn.hour}:${_fanOn.minute}","Off time":"${_fanOff.hour}:${_fanOff.minute}","Power(%)":${_activeSliderValue3.toInt()},"Start time":"$_fanStart$startTimeUnit","Stop time":"$_fanStop$stopTimeUnit"}';
    saveControlFan(
        fanData.toString(),
        _fanOn.hour.toString(),
        _fanOn.minute.toString(),
        _fanOff.hour.toString(),
        _fanOff.minute.toString(),
        _activeSliderValue3.toString(),
        _fanStart.toString(),
        _fanStop.toString());
    return data;
  }

  int _lightDimUpDown = 1;

  int get lightDimUpDown => _lightDimUpDown;

  int _fanStart = 1;

  int get fanStart => _fanStart;

  int _fanStop = 1;

  int get fanStop => _fanStop;

  void showNumberPicker(BuildContext context, int selected) {
    Picker(
      adapter: NumberPickerAdapter(data: [
        NumberPickerColumn(begin: 1, end: 100),
      ]),
      changeToFirst: true,
      onConfirm: (Picker picker, List<int> values) {
        if (selected == 0) {
          int selectedNumber = values[0] + 1;
          _lightDimUpDown = selectedNumber;
          notifyListeners();
        } else if (selected == 1) {
          int selectedNumber = values[0] + 1;
          _fanStart = selectedNumber;
          notifyListeners();
        } else if (selected == 2) {
          int selectedNumber = values[0] + 1;
          _fanStop = selectedNumber;
          notifyListeners();
        }
      },
    ).showModal(context);
  }
}
