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
    apiKey: 'AIzaSyB-Z4BmxRxx1NBVc37rR-YN2jjBo0zzbtc',
    appId: '1:207846391438:web:1639ffcb38dd16387493df',
    messagingSenderId: '207846391438',
    projectId: 'mentorme-4ae20',
    authDomain: 'mentorme-4ae20.firebaseapp.com',
    storageBucket: 'mentorme-4ae20.appspot.com',
    measurementId: 'G-M94LVPGTTL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAVlyQmi5fXyP9CleV0SaKP25u8MTssxXs',
    appId: '1:207846391438:android:a7465c828e22e6537493df',
    messagingSenderId: '207846391438',
    projectId: 'mentorme-4ae20',
    storageBucket: 'mentorme-4ae20.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD6ZQMI_ZdLeEv-SXo-TGlGamD3IVQ7n4k',
    appId: '1:207846391438:ios:4eab05f03a7fb1f67493df',
    messagingSenderId: '207846391438',
    projectId: 'mentorme-4ae20',
    storageBucket: 'mentorme-4ae20.appspot.com',
    iosBundleId: 'com.example.mentorMe',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD6ZQMI_ZdLeEv-SXo-TGlGamD3IVQ7n4k',
    appId: '1:207846391438:ios:3251d637aa103ba57493df',
    messagingSenderId: '207846391438',
    projectId: 'mentorme-4ae20',
    storageBucket: 'mentorme-4ae20.appspot.com',
    iosBundleId: 'com.example.mentorMe.RunnerTests',
  );
}
