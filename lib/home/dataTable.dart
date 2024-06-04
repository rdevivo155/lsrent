import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/response/shift_of_the_day_response.dart';

// Widget per la visualizzazione della tabella dei turni
class DataTableWidget extends StatelessWidget {
  final ShiftOfTheDayResponse? shiftOfTheDayResponse;
  final String address1;
  final String address2;

  DataTableWidget({this.shiftOfTheDayResponse, required this.address1, required this.address2});

  @override
  Widget build(BuildContext context) {
    return _createDataTable(shiftOfTheDayResponse, address1, address2);
  }
}

DataTable _createDataTable(ShiftOfTheDayResponse? shiftOfTheDayResponse, String address1, String address2) {
  return DataTable(
    columns: _createColumns(),
    rows: _createRows(shiftOfTheDayResponse, address1, address2),
    dataRowHeight: 100,
  );
}

List<DataColumn> _createColumns() {
  return [
    DataColumn(
      label: Container(width: 50, child: Text('Verso')),
    ),
    DataColumn(label: Container(width: 50, child: Text('Orario'))),
    DataColumn(label: Container(width: 100, child: Text('Luogo')))
  ];
}

List<DataRow> _createRows(ShiftOfTheDayResponse? shiftOfTheDayResponse, String address1, String address2) {
  return [
    shiftOfTheDayResponse?.data?.employeeTimeStart != null
        ? DataRow(cells: [
            DataCell(Container(width: 50, child: Text('INIZIO'))),
            DataCell(Container(
                width: 50,
                child: Text(DateFormat("HH:mm").format(DateTime.parse(
                    shiftOfTheDayResponse?.data?.employeeTimeStart ?? ""))))),
            DataCell(Text(address1)),
          ])
        : DataRow(cells: [DataCell(Text(''))]),
    shiftOfTheDayResponse?.data?.employeeTimeEnd != null
        ? DataRow(cells: [
            DataCell(Text('FINE')),
            DataCell(Text(DateFormat("HH:mm").format(DateTime.parse(
                shiftOfTheDayResponse?.data?.employeeTimeEnd ?? "")))),
            DataCell(Text(address2)),
          ])
        : DataRow(cells: [
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
          ])
  ];
}
