import 'package:culti_app/core/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/utils/app_constants.dart';

enum MQTTAppConnectionState { connected, disconnected, connecting }

class MQTTProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;

  MQTTProvider({required this.sharedPreferences});

  MqttServerClient? _client;
  String identifier = 'random_text';
  String host = '13.50.1.222';

  final List<String> _topics = [
    '/wifi_scan',
    '/wifi_configuration',
    '/controller_setup',
    '/setup_time',
    '/LED_Setup',
    '/FAN_Setup',
    '/firmware_ver',
    '/update',
  ];

  // final List<String> _subTopics = [
  //   'akhil/wifi_scan_res',
  //   'akhil/wifi_configuration_res',
  //   'akhil/controller_setup_res',
  //   'akhil/setup_time_res',
  //   'akhil/LED_Setup_res',
  //   'akhil/FAN_Setup_res',
  //   'akhil/firmware_ver_res',
  //   'akhil/update_res',
  // ];

  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnected;

  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;

  String get getReceivedText => _receivedText;
  String _receivedText = '';

  void setReceivedText(String topic, String message) {
    print(topic);
    print(message);
    print('Akhil');
    _receivedText = message;
    notifyListeners();
  }

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }

  // Initialize MQTT client
  void initializeMQTTClient() {
    _client = MqttServerClient.withPort(host, identifier, 1883);
    _client!.keepAlivePeriod = 60;
    _client!.onDisconnected = onDisconnected;
    _client!.secure = false;
    // _client!.logging(on: true);

    _client!.onConnected = onConnected;
    _client!.onSubscribed = onSubscribed;

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
    } on Exception catch (e) {
      disconnect();
      rethrow; // You can handle the exception here if you want to.
    }
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

  // Publish to a specific topic
  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    print(message);
    print('sklafjsldk');
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
    notifyListeners();
  }

  // Handle onConnected
  void onConnected() {
    setAppConnectionState(MQTTAppConnectionState.connected);
    showToast('Connected!');
    notifyListeners();
    String? data = sharedPreferences.getString(AppConstants.USERNAME);

    // Subscribe to all topics in the list
    for (var topic in _topics) {
      String modifiedTopic = data! + topic;
      print(modifiedTopic);
      print('Akhil');
      subscribeToTopic(modifiedTopic);
    }
    _client?.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      final String message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print(recMess.payload.message);
      setReceivedText(c[0].topic, message);
      notifyListeners();
    });
  }
}
