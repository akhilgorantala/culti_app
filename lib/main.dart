import 'dart:io';

import 'package:appspector/appspector.dart';
import 'package:culti_app/provider/configure_provider.dart';
import 'package:culti_app/provider/date_format_provider.dart';
import 'package:culti_app/provider/home_provider.dart';
import 'package:culti_app/provider/mqtt_provider.dart';
import 'package:culti_app/provider/user_provider.dart';
import 'package:culti_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'di_container.dart' as di;

Future<void> main() async {
  if (Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    runAppSpector();
    await di.init();
    [
      Permission.location,
      Permission.locationWhenInUse,
      Permission.locationAlways,
    ].request().then((status) {
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (ctx) => di.sl<HomeProvider>()),
            ChangeNotifierProvider(create: (ctx) => di.sl<ConfigureProvider>()),
            ChangeNotifierProvider(create: (ctx) => di.sl<MQTTProvider>()),
            ChangeNotifierProvider(create: (ctx) => di.sl<UserProvider>()),
            ChangeNotifierProvider(
                create: (ctx) => di.sl<DateFormatProvider>()),
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
    ].request().then((status) {
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (ctx) => di.sl<HomeProvider>()),
            ChangeNotifierProvider(create: (ctx) => di.sl<ConfigureProvider>()),
            ChangeNotifierProvider(create: (ctx) => di.sl<MQTTProvider>()),
            ChangeNotifierProvider(create: (ctx) => di.sl<UserProvider>()),
            ChangeNotifierProvider(
                create: (ctx) => di.sl<DateFormatProvider>()),
          ],
          child: MyApp(),
        ),
      );
    });
  }
}

void runAppSpector() {
  final config = Config()
    ..iosApiKey = "Your iOS API_KEY"
    ..androidApiKey =
        "android_ODRjNzdkZGMtZjgyMS00M2VhLWFjMDEtZWNhZjViZDI1MmU0";

  // If you don't want to start all monitors you can specify a list of necessary ones
  config.monitors = [Monitors.http, Monitors.logs, Monitors.screenshot];

  AppSpectorPlugin.run(config);
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
        home: SplashScreen());
  }
}
