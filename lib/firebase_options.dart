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
    apiKey: 'AIzaSyD-WgZclnvW2t0KsVEY6Dgo0uoCO0PYtbw',
    appId: '1:762932216843:web:9ac2f25ba68382e3ae330e',
    messagingSenderId: '762932216843',
    projectId: 'creatorcrew-3f26a',
    authDomain: 'creatorcrew-3f26a.firebaseapp.com',
    storageBucket: 'creatorcrew-3f26a.firebasestorage.app',
    measurementId: 'G-6B3CLV0HP8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBNaxo8r0k5iCYA7qC4S0E-P7mpf00w-rc',
    appId: '1:762932216843:android:072c00ece7c1bbc8ae330e',
    messagingSenderId: '762932216843',
    projectId: 'creatorcrew-3f26a',
    storageBucket: 'creatorcrew-3f26a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyADx3ra_4nzurLxYCdfgiuiDtm90qjjYks',
    appId: '1:762932216843:ios:8f48da8c42dd62e0ae330e',
    messagingSenderId: '762932216843',
    projectId: 'creatorcrew-3f26a',
    storageBucket: 'creatorcrew-3f26a.firebasestorage.app',
    iosBundleId: 'com.example.creatorcrew',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyADx3ra_4nzurLxYCdfgiuiDtm90qjjYks',
    appId: '1:762932216843:ios:8f48da8c42dd62e0ae330e',
    messagingSenderId: '762932216843',
    projectId: 'creatorcrew-3f26a',
    storageBucket: 'creatorcrew-3f26a.firebasestorage.app',
    iosBundleId: 'com.example.creatorcrew',
  );
}
