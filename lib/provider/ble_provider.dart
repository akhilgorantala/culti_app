import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:culti_app/provider/devices_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleProvider extends ChangeNotifier {
  final DevicesProvider devicesProvider;

  BleProvider({required this.devicesProvider});

  final TextEditingController ssid = TextEditingController();
  final TextEditingController password = TextEditingController();

  late BluetoothDevice _device;
  BluetoothDevice get device => _device;

  List<ScanResult> scannedDevices = [];
  late StreamSubscription<List<ScanResult>> scanSubscription;

  late List<BluetoothCharacteristic> _characteristics;

  static const serviceId = 'BLEFB001-1000-1000-8000-00805F9B34FB';
  static const characteristicId = 'b5efb001-2000-1000-8000-00805f9b34fb';

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  bool _isScanning = false;
  bool get isScanning => _isScanning;

  bool? _isSent;
  bool? get isSent => _isSent;

  List<bool> _isConnecting = [];
  List<bool> get isConnecting => _isConnecting;

  Future<void> scanDevices() async {
    _isScanning = true;
    scannedDevices = [];
    notifyListeners();
    try {
      if (Platform.isAndroid) {
        await FlutterBluePlus.turnOn();
      } else {
        await FlutterBluePlus.adapterState
            .map((s) {
              print(s);
              return s;
            })
            .where((s) => s == BluetoothAdapterState.on)
            .first;
      }
      FlutterBluePlus.startScan();
      scanSubscription = FlutterBluePlus.scanResults.listen((event) {
        for (ScanResult r in event) {
          if (!scannedDevices.any((device) =>
              device.advertisementData.advName ==
              r.advertisementData.advName)) {
            if (r.advertisementData.advName != '') {
              scannedDevices.add(r);
              _isConnecting.add(false); // Initialize connecting state
            }
          }
        }
      });

      Timer(const Duration(seconds: 5), () {
        FlutterBluePlus.stopScan();
        scanSubscription.cancel();
        _isScanning = false;
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> connectDevice(BluetoothDevice device, int index) async {
    _isConnecting[index] = true;
    notifyListeners();
    await device.connect();
    if (Platform.isAndroid) {
      await device.requestMtu(512);
    }
    _device = device;
    _device.connectionState.listen((event) async {
      if (event == BluetoothConnectionState.connected) {
        Future.delayed(const Duration(seconds: 3), () {
          _isConnecting[index] = false;
          _isConnected = true;
          notifyListeners();
        });
        print('Device connected!');
      } else if (event == BluetoothConnectionState.disconnected) {
        _isConnecting[index] = false;
        _isConnected = false;
        notifyListeners();
      }
    });
  }

  Future<void> sendData(String data) async {
    try {
      _device.connectionState.listen((event) async {
        if (event == BluetoothConnectionState.connected) {
          final services = await device.discoverServices();
          for (var element in services) {
            _characteristics = element.characteristics;
          }
          for (BluetoothCharacteristic c in _characteristics) {
            if (c.characteristicUuid.toString().toLowerCase() ==
                characteristicId.toLowerCase()) {
              List<int> uint8list = utf8.encode(data);
              c.write(uint8list, allowLongWrite: true).whenComplete(() {
                _isSent = true;
                notifyListeners();
                _device.disconnect();
                print('Data Sent Success');
              });
            }
          }
        } else if (event == BluetoothConnectionState.disconnected) {
          print('Device disconnected!');
        }
      });
    } catch (e) {
      _isSent = false;
      print(e);
    }
    notifyListeners();
  }
}
