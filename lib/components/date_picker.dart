import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final date = DateTime.now().add(Duration(days: 1));

class DatePicker extends StatefulWidget {
  final Function() notifyParent;

  const DatePicker(
      {Key? key,
      required this.color,
      required this.isStartDate,
      required this.correctDate,
      required this.isDisabled,
      required this.days,
      required this.notifyParent,
      required this.activeStartDate})
      : super(key: key);

  final Color color;
  final bool isStartDate;
  final bool isDisabled;
  final String correctDate;
  final int days;
  final bool activeStartDate;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  String _correctDate = "";
  // @override
  // void initState() {
  //   super.initState();
  //   _correctDate = widget.correctDate;
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 110,
          height: 48,
          child: Center(
              child: Text(
            widget.correctDate,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
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
                if (!widget.isDisabled) {
                  showDatePicker(
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                          cancelText: '',
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now())
                      .then((value) {
                    setState(() {
                      if (widget.isStartDate) {
                        //   globals.startDate = formatISODate(value ?? date);
                        //   globals.startDateGMT = value ?? date;
                        //   globals.endDateGMT = value ?? date;
                        //   globals.endDate = formatISODate(value ?? date);
                        //   _correctDate = formatISODate(value ?? date);
                        // } else {
                        //   globals.endDate = formatISODate(value ?? date);
                        //   globals.endDateGMT = value ?? date;
                        //   _correctDate = formatISODate(value ?? date);
                        // }

                        // print("fine data: ${globals.endDateGMT}");
                        // print("inizio data: ${globals.startDateGMT}");
                      }
                      widget.notifyParent();
                    });
                  });
                }
              },
              icon: const Icon(
                Icons.calendar_today,
                color: Colors.red,
              )),
        ),
      ],
    );
  }
}

String formatDate(DateTime date) {
  final formatted = DateFormat('dd-MM-y').format(date);
  return formatted;
}

String formatISODate(DateTime date) {
  final formatted = DateFormat('y-MM-dd').format(date);
  return formatted;
}
