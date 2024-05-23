import 'package:flutter/material.dart';
import '../model/response/shift_of_the_day_response.dart';
import '../home/vehicleInfo.dart';
import '../home/turnInfo.dart';
import '../home/attendanceButton.dart';
import '../home/dataTable.dart';

// Widget per la gestione del dashboard principale
class DashboardWidget extends StatelessWidget {
  final BuildContext context;
  final ShiftOfTheDayResponse? shiftOfTheDayResponse;
  final bool isEndedAttendance;
  final Function editShift;
  final String addressVehicle;

  DashboardWidget({
    required this.context,
    this.shiftOfTheDayResponse,
    required this.isEndedAttendance,
    required this.editShift,
    required this.addressVehicle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              "Prossimo turno con il veicolo:",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          )),
      VehicleInfoWidget(context: context, shiftOfTheDayResponse: shiftOfTheDayResponse),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.center,
          child: Text(addressVehicle, textAlign: TextAlign.center),
        ),
      ),
      TurnInfoWidget(context: context, shiftOfTheDayResponse: shiftOfTheDayResponse),
      SizedBox(height: 20),
      AttendanceButtonWidget(isEndedAttendance: isEndedAttendance, editShift: editShift),
      shiftOfTheDayResponse?.data?.employeeTimeStart != null
          ? DataTableWidget(shiftOfTheDayResponse: shiftOfTheDayResponse)
          : SizedBox()
    ]);
  }
}