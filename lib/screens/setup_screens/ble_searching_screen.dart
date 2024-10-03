import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../provider/ble_provider.dart';
import '../../provider/devices_provider.dart';
import '../home_screen.dart';

class BleSearchingScreen extends StatefulWidget {
  final String ssid;
  final String password;
  final String userName;
  final String macAddress;

  const BleSearchingScreen({
    super.key,
    required this.ssid,
    required this.password,
    required this.userName,
    required this.macAddress,
  });

  @override
  State<BleSearchingScreen> createState() => _BleSearchingScreenState();
}

class _BleSearchingScreenState extends State<BleSearchingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final bleProvider = Provider.of<BleProvider>(context, listen: false);
      bleProvider
          .sendData(
              '{"SSID":"${widget.ssid}","PASS":"${widget.password}","rcv_did":"${widget.userName}"}')
          .whenComplete(() {
        bleProvider.device.connectionState.listen((event) {
          if (event == BluetoothConnectionState.disconnected) {
            final deviceProvider =
                Provider.of<DevicesProvider>(context, listen: false);
            deviceProvider.addDevice(
                deviceProvider.deviceName.text, widget.macAddress);
            Future.delayed(const Duration(seconds: 4), () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            });
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BleProvider>(builder: (context, provider, child) {
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
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: SvgPicture.asset('assets/cultiapp_logo.svg'),
              ),
              if (provider.isSent == null)
                Column(
                  children: [
                    LottieBuilder.asset(
                        'assets/lotti/43352-wifi-searching.json'),
                    Text(
                      'Searching..',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                )
              else if (provider.isSent == true)
                Column(
                  children: [
                    LottieBuilder.asset('assets/lotti/121018-done.json'),
                    Text(
                      'Device Found!',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                )
              else if (provider.isSent == false)
                Column(
                  children: [
                    LottieBuilder.asset('assets/lotti/133064-angry-cloud.json'),
                    Text(
                      'No Device Found!',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                )
            ],
          ),
        ),
      );
    });
  }
}
