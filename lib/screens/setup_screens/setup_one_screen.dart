import 'package:culti_app/screens/setup_screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spring_button/spring_button.dart';

class SetUpOneScreen extends StatefulWidget {
  const SetUpOneScreen({super.key});

  @override
  State<SetUpOneScreen> createState() => _SetUpOneScreenState();
}

class _SetUpOneScreenState extends State<SetUpOneScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                  'Plug in controller\npower plug',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              Image.asset('assets/hardware.png'),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                child: SpringButton(
                  SpringButtonType.OnlyScale,
                  Container(
                    height: 40,
                    width: 115,
                    decoration: BoxDecoration(
                        color: Color(0xff37B44B),
                        borderRadius: BorderRadius.all(Radius.circular(100))),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
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
    );
  }
}
