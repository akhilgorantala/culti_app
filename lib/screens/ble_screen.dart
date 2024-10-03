import 'package:culti_app/provider/ble_provider.dart';
import 'package:culti_app/provider/wifi_provider.dart';
import 'package:culti_app/screens/setup_screens/ble_searching_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';

class BleScreen extends StatefulWidget {
  const BleScreen({super.key});

  @override
  State<BleScreen> createState() => _BleScreenState();
}

class _BleScreenState extends State<BleScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<BleProvider>(context, listen: false).scanDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BleProvider, WifiProvider>(
        builder: (context, provider, wifiProvider, child) {
      return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 15,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xff37B44B),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                  child: SvgPicture.asset('assets/cultiapp_logo.svg'),
                ),
                const Text('Bluetooth Setup',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                Expanded(
                  child: provider.isScanning
                      ? Center(
                          child: LoadingAnimationWidget.fourRotatingDots(
                            color: Colors.grey,
                            size: 120,
                          ),
                        )
                      : ListView.builder(
                          itemCount: provider.scannedDevices.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(provider.scannedDevices[index]
                                  .advertisementData.advName),
                              trailing: SizedBox(
                                width: 120,
                                child: ElevatedButton(
                                  onPressed: () {
                                    final userName = Provider.of<UserProvider>(
                                            context,
                                            listen: false)
                                        .getUserName();
                                    final bleProvider =
                                        Provider.of<BleProvider>(context,
                                            listen: false);
                                    bleProvider
                                        .connectDevice(
                                            provider
                                                .scannedDevices[index].device,
                                            index)
                                        .whenComplete(() {
                                      Future.delayed(const Duration(seconds: 3),
                                          () {
                                        bleProvider.device.connectionState
                                            .listen((event) {
                                          if (event ==
                                              BluetoothConnectionState
                                                  .connected) {
                                            print('Connected');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BleSearchingScreen(
                                                        ssid: wifiProvider
                                                            .ssid.text,
                                                        password: wifiProvider
                                                            .password.text,
                                                        userName: userName,
                                                        macAddress: provider
                                                            .scannedDevices[
                                                                index]
                                                            .device
                                                            .id
                                                            .toString()),
                                              ),
                                            );
                                          }
                                        });
                                      });
                                    });
                                  },
                                  child: provider.isConnecting[index]
                                      ? LoadingAnimationWidget.waveDots(
                                          color: Colors.grey,
                                          size: 20,
                                        )
                                      : const Text('Connect'),
                                ),
                              ),
                            );
                          }),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (!provider.isScanning) {
                provider.scanDevices();
              }
            },
            child: !provider.isScanning
                ? const Icon(Icons.refresh)
                : const Icon(Icons.stop),
          ));
    });
  }
}
