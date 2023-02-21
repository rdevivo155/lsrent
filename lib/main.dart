import 'dart:async';

//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:ls_rent/accident/accident.dart';
import 'package:ls_rent/authentication/login.dart';
import 'package:ls_rent/home/home.dart';
import 'package:ls_rent/dayOff/dayOff.dart';
import 'package:flutter/material.dart';
import 'package:ls_rent/profile/profile.dart';
import 'package:ls_rent/list/list.dart';
import 'package:ls_rent/registration/registration.dart';
import 'package:ls_rent/services/shared.dart';
import 'package:ls_rent/stateOfVehicle/stateOfVehicle.dart';

import 'SplashScreen/splash_screen.dart';
import 'brokenDown/brokenDown.dart';
import 'home/home.dart';

void main() async {
  // Set default home.
  WidgetsFlutterBinding.ensureInitialized();
  /*final fcmToken = await FirebaseMessaging.instance.getToken(
      vapidKey: "BNltQH08zABkbVX2GItJyqjMn-Mjh5qYmLHo_PuWkixeermvNj81rNXqwPy3Hr__bFguPHcfFHFwgdYEgnvYOY4");*/

  bool isLogged = await getIsLogged();
  await initialization(null);
  //!isLogged ? new Login() : new Home();

  // Get result of the login function.
  bool _result = false;
  if (_result) {
    //_defaultHome = new Home();
  }
  var routes = <String, WidgetBuilder>{
    // Set routes for using the Navigator.
    '/home': (BuildContext context) => new Home(),
    '/accident': (BuildContext context) => new Accident(),
    '/broken-down': (BuildContext context) => new BrokenDown(),
    // '/day-off': (BuildContext context) => new DayOff(),
    '/login': (BuildContext context) => new Login(),
    '/profile': (BuildContext context) => new Profile(),
    '/list': (BuildContext context) => new ListShits(),
    '/registration': (BuildContext context) => new Registration(),
    '/stateOfVehicle': (BuildContext context) => new StateOfVehicle()
  };
  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print('Got a message whilst in the foreground!');
  //   print('Message data: ${message.data}');

  //   if (message.notification != null) {
  //     print('Message also contained a notification: ${message.notification}');
  //   }
  // });

  // @pragma('vm:entry-point')
  // Future<void> _firebaseMessagingBackgroundHandler(
  //     RemoteMessage message) async {
  //   // If you're going to use other Firebase services in the background, such as Firestore,
  //   // make sure you call `initializeApp` before using other Firebase services.
  //   await Firebase.initializeApp();

  //   print("Handling a background message: ${message.messageId}");
  // }

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Run app!
  runApp(new MaterialApp(
    title: 'App',
    home: isLogged ? new Home() : new Login(),
    debugShowCheckedModeBanner: false,
    routes: routes,
    onGenerateRoute: (settings) {
      return CupertinoPageRoute(
          builder: (context) => routes[settings.name]!(context));
    },
  ));
}

Future initialization(BuildContext? context) async {
  await Future.delayed(Duration(seconds: 1));
}
