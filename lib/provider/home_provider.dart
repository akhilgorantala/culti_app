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

  int _selectedLEDValue = 0;

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
      _selectedFANValue = 0;
      notifyListeners();
    } else if (data == 1) {
      fanData = '$_selectedFANValue';
      notifyListeners();
    }
    getControlFan();
  }

  void lightControlAllIndividuallyHandle(int value) {
    _lightControlAllIndividually = value;
    selectedLED(value);
    notifyListeners();
  }

  String convertToUTC(String time) {
    List<String> timeSplit = time.split(':');
    int hour = int.parse(timeSplit[0]);
    int minute = int.parse(timeSplit[1]);
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day, hour, minute);
    DateTime utcDate = date.toUtc();
    String hourMin =
        '${utcDate.hour.toString().padLeft(2, '0')}:${utcDate.minute.toString().padLeft(2, '0')}';
    return hourMin;
  }

  void selectLED(int value) {
    _selectedLEDValue = value;
    notifyListeners();
  }

  void selectedLED(int data) {
    if (data == 0) {
      ledData = '0';
      _selectedLEDValue = 0;
      notifyListeners();
    } else if (data == 1) {
      ledData = '$_selectedLEDValue';
      notifyListeners();
    }
    getControlLight();
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
    notifyListeners();
  }

  void slider2(double value) {
    _activeSliderValue2 = value;
    notifyListeners();
  }

  void slider3(double value) {
    _activeSliderValue3 = value;
    notifyListeners();
  }

  String controlLight() {
    String onTime = convertToUTC('${_lightOn.hour}:${_lightOn.minute}');
    String offTime = convertToUTC('${_lightOff.hour}:${_lightOff.minute}');
    print(onTime);
    print(offTime);
    String data =
        '{"LED Number":$ledData,"On time":"$onTime","Off time":"$offTime","Power(%)":${_activeSliderValue2.toInt()},"Dim Up/Down":"${_lightDimUpDown}M","Dim(%)":${_activeSliderValue1.toInt()}}';
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
    if (_selectedLEDValue == 0) {
      ledData = sharedPreferences.getString('ledData') ?? ledData;
      _lightOn = Time(
          hour:
              int.tryParse(sharedPreferences.getString('lightOnHour') ?? '') ??
                  _lightOn.hour,
          minute: int.tryParse(
                  sharedPreferences.getString('lightOnMinute') ?? '') ??
              _lightOn.minute);
      _lightOff = Time(
          hour:
              int.tryParse(sharedPreferences.getString('lightOffHour') ?? '') ??
                  _lightOff.hour,
          minute: int.tryParse(
                  sharedPreferences.getString('lightOffMinute') ?? '') ??
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
    } else if (_selectedLEDValue == 1) {
      ledData = sharedPreferences.getString('ledData1') ?? ledData;
      _lightOn = Time(
          hour:
              int.tryParse(sharedPreferences.getString('lightOnHour1') ?? '') ??
                  _lightOn.hour,
          minute: int.tryParse(
                  sharedPreferences.getString('lightOnMinute1') ?? '') ??
              _lightOn.minute);
      _lightOff = Time(
          hour: int.tryParse(
                  sharedPreferences.getString('lightOffHour1') ?? '') ??
              _lightOff.hour,
          minute: int.tryParse(
                  sharedPreferences.getString('lightOffMinute1') ?? '') ??
              _lightOff.minute);
      _activeSliderValue2 = double.tryParse(
              sharedPreferences.getString('activeSliderValue21') ?? '') ??
          _activeSliderValue2;
      _lightDimUpDown =
          int.tryParse(sharedPreferences.getString('lightDimUpDown1') ?? '') ??
              _lightDimUpDown;
      _activeSliderValue1 = double.tryParse(
              sharedPreferences.getString('activeSliderValue11') ?? '') ??
          _activeSliderValue1;
    } else if (_selectedLEDValue == 2) {
      ledData = sharedPreferences.getString('ledData2') ?? ledData;
      _lightOn = Time(
          hour:
              int.tryParse(sharedPreferences.getString('lightOnHour2') ?? '') ??
                  _lightOn.hour,
          minute: int.tryParse(
                  sharedPreferences.getString('lightOnMinute2') ?? '') ??
              _lightOn.minute);
      _lightOff = Time(
          hour: int.tryParse(
                  sharedPreferences.getString('lightOffHour2') ?? '') ??
              _lightOff.hour,
          minute: int.tryParse(
                  sharedPreferences.getString('lightOffMinute2') ?? '') ??
              _lightOff.minute);
      _activeSliderValue2 = double.tryParse(
              sharedPreferences.getString('activeSliderValue22') ?? '') ??
          _activeSliderValue2;
      _lightDimUpDown =
          int.tryParse(sharedPreferences.getString('lightDimUpDown2') ?? '') ??
              _lightDimUpDown;
      _activeSliderValue1 = double.tryParse(
              sharedPreferences.getString('activeSliderValue12') ?? '') ??
          _activeSliderValue1;
    } else if (_selectedLEDValue == 3) {
      ledData = sharedPreferences.getString('ledData3') ?? ledData;
      _lightOn = Time(
          hour:
              int.tryParse(sharedPreferences.getString('lightOnHour3') ?? '') ??
                  _lightOn.hour,
          minute: int.tryParse(
                  sharedPreferences.getString('lightOnMinute3') ?? '') ??
              _lightOn.minute);
      _lightOff = Time(
          hour: int.tryParse(
                  sharedPreferences.getString('lightOffHour3') ?? '') ??
              _lightOff.hour,
          minute: int.tryParse(
                  sharedPreferences.getString('lightOffMinute3') ?? '') ??
              _lightOff.minute);
      _activeSliderValue2 = double.tryParse(
              sharedPreferences.getString('activeSliderValue23') ?? '') ??
          _activeSliderValue2;
      _lightDimUpDown =
          int.tryParse(sharedPreferences.getString('lightDimUpDown3') ?? '') ??
              _lightDimUpDown;
      _activeSliderValue1 = double.tryParse(
              sharedPreferences.getString('activeSliderValue13') ?? '') ??
          _activeSliderValue1;
    }
  }

  void getControlFan() {
    if (_selectedFANValue == 0) {
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
      _fanStop = int.tryParse(sharedPreferences.getString('fanStop') ?? '') ??
          _fanStop;
      _startSecMin = sharedPreferences.getInt('startTimeUnit') ?? _startSecMin;
      _stopSecMin = sharedPreferences.getInt('stopTimeUnit') ?? _stopSecMin;
    } else if (_selectedFANValue == 1) {
      fanData = sharedPreferences.getString('fanData1') ?? fanData;
      _fanOn = Time(
          hour: int.tryParse(sharedPreferences.getString('fanOnHour1') ?? '') ??
              _fanOn.hour,
          minute:
              int.tryParse(sharedPreferences.getString('fanOnMinute1') ?? '') ??
                  _fanOn.minute);
      _fanOff = Time(
          hour:
              int.tryParse(sharedPreferences.getString('fanOffHour1') ?? '') ??
                  _fanOff.hour,
          minute: int.tryParse(
                  sharedPreferences.getString('fanOffMinute1') ?? '') ??
              _fanOff.minute);
      _activeSliderValue3 = double.tryParse(
              sharedPreferences.getString('activeSliderValue31') ?? '') ??
          _activeSliderValue3;
      _fanStart =
          int.tryParse(sharedPreferences.getString('fanStart1') ?? '') ??
              _fanStart;
      _fanStop = int.tryParse(sharedPreferences.getString('fanStop1') ?? '') ??
          _fanStop;
      _startSecMin = sharedPreferences.getInt('startTimeUnit1') ?? _startSecMin;
      _stopSecMin = sharedPreferences.getInt('stopTimeUnit1') ?? _stopSecMin;
    } else if (_selectedFANValue == 2) {
      fanData = sharedPreferences.getString('fanData2') ?? fanData;
      _fanOn = Time(
          hour: int.tryParse(sharedPreferences.getString('fanOnHour2') ?? '') ??
              _fanOn.hour,
          minute:
              int.tryParse(sharedPreferences.getString('fanOnMinute2') ?? '') ??
                  _fanOn.minute);
      _fanOff = Time(
          hour:
              int.tryParse(sharedPreferences.getString('fanOffHour2') ?? '') ??
                  _fanOff.hour,
          minute: int.tryParse(
                  sharedPreferences.getString('fanOffMinute2') ?? '') ??
              _fanOff.minute);
      _activeSliderValue3 = double.tryParse(
              sharedPreferences.getString('activeSliderValue32') ?? '') ??
          _activeSliderValue3;
      _fanStart =
          int.tryParse(sharedPreferences.getString('fanStart2') ?? '') ??
              _fanStart;
      _fanStop = int.tryParse(sharedPreferences.getString('fanStop2') ?? '') ??
          _fanStop;
      _startSecMin = sharedPreferences.getInt('startTimeUnit2') ?? _startSecMin;
      _stopSecMin = sharedPreferences.getInt('stopTimeUnit2') ?? _stopSecMin;
    }
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
    if (_selectedLEDValue == 0) {
      sharedPreferences.setString('ledData', ledData);
      sharedPreferences.setString('lightOnHour', lightOnHour);
      sharedPreferences.setString('lightOnMinute', lightOnMinute);
      sharedPreferences.setString('lightOffHour', lightOffHour);
      sharedPreferences.setString('lightOffMinute', lightOffMinute);
      sharedPreferences.setString('activeSliderValue2', activeSliderValue2);
      sharedPreferences.setString('lightDimUpDown', lightDimUpDown);
      sharedPreferences.setString('activeSliderValue1', activeSliderValue1);
    } else if (_selectedLEDValue == 1) {
      sharedPreferences.setString('ledData1', ledData);
      sharedPreferences.setString('lightOnHour1', lightOnHour);
      sharedPreferences.setString('lightOnMinute1', lightOnMinute);
      sharedPreferences.setString('lightOffHour1', lightOffHour);
      sharedPreferences.setString('lightOffMinute1', lightOffMinute);
      sharedPreferences.setString('activeSliderValue21', activeSliderValue2);
      sharedPreferences.setString('lightDimUpDown1', lightDimUpDown);
      sharedPreferences.setString('activeSliderValue11', activeSliderValue1);
    } else if (_selectedLEDValue == 2) {
      sharedPreferences.setString('ledData2', ledData);
      sharedPreferences.setString('lightOnHour2', lightOnHour);
      sharedPreferences.setString('lightOnMinute2', lightOnMinute);
      sharedPreferences.setString('lightOffHour2', lightOffHour);
      sharedPreferences.setString('lightOffMinute2', lightOffMinute);
      sharedPreferences.setString('activeSliderValue22', activeSliderValue2);
      sharedPreferences.setString('lightDimUpDown2', lightDimUpDown);
      sharedPreferences.setString('activeSliderValue12', activeSliderValue1);
    } else if (_selectedLEDValue == 3) {
      sharedPreferences.setString('ledData3', ledData);
      sharedPreferences.setString('lightOnHour3', lightOnHour);
      sharedPreferences.setString('lightOnMinute3', lightOnMinute);
      sharedPreferences.setString('lightOffHour3', lightOffHour);
      sharedPreferences.setString('lightOffMinute3', lightOffMinute);
      sharedPreferences.setString('activeSliderValue23', activeSliderValue2);
      sharedPreferences.setString('lightDimUpDown3', lightDimUpDown);
      sharedPreferences.setString('activeSliderValue13', activeSliderValue1);
    }
  }

  void saveControlFan(
      String fanData,
      String fanOnHour,
      String fanOnMinute,
      String fanOffHour,
      String fanOffMinute,
      String activeSliderValue3,
      String fanStart,
      String fanStop,
      int startTimeUnit,
      int stopTimeUnit) {
    if (_selectedFANValue == 0) {
      sharedPreferences.setString('fanData', fanData);
      sharedPreferences.setString('fanOnHour', fanOnHour);
      sharedPreferences.setString('fanOnMinute', fanOnMinute);
      sharedPreferences.setString('fanOffHour', fanOffHour);
      sharedPreferences.setString('fanOffMinute', fanOffMinute);
      sharedPreferences.setString('activeSliderValue3', activeSliderValue3);
      sharedPreferences.setString('fanStart', fanStart);
      sharedPreferences.setString('fanStop', fanStop);
      sharedPreferences.setInt('startTimeUnit', startTimeUnit);
      sharedPreferences.setInt('stopTimeUnit', stopTimeUnit);
    } else if (_selectedFANValue == 1) {
      sharedPreferences.setString('fanData1', fanData);
      sharedPreferences.setString('fanOnHour1', fanOnHour);
      sharedPreferences.setString('fanOnMinute1', fanOnMinute);
      sharedPreferences.setString('fanOffHour1', fanOffHour);
      sharedPreferences.setString('fanOffMinute1', fanOffMinute);
      sharedPreferences.setString('activeSliderValue31', activeSliderValue3);
      sharedPreferences.setString('fanStart1', fanStart);
      sharedPreferences.setString('fanStop1', fanStop);
      sharedPreferences.setInt('startTimeUnit1', startTimeUnit);
      sharedPreferences.setInt('stopTimeUnit1', stopTimeUnit);
    } else if (_selectedFANValue == 2) {
      sharedPreferences.setString('fanData2', fanData);
      sharedPreferences.setString('fanOnHour2', fanOnHour);
      sharedPreferences.setString('fanOnMinute2', fanOnMinute);
      sharedPreferences.setString('fanOffHour2', fanOffHour);
      sharedPreferences.setString('fanOffMinute2', fanOffMinute);
      sharedPreferences.setString('activeSliderValue32', activeSliderValue3);
      sharedPreferences.setString('fanStart2', fanStart);
      sharedPreferences.setString('fanStop2', fanStop);
      sharedPreferences.setInt('startTimeUnit2', startTimeUnit);
      sharedPreferences.setInt('stopTimeUnit2', stopTimeUnit);
    }
  }

  String controlFanPump() {
    String startTimeUnit = _startSecMin == 1 ? 'S' : 'M';
    String stopTimeUnit = _stopSecMin == 1 ? 'S' : 'M';
    String onTime = convertToUTC('${_fanOn.hour}:${_fanOn.minute}');
    String offTime = convertToUTC('${_fanOff.hour}:${_fanOff.minute}');
    String data =
        '{"FAN Number":$fanData,"On time":"$onTime","Off time":"$offTime","Power(%)":${_activeSliderValue3.toInt()},"Start time":"$_fanStart$startTimeUnit","Stop time":"$_fanStop$stopTimeUnit"}';
    saveControlFan(
        fanData.toString(),
        _fanOn.hour.toString(),
        _fanOn.minute.toString(),
        _fanOff.hour.toString(),
        _fanOff.minute.toString(),
        _activeSliderValue3.toString(),
        _fanStart.toString(),
        _fanStop.toString(),
        _startSecMin,
        _stopSecMin);
    return data;
  }

  bool _dimLights = true;

  bool get dimLights => _dimLights;

  void dimAllLights() {
    String defaultState1 =
        sharedPreferences.getString('activeSliderValue1') ?? '';
    sharedPreferences.setString('defaultState1', defaultState1);
    String defaultState2 =
        sharedPreferences.getString('activeSliderValue11') ?? '';
    sharedPreferences.setString('defaultState2', defaultState2);
    String defaultState3 =
        sharedPreferences.getString('activeSliderValue12') ?? '';
    sharedPreferences.setString('defaultState3', defaultState3);
    String defaultState4 =
        sharedPreferences.getString('activeSliderValue13') ?? '';
    sharedPreferences.setString('defaultState4', defaultState4);

    sharedPreferences.setString('activeSliderValue1', '10');
    sharedPreferences.setString('activeSliderValue11', '10');
    sharedPreferences.setString('activeSliderValue12', '10');
    sharedPreferences.setString('activeSliderValue13', '10');
    _dimLights = false;
    notifyListeners();
    getControlLight();
  }

  void unDimLights() {
    sharedPreferences.setString('activeSliderValue1',
        sharedPreferences.getString('defaultState1') ?? '');
    sharedPreferences.setString('activeSliderValue11',
        sharedPreferences.getString('defaultState2') ?? '');
    sharedPreferences.setString('activeSliderValue12',
        sharedPreferences.getString('defaultState3') ?? '');
    sharedPreferences.setString('activeSliderValue13',
        sharedPreferences.getString('defaultState4') ?? '');
    getControlLight();
    _dimLights = true;
    notifyListeners();
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
