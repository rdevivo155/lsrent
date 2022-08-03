import 'package:ls_rent/accident/accident.dart';
import 'package:ls_rent/authentication/login.dart';
import 'package:ls_rent/home/home.dart';
import 'package:ls_rent/dayOff/dayOff.dart';
import 'package:flutter/material.dart';
import 'package:ls_rent/profile/profile.dart';
import 'package:ls_rent/registration/registration.dart';
import 'package:ls_rent/services/shared.dart';
import 'package:ls_rent/stateOfVehicle/stateOfVehicle.dart';

import 'home/home.dart';

void main() async {
  // Set default home.
  WidgetsFlutterBinding.ensureInitialized();

  bool isLogged = await getIsLogged();
  Widget _defaultHome = !isLogged ? new Login() : new Home();

  // Get result of the login function.
  bool _result = false;
  if (_result) {
    _defaultHome = new Home();
  }

  // Run app!
  runApp(new MaterialApp(
    title: 'App',
    home: _defaultHome,
    debugShowCheckedModeBanner: false,
    routes: <String, WidgetBuilder>{
      // Set routes for using the Navigator.
      '/home': (BuildContext context) => new Home(),
      '/accident': (BuildContext context) => new Accident(),
      // '/day-off': (BuildContext context) => new DayOff(),
      '/login': (BuildContext context) => new Login(),
      '/profile': (BuildContext context) => new Profile(),
      '/registration': (BuildContext context) => new Registration(),
      '/stateOfVehicle': (BuildContext context) => new StateOfVehicle()
    },
  ));
}
