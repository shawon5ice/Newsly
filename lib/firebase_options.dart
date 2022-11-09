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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAgtWdzOiyuwABHqbUi-gjoK9SwyiuT98Y',
    appId: '1:368221296224:web:e6eaeb0c39f498d31f5505',
    messagingSenderId: '368221296224',
    projectId: 'newsly-news-for-all',
    authDomain: 'newsly-news-for-all.firebaseapp.com',
    storageBucket: 'newsly-news-for-all.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAt6CfMsOeEGq2Pq1Mft5AnC2FI20PYnRE',
    appId: '1:368221296224:android:52ebf632509e41291f5505',
    messagingSenderId: '368221296224',
    projectId: 'newsly-news-for-all',
    storageBucket: 'newsly-news-for-all.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAUTnOdmr6hzSEy-oXXfJBj9-mnjg1HlY4',
    appId: '1:368221296224:ios:5b2c44fe19f691fd1f5505',
    messagingSenderId: '368221296224',
    projectId: 'newsly-news-for-all',
    storageBucket: 'newsly-news-for-all.appspot.com',
    iosClientId: '368221296224-lvk5tp0h4hrjkns1c1i7fhnlh4oe6857.apps.googleusercontent.com',
    iosBundleId: 'com.ssquare.newsly',
  );
}
