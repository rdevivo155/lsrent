import 'dart:async';
import 'dart:io';

//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ls_rent/accident/accident.dart';
import 'package:ls_rent/authentication/login.dart';
import 'package:ls_rent/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:ls_rent/home/home_2.dart';
import 'package:ls_rent/profile/profile.dart';
import 'package:ls_rent/list/list.dart';
import 'package:ls_rent/registration/registration.dart';
import 'package:ls_rent/services/notification_service.dart';
import 'package:ls_rent/services/shared.dart';
import 'package:ls_rent/stateOfVehicle/stateOfVehicle.dart';

import 'brokenDown/brokenDown.dart';
import 'constants/globals.dart';
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
  // ignore: dead_code
  if (_result) {
    //_defaultHome = new Home();
  }
  var routes = <String, WidgetBuilder>{
    // Set routes for using the Navigator.
    '/home': (BuildContext context) => new Home(),
    '/accident': (BuildContext context) => new AccidentPage(),
    '/broken-down': (BuildContext context) => new BrokenDown(),
    // '/day-off': (BuildContext context) => new DayOff(),
    '/login': (BuildContext context) => new LoginView(),
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
        home: isLogged ? new Home() : new LoginView(),
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        routes: routes,
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: Colors.blue,
          hintColor: Color(0xFFF5F5F5),
        ),
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
