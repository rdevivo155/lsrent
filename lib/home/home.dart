import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import '../constants/constants.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:connectivity/connectivity.dart';
import '../../components/button.dart';
import '../model/response/shift_of_the_day_response.dart';
import '../model/response/vehicle_model_response.dart';
import '../model/response/vehicle_response.dart';
import '../services/shared.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';

ShiftOfTheDayResponse? shiftOfTheDayResponse;
VehicleResponse? vehicleResponse;
VehicleModelResponse? vehicleModelResponse;
String addressVehicle = "";
String address1 = "";
String address2 = "";
bool serviceEnabled = false;
LocationPermission permission = LocationPermission.denied;

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child:
            Scaffold(body: MyStatefulWidget(), backgroundColor: Colors.white));
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
                    style: theme.textTheme.labelLarge,
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

DataTable _createDataTable() {
  return DataTable(
    columns: _createColumns(),
    rows: _createRows(),
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

List<DataRow> _createRows() {
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

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool isStartedAttendance = false;
  bool isEndedAttendance = false;
  bool scan = false;
  bool loading = false;
  bool isoffline = false;
  String _authStatus = 'Unknown';
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  initState() {
    super.initState();
    checkConnectivity();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Esegui un'azione quando la connessione torna online
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        // Connessione tornata online
        print('La connessione è tornata online');
        setState(() {
          isoffline = false;
        });
        // Esegui altre azioni necessarie qui
      } else {
        setState(() {
          isoffline = true;
        });
      }
    });
    initPlugin();
    //setupInteractedMessage();
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // Mostra un popup quando non c'è connessione di rete
      showNoConnectionPopup();
    }
  }

  void showNoConnectionPopup() {
    isoffline = true;
    Fluttertoast.showToast(
      msg: "Nessuna connessione di rete",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    setState(() => _authStatus = '$status');
    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      // Show a custom explainer dialog before the system dialog
      await showCustomTrackingDialog(context);
      // Wait for dialog popping animation
      // await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      final TrackingStatus status =
          await AppTrackingTransparency.requestTrackingAuthorization();
      setState(() => _authStatus = '$status');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("UUID: $uuid");
  }

  Future<void> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Attenzione'),
          content: const Text(
            'I tuoi dati verranno utilizzati a fini di analisi e monitoraggio dei percorsi effettuati durante le operazioni di trasporto.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue'),
            ),
          ],
        ),
      );

  Future editShift() async {
    try {
      Position? position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (position == "null") {
        throw Exception('Position is null');
      }
      final authToken = await getBasicAuth();
      var response = await http
          .put(
              Uri.parse(baseUrl + "/api/v1/shifts/update/${shiftOfTheDayResponse!.data!.id}"),
              headers: <String, String>{
                'Authorization': "Bearer " + authToken!
              },
              body: !isStartedAttendance
                  ? {
                      "employee_time_start": DateTime.now().toIso8601String(),
                      "employee_geolocation_start": "{\"lat\":${position.latitude},\"lng\":${position.longitude}}"
                    }
                  : {
                      "employee_time_end": DateTime.now().toIso8601String(),
                      "employee_geolocation_end": "{\"lat\":${position.latitude},\"lng\":${position.longitude}}"
                    })
          .timeout((const Duration(seconds: 10)));

      if (response.statusCode == 202) {
        setState(() {
          loading = false;
          shiftOfTheDayResponse =
              ShiftOfTheDayResponse.fromJson(jsonDecode(response.body));
        });
        await getVehicle();
      } else if (response.statusCode == 401 || response.statusCode >= 500) {
        showSnackBar(context, 'Errore di autenticazione.');
      }
      return response;
    } on TimeoutException catch (_) {
      setState(() {
        loading = false;
      });
      showSnackBar(context, 'Errore di connessione');
    } catch (e) {
      showSnackBar(context, 'An error occurred: ${e.toString()}');
    }
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future downloadData() async {
    checkConnectivity();

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
   
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Attenzione"),
                content: Text(
                    "Se non attivi la localizzazione non ti sarà concesso di usare l'app"),
                actions: [
                  ElevatedButton(
                    child: Text("Ok"),
                    onPressed: () {
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
    
      return Future.error('Location permissions are denied');
    }

    final authToken = await getBasicAuth();
    print(authToken);
    try {
      var response = await http.get(Uri.parse(baseUrl + "/api/v1/shifts/me"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer " + (authToken ?? "")
          }).timeout((const Duration(seconds: 15)));

      if (response.statusCode == 200) {
        shiftOfTheDayResponse =
            ShiftOfTheDayResponse.fromJson(jsonDecode(response.body));

        setEmployee(shiftOfTheDayResponse?.data?.employeeId.toString() ?? "");
        setVehicle(shiftOfTheDayResponse?.data?.vehicleId .toString() ?? "");
        await getVehicle();
        isStartedAttendance =
            shiftOfTheDayResponse?.data?.employeeTimeStart != null
                ? true
                : false;
        isEndedAttendance =
            shiftOfTheDayResponse?.data?.employeeTimeEnd != null ? true : false;
        var latV = shiftOfTheDayResponse?.data?.geolocationStart
            ?.replaceAll("\"", "")
            .replaceAll(",", ":")
            .replaceAll("}", " ")
            .split(":")[1];
        var lonV = shiftOfTheDayResponse?.data?.geolocationStart
            ?.replaceAll("\"", "")
            .replaceAll(",", ":")
            .replaceAll("}", " ")
            .split(":")[3];
        List<Placemark> placemarksV = await placemarkFromCoordinates(
            double.parse(latV ?? ""), double.parse(lonV ?? ""));
        print(placemarksV);
        Placemark placeV = placemarksV[0];
        addressVehicle = '${placeV.street}, ${placeV.locality}';

        var arrayString = shiftOfTheDayResponse?.data?.employeeGeolocationStart
            ?.replaceAll("\"", "")
            .replaceAll(",", ":")
            .split(":");
        print(arrayString);
        var lat = shiftOfTheDayResponse?.data?.employeeGeolocationStart
            ?.replaceAll("\"", "")
            .replaceAll(",", ":")
            .replaceAll("}", " ")
            .split(":")[1];
        var lon = shiftOfTheDayResponse?.data?.employeeGeolocationStart
            ?.replaceAll("\"", "")
            .replaceAll(",", ":")
            .replaceAll("}", " ")
            .split(":")[3];
        if (lat != null) {
          List<Placemark> placemarks = await placemarkFromCoordinates(
              double.parse(lat), double.parse(lon ?? ""));
          print(placemarks);
          Placemark place = placemarks[0];
          address1 =
              '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
        }

        var lat2 = shiftOfTheDayResponse?.data?.employeeGeolocationEnd
            ?.replaceAll("\"", "")
            .replaceAll(",", ":")
            .replaceAll("}", " ")
            .split(":")[1];
        var lon2 = shiftOfTheDayResponse?.data?.employeeGeolocationEnd
            ?.replaceAll("\"", "")
            .replaceAll(",", ":")
            .replaceAll("}", " ")
            .split(":")[3];

        if (lat2 != null) {
          List<Placemark> placemarks2 = await placemarkFromCoordinates(
              double.parse(lat2), double.parse(lon2 ?? ""));
          Placemark place2 = placemarks2[0];
          address2 =
              '${place2.street}, ${place2.subLocality}, ${place2.locality}, ${place2.postalCode}, ${place2.country}';
        }
        return response;
      } else if (response.statusCode == 401 ||
          response.statusCode == 404 ||
          response.statusCode >= 500) {}
      return response;
    } on TimeoutException catch (_) {
      print("non funziona");
    
    } 
  }

  Future getVehicle() async {
    final authToken = await getBasicAuth();
    try {
      var response = await http.get(
          Uri.parse(baseUrl +
              "/api/v1/vehicles/view/${shiftOfTheDayResponse!.data!.vehicleId}"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer " + authToken!
          }).timeout((const Duration(seconds: 10)));

      if (response.statusCode == 200) {
        vehicleResponse = VehicleResponse.fromJson(jsonDecode(response.body));
        setVehicle(vehicleResponse?.data?.vehicleModelId.toString() ?? "");
        setLocation(vehicleResponse?.data?.officeLocationId.toString() ?? "");
        await getVehicleModel();
      } else if (response.statusCode == 401 || response.statusCode >= 500) {}
      return response;
    } on TimeoutException catch (_) {
      print("non funziona");
      // checkError(0, "Connessione assente!");
    }
  }

  Future getVehicleModel() async {
    final authToken = await getBasicAuth();
    try {
      var response = await http.get(
          Uri.parse(baseUrl +
              "/api/v1/vehicle-models/view/${vehicleResponse!.data!.vehicleModelId}"),
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
    }
  }

  Color createColor() {
    if (!isStartedAttendance && !isEndedAttendance) {
      return Color(0xff44b930);
    } else if (isStartedAttendance && !isEndedAttendance) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  Future sendPosition() async {
    // Position? position = await Geolocator.getLastKnownPosition();

    // print('${position}');
    final authToken = await getBasicAuth();
    try {
      var response = await http.get(Uri.parse(baseUrl + "/api/v1/shifts/me"),
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
    }
  }

  Widget getDashboard(context) {
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
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                  flex: 50,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/shipping.png'),
                      )
                    ]),
                  )),
              Flexible(
                  flex: 50,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(children: <Widget>[
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            vehicleModelResponse?.data?.brand ?? "",
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
                            vehicleModelResponse?.data?.description ?? "",
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
                            vehicleResponse?.data?.carPlate ?? "",
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
          )),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.center,
          child: Text(addressVehicle, textAlign: TextAlign.center),
        ),
      ),
      getTurno(context),
      SizedBox(height: 20),
      GestureDetector(
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
                            setState(() {
                              loading = true;
                            });
                            editShift();
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  })
            }
          // sendPosition();
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
                      color: createColor(),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 80,
                        height: 18,
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
            )
          ]),
        ),
      ),
      shiftOfTheDayResponse?.data?.employeeTimeStart != null
          ? _createDataTable()
          : SizedBox()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: downloadData(),
        builder: (context, projectSnap) {
          if (projectSnap.data != null && !isoffline && serviceEnabled) {
            return Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  actions: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/list');
                      },
                      child: isoffline
                          ? Column(children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      "Trovare una fonte di rete",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ))
                            ])
                          : Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: Icon(
                                Icons.list_alt,
                                size: 26.0,
                              ),
                            ),
                    ),
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
                body: shiftOfTheDayResponse != null
                    ? Column(
                      children: [
                        Expanded(
                            child: RefreshIndicator(
                                onRefresh: downloadData,
                                child: !loading
                                    ? ListView(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.symmetric(vertical: 20),
                                        children: [
                                            getDashboard(context),
                                            getStateOfVehicol(context)
                                            
                        
                                            //non qua
                                          ])
                                    : Container(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        alignment: Alignment.center,
                                        child: const SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: CircularProgressIndicator(
                                              color: Colors.black,
                                              strokeWidth: 3.5,
                                            ))))),
                                            Container(
                                          constraints: BoxConstraints(
                                              minWidth: double.infinity,
                                              maxHeight: 200),
                                          decoration: new BoxDecoration(
                                            color: Color(0x4d7BCEFD),
                                          ),
                                          margin: const EdgeInsets.only(
                                              left: 0.0,
                                              right: 0.0,
                                              bottom: 0.0,
                                              top: 0),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: GridView.count(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              crossAxisCount: 2,
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              childAspectRatio: 20.0 / 15.0,
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              '/accident');
                                                    },
                                                    child: Container(
                                                      width: 150,
                                                      height: 150,
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            width: 150,
                                                            height: 150,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Color(
                                                                      0x3ff4af49),
                                                                  blurRadius: 4,
                                                                  offset:
                                                                      Offset(
                                                                          0, 3),
                                                                ),
                                                              ],
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              left: 25,
                                                              right: 29,
                                                              top: 11,
                                                              bottom: 11,
                                                            ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                  width: 96,
                                                                  height: 91,
                                                                  child: Image
                                                                      .asset(
                                                                          'assets/crashedCar.png'),
                                                                ),
                                                                Text(
                                                                  "Sinistro",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        "Montserrat",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
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
                                                        .pushNamed(
                                                            '/broken-down');
                                                  },
                                                  child: Container(
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: 150,
                                                          height: 150,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Color(
                                                                    0x3ff4af49),
                                                                blurRadius: 4,
                                                                offset: Offset(
                                                                    0, 3),
                                                              ),
                                                            ],
                                                            color: Colors.white,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 24,
                                                            right: 30,
                                                            top: 11,
                                                            bottom: 11,
                                                          ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                width: 96,
                                                                height: 91,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Image.asset(
                                                                    'assets/damage.png'),
                                                              ),
                                                              SizedBox(
                                                                width: 71,
                                                                child: Text(
                                                                  "Guasto",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        "Montserrat",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
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
                                        )
                      ],
                    )
                    : Column(
                        children: [
                          SizedBox(height: 100),
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Nessun turno caricato",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w700,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(addressVehicle,
                                  textAlign: TextAlign.center),
                            ),
                          ),
                        ],
                      ));

     
          } else if (projectSnap.data != null && isoffline) {
            return Center(
                child: Text("Assenza di rete",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w700,
                    )));
          } else {
            return Center(
                child: Text("Attiva la localizzazione per poter usare l'app"));
          }
        });
  }
}

Widget getTurno(context) {
  return shiftOfTheDayResponse != null
      ? Column(
          children: <Widget>[
            Padding(
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
        );
}

Widget getStateOfVehicol(context) {
  return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
        child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/stateOfVehicle');
            },
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 52,
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
                      left: 10.0, right: 10.0, bottom: 0.0, top: 0),
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 29,
                    top: 12,
                    bottom: 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                 
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
      ));
}
