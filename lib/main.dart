import 'package:ls_rent/authentication/login.dart';
import 'package:ls_rent/home/home.dart';
import 'package:ls_rent/dayOff/dayOff.dart';
import 'package:flutter/material.dart';

import 'home/home.dart';


void main() async {
  // Set default home.
  Widget _defaultHome = new Login();


  // Get result of the login function.
  bool _result = false;
  if (_result) {
    _defaultHome = new Home();
  }

  // Run app!
  runApp(new MaterialApp(
    title: 'App',
    home: _defaultHome,
    routes: <String, WidgetBuilder>{
      // Set routes for using the Navigator.
      '/home': (BuildContext context) => new Home(),
      '/day-off': (BuildContext context) => new DayOff(),
      '/login': (BuildContext context) => new Login()
    },
  ));
}
