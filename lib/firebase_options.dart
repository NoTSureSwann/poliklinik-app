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

  // TODO: Replace these placeholder values by running `flutterfire configure`

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA6NTp36JuXfLJvFPl7fFzuTZDME_lHMYg',
    appId: '1:690427649630:web:a0e203542abfcc08bd1ecf',
    messagingSenderId: '690427649630',
    projectId: 'poliklinik-app-2fc36',
    authDomain: 'poliklinik-app-2fc36.firebaseapp.com',
    storageBucket: 'poliklinik-app-2fc36.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCT2g3z-lwhM_oEa15SRFK5GJwlgSkDSJg',
    appId: '1:690427649630:android:37be10280b94aadfbd1ecf',
    messagingSenderId: '690427649630',
    projectId: 'poliklinik-app-2fc36',
    storageBucket: 'poliklinik-app-2fc36.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDEWOapJ23Qk1r2GZ65T14vwlU65POBMjA',
    appId: '1:690427649630:ios:7e8cdff03c62bc77bd1ecf',
    messagingSenderId: '690427649630',
    projectId: 'poliklinik-app-2fc36',
    storageBucket: 'poliklinik-app-2fc36.firebasestorage.app',
    iosBundleId: 'com.example.helloWorld',
  );
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'API_KEY',
    appId: '1:1234567890:ios:1234567890abcdef',
    messagingSenderId: '1234567890',
    projectId: 'poliklinik-project',
    storageBucket: 'poliklinik-project.appspot.com',
    iosBundleId: 'com.example.poliklinik',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'API_KEY',
    appId: '1:1234567890:web:1234567890abcdef',
    messagingSenderId: '1234567890',
    projectId: 'poliklinik-project',
    authDomain: 'poliklinik-project.firebaseapp.com',
    storageBucket: 'poliklinik-project.appspot.com',
    measurementId: 'G-123456789',
  );
}
