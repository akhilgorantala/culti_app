import 'package:culti_app/provider/home_provider.dart';
import 'package:culti_app/provider/mqtt_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:spring_button/spring_button.dart';

import '../widgets/fan_pump_widget.dart';
import '../widgets/light_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MQTTProvider>(context, listen: false).connect();
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      homeProvider.selectedLED(0);
      homeProvider.selectedFAN(0);
      homeProvider.getControlFan();
      homeProvider.getControlLight();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return Scaffold(
        body: SafeArea(
          child: SizedBox(
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
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          customButton: Container(
                            child: SvgPicture.asset(
                              'assets/menu.svg',
                              height: 30,
                            ),
                          ),
                          items: [
                            ...MenuItems.firstItems.map(
                              (item) => DropdownMenuItem<MenuItem>(
                                value: item,
                                child: MenuItems.buildItem(item),
                              ),
                            ),
                            const DropdownMenuItem<Divider>(
                                enabled: false, child: Divider()),
                            ...MenuItems.secondItems.map(
                              (item) => DropdownMenuItem<MenuItem>(
                                value: item,
                                child: MenuItems.buildItem(item),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            MenuItems.onChanged(context, value! as MenuItem);
                            print(value);
                            print('akhil');
                          },
                          dropdownStyleData: DropdownStyleData(
                            width: 250,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white,
                            ),
                            offset: const Offset(0, 8),
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            customHeights: [
                              ...List<double>.filled(
                                  MenuItems.firstItems.length, 60),
                              8,
                              ...List<double>.filled(
                                  MenuItems.secondItems.length, 60),
                            ],
                            padding: const EdgeInsets.only(left: 16, right: 16),
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/cultiapp_logo.svg',
                        height: 40,
                        width: 150,
                      ),
                      SvgPicture.asset(
                        'assets/cloud.svg',
                        height: 30,
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                  child: Text(
                    'Controller Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        provider.lightFanSwitch(0);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 40,
                        decoration: BoxDecoration(
                            color: provider.selectedIndex == 0
                                ? const Color(0xff37B44B)
                                : const Color(0xffE1F4E4),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            provider.selectedIndex == 0
                                ? SvgPicture.asset('assets/white_light.svg')
                                : SvgPicture.asset('assets/green_light.svg'),
                            Text(
                              ' LIGHT',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: provider.selectedIndex == 0
                                    ? Colors.white
                                    : const Color(0xff37B44B),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        provider.lightFanSwitch(1);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 40,
                        decoration: BoxDecoration(
                            color: provider.selectedIndex == 1
                                ? const Color(0xff37B44B)
                                : const Color(0xffE1F4E4),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            provider.selectedIndex == 1
                                ? SvgPicture.asset('assets/white_fan.svg')
                                : SvgPicture.asset('assets/green_fan.svg'),
                            Text(
                              ' FAN/PUMP',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: provider.selectedIndex == 1
                                    ? Colors.white
                                    : const Color(0xff37B44B),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: provider.controller,
                    scrollDirection: Axis.horizontal,
                    children: const [
                      LightWidget(),
                      FanPumpWidget(),
                    ],
                  ),
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
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: const Center(
                        child: Text(
                          'SET',
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
                      if (provider.selectedIndex == 0) {
                        print('Light');
                        var data = provider.controlLight();
                        print(data);
                        Provider.of<MQTTProvider>(context, listen: false)
                            .publish('akhil/LED_Setup', data);
                      } else if (provider.selectedIndex == 1) {
                        print('Fan/Pump');
                        var data = provider.controlFanPump();
                        print(data);
                        Provider.of<MQTTProvider>(context, listen: false)
                            .publish('akhil/FAN_Setup', data);
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
                SizedBox(
                  height: 70,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.svgAsset,
  });

  final String text;
  final String svgAsset; // Path to the SVG asset
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [home, share, settings];
  static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(
      text: ' Controller Setup', svgAsset: 'assets/menu/controller_setup.svg');
  static const share =
      MenuItem(text: ' Help Center', svgAsset: 'assets/menu/help_center.svg');
  static const settings =
      MenuItem(text: ' Community', svgAsset: 'assets/menu/community.svg');
  static const logout =
      MenuItem(text: ' My Account', svgAsset: 'assets/menu/my_account.svg');

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        SvgPicture.asset(item.svgAsset,
            color: Colors.green, width: 22, height: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item.text) {
      // Note: Switching on `item.text` as we cannot switch on the instance directly.
      case 'Home':
        //Do something
        break;
      case 'Settings':
        //Do something
        break;
      case 'Share':
        //Do something
        break;
      case 'Log Out':
        //Do something
        break;
    }
  }
}
