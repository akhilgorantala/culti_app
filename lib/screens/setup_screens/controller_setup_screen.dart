import 'package:culti_app/screens/home_screen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spring_button/spring_button.dart';

class ControllerSetupScreen extends StatefulWidget {
  const ControllerSetupScreen({super.key});

  @override
  State<ControllerSetupScreen> createState() => _ControllerSetupScreenState();
}

class _ControllerSetupScreenState extends State<ControllerSetupScreen> {
  final List<String> chooseProduct = [
    'CultKit',
    'CultCase',
    'CultBox',
  ];
  String? chooseProductValue;

  final List<String> chooseMedium = [
    'Aeroponic',
    'Hydroponic',
    'Soil (Water Pump)',
    'Soil (No Pump)',
  ];
  String? chooseMediumValue;

  final List<String> chooseSchedule = [
    '10/14 hour (on/off)',
    '12/12 hour (on/off)',
    '18/6 hour (on/off)',
    '24 hour (on)',
  ];
  String? chooseScheduleValue;

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
                  'Choose\nsettings',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),

              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: const Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(
                            '1. Choose Product',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff37B44B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  items: chooseProduct
                      .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff37B44B),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ))
                      .toList(),
                  value: chooseProductValue,
                  onChanged: (String? value) {
                    setState(() {
                      chooseProductValue = value;
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 50,
                    width: 285,
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30), // Rounded border
                      color: Color(0xffE1F4E4),
                    ),
                    elevation: 2,
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                    ),
                    iconSize: 25,
                    iconEnabledColor: Color(0xff37B44B),
                    iconDisabledColor: Colors.grey,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14), // Rounded border
                      color: Colors.white,
                    ),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(0),
                      thickness: MaterialStateProperty.all<double>(6),
                      thumbVisibility: MaterialStateProperty.all<bool>(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.only(left: 14, right: 14),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: const Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(
                            '2. Choose Medium',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff37B44B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  items: chooseMedium
                      .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff37B44B),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ))
                      .toList(),
                  value: chooseMediumValue,
                  onChanged: (String? value) {
                    setState(() {
                      chooseMediumValue = value;
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 50,
                    width: 285,
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30), // Rounded border
                      color: Color(0xffE1F4E4),
                    ),
                    elevation: 2,
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                    ),
                    iconSize: 25,
                    iconEnabledColor: Color(0xff37B44B),
                    iconDisabledColor: Colors.grey,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14), // Rounded border
                      color: Colors.white,
                    ),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(0),
                      thickness: MaterialStateProperty.all<double>(6),
                      thumbVisibility: MaterialStateProperty.all<bool>(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.only(left: 14, right: 14),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: const Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(
                            '3. Choose Schedule',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff37B44B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  items: chooseSchedule
                      .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff37B44B),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ))
                      .toList(),
                  value: chooseScheduleValue,
                  onChanged: (String? value) {
                    setState(() {
                      chooseScheduleValue = value;
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 50,
                    width: 285,
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30), // Rounded border
                      color: Color(0xffE1F4E4),
                    ),
                    elevation: 2,
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                    ),
                    iconSize: 25,
                    iconEnabledColor: Color(0xff37B44B),
                    iconDisabledColor: Colors.grey,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14), // Rounded border
                      color: Colors.white,
                    ),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(0),
                      thickness: MaterialStateProperty.all<double>(6),
                      thumbVisibility: MaterialStateProperty.all<bool>(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.only(left: 14, right: 14),
                  ),
                ),
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
                        MaterialPageRoute(builder: (context) => HomeScreen()));
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
