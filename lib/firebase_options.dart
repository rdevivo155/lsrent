// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB4ymHN0Fmy-yz5D_NT3MDXWU3rM05sJgM',
    appId: '1:688608370648:web:5c960ea1830836fb3bdcad',
    messagingSenderId: '688608370648',
    projectId: 'lsrent-82245',
    authDomain: 'lsrent-82245.firebaseapp.com',
    storageBucket: 'lsrent-82245.appspot.com',
    measurementId: 'G-MSN8BNL436',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBTrr9xr206nf041Hig3YsH4_hM6SGKiwo',
    appId: '1:688608370648:android:e41530bf99021cca3bdcad',
    messagingSenderId: '688608370648',
    projectId: 'lsrent-82245',
    storageBucket: 'lsrent-82245.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA4-GS9J38yjp1W55Wg7OurR4nLjq_Et8U',
    appId: '1:688608370648:ios:8286f54e3540ee973bdcad',
    messagingSenderId: '688608370648',
    projectId: 'lsrent-82245',
    storageBucket: 'lsrent-82245.appspot.com',
    iosClientId: '688608370648-mjc85c4guvomn97fkv7s601g07thoilv.apps.googleusercontent.com',
    iosBundleId: 'it.lsrent.it',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA4-GS9J38yjp1W55Wg7OurR4nLjq_Et8U',
    appId: '1:688608370648:ios:8286f54e3540ee973bdcad',
    messagingSenderId: '688608370648',
    projectId: 'lsrent-82245',
    storageBucket: 'lsrent-82245.appspot.com',
    iosClientId: '688608370648-mjc85c4guvomn97fkv7s601g07thoilv.apps.googleusercontent.com',
    iosBundleId: 'it.lsrent.it',
  );
}
