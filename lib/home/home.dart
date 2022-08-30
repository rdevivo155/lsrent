import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../../components/button.dart';
import '../model/response/shift_of_the_day_response.dart';
import '../model/response/vehicle_model_response.dart';
import '../model/response/vehicle_response.dart';
import '../services/shared.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

ShiftOfTheDayResponse? shiftOfTheDayResponse;
VehicleResponse? vehicleResponse;
VehicleModelResponse? vehicleModelResponse;

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MyStatefulWidget(), backgroundColor: Colors.white);
  }
}

List<Card> _buildGridCards(BuildContext context) {
  List<Button> buttons = [];
  buttons[0] = Button(name: 'Sinistro', icon: 'sinistro');
  // buttons[1] = Button(name: 'Pagamenti', icon: 'Pagamenti');
  buttons[1] = Button(name: 'Guasto', icon: 'guasto');
  // buttons[3] = Button(name: 'Permessi', icon: 'permessi');

  if (buttons.isEmpty) {
    return const <Card>[];
  }

  final ThemeData theme = Theme.of(context);

  return buttons.map((button) {
    return Card(
      clipBehavior: Clip.antiAlias,
      // TODO: Adjust card heights (103)
      elevation: 0.0,
      child: Column(
        // TODO: Center items on the card (103)
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 18 / 11,
            child: Image.asset(
              'assets/shipping.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
              child: Column(
                // TODO: Align labels to the bottom and center (103)
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                // TODO: Change innermost Column (103)
                children: <Widget>[
// TODO: Handle overflowing labels (103)
                  Text(
                    button.name,
                    style: theme.textTheme.button,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  // End new code
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }).toList();
}

// _getLocation(double lat, double long) async {
//   Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high);
//   debugPrint('location: ${position.latitude}');
//   final coordinates = new Coordinates(lat, long);
//   var addresses =
//       await Geocoder.local.findAddressesFromCoordinates(coordinates);
//   var first = addresses.first;
//   print("${first.featureName} : ${first.addressLine}");
// }

DataTable _createDataTable() {
  return DataTable(columns: _createColumns(), rows: _createRows());
}

List<DataColumn> _createColumns() {
  return [
    DataColumn(label: Text('Verso')),
    DataColumn(label: Text('Orario')),
    DataColumn(label: Text('Luogo')),
  ];
}

List<DataRow> _createRows() {
  return [
    shiftOfTheDayResponse?.data?.employeeTimeStart != null
        ? DataRow(cells: [
            DataCell(Text('INIZIO')),
            DataCell(Text(DateFormat("HH:mm").format(DateTime.parse(
                shiftOfTheDayResponse?.data?.employeeTimeStart ?? "")))),
            DataCell(Text('via giordano bruno 163')),
          ])
        : DataRow(cells: [DataCell(Text(''))]),
    shiftOfTheDayResponse?.data?.employeeTimeEnd != null
        ? DataRow(cells: [
            DataCell(Text('FINE')),
            DataCell(Text(DateFormat("HH:mm").format(DateTime.parse(
                shiftOfTheDayResponse?.data?.employeeTimeEnd ?? "")))),
            DataCell(Text('via iannielli 103')),
          ])
        : DataRow(cells: [
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
          ])
  ];
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool isStartedAttendance = false;
  bool isEndedAttendance = false;

  Future editShift() async {
    print("init");
    // Position? position = await Geolocator.getLastKnownPosition();

    // print('${position}');
    final authToken = await getBasicAuth();
    print(authToken);
    try {
      var response = await http
          .put(
              Uri.parse(
                  "https://api.lsrent.ml/api/v1/shifts/${shiftOfTheDayResponse!.data!.id}"),
              headers: <String, String>{
                'Authorization': "Bearer " + authToken!
              },
              body: isStartedAttendance
                  ? {
                      "employee_time_start": DateTime.now().toIso8601String(),
                      "employee_geolocation_start":
                          "{\"lat\":40.90834,\"lng\":14.34993}"
                    }
                  : {
                      "employee_time_end": DateTime.now().toIso8601String(),
                      "employee_geolocation_end":
                          "{\"lat\":40.90834,\"lng\":14.34993}"
                    })
          .timeout((const Duration(seconds: 10)));

      print(response.statusCode);
      print("errore : ${response.statusCode}");
      if (response.statusCode == 202) {
        setState(() {
          shiftOfTheDayResponse =
              ShiftOfTheDayResponse.fromJson(jsonDecode(response.body));
        });

        await getVehicle();
      } else if (response.statusCode == 401 || response.statusCode >= 500) {}
      return response;
    } on TimeoutException catch (_) {
      print("non funziona");
      // checkError(0, "Connessione assente!");
    } // return your response
  }

  Future downloadData() async {
    print("init");
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position pos = await Geolocator.getCurrentPosition();
    print(pos);
    final authToken = await getBasicAuth();
    try {
      var response = await http.get(
          Uri.parse("https://api.lsrent.ml/api/v1/shifts/me"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer " + authToken!
          }).timeout((const Duration(seconds: 10)));

      if (response.statusCode == 200) {
        shiftOfTheDayResponse =
            ShiftOfTheDayResponse.fromJson(jsonDecode(response.body));
        await getVehicle();
        isStartedAttendance =
            shiftOfTheDayResponse?.data?.employeeTimeStart != null
                ? true
                : false;
        isEndedAttendance =
            shiftOfTheDayResponse?.data?.employeeTimeEnd != null ? true : false;
        var arrayString = shiftOfTheDayResponse?.data?.geolocationStart
            ?.replaceAll("\"", "")
            .replaceAll(",", ":")
            .split(":");
        var lat = "";
        var lon = shiftOfTheDayResponse?.data?.geolocationStart
            ?.replaceAll("\"", "")
            .replaceAll(",", ":")
            .replaceAll("}", " ")
            .split(":")[3];
        List<Placemark> placemarks = await placemarkFromCoordinates(
            double.parse(lat ?? ""), double.parse(lon ?? ""));
        print(placemarks);
        Placemark place = placemarks[0];
        var address =
            '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      } else if (response.statusCode == 401 ||
          response.statusCode == 404 ||
          response.statusCode >= 500) {}
      return response;
    } on TimeoutException catch (_) {
      print("non funziona");
      // checkError(0, "Connessione assente!");
    } // return your response
  }

  Future getVehicle() async {
    print("init");
    // Position? position = await Geolocator.getLastKnownPosition();

    // print('${position}');
    final authToken = await getBasicAuth();
    try {
      var response = await http.get(
          Uri.parse(
              "https://api.lsrent.ml/api/v1/vehicles/${shiftOfTheDayResponse!.data!.vehicleId}"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer " + authToken!
          }).timeout((const Duration(seconds: 10)));

      if (response.statusCode == 200) {
        vehicleResponse = VehicleResponse.fromJson(jsonDecode(response.body));
        await getVehicleModel();
      } else if (response.statusCode == 401 || response.statusCode >= 500) {}
      return response;
    } on TimeoutException catch (_) {
      print("non funziona");
      // checkError(0, "Connessione assente!");
    }
  }

  Future getVehicleModel() async {
    print("init");
    // Position? position = await Geolocator.getLastKnownPosition();

    // print('${position}');
    final authToken = await getBasicAuth();
    try {
      var response = await http.get(
          Uri.parse(
              "https://api.lsrent.ml/api/v1/vehicle-models/${vehicleResponse!.data!.vehicleModelId}"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer " + authToken!
          }).timeout((const Duration(seconds: 10)));

      if (response.statusCode == 200) {
        vehicleModelResponse =
            VehicleModelResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401 || response.statusCode >= 500) {}
      return response;
    } on TimeoutException catch (_) {
      print("non funziona");
      // checkError(0, "Connessione assente!");
    }
  }

  Future sendPosition() async {
    print("init");
    // Position? position = await Geolocator.getLastKnownPosition();

    // print('${position}');
    final authToken = await getBasicAuth();
    try {
      var response = await http.get(
          Uri.parse("https://api.lsrent.ml/api/v1/shifts/me"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer " + authToken!
          }).timeout((const Duration(seconds: 10)));

      if (response.statusCode == 200) {
        shiftOfTheDayResponse =
            ShiftOfTheDayResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401 || response.statusCode >= 500) {}
      return response;
    } on TimeoutException catch (_) {
      print("non funziona");
      // checkError(0, "Connessione assente!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: downloadData(),
        builder: (context, projectSnap) {
          if (projectSnap.data != null) {
            return Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  actions: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/profile');
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Icon(
                          Icons.account_circle,
                          size: 26.0,
                        ),
                      ),
                    ),
                  ],
                ),
                body: Column(children: <Widget>[
                  Column(children: <Widget>[
                    const SizedBox(height: 8.0),
                    shiftOfTheDayResponse != null
                        ? Column(children: <Widget>[
                            Padding(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Flexible(
                                          flex: 100,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                          ))
                                    ])),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Flexible(
                                        flex: 50,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Column(children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.asset(
                                                  'assets/shipping.png'),
                                            )
                                          ]),
                                        )),
                                    Flexible(
                                        flex: 50,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Column(children: <Widget>[
                                            SizedBox(height: 40.0),
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  vehicleModelResponse
                                                          ?.data?.brand ??
                                                      "",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                )),
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  vehicleModelResponse
                                                          ?.data?.description ??
                                                      "",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                )),
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  vehicleResponse
                                                          ?.data?.carPlate ??
                                                      "",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                )),
                                          ]),
                                        )),
                                  ],
                                ))
                          ])
                        : Column(),
                    SizedBox(height: 20),
                    shiftOfTheDayResponse != null
                        ? Column(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Flexible(
                                          flex: 50,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Column(children: <Widget>[
                                              Row(children: [
                                                Flexible(
                                                    flex: 50,
                                                    child: Container(
                                                        child:
                                                            Column(children: [
                                                      Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "INIZIO TURNO:",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  "Montserrat",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ))
                                                    ]))),
                                                Flexible(
                                                    flex: 50,
                                                    child: Container(
                                                        child:
                                                            Column(children: [
                                                      Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            shiftOfTheDayResponse !=
                                                                    null
                                                                ? shiftOfTheDayResponse!
                                                                    .data!
                                                                    .timeStart!
                                                                    .split(
                                                                        " ")[1]
                                                                    .substring(
                                                                        0, 5)
                                                                : "",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  "Montserrat",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ))
                                                    ])))
                                              ]),
                                              Row(children: [
                                                Flexible(
                                                    flex: 50,
                                                    child: Container(
                                                        child:
                                                            Column(children: [
                                                      Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "FINE TURNO:",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  "Montserrat",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ))
                                                    ]))),
                                                Flexible(
                                                    flex: 50,
                                                    child: Container(
                                                        child:
                                                            Column(children: [
                                                      Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            shiftOfTheDayResponse !=
                                                                    null
                                                                ? shiftOfTheDayResponse!
                                                                    .data!
                                                                    .timeEnd!
                                                                    .split(
                                                                        " ")[1]
                                                                    .substring(
                                                                        0, 5)
                                                                : "",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  "Montserrat",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ))
                                                    ])))
                                              ])
                                            ]),
                                          ),
                                        ),
                                      ]))
                            ],
                          )
                        : Column(
                            children: [
                              Text(
                                "Nessun turno caricato",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                    SizedBox(height: 30),
                    shiftOfTheDayResponse != null
                        ? Column(
                            children: [
                              GestureDetector(
                                onTap: () => setState(() {
                                  if (!isEndedAttendance) {
                                    isStartedAttendance = !isStartedAttendance;
                                    editShift();
                                  }
                                  // sendPosition();
                                }),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
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
                                              color: !isStartedAttendance &&
                                                      !isEndedAttendance
                                                  ? Color(0xff44b930)
                                                  : (isStartedAttendance &&
                                                          !isEndedAttendance
                                                      ? Colors.red
                                                      : Colors.grey),
                                            ),
                                          ),
                                          Positioned.fill(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: SizedBox(
                                                width: 80,
                                                height: 18,
                                                child: Text(
                                                  !isStartedAttendance
                                                      ? "INIZIO"
                                                      : "FINE",
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
                              ),
                            ],
                          )
                        : Container(
                            height: 100,
                          ),
                    shiftOfTheDayResponse?.data?.employeeTimeStart != null
                        ? _createDataTable()
                        : SizedBox(),
                  ]),

                  Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed('/stateOfVehicle');
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width - 20,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x3ff4af49),
                                        blurRadius: 4,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                    color: Colors.amber,
                                  ),
                                  margin: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      bottom: 0.0,
                                      top: 0),
                                  padding: const EdgeInsets.only(
                                    left: 25,
                                    right: 29,
                                    top: 11,
                                    bottom: 21,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Container(
                                      //   width: 96,
                                      //   height: 96,
                                      //   child:
                                      //       Image.asset('assets/crashedCar.png'),
                                      // ),
                                      Text(
                                        "Stato del veicolo",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      )),
                  Expanded(
                      child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Container(
                            height: MediaQuery.of(context).size.height / 3,
                            decoration: new BoxDecoration(
                              color: Color(0x4d7BCEFD),
                              // borderRadius: new BorderRadius.only(
                              //   topLeft: const Radius.circular(40.0),
                              //   topRight: const Radius.circular(40.0),
                              // )
                            ),
                            margin: const EdgeInsets.only(
                                left: 0.0, right: 0.0, bottom: 0.0, top: 0),
                            child: Expanded(
                              child: Align(
                                child: GridView.count(
                                    physics: NeverScrollableScrollPhysics(),
                                    crossAxisCount: 2,
                                    padding: const EdgeInsets.all(8.0),
                                    childAspectRatio: 8.0 / 9.0,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushNamed('/accident');
                                          },
                                          child: Container(
                                            width: 150,
                                            height: 150,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 150,
                                                  height: 150,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color:
                                                            Color(0x3ff4af49),
                                                        blurRadius: 4,
                                                        offset: Offset(0, 3),
                                                      ),
                                                    ],
                                                    color: Colors.white,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 25,
                                                    right: 29,
                                                    top: 11,
                                                    bottom: 21,
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        width: 96,
                                                        height: 96,
                                                        child: Image.asset(
                                                            'assets/crashedCar.png'),
                                                      ),
                                                      Text(
                                                        "Sinistro",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontFamily:
                                                              "Montserrat",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .pushNamed('/accident');
                                        },
                                        child: Container(
                                          width: 150,
                                          height: 150,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 150,
                                                height: 150,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0x3ff4af49),
                                                      blurRadius: 4,
                                                      offset: Offset(0, 3),
                                                    ),
                                                  ],
                                                  color: Colors.white,
                                                ),
                                                padding: const EdgeInsets.only(
                                                  left: 24,
                                                  right: 30,
                                                  top: 11,
                                                  bottom: 21,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 96,
                                                      height: 96,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Image.asset(
                                                          'assets/damage.png'),
                                                    ),
                                                    SizedBox(
                                                      width: 71,
                                                      child: Text(
                                                        "Guasto",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontFamily:
                                                              "Montserrat",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          )))

                  //non qua
                ]));
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          }
        });
  }
}
