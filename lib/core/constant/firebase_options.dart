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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCQfkrwSWHtVYO2himPrWRBK9jBl5ctXh4',
    appId: '1:902650636483:android:6af63ed5a01a5d30695a76',
    messagingSenderId: '902650636483',
    projectId: 'chayyakartaug',
    storageBucket: 'chayyakartaug.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBKjxbso7hvQNsUt9WGEveE5FOpBbgu4yw',
    appId: '1:925593502189:ios:8674a8c3f3fee536b527e4',
    messagingSenderId: '925593502189',
    projectId: 'chhayakart-2aad5',
    storageBucket: 'chhayakart-2aad5.appspot.com',
    androidClientId: '925593502189-c94tpba5rou536rnippvubkguigfel19.apps.googleusercontent.com',
    iosClientId: '925593502189-r5bm3tsgso466aogr0g8u6s51ajco08a.apps.googleusercontent.com',
    iosBundleId: 'com.chayakart',
  );
}
