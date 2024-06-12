import 'dart:io';

import 'package:culti_app/core/utils/utils.dart';
import 'package:culti_app/provider/configure_provider.dart';
import 'package:culti_app/screens/searching_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spring_button/spring_button.dart';

import '../../widgets/custom_text_field.dart';

class WifiCredentialsScreen extends StatefulWidget {
  const WifiCredentialsScreen({super.key});

  @override
  State<WifiCredentialsScreen> createState() => _WifiCredentialsScreenState();
}

class _WifiCredentialsScreenState extends State<WifiCredentialsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ConfigureProvider>(context, listen: false).getssid();
      if (Platform.isAndroid) {
        Provider.of<ConfigureProvider>(context, listen: false).getFrequency();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConfigureProvider>(builder: (context, provider, child) {
      return Scaffold(
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
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
                  // PageView(
                  //   children: [],
                  // ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Text(
                      'Enter your\nwifi credentials',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),

                  CustomTextField(
                    hintText: 'SSID',
                    controller: provider.ssid,
                  ),
                  CustomTextField(
                    hintText: 'Password',
                    controller: provider.password,
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                    child: SpringButton(
                      SpringButtonType.OnlyScale,
                      Container(
                        height: 40,
                        width: 115,
                        decoration: BoxDecoration(
                            color: Color(0xff37B44B),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: Center(
                          child: Text(
                            'NEXT',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      scaleCoefficient: 0.95,
                      onTap: () {
                        if (provider.password.text.length >= 6) {
                          if (Platform.isAndroid) {
                            if (provider.frequency == 2) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchingScreen()));
                            } else {
                              showToast('Please Connect to 2.4GHz Wifi!');
                            }
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchingScreen()));
                          }
                        } else {
                          showToast('Please Enter Password!');
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info,
                        color: Color(0xff37B44B),
                      ),
                      Text(
                        ' Help Center',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff37B44B),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
