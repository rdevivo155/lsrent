import 'package:flutter/material.dart';
import '../services/connectivityService.dart';
import '../services/trackingService.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ConnectivityService _connectivityService = ConnectivityService();
  final TrackingService _trackingService = TrackingService();

  @override
  void initState() {
    super.initState();
    _connectivityService.connectivityStream.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        _connectivityService.showNoConnectionToast();
      }
    });
    _trackingService.initTracking().then((uuid) {
      print("UUID: $uuid");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(child: Text("Benvenuto nella Home")),
    );
  }
}