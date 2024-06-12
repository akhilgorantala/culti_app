import 'package:culti_app/provider/configure_provider.dart';
import 'package:culti_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SearchingScreen extends StatefulWidget {
  const SearchingScreen({super.key});

  @override
  State<SearchingScreen> createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ConfigureProvider>(context, listen: false)
          .startPro()
          .then((value) {
        print(value);
        if (value == true) {
          Future.delayed(Duration(seconds: 2), () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConfigureProvider>(builder: (context, provider, child) {
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
              if (provider.isConfig == null)
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
              else if (provider.isConfig == true)
                Column(
                  children: [
                    LottieBuilder.asset('assets/lotti/121018-done.json'),
                    Text(
                      'Device Found!',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                )
              else if (provider.isConfig == false)
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
