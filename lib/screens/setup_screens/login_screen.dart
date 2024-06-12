import 'package:culti_app/provider/configure_provider.dart';
import 'package:culti_app/screens/home_screen.dart';
import 'package:culti_app/screens/setup_screens/wifi_credentials_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spring_button/spring_button.dart';

import '../../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ConfigureProvider>(builder: (context, provider, child) {
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
                      'Setup\nController',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Text(
                    'Login with your account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomTextField(
                    hintText: 'Username',
                    controller: provider.userName,
                  ),
                  CustomTextField(
                    hintText: 'Password',
                    controller: provider.userPassword,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      'Check your order confirmation email\nor go to our website to set up account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Container(
                        width: 107,
                        height: 45,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                            child: Text(
                          '7:00 AM',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        )),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 25,
                        width: 25,
                        child: Checkbox(value: false, onChanged: (value) {}),
                      ),
                      Text(
                        ' 24 hours clock',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
                        provider.login().then((value) {
                          if (value != false && provider.isDemo != false) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          } else if (value != false &&
                              provider.isDemo == false) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        WifiCredentialsScreen()));
                          }
                        });
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
