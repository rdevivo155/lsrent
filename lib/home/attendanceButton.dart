import 'package:flutter/material.dart';

// Widget per il bottone di timbratura
class AttendanceButtonWidget extends StatelessWidget {
  final bool isEndedAttendance;
  final Function editShift;

  AttendanceButtonWidget({required this.isEndedAttendance, required this.editShift});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        if (!isEndedAttendance)
          {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Attenzione"),
                    content: Text("Sicuro di voler timbrare?"),
                    actions: [
                      ElevatedButton(
                        child: Text("Ok"),
                        onPressed: () {
                          editShift();
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                })
          }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(children: <Widget>[
          Container(
            width: 82,
            height: 77,
            child: Stack(
              children: [
                Container(
                  width: 82,
                  height: 77,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x3f000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                    color: !isEndedAttendance ? Colors.green : Colors.red,
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 80,
                      height: 18,
                      child: Text(
                        !isEndedAttendance ? "INIZIO" : "FINE",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}