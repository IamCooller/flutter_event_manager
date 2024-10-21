// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyBtzCSen0DbUohNGkvzZKEujdsJurpPBdE',
    appId: '1:14685698391:web:63ee82dfea24527ba06612',
    messagingSenderId: '14685698391',
    projectId: 'event-management-applica-a29fb',
    authDomain: 'event-management-applica-a29fb.firebaseapp.com',
    storageBucket: 'event-management-applica-a29fb.appspot.com',
    measurementId: 'G-53F3C16VHL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB43hvOv3lAnQZSDn76a4HUrajV-73yoZk',
    appId: '1:14685698391:android:d234cc6ad4cea312a06612',
    messagingSenderId: '14685698391',
    projectId: 'event-management-applica-a29fb',
    storageBucket: 'event-management-applica-a29fb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB5xT0aGk2d1sPjQ5CnrC-BXj-7NJ2chQE',
    appId: '1:14685698391:ios:315d024746916b12a06612',
    messagingSenderId: '14685698391',
    projectId: 'event-management-applica-a29fb',
    storageBucket: 'event-management-applica-a29fb.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB5xT0aGk2d1sPjQ5CnrC-BXj-7NJ2chQE',
    appId: '1:14685698391:ios:315d024746916b12a06612',
    messagingSenderId: '14685698391',
    projectId: 'event-management-applica-a29fb',
    storageBucket: 'event-management-applica-a29fb.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBtzCSen0DbUohNGkvzZKEujdsJurpPBdE',
    appId: '1:14685698391:web:b2c5a0294952af9ba06612',
    messagingSenderId: '14685698391',
    projectId: 'event-management-applica-a29fb',
    authDomain: 'event-management-applica-a29fb.firebaseapp.com',
    storageBucket: 'event-management-applica-a29fb.appspot.com',
    measurementId: 'G-YGWC475C0M',
  );
}
