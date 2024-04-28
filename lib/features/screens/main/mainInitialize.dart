import 'package:egrocer/core/constant/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainInitialize {
  static functionCall() async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      if (Firebase.apps.isNotEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      } else {
        await Firebase.initializeApp();
      }

      await FirebaseMessaging.instance.setAutoInitEnabled(true);
    } catch (_) {}

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}
