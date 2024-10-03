import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../provider/home_provider.dart';

class LightWidget extends StatelessWidget {
  const LightWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Radio<int>(
                      activeColor: Colors.black,
                      value: 0,
                      groupValue: provider.lightControlAllIndividually,
                      onChanged: (int? value) {
                        provider.lightControlAllIndividuallyHandle(value!);
                      },
                    ),
                    const Text(
                      'Control all',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Radio<int>(
                      activeColor: Colors.black,
                      value: 1,
                      groupValue: provider.lightControlAllIndividually,
                      onChanged: (int? value) {
                        provider.lightControlAllIndividuallyHandle(value!);
                        provider.selectLED(1);
                        provider.selectedLED(1);
                      },
                    ),
                    const Text(
                      'Individually',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10), child: Divider()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Dim Up/Down: ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  provider.showNumberPicker(context, 0);
                },
                child: Container(
                  width: 50,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                      child: Text(
                    provider.lightDimUpDown.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  )),
                ),
              ),
              const Text(
                ' min.',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '÷',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: SfSliderTheme(
                    data:
                        SfSliderThemeData(tooltipBackgroundColor: Colors.blue),
                    child: SfSlider(
                      activeColor: const Color(0xff50A1FF),
                      inactiveColor: const Color(0xff50A1FF),
                      max: 100.0,
                      onChanged: (dynamic values) {
                        provider.slider1(values);
                      },
                      value: provider.activeSliderValue1,
                      enableTooltip: true,
                      numberFormat: NumberFormat('#'),
                    ),
                  ),
                ),
                const Text(
                  '+',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Text(
            'Dim: ${provider.activeSliderValue1.toInt()}%',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          const Padding(
              padding: EdgeInsets.fromLTRB(40, 25, 40, 20), child: Divider()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'ON:  ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    showPicker(
                      is24HrFormat: true,
                      displayHeader: false,
                      showSecondSelector: false,
                      disableHour: false,
                      context: context,
                      value: provider.lightOn,
                      sunrise: TimeOfDay(hour: 6, minute: 0),
                      // // optional
                      sunset: TimeOfDay(hour: 18, minute: 0),
                      // optional
                      duskSpanInMinutes: 120,
                      // optional
                      onChange: provider.lightOnTimeChanged,
                    ),
                  );
                },
                child: Container(
                  width: 50,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                      child: Text(
                    '${provider.lightOn.hour}:${provider.lightOn.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  )),
                ),
              ),
              const SizedBox(
                width: 40,
              ),
              const Text(
                'OFF:  ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    showPicker(
                      is24HrFormat: true,
                      displayHeader: false,
                      showSecondSelector: false,
                      disableHour: false,
                      context: context,
                      value: provider.lightOff,
                      duskSpanInMinutes: 120,
                      onChange: provider.lightOffTimeChanged,
                    ),
                  );
                },
                child: Container(
                  width: 50,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                      child: Text(
                    '${provider.lightOff.hour}:${provider.lightOff.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  )),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '÷',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: SfSliderTheme(
                    data: SfSliderThemeData(
                        tooltipBackgroundColor: const Color(0xffFFDD50)),
                    child: SfSlider(
                      activeColor: const Color(0xffFFDD50),
                      inactiveColor: const Color(0xffFFDD50),
                      max: 100.0,
                      onChanged: (dynamic values) {
                        provider.slider2(values);
                      },
                      value: provider.activeSliderValue2,
                      enableTooltip: true,
                      numberFormat: NumberFormat('#'),
                    ),
                  ),
                ),
                const Text(
                  '+',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Text(
            'Operation: ${provider.activeSliderValue2.toInt()}%',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 5), child: Divider()),
          provider.lightControlAllIndividually == 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        provider.selectLED(1);
                        provider.selectedLED(1);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: provider.selectedLEDValue == 1
                              ? Colors.grey.shade700
                              : Colors.grey.shade400,
                        ),
                        child: const Center(
                            child: Text(
                          '1',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        provider.selectLED(2);
                        provider.selectedLED(1);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: provider.selectedLEDValue == 2
                              ? Colors.grey.shade700
                              : Colors.grey.shade400,
                        ),
                        child: const Center(
                            child: Text(
                          '2',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        provider.selectLED(3);
                        provider.selectedLED(1);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: provider.selectedLEDValue == 3
                              ? Colors.grey.shade700
                              : Colors.grey.shade400,
                        ),
                        child: const Center(
                            child: Text(
                          '3',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    )
                  ],
                )
              : const SizedBox(),
        ],
      );
    });
  }
}
