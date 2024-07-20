import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsumerFunction{
  static call(BuildContext context){
    Constant.session = Provider.of<SessionManager>(context);
    Constant.searchedItemsHistoryList = Constant.session.prefs
        .getStringList(SessionManager.keySearchHistory) ??
        [];

    FirebaseMessaging.instance
        .requestPermission(alert: true, sound: true, badge: true);



    final window = WidgetsBinding.instance.window;

    if (Constant.session
        .getData(SessionManager.appThemeName)
        .toString()
        .isEmpty) {
      Constant.session.setData(
          SessionManager.appThemeName, Constant.themeList[0], false);
      Constant.session.setBoolData(SessionManager.isDarkTheme,
          window.platformBrightness == Brightness.dark, false);
    }

    // This callback is called every time the brightness changes from the device.
    window.onPlatformBrightnessChanged = () {
      if (Constant.session.getData(SessionManager.appThemeName) ==
          Constant.themeList[0]) {
        Constant.session.setBoolData(SessionManager.isDarkTheme,
            window.platformBrightness == Brightness.dark, true);
      }
    };


  }
}