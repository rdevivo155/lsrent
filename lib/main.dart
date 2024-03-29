import 'dart:async';
import 'dart:io';

//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ls_rent/accident/accident.dart';
import 'package:ls_rent/authentication/login.dart';
import 'package:ls_rent/firebase_options.dart';
import 'package:ls_rent/home/home.dart';
import 'package:ls_rent/dayOff/dayOff.dart';
import 'package:flutter/material.dart';
import 'package:ls_rent/profile/profile.dart';
import 'package:ls_rent/list/list.dart';
import 'package:ls_rent/registration/registration.dart';
import 'package:ls_rent/services/notification_service.dart';
import 'package:ls_rent/services/shared.dart';
import 'package:ls_rent/stateOfVehicle/stateOfVehicle.dart';

import 'SplashScreen/splash_screen.dart';
import 'brokenDown/brokenDown.dart';
import 'constants/globals.dart';
import 'home/home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

late FirebaseMessaging messaging;
var initializationSettingsIOS = DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, payload) async {});

const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_launcher_foreground');

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  // Set default home.
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  initFirebaseGoogleService();

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    NotificationService().showNotification(
        title: event.notification!.title, body: event.notification!.body);
    print("message recieved");
    print(event.notification!.body);
  });
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

  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) =>

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
      )));
}

void initFirebaseGoogleService() {
  messaging = FirebaseMessaging.instance;
  messaging.getToken().then((value) {
    token = value ?? "";
    print(value);
    Stream<RemoteMessage> _stream = FirebaseMessaging.onMessageOpenedApp;
    _stream.listen((RemoteMessage event) async {
      if (event.notification!.title != null) {}
    });
  });
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future initialization(BuildContext? context) async {
  await Future.delayed(Duration(seconds: 1));
}
