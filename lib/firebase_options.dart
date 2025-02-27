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
    apiKey: 'AIzaSyB3Fgcp-8AYtv-HgJFd8F_r75_d_QLdf7w',
    appId: '1:464312891637:web:429e34873e5f4f021fedbc',
    messagingSenderId: '464312891637',
    projectId: 'new-battery-app-dfc99',
    authDomain: 'new-battery-app-dfc99.firebaseapp.com',
    databaseURL: 'https://new-battery-app-dfc99-default-rtdb.firebaseio.com',
    storageBucket: 'new-battery-app-dfc99.appspot.com',
    measurementId: 'G-17W1F6E2DQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDQ9h6tK2Lhu39QtTGzBA650iQtuhZi8PQ',
    appId: '1:464312891637:android:ba329c6f25a273e31fedbc',
    messagingSenderId: '464312891637',
    projectId: 'new-battery-app-dfc99',
    databaseURL: 'https://new-battery-app-dfc99-default-rtdb.firebaseio.com',
    storageBucket: 'new-battery-app-dfc99.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDUFQOvReX3k4ZhANt6eRpAGfn6X6-lIUY',
    appId: '1:464312891637:ios:22e66ccd3989d58b1fedbc',
    messagingSenderId: '464312891637',
    projectId: 'new-battery-app-dfc99',
    databaseURL: 'https://new-battery-app-dfc99-default-rtdb.firebaseio.com',
    storageBucket: 'new-battery-app-dfc99.appspot.com',
    iosBundleId: 'com.example.batterySystemApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDUFQOvReX3k4ZhANt6eRpAGfn6X6-lIUY',
    appId: '1:464312891637:ios:11f23de73b878c421fedbc',
    messagingSenderId: '464312891637',
    projectId: 'new-battery-app-dfc99',
    databaseURL: 'https://new-battery-app-dfc99-default-rtdb.firebaseio.com',
    storageBucket: 'new-battery-app-dfc99.appspot.com',
    iosBundleId: 'com.example.batterySystemApp.RunnerTests',
  );
}
