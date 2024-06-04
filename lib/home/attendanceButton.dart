import 'package:flutter/material.dart';

class AttendanceButtonWidget extends StatelessWidget {

  final bool isStartedAttendance;
  final bool isEndedAttendance;
  final bool loading;
  final VoidCallback onTap;

  AttendanceButtonWidget(
      {required this.isStartedAttendance,
      required this.isEndedAttendance,
      required this.loading,
      required this.onTap});

  Color createColor() {
    if (!isStartedAttendance && !isEndedAttendance) {
      return Color(0xff44b930);
    } else if (isStartedAttendance && !isEndedAttendance) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                    color: createColor(),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 82,
                      height: 20,
                      child: Text(
                        !isStartedAttendance ? "INIZIO" : "FINE",
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
          ),
        ]),
      ),
    );
  }
}