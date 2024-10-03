import 'package:culti_app/provider/user_provider.dart';
import 'package:culti_app/screens/home_screen.dart';
import 'package:culti_app/screens/setup_screens/setup_one_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 4), () {
        final userName =
            Provider.of<UserProvider>(context, listen: false).getUserName();
        if (userName.isNotEmpty) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SetUpOneScreen()));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/logo.svg',
                color: Colors.green,
                height: MediaQuery.of(context).size.height * 0.2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
