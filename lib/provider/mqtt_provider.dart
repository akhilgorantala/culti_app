import 'dart:convert';

import 'package:culti_app/core/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/utils/app_constants.dart';

enum MQTTAppConnectionState { connected, disconnected, connecting }

class MQTTProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;

  MQTTProvider({
    required this.sharedPreferences,
  });

  MqttServerClient? _client;
  String identifier = 'random_text';
  String host = '13.50.1.222';

  String _updateStatus = 'Checking...';
  String get getUpdateStatus => _updateStatus;

  bool _isDismissible = false;
  bool get getIsDismissible => _isDismissible;

  final List<String> _topics = [
    '/wifi_scan',
    '/wifi_configuration',
    '/controller_setup',
    '/setup_time',
    '/LED_Setup',
    '/FAN_Setup',
    '/firmware_ver',
    '/firmware_ver_res',
    '/update',
    '/update_res',
  ];

  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnected;

  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;

  String get getReceivedText => _receivedText;
  String _receivedText = '';

  String get version => _version;
  String _version = '';

  BuildContext? _context;
  BuildContext? get context => _context;

  void setContext(BuildContext? context) {
    _context = context;
  }

  void setUpdateStatus(String status) {
    _updateStatus = status;
    notifyListeners();
  }

  void setReceivedText(String topic, String message) {
    String? username = sharedPreferences.getString(AppConstants.USERNAME);
    String? selectedMacAddress =
        sharedPreferences.getString(AppConstants.SELECTED_MACADDRESS);

    if (topic == '${username!}/$selectedMacAddress/firmware_ver_res') {
      checkFirmwareVersion(message);
    } else if (topic == '$username/$selectedMacAddress/update_res') {
      updateProgress(message);
    }
    _receivedText = message;
    notifyListeners();
  }

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }

  updateProgress(data) {
    if (data != null) {
      Map<String, dynamic> updateData = jsonDecode(data);
      if (updateData.containsKey('Update ')) {
        String updateStatus = updateData['Update '];
        if (updateStatus == 'Starting') {
          _updateStatus = 'Firmware update started';
          notifyListeners();
        } else if (updateStatus == 'finish') {
          _updateStatus = 'Firmware update finished!';
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pop(_context!);
          });
          notifyListeners();
        }
      }
      if (updateData.containsKey('Update (%)')) {
        String updatePercentage = updateData['Update (%)'].toString();
        _updateStatus = 'Updating... ${double.parse(updatePercentage)}%';
        notifyListeners();
      }
    }
  }

  updateFirmware() {
    String? data = sharedPreferences.getString(AppConstants.USERNAME);
    String? selectedMacAddress =
        sharedPreferences.getString(AppConstants.SELECTED_MACADDRESS);
    String topic = '${data!}/$selectedMacAddress/update';
    publish(topic, '{"Update":"begin"}');
  }

  void changeSheetState(bool state) {
    _isDismissible = state;
    notifyListeners();
  }

  checkFirmwareVersion(data) {
    if (data != null) {
      Map<String, dynamic> firmwareData = jsonDecode(data);
      String runningFirmware = firmwareData['Firmware version running'];
      String OTAfirmware = firmwareData['Firmware version OTA'];
      if (runningFirmware != OTAfirmware) {
        updateFirmware();
      } else if (runningFirmware == OTAfirmware) {
        _updateStatus = 'Firmware is up to date!';
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(_context!);
        });
      }
    }
  }

  // Initialize MQTT client
  void initializeMQTTClient() {
    _client = MqttServerClient.withPort(host, identifier, 1883);
    _client!.onDisconnected = onDisconnected;
    _client!.secure = false;
    _client!.onConnected = onConnected;
    _client!.onSubscribed = onSubscribed;
    _client!.autoReconnect = true;
    // Set up the connection message
    _client!.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(identifier)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
  }

  // Connect to the host
  void connect() async {
    initializeMQTTClient();
    assert(_client != null);
    setAppConnectionState(MQTTAppConnectionState.connecting);
    notifyListeners();
    try {
      await _client!.connect();
    } catch (e) {
      print(e.toString());
      disconnect();
    }
  }

  void setVersion(String value) {
    sharedPreferences.setString(AppConstants.VERSION, value);
  }

  void getFirmwareVersion() {
    _version = sharedPreferences.getString(AppConstants.VERSION)!;
    notifyListeners();
  }

  // Disconnect from the broker
  void disconnect() {
    _client?.disconnect();
    setAppConnectionState(MQTTAppConnectionState.disconnected);
    notifyListeners();
  }

  // Subscribe to multiple topics
  void subscribeToTopic(String topic) {
    _client?.subscribe(topic, MqttQos.atMostOnce);
    notifyListeners();
  }

  // Unsubscribe from a topic
  void unsubscribeFromTopic(String topic) {
    _client?.unsubscribe(topic);
    notifyListeners();
  }

  void unsubscribeAllTopics() {
    String? data = sharedPreferences.getString(AppConstants.USERNAME);
    String macAddress =
        sharedPreferences.getString(AppConstants.SELECTED_MACADDRESS)!;
    for (var topic in _topics) {
      String modifiedTopic = '${data!}/$macAddress$topic';
      unsubscribeFromTopic(modifiedTopic);
    }
  }

  void subscribeAllTopics() {
    String? data = sharedPreferences.getString(AppConstants.USERNAME);
    String macAddress =
        sharedPreferences.getString(AppConstants.SELECTED_MACADDRESS)!;
    for (var topic in _topics) {
      String modifiedTopic = '${data!}/$macAddress$topic';
      subscribeToTopic(modifiedTopic);
    }
  }

  // Publish to a specific topic
  Future<void> publish(String topic, String message) async {
    if (_appConnectionState == MQTTAppConnectionState.disconnected) {
      _client?.connect();
      print('reconnect ra akhiluuu');
    }
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client?.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
  }

  // Handle onSubscribed
  void onSubscribed(String topic) {
    // Handle the event here
    // For example: print('Subscribed to $topic');
    print('Subscribed to $topic');
  }

  // Handle onDisconnected
  void onDisconnected() {
    setAppConnectionState(MQTTAppConnectionState.disconnected);
    showToast('DisConnected!');
    print(_appConnectionState.toString());
    print('its disconnecteddd');
    notifyListeners();
  }

  // Handle onConnected
  void onConnected() {
    setAppConnectionState(MQTTAppConnectionState.connected);
    showToast('Connected!');
    notifyListeners();
    String? data = sharedPreferences.getString(AppConstants.USERNAME);
    String macAddress =
        sharedPreferences.getString(AppConstants.SELECTED_MACADDRESS)!;

    // Subscribe to all topics in the list
    for (var topic in _topics) {
      String modifiedTopic = '${data!}/$macAddress$topic';
      print(modifiedTopic);
      print('Akhil');
      subscribeToTopic(modifiedTopic);
    }
    _client?.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      print(_appConnectionState.toString());
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      final String message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print(recMess.payload.message);
      setReceivedText(c[0].topic, message);
      notifyListeners();
    });
  }
}
