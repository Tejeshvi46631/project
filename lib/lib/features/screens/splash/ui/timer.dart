import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/provider/cartListProvider.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashTimer {
  static startTime(
    currentAppVersion,
    expectedAppVersion,
    BuildContext context,
  ) async {
    return Timer(
      const Duration(seconds: 0),
      () async {
        print("In startTime");
        print(!Constant.session
            .getBoolData(SessionManager.introSlider.toString()));
        if (Platform.isAndroid) {
          if (!Constant.session.getBoolData(SessionManager.introSlider)) {
            if (currentAppVersion != expectedAppVersion) {
              print("In if");
              Constant.session
                  .setBoolData(SessionManager.introSlider, true, false);
              Navigator.pushReplacementNamed(context, introSliderScreen);
              Navigator.pushReplacementNamed(context, appUpdateScreen,
                  arguments: true);
            } else {
              print("In else");
              Constant.session
                  .setBoolData(SessionManager.introSlider, true, false);
              Navigator.pushReplacementNamed(context, introSliderScreen);
            }
          } else if (Constant.session.getBoolData(SessionManager.isUserLogin) &&
              Constant.session.getIntData(SessionManager.keyUserStatus) == 0) {
            print("In reg");
            if (currentAppVersion != expectedAppVersion) {
              Navigator.pushReplacementNamed(context, editProfileScreen,
                  arguments: "register");
              Navigator.pushNamed(context, appUpdateScreen, arguments: false);
            } else {
              Navigator.pushReplacementNamed(context, editProfileScreen,
                  arguments: "register");
            }
          } else {
            if (Constant.session.getBoolData(SessionManager.keySkipLogin) ||
                Constant.session.getBoolData(SessionManager.isUserLogin)) {
              if (Constant.session.getData(SessionManager.keyLatitude) == "0" &&
                  Constant.session.getData(SessionManager.keyLongitude) ==
                      "0") {
                print("In loc");
                if (currentAppVersion != expectedAppVersion) {
                  Navigator.pushReplacementNamed(context, getLocationScreen,
                      arguments: "location");
                  Navigator.pushNamed(context, appUpdateScreen,
                      arguments: false);
                } else {
                  Navigator.pushReplacementNamed(context, getLocationScreen,
                      arguments: "location");
                }
              } else {
                if (currentAppVersion != expectedAppVersion) {
                  Navigator.pushReplacementNamed(context, mainHomeScreen);
                  Navigator.pushNamed(context, appUpdateScreen,
                      arguments: false);
                } else {
                  Navigator.pushReplacementNamed(context, mainHomeScreen);
                }
              }
            } else {
              if (currentAppVersion != expectedAppVersion) {
                print("In last");
                Navigator.pushReplacementNamed(context, loginScreen);
                Navigator.pushNamed(context, appUpdateScreen, arguments: false);
              } else {
                print("In last1");
                Navigator.pushReplacementNamed(context, loginScreen);
              }
            }
          }

        }





        // if (Constant.session.getBoolData(SessionManager.isUserLogin)) {
        //   await context
        //       .read<CartListProvider>()
        //       .getAllCartItems(context: context);
        // }

        // if (Platform.isAndroid) {
        //   if (!Constant.session.getBoolData(SessionManager.introSlider)) {
        //     if ((Constant.isVersionSystemOn == "1" || Constant.currentRequiredAppVersion.isNotEmpty) && (Version.parse(Constant.currentRequiredAppVersion) > Version.parse(currentAppVersion))) {
        //       if (Constant.requiredForceUpdate == "1") {
        //         Constant.session.setBoolData(SessionManager.introSlider, true, false);
        //         Navigator.pushReplacementNamed(context, introSliderScreen);
        //         Navigator.pushReplacementNamed(context, appUpdateScreen, arguments: true);
        //       } else {
        //         Constant.session.setBoolData(SessionManager.introSlider, true, false);
        //         Navigator.pushReplacementNamed(context, introSliderScreen);
        //         Navigator.pushNamed(context, appUpdateScreen, arguments: false);
        //       }
        //     } else {
        //       Constant.session.setBoolData(SessionManager.introSlider, true, false);
        //       Navigator.pushReplacementNamed(context, introSliderScreen);
        //     }
        //   } else if (Constant.session.getBoolData(SessionManager.isUserLogin) && Constant.session.getIntData(SessionManager.keyUserStatus) == 0) {
        //     if (Constant.isVersionSystemOn == "1" && (Version.parse(Constant.currentRequiredAppVersion) > Version.parse(currentAppVersion))) {
        //       if (Constant.requiredForceUpdate == "1") {
        //         Navigator.pushReplacementNamed(context, editProfileScreen, arguments: "register");
        //         Navigator.pushReplacementNamed(context, appUpdateScreen, arguments: true);
        //       } else {
        //         Navigator.pushReplacementNamed(context, editProfileScreen, arguments: "register");
        //         Navigator.pushNamed(context, appUpdateScreen, arguments: false);
        //       }
        //     } else {
        //       Navigator.pushReplacementNamed(context, editProfileScreen, arguments: "register");
        //     }
        //   } else {
        //     if (Constant.session.getBoolData(SessionManager.keySkipLogin) || Constant.session.getBoolData(SessionManager.isUserLogin)) {
        //       if (Constant.session.getData(SessionManager.keyLatitude) == "0" && Constant.session.getData(SessionManager.keyLongitude) == "0") {
        //         if (Constant.isVersionSystemOn == "1" && (Version.parse(Constant.currentRequiredAppVersion) > Version.parse(currentAppVersion))) {
        //           if (Constant.requiredForceUpdate == "1") {
        //             Navigator.pushReplacementNamed(context, getLocationScreen, arguments: "location");
        //             Navigator.pushReplacementNamed(context, appUpdateScreen, arguments: true);
        //           } else {
        //             Navigator.pushReplacementNamed(context, getLocationScreen, arguments: "location");
        //             Navigator.pushNamed(context, appUpdateScreen, arguments: false);
        //           }
        //         } else {
        //           Navigator.pushReplacementNamed(context, getLocationScreen, arguments: "location");
        //         }
        //       } else {
        //         if (Constant.isVersionSystemOn == "1" && (Version.parse(Constant.currentRequiredAppVersion) > Version.parse(currentAppVersion))) {
        //           if (Constant.requiredForceUpdate == "1") {
        //             Navigator.pushReplacementNamed(context, mainHomeScreen);
        //             Navigator.pushReplacementNamed(context, appUpdateScreen, arguments: true);
        //           } else {
        //             Navigator.pushReplacementNamed(context, mainHomeScreen);
        //             Navigator.pushNamed(context, appUpdateScreen, arguments: false);
        //           }
        //         } else {
        //           Navigator.pushReplacementNamed(context, mainHomeScreen);
        //         }
        //       }
        //     } else {
        //       if (Constant.isVersionSystemOn == "1" && (Version.parse(Constant.currentRequiredAppVersion) > Version.parse(currentAppVersion))) {
        //         if (Constant.requiredForceUpdate == "1") {
        //           Navigator.pushReplacementNamed(context, loginScreen);
        //           Navigator.pushReplacementNamed(context, appUpdateScreen, arguments: true);
        //         } else {
        //           Navigator.pushReplacementNamed(context, loginScreen);
        //           Navigator.pushNamed(context, appUpdateScreen, arguments: false);
        //         }
        //       } else {
        //         Navigator.pushReplacementNamed(context, loginScreen);
        //       }
        //     }
        //   }
        // }

      },
    );
  }


}
