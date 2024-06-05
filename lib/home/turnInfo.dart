import 'package:flutter/material.dart';
import '../model/response/shift_of_the_day_response.dart';

// Widget per mostrare le informazioni del turno
class TurnInfoWidget extends StatelessWidget {
  final BuildContext context;
  final ShiftOfTheDayResponse? shiftOfTheDayResponse;

  TurnInfoWidget({required this.context, this.shiftOfTheDayResponse});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Row(mainAxisSize: MainAxisSize.max, children: [
          Flexible(
            flex: 50,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Row(children: [
                  Flexible(
                      flex: 50,
                      child: Container(
                                                    child: Column(children: [
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "INIZIO TURNO:",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.left,
                            ))
                      ]))),
                  SizedBox(width: 2),
                  Flexible(
                      flex: 50,
                      child: Container(
                          child: Column(children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              shiftOfTheDayResponse != null
                                  ? shiftOfTheDayResponse!
                                      .data!.timeStart!
                                      .split(" ")[1]
                                      .substring(0, 5)
                                  : "",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.left,
                            ))
                      ])))
                ]),
                Row(children: [
                  Flexible(
                      flex: 50,
                      child: Container(
                          child: Column(children: [
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "FINE TURNO:",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.left,
                            ))
                      ]))),
                  SizedBox(width: 2),
                  Flexible(
                      flex: 50,
                      child: Container(
                          child: Column(children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              shiftOfTheDayResponse != null
                                  ? shiftOfTheDayResponse!
                                      .data!.timeEnd!
                                      .split(" ")[1]
                                      .substring(0, 5)
                                  : "",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.left,
                            ))
                      ])))
                ])
              ]),
            ),
          ),
        ]));
  }
}