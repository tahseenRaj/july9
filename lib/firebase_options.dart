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
    apiKey: 'AIzaSyDGXoblUE-DIxQ2OzsvzbpPnR9DvILawQE',
    appId: '1:159861447990:web:4f348e1490df340b30a797',
    messagingSenderId: '159861447990',
    projectId: 'july9-18f13',
    authDomain: 'july9-18f13.firebaseapp.com',
    storageBucket: 'july9-18f13.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCe6RN84vETr6eYyM5O_ejkj7PofWFivak',
    appId: '1:159861447990:android:8f5cf3c015f6de6730a797',
    messagingSenderId: '159861447990',
    projectId: 'july9-18f13',
    storageBucket: 'july9-18f13.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCK8BU5jmw90d7zXHGmwYG3pVU9MXGKJ-w',
    appId: '1:159861447990:ios:5632484be21a75b830a797',
    messagingSenderId: '159861447990',
    projectId: 'july9-18f13',
    storageBucket: 'july9-18f13.appspot.com',
    iosClientId: '159861447990-flcnajl07n8fvf0ulsj8m35u3ue86oer.apps.googleusercontent.com',
    iosBundleId: 'com.example.july9',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCK8BU5jmw90d7zXHGmwYG3pVU9MXGKJ-w',
    appId: '1:159861447990:ios:5632484be21a75b830a797',
    messagingSenderId: '159861447990',
    projectId: 'july9-18f13',
    storageBucket: 'july9-18f13.appspot.com',
    iosClientId: '159861447990-flcnajl07n8fvf0ulsj8m35u3ue86oer.apps.googleusercontent.com',
    iosBundleId: 'com.example.july9',
  );
}
