import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:ls_rent/constants/globals.dart' as globals;

class TimePicker extends StatefulWidget {
  const TimePicker(
      {Key? key,
      required this.color,
      required this.isStartHour,
      required this.isROL})
      : super(key: key);

  final Color color;
  final bool isStartHour;
  final bool isROL;

  @override
  State<TimePicker> createState() => _TimePickerState();
}

TimeOfDay stringToTimeOfDay(String s) {
  String sub = s.substring(0, s.length - 1);
  String time = sub.substring(10);
  return TimeOfDay(
      hour: int.parse(time.split(":")[0]),
      minute: int.parse(time.split(":")[1]));
}

class _TimePickerState extends State<TimePicker> {
  TimeOfDay _currentTime = TimeOfDay.now();
  String currentTime = "";
  DateTime date = DateTime.now();
  String currentTimeString = "";

  @override
  void initState() {
    super.initState();
    currentTimeString = widget.isROL ? "" : formatTimeOfDay(_currentTime);
    // controllerStartTime.text = currentTimeString;
    // controllerEndTime.text = currentTimeString;
  }

  void _showDatePicker(ctx) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 500,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  SizedBox(
                    height: 400,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        use24hFormat: true,
                        dateOrder: DatePickerDateOrder.ymd,
                        initialDateTime: widget.isROL ? null : date,
                        onDateTimeChanged: (val) {
                          setState(() {
                            date = val;
                            currentTime = val.toString();
                            _currentTime = stringToTimeOfDay(currentTime);
                            if (widget.isStartHour) {
                              globals.startHour = formatTimeOfDay(_currentTime);
                            } else {
                              globals.endHour = formatTimeOfDay(_currentTime);
                            }
                          });
                        }),
                  ),

                  // Close the modal
                  CupertinoButton(
                    child: const Text('OK'),
                    onPressed: () {
                      setState(() {
                        currentTime = date.toString();
                        _currentTime = stringToTimeOfDay(currentTime);
                        currentTimeString = formatTimeOfDay(_currentTime);
                        ;
                        if (widget.isStartHour) {
                          // controllerStartTime.text = currentTimeString;

                          globals.startHour = formatTimeOfDay(_currentTime);
                        } else {
                          // controllerEndTime.text = currentTimeString;

                          globals.endHour = formatTimeOfDay(_currentTime);
                        }
                      });
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          width: 110,
          height: 48,
          child: Center(
              child: Text(
            "DATA",
            // widget.isStartHour,
            // ? controllerStartTime.text
            // : controllerEndTime.text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
          decoration: BoxDecoration(
            // border: Border.all(color: (isDarkMode) ? white : grey),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
          ),
        ),
        Container(
          width: 40,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            color: widget.color,
          ),
          child: IconButton(
              onPressed: () {
                _showDatePicker(context);
              },
              // onPressed: () {
              //   showTimePicker(
              //     cancelText: '',
              //     context: context,
              //     initialTime: TimeOfDay.now(),
              //   ).then((value) {
              //     setState(() {
              //       currentTime = value.toString();
              //       _currentTime = stringToTimeOfDay(currentTime);
              //       if (widget.isStartHour) {
              //         globals.startHour = formatTimeOfDay(_currentTime);
              //       } else {
              //         globals.endHour = formatTimeOfDay(_currentTime);
              //       }
              //     });
              //   });
              // },
              icon: const Icon(
                Icons.access_time,
                color: Colors.white,
              )),
        ),
      ],
    );
  }
}

String formatTimeOfDay(TimeOfDay tod) {
  final now = new DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  final format = DateFormat("HH:mm"); //"6:00 AM"
  return format.format(dt);
}
