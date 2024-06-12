import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
// import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../provider/home_provider.dart';

class FanPumpWidget extends StatefulWidget {
  const FanPumpWidget({
    super.key,
  });

  @override
  State<FanPumpWidget> createState() => _FanPumpWidgetState();
}

class _FanPumpWidgetState extends State<FanPumpWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return SingleChildScrollView(
        child: Column(
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
                        groupValue: provider.fanControlAllIndividually,
                        onChanged: (int? value) {
                          provider.fanControlAllIndividuallyHandle(value!);
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
                        groupValue: provider.fanControlAllIndividually,
                        onChanged: (int? value) {
                          provider.fanControlAllIndividuallyHandle(value!);
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
                  'Start: ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    provider.showNumberPicker(context, 1);
                  },
                  child: Container(
                    width: 50,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                        child: Text(
                      provider.fanStart.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    )),
                  ),
                ),
                Radio<int>(
                  activeColor: Colors.black,
                  value: 1,
                  groupValue: provider.startSecMin,
                  onChanged: (int? value) {
                    provider.startHandle(value!);
                  },
                ),
                const Text(
                  'Sec.',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
                Radio<int>(
                  activeColor: Colors.black,
                  value: 2,
                  groupValue: provider.startSecMin,
                  onChanged: (int? value) {
                    provider.startHandle(value!);
                  },
                ),
                const Text(
                  'Min.',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Stop: ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    provider.showNumberPicker(context, 2);
                  },
                  child: Container(
                    width: 50,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                        child: Text(
                      provider.fanStop.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    )),
                  ),
                ),
                Radio<int>(
                  activeColor: Colors.black,
                  value: 1,
                  groupValue: provider.stopSecMin,
                  onChanged: (int? value) {
                    provider.stopHandle(value!);
                  },
                ),
                const Text(
                  'Sec.',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
                Radio<int>(
                  activeColor: Colors.black,
                  value: 2,
                  groupValue: provider.stopSecMin,
                  onChanged: (int? value) {
                    provider.stopHandle(value!);
                  },
                ),
                const Text(
                  'Min.',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
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
                        value: provider.fanOn,
                        sunrise: TimeOfDay(hour: 6, minute: 0),
                        // // optional
                        sunset: TimeOfDay(hour: 18, minute: 0),
                        // optional
                        duskSpanInMinutes: 120,
                        // optional
                        onChange: provider.fanOnTimeChanged,
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
                      '${provider.fanOn.hour}:${provider.fanOn.minute.toString().padLeft(2, '0')}',
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
                        value: provider.fanOff,
                        sunrise: TimeOfDay(hour: 6, minute: 0),
                        // // optional
                        sunset: TimeOfDay(hour: 18, minute: 0),
                        // optional
                        duskSpanInMinutes: 120,
                        // optional
                        onChange: provider.fanOffTimeChanged,
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
                      '${provider.fanOff.hour}:${provider.fanOff.minute.toString().padLeft(2, '0')}',
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
                          tooltipBackgroundColor: const Color(0xff37B44B)),
                      child: SfSlider(
                        activeColor: const Color(0xff37B44B),
                        inactiveColor: const Color(0xff37B44B),
                        max: 100.0,
                        onChanged: (dynamic values) {
                          provider.slider3(values);
                        },
                        value: provider.activeSliderValue3,
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
              'Power: ${provider.activeSliderValue3.toInt()}%',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
            const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 10), child: Divider()),
            provider.fanControlAllIndividually == 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          provider.selectFAN(1);
                          provider.selectedFAN(1);
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: provider.selectedFANValue == 1
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
                          provider.selectFAN(2);
                          provider.selectedFAN(1);
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: provider.selectedFANValue == 2
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
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      );
    });
  }
}
