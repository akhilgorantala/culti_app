import 'dart:io';

import 'package:culti_app/provider/ble_provider.dart';
import 'package:culti_app/provider/configure_provider.dart';
import 'package:culti_app/provider/date_time_format.dart';
import 'package:culti_app/provider/devices_provider.dart';
import 'package:culti_app/provider/home_provider.dart';
import 'package:culti_app/provider/mqtt_provider.dart';
import 'package:culti_app/provider/user_provider.dart';
import 'package:culti_app/provider/wifi_provider.dart';
import 'package:culti_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'di_container.dart' as di;

Future<void> main() async {
  if (Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    await di.init();
    [
      Permission.location,
      Permission.locationWhenInUse,
      Permission.locationAlways,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan
    ].request().then((status) {
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (ctx) => di.sl<HomeProvider>()),
            ChangeNotifierProvider(create: (ctx) => di.sl<ConfigureProvider>()),
            ChangeNotifierProvider(create: (ctx) => di.sl<UserProvider>()),
            ChangeNotifierProvider(create: (ctx) => di.sl<DateTimeFormat>()),
            ChangeNotifierProvider(create: (ctx) => di.sl<BleProvider>()),
            ChangeNotifierProvider(create: (ctx) => di.sl<WifiProvider>()),
            ChangeNotifierProvider(create: (ctx) => di.sl<DevicesProvider>()),
            ChangeNotifierProvider(create: (ctx) => di.sl<MQTTProvider>()),
          ],
          child: MyApp(),
        ),
      );
    });
  } else {
    WidgetsFlutterBinding.ensureInitialized();
    await di.init();
    [
      Permission.location,
      Permission.locationWhenInUse,
      Permission.locationAlways,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan
    ].request().then((status) {
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (ctx) => di.sl<HomeProvider>()),
            ChangeNotifierProvider(create: (ctx) => di.sl<ConfigureProvider>()),
            ChangeNotifierProvider(create: (ctx) => di.sl<MQTTProvider>()),
            ChangeNotifierProvider(create: (ctx) => di.sl<UserProvider>()),
            ChangeNotifierProvider(create: (ctx) => di.sl<DateTimeFormat>()),
            ChangeNotifierProvider(create: (ctx) => di.sl<BleProvider>()),
            ChangeNotifierProvider(create: (ctx) => di.sl<WifiProvider>()),
            ChangeNotifierProvider(create: (ctx) => di.sl<DevicesProvider>()),
          ],
          child: const MyApp(),
        ),
      );
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Culti App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Mon',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: const SplashScreen());
  }
}
