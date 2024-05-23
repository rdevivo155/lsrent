import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConnectivityService {
  Stream<ConnectivityResult> get connectivityStream => Connectivity().onConnectivityChanged;

  void showNoConnectionToast() {
    Fluttertoast.showToast(
      msg: "Nessuna connessione di rete",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}