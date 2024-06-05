import 'dart:async';
import 'dart:convert';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ls_rent/constants/constants.dart';
import 'package:ls_rent/home/dataTable.dart';
import 'package:ls_rent/home/shift.dart';
import 'package:ls_rent/model/response/shift_of_the_day_response.dart';
import 'package:ls_rent/model/response/vehicle_model_response.dart';
import 'package:ls_rent/model/response/vehicle_response.dart';
import 'package:ls_rent/services/network.dart';
import 'package:ls_rent/services/shared.dart';
import 'gridButton.dart';
import 'attendanceButton.dart';
import 'shiftInfo.dart';
import 'vehicleInfo.dart';
import 'header.dart';
import 'package:http/http.dart' as http;
import 'package:ls_rent/constants/api.dart';

ShiftOfTheDayResponse? shiftOfTheDayResponse;
VehicleResponse? vehicleResponse;
VehicleModelResponse? vehicleModelResponse;
String addressVehicle = '';
String address1 = '';
String address2 = '';
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

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool isStartedAttendance = false;
  bool isEndedAttendance = false;
  bool loading = false;
  bool isoffline = false;
  String _authStatus = 'Unknown';
  late Future<void> _future;


  @override
  void initState() {
    super.initState();
    checkConnectivity();
    initPlugin();
    _future = downloadData();
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showNoConnectionPopup();
    }
  }

  void showNoConnectionPopup() {
    isoffline = true;
    Fluttertoast.showToast(
      msg: 'Nessuna connessione di rete',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> initPlugin() async {
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    setState(() => _authStatus = '$status');
    if (status == TrackingStatus.notDetermined) {
      await showCustomTrackingDialog(context);
      final TrackingStatus status =
          await AppTrackingTransparency.requestTrackingAuthorization();
      setState(() => _authStatus = '$status');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print('UUID: $uuid');
    print(_authStatus);
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
      if (position == null) {
        throw Exception('Position is null');
      }
      final authToken = await getBasicAuth();
      var response = await http.put(
              Uri.parse(baseUrl + '/api/v1/shifts/update/${shiftOfTheDayResponse!.data!.id}'),
              headers: <String, String>{
                'Authorization': 'Bearer ' + authToken!,
              },
              body: !isStartedAttendance
                  ? {
                      'employee_time_start': DateTime.now().toIso8601String(),
                      'employee_geolocation_start': '{"lat":${position.latitude},"lng":${position.longitude}}'
                    }
                  : {
                      'employee_time_end': DateTime.now().toIso8601String(),
                      'employee_geolocation_end': '{"lat":${position.latitude},"lng":${position.longitude}}'
                    })
          .timeout(const Duration(seconds: 20));

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

  Future<void> _refreshData() async {
    setState(() {
      _future = downloadData();
    });
    return _future;
  }

  Future downloadData() async {
    checkConnectivity();

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
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
                title: Text('Attenzione'),
                content: Text(
                    'Se non attivi la localizzazione non ti sarà concesso di usare l\'app'),
                actions: [
                  ElevatedButton(
                    child: Text('Ok'),
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
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
    
      return Future.error('Location permissions are denied');
    }

    try {
      final authToken = await getBasicAuth();
      if (authToken == null) {
        throw Exception('Authentication token is null');
      }
      
      var response = await NetworkService().fetchData(API.shiftsMe, authToken, context);
      shiftOfTheDayResponse =
            ShiftOfTheDayResponse.fromJson(response);
      if (shiftOfTheDayResponse?.statusCode == 200) {
        print(response);

        setVehicle(shiftOfTheDayResponse?.data?.vehicleId .toString() ?? '');
        await getVehicle();
        isStartedAttendance =
            shiftOfTheDayResponse?.data?.employeeTimeStart != null
                ? true
                : false;
        isEndedAttendance =
            shiftOfTheDayResponse?.data?.employeeTimeEnd != null ? true : false;
        var latV = shiftOfTheDayResponse?.data?.geolocationStart
            ?.replaceAll('"', '')
            .replaceAll(',', ':')
            .replaceAll('}', ' ')
            .split(':')[1];
        var lonV = shiftOfTheDayResponse?.data?.geolocationStart
            ?.replaceAll('"', '')
            .replaceAll(',', ':')
            .replaceAll('}', ' ')
            .split(':')[3];
        List<Placemark> placemarksV = await placemarkFromCoordinates(
            double.parse(latV ?? ''), double.parse(lonV ?? ''));
        print(placemarksV);
        Placemark placeV = placemarksV[0];
        addressVehicle = '${placeV.street}, ${placeV.locality}';

        var arrayString = shiftOfTheDayResponse?.data?.employeeGeolocationStart
            ?.replaceAll('"', '')
            .replaceAll(',', ':')
            .split(':');
        print(arrayString);
        var lat = shiftOfTheDayResponse?.data?.employeeGeolocationStart
            ?.replaceAll('"', '')
            .replaceAll(',', ':')
            .replaceAll('}', ' ')
            .split(':')[1];
        var lon = shiftOfTheDayResponse?.data?.employeeGeolocationStart
            ?.replaceAll('"', '')
            .replaceAll(',', ':')
            .replaceAll('}', ' ')
            .split(':')[3];
        if (lat != null) {
          List<Placemark> placemarks = await placemarkFromCoordinates(
              double.parse(lat), double.parse(lon ?? ''));
          print(placemarks);
          Placemark place = placemarks[0];
          address1 =
              '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
        }

        var lat2 = shiftOfTheDayResponse?.data?.employeeGeolocationEnd
            ?.replaceAll('"', '')
            .replaceAll(',', ':')
            .replaceAll('}', ' ')
            .split(':')[1];
        var lon2 = shiftOfTheDayResponse?.data?.employeeGeolocationEnd
            ?.replaceAll('"', '')
            .replaceAll(',', ':')
            .replaceAll('}', ' ')
            .split(':')[3];

        if (lat2 != null) {
          List<Placemark> placemarks2 = await placemarkFromCoordinates(
              double.parse(lat2), double.parse(lon2 ?? ''));
          Placemark place2 = placemarks2[0];
          address2 =
              '${place2.street}, ${place2.subLocality}, ${place2.locality}, ${place2.postalCode}, ${place2.country}';
        }
        return response;
      } else if 
      (response.statusCode == 401 || response.statusCode == 404 ||
          response.statusCode >= 500) {}
      return response;
    } on TimeoutException catch (_) {
      print('non funziona');
    
    } 
  }

  Future getVehicle() async {
    final authToken = await getBasicAuth();
    try {
      var response = await http.get(
          Uri.parse(baseUrl +
              '/api/v1/vehicles/view/${shiftOfTheDayResponse!.data!.vehicleId}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ' + authToken!,
          }).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        vehicleResponse = VehicleResponse.fromJson(jsonDecode(response.body));
        setVehicle(vehicleResponse?.data?.vehicleModelId.toString() ?? '');
        setLocation(vehicleResponse?.data?.officeLocationId.toString() ?? '');
        await getVehicleModel();
      } else if (response.statusCode == 401 || response.statusCode >= 500) {}
      return response;
    } on TimeoutException catch (_) {
      print('non funziona');
      // checkError(0, 'Connessione assente!');
    }
  }

   Future getVehicleModel() async {
    final authToken = await getBasicAuth();
    try {
      var response = await http.get(
          Uri.parse(baseUrl +
              '/api/v1/vehicle-models/view/${vehicleResponse!.data!.vehicleModelId}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ' + authToken!,
          }).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        vehicleModelResponse =
            VehicleModelResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401 || response.statusCode >= 500) {}
      return response;
    } on TimeoutException catch (_) {
      print('non funziona');
    }
  }

  Widget getDashboard(BuildContext context) {
    return Column(children: [
      HeaderWidget(title: 'Prossimo turno con il veicolo:'),
      VehicleInfoWidget(
        vehicleModelResponse: vehicleModelResponse,
        vehicleResponse: vehicleResponse,
        addressVehicle: addressVehicle,
      ),
      ShiftInfoWidget(shiftOfTheDayResponse: shiftOfTheDayResponse),
      SizedBox(height: 20),
      AttendanceButtonWidget(
        isStartedAttendance: isStartedAttendance,
        isEndedAttendance: isEndedAttendance,
        loading: loading,
        onTap: () {
          if (!isEndedAttendance) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Attenzione'),
                    content: Text('Sicuro di voler timbrare?'),
                    actions: [
                      ElevatedButton(
                        child: Text('Ok'),
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
                });
          }
        },
      ),
      shiftOfTheDayResponse?.data?.employeeTimeStart != null
          ? DataTableWidget(shiftOfTheDayResponse: shiftOfTheDayResponse, address1: address1, address2: address2)
          : SizedBox(),
    ]);
  }

  Widget getTurno(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    children: [
                      getDashboard(context),
                      getStateOfVehicle(context),
                    ],
                  )
                
          ),
        GridButtonsWidget(),
      ],
    );
  }

  Widget emptyShift(BuildContext context) {
    return Column(
                    children: [
                      SizedBox(height: 100),
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Nessun turno caricato',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Montserrat',
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
                  );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: downloadData(),
      builder: (context, projectSnap) {
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
                                  'Trovare una fonte di rete',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'Montserrat',
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
            body: RefreshIndicator(
              onRefresh: _refreshData,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: ShiftWidget(
                    projectSnap: projectSnap,
                    isOffline: isoffline,
                    shiftOfTheDayResponse: shiftOfTheDayResponse,
                    getTurno: getTurno,
                    emptyShift: emptyShift,
                  ),
              ),
            ),
          );
      },
    );
  }
}

Widget getStateOfVehicle(context) {
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
                    bottom: 18,
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