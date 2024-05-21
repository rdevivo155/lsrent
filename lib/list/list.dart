import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:ls_rent/model/response/shifts_response.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../services/shared.dart';

ShiftsResponse? shiftsResponse;

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidget();
}

class ListShits extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Turni'),
        ),
        body: MyStatefulWidget(),
        backgroundColor: baseBackgroundColor);
  }
}

class _MyStatefulWidget extends State<MyStatefulWidget> {
  static const int numItems = 10;
  List<bool> selected = List<bool>.generate(numItems, (int index) => false);
  DateTime? selectedDate;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  Future downloadData() async {
    print("init");

    final authToken = await getBasicAuth();
    try {
      final response = await http.get(
          Uri.parse(baseUrl + "/api/v1/shifts?year=${selectedDate?.year}&month=${selectedDate?.month}"),
          headers: <String, String>{
            'Authorization': "Bearer " + authToken!
          }).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        shiftsResponse = ShiftsResponse.fromJson(jsonDecode(response.body));
        shiftsResponse!.data!.dataModels!
            .sort((a, b) => a.timeStart!.compareTo(b.timeStart!));
      } else if (response.statusCode == 401 || response.statusCode >= 500) {}

      return response;
    } on TimeoutException catch (_) {
      print("non funziona");
      // checkError(0, "Connessione assente!");
    } // return your response
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: downloadData(),
        builder: (context, projectSnap) {
          if (projectSnap.data != null) {
            return Scaffold(
                backgroundColor: Colors.white,
                body: Container(
                    child: Column(children: [
                  SizedBox(height: 30),
                  Center(
                      child: Text(
                    'Anno: ${selectedDate?.year}\nMese: ${selectedDate?.month}',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  )),
                  FloatingActionButton(
                    onPressed: () {
                      showMonthPicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1970),
                              lastDate: DateTime(2050))
                          .then((date) async {
                        setState(() {
                          loading = true;
                        });
                        var calendar = await downloadData();
                        if (date != null) {
                          setState(() {
                            loading = false;
                            selectedDate = date;
                          });
                        } else {
                           setState(() {
                            loading = false;
                          });
                        }
                      });
                    },
                    child: Icon(Icons.calendar_today),
                    backgroundColor: baseBackgroundColor,
                  ),
                  !loading
                      ? Expanded(
                          child: RefreshIndicator(
                              onRefresh: () async {
                                setState(() {
                                  loading = true;
                                });
                                await downloadData();
                                setState(() {
                                  loading = false;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 50),
                                child: SizedBox(
                                    width: double.infinity,
                                    child: SingleChildScrollView(
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        child: FittedBox(
                                            alignment: Alignment.center,
                                            child: DataTable(
                                              horizontalMargin: 20,
                                              dataRowHeight: 60,
                                              columns: const <DataColumn>[
                                                DataColumn(
                                                  label: Center(
                                                      child: Text('Inizio',
                                                          textAlign: TextAlign
                                                              .center)),
                                                ),
                                                DataColumn(
                                                  label: Center(
                                                      child: Text('Fine',
                                                          textAlign: TextAlign
                                                              .center)),
                                                ),
                                                DataColumn(
                                                  label: Center(
                                                      child: Text('Stato',
                                                          textAlign: TextAlign
                                                              .center)),
                                                ),
                                              ],
                                              rows: shiftsResponse != null
                                                  ? List<DataRow>.generate(
                                                      shiftsResponse!
                                                              .data!.count ??
                                                          0,
                                                      (int index) => DataRow(
                                                        color: MaterialStateProperty
                                                            .resolveWith<
                                                                Color?>((Set<
                                                                    MaterialState>
                                                                states) {
                                                          // All rows will have the same selected color.
                                                          if (states.contains(
                                                              MaterialState
                                                                  .selected)) {
                                                            return Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary
                                                                .withOpacity(
                                                                    0.08);
                                                          }
                                                          // Even rows will have a grey color.
                                                          if (index.isEven) {
                                                            return Colors.grey
                                                                .withOpacity(
                                                                    0.3);
                                                          }
                                                          return null; // Use default value for other states and odd rows.
                                                        }),
                                                        cells: <DataCell>[
                                                          DataCell(Text(shiftsResponse
                                                                      ?.data
                                                                      ?.dataModels?[
                                                                          index]
                                                                      .employeeTimeStart !=
                                                                  null
                                                              ? (DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(
                                                                  shiftsResponse
                                                                          ?.data
                                                                          ?.dataModels?[
                                                                              index]
                                                                          .employeeTimeStart ??
                                                                      "")))
                                                              : (DateFormat(
                                                                      "dd/MM/yyyy HH:mm")
                                                                  .format(DateTime.parse(shiftsResponse?.data?.dataModels?[index].timeStart ?? ""))))),
                                                          DataCell(Text(shiftsResponse
                                                                      ?.data
                                                                      ?.dataModels?[
                                                                          index]
                                                                      .employeeTimeEnd !=
                                                                  null
                                                              ? (DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(shiftsResponse
                                                                      ?.data
                                                                      ?.dataModels?[
                                                                          index]
                                                                      .employeeTimeEnd ??
                                                                  shiftsResponse
                                                                      ?.data
                                                                      ?.dataModels?[
                                                                          index]
                                                                      .timeEnd ??
                                                                  "")))
                                                              : (DateFormat("dd/MM/yyyy HH:mm")
                                                                  .format(DateTime.parse(shiftsResponse?.data?.dataModels?[index].timeEnd ?? ""))))),
                                                          DataCell(shiftsResponse
                                                                      ?.data
                                                                      ?.dataModels?[
                                                                          index]
                                                                      .type !=
                                                                  0
                                                              ? Container(
                                                                  width: 20,
                                                                  height: 20,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Color(
                                                                        0xff1b9c28),
                                                                  ),
                                                                )
                                                              : Container(
                                                                  width: 20,
                                                                  height: 20,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Color(
                                                                        0xfff4af49),
                                                                  ),
                                                                )),
                                                        ],
                                                      ),
                                                    )
                                                  : [],
                                            )))),
                              )))
                      : Container(
                          padding: EdgeInsets.all(100),
                          child: const CircularProgressIndicator(
                            color: baseBackgroundColor,
                          ),
                        )
                ])));
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          }
        });
  }
}
