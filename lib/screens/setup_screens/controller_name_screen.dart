import 'package:culti_app/core/utils/utils.dart';
import 'package:culti_app/provider/devices_provider.dart';
import 'package:culti_app/screens/setup_screens/wifi_credentials_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:spring_button/spring_button.dart';

import '../../widgets/custom_text_field.dart';

class ControllerNameScreen extends StatefulWidget {
  const ControllerNameScreen({super.key});

  @override
  State<ControllerNameScreen> createState() => _ControllerNameScreenState();
}

class _ControllerNameScreenState extends State<ControllerNameScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DevicesProvider>(builder: (context, provider, child) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    height: 15,
                    width: MediaQuery.of(context).size.width,
                    color: const Color(0xff37B44B),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: SvgPicture.asset('assets/cultiapp_logo.svg'),
                  ),
                  const Text(
                    'Enter Controller Name',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomTextField(
                    hintText: 'Controller Name',
                    controller: provider.deviceName,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                    child: SpringButton(
                      SpringButtonType.OnlyScale,
                      Container(
                        height: 40,
                        width: 115,
                        decoration: const BoxDecoration(
                            color: Color(0xff37B44B),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: const Center(
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
                        if (provider.deviceName.text.isNotEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const WifiCredentialsScreen()));
                        } else {
                          showToast('Please enter controller name');
                        }
                      },
                    ),
                  ),
                  const Row(
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
