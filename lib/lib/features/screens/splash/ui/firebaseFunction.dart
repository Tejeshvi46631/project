import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/repository/registerFcmKey.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class SplashInit{
  static firebaseCall(BuildContext context){
    FirebaseMessaging.instance.getToken().then((token) {
      if (Constant.session.getData(SessionManager.keyFCMToken).isEmpty) {
        Constant.session.setData(SessionManager.keyFCMToken, token!, false);
        registerFcmKey(context: context, fcmToken: token);
      }
    });
  }
}