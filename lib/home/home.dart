import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';

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

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool isStartedAttendance = false;

  Future editShift() async {
    print("init");
    // Position? position = await Geolocator.getLastKnownPosition();

    // print('${position}');
    final authToken = await getBasicAuth();
    print(authToken);
    try {
      var response = await http.put(
          Uri.parse("https://api.lsrent.ml/api/v1/shifts"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer " + authToken!
          },
          body: {
            "employee_time_start": DateTime.now(),
            "employee_time_end": DateTime.now(),
            "employee_geolocation_start": "{\"lat\":40.90834,\"lng\":14.34993}",
            "employee_geolocation_end": "{\"lat\":40.90834,\"lng\":14.34993}"
          }).timeout((const Duration(seconds: 10)));

      print("errore : ${response.statusCode}");
      if (response.statusCode == 200) {
        shiftOfTheDayResponse =
            ShiftOfTheDayResponse.fromJson(jsonDecode(response.body));
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
    // Position? position = await Geolocator.getLastKnownPosition();

    // print('${position}');
    final authToken = await getBasicAuth();
    print(authToken);
    try {
      var response = await http.get(
          Uri.parse("https://api.lsrent.ml/api/v1/shifts/me"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer " + authToken!
          }).timeout((const Duration(seconds: 10)));

      log(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        shiftOfTheDayResponse =
            ShiftOfTheDayResponse.fromJson(jsonDecode(response.body));
        await getVehicle();
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
    print(authToken);
    try {
      var response = await http.get(
          Uri.parse(
              "https://api.lsrent.ml/api/v1/vehicles/${shiftOfTheDayResponse!.data!.vehicleId}"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer " + authToken!
          }).timeout((const Duration(seconds: 10)));

      log(response.body);
      print(response.statusCode);
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
    print(authToken);
    try {
      var response = await http.get(
          Uri.parse(
              "https://api.lsrent.ml/api/v1/vehicle-models/${vehicleResponse!.data!.vehicleModelId}"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer " + authToken!
          }).timeout((const Duration(seconds: 10)));

      log(response.body);
      print(response.statusCode);
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
    print(authToken);
    try {
      var response = await http.get(
          Uri.parse("https://api.lsrent.ml/api/v1/shifts/me"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer " + authToken!
          }).timeout((const Duration(seconds: 10)));

      log(response.body);
      print(response.statusCode);
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
                body: SafeArea(
                    child: ListView(
                  children: <Widget>[
                    const SizedBox(height: 20.0),
                    Column(children: <Widget>[
                      const SizedBox(height: 8.0),
                      shiftOfTheDayResponse != null
                          ? Column(children: <Widget>[
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
                                              const Text(
                                                "Prossimo turno con il veicolo:",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Image.asset('assets/shipping.png')
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
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    vehicleModelResponse
                                                            ?.data?.brand ??
                                                        "",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: "Montserrat",
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  )),
                                              Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    vehicleModelResponse?.data
                                                            ?.description ??
                                                        "",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: "Montserrat",
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  )),
                                              Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    vehicleResponse
                                                            ?.data?.carPlate ??
                                                        "",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: "Montserrat",
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
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
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "INIZIO",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    "Montserrat",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
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
                                                                      .split(" ")[
                                                                          1]
                                                                      .substring(
                                                                          0, 5)
                                                                  : "",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    "Montserrat",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
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
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "FINE",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    "Montserrat",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
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
                                                                      .split(" ")[
                                                                          1]
                                                                      .substring(
                                                                          0, 5)
                                                                  : "",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    "Montserrat",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ))
                                                      ])))
                                                ]),
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
                                    isStartedAttendance = !isStartedAttendance;
                                    if (isStartedAttendance) {
                                      editShift();
                                    }
                                    sendPosition();
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
                                                color: !isStartedAttendance
                                                    ? Color(0xff44b930)
                                                    : Colors.red,
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
                                                      fontWeight:
                                                          FontWeight.w700,
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
                          : Column(
                              children: [
                                SizedBox(
                                  height: 400,
                                )
                              ],
                            ),
                      SizedBox(height: 130),
                    ]),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height,
                            decoration: new BoxDecoration(
                              color: Color(0x4d7BCEFD),
                              // borderRadius: new BorderRadius.only(
                              //   topLeft: const Radius.circular(40.0),
                              //   topRight: const Radius.circular(40.0),
                              // )
                            ),
                            margin: const EdgeInsets.only(
                                left: 0.0, right: 0.0, bottom: 0.0, top: 50),
                            child: GridView.count(
                                crossAxisCount: 2,
                                padding: const EdgeInsets.all(16.0),
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
                                                left: 25,
                                                right: 29,
                                                top: 11,
                                                bottom: 21,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 96,
                                                    height: 96,
                                                    child: Image.asset(
                                                        'assets/crashedCar.png'),
                                                  ),
                                                  Text(
                                                    "Sinistro",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontFamily: "Montserrat",
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
                                  // Container(
                                  //   width: 150,
                                  //   height: 150,
                                  //   child: Row(
                                  //     mainAxisSize: MainAxisSize.min,
                                  //     mainAxisAlignment: MainAxisAlignment.center,
                                  //     crossAxisAlignment: CrossAxisAlignment.center,
                                  //     children: [
                                  //       Container(
                                  //         width: 150,
                                  //         height: 150,
                                  //         decoration: BoxDecoration(
                                  //           borderRadius: BorderRadius.circular(15),
                                  //           boxShadow: [
                                  //             BoxShadow(
                                  //               color: Color(0x3ff4af49),
                                  //               blurRadius: 4,
                                  //               offset: Offset(0, 3),
                                  //             ),
                                  //           ],
                                  //           color: Colors.white,
                                  //         ),
                                  //         padding: const EdgeInsets.only(
                                  //           left: 26,
                                  //           right: 23,
                                  //           top: 5,
                                  //           bottom: 26,
                                  //         ),
                                  //         child: Column(
                                  //           mainAxisSize: MainAxisSize.min,
                                  //           mainAxisAlignment: MainAxisAlignment.end,
                                  //           crossAxisAlignment: CrossAxisAlignment.center,
                                  //           children: [
                                  //             Container(
                                  //               width: 96,
                                  //               height: 96,
                                  //               child: Image.asset('assets/wallet.png'),
                                  //             ),
                                  //             SizedBox(height: 1),
                                  //             Text(
                                  //               "Pagamenti",
                                  //               textAlign: TextAlign.center,
                                  //               style: TextStyle(
                                  //                 color: Colors.black,
                                  //                 fontSize: 14,
                                  //                 fontFamily: "Montserrat",
                                  //                 fontWeight: FontWeight.w600,
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  Container(
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
                                            mainAxisSize: MainAxisSize.min,
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
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Image.asset(
                                                    'assets/damage.png'),
                                              ),
                                              SizedBox(
                                                width: 71,
                                                child: Text(
                                                  "Guasto",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // InkWell(
                                  //     onTap: () {
                                  //       Navigator.of(context).pushNamed('/day-off');
                                  //     },
                                  //     child: Container(
                                  //       width: 150,
                                  //       height: 150,
                                  //       child: Row(
                                  //         mainAxisSize: MainAxisSize.min,
                                  //         mainAxisAlignment: MainAxisAlignment.center,
                                  //         crossAxisAlignment: CrossAxisAlignment.center,
                                  //         children: [
                                  //           Container(
                                  //             width: 150,
                                  //             height: 150,
                                  //             decoration: BoxDecoration(
                                  //               borderRadius: BorderRadius.circular(15),
                                  //               boxShadow: [
                                  //                 BoxShadow(
                                  //                   color: Color(0x3ff4af49),
                                  //                   blurRadius: 4,
                                  //                   offset: Offset(0, 3),
                                  //                 ),
                                  //               ],
                                  //               color: Colors.white,
                                  //             ),
                                  //             padding: const EdgeInsets.only(
                                  //               left: 13,
                                  //               right: 11,
                                  //               top: 13,
                                  //               bottom: 21,
                                  //             ),
                                  //             child: Column(
                                  //               mainAxisSize: MainAxisSize.min,
                                  //               mainAxisAlignment: MainAxisAlignment.end,
                                  //               crossAxisAlignment:
                                  //                   CrossAxisAlignment.center,
                                  //               children: [
                                  //                 Container(
                                  //                   width: 96,
                                  //                   height: 96,
                                  //                   child:
                                  //                       Image.asset('assets/dayOff.png'),
                                  //                 ),
                                  //                 SizedBox(
                                  //                   width: 126,
                                  //                   child: Text(
                                  //                     "Permessi",
                                  //                     textAlign: TextAlign.center,
                                  //                     style: TextStyle(
                                  //                       color: Colors.black,
                                  //                       fontSize: 14,
                                  //                       fontFamily: "Montserrat",
                                  //                       fontWeight: FontWeight.w600,
                                  //                     ),
                                  //                   ),
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ))
                                ]),
                          )
                        ]),
                    new Positioned(
                        left: 30.0,
                        bottom: 30.0,
                        child: new Container(
                          width: 100.0,
                          height: 80.0,
                          decoration: new BoxDecoration(color: Colors.red),
                          child: new Text('hello'),
                        )),
                  ],
                )));
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          }
        });
  }
}
