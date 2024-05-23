import 'package:flutter/material.dart';
import '../model/response/shift_of_the_day_response.dart';

// Widget per la visualizzazione della tabella dei turni
class DataTableWidget extends StatelessWidget {
  final ShiftOfTheDayResponse? shiftOfTheDayResponse;

  DataTableWidget({this.shiftOfTheDayResponse});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: <DataColumn>[
        DataColumn(label: Text('Verso')),
        DataColumn(label: Text('Orario')),
        DataColumn(label: Text('Luogo')),
      ],
      rows: <DataRow>[
        DataRow(cells: [
          DataCell(Text('INIZIO')),
           DataCell(Text(shiftOfTheDayResponse?.data?.employeeTimeStart != null
              ? DateFormat("HH:mm").format(DateTime.parse(shiftOfTheDayResponse!.data!.employeeTimeStart!))
              : "")),
          DataCell(Text(shiftOfTheDayResponse?.data?.geolocationStart ?? "")),
        ]),
        DataRow(cells: [
          DataCell(Text('FINE')),
          DataCell(Text(shiftOfTheDayResponse?.data?.employeeTimeEnd != null
              ? DateFormat("HH:mm").format(DateTime.parse(shiftOfTheDayResponse!.data!.employeeTimeEnd!))
              : "")),
          DataCell(Text(shiftOfTheDayResponse?.data?.geolocationEnd ?? "")),
        ]),
      ],
    );
  }
}