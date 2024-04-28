import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:flutter/material.dart';

class LoginFunctions {
  static getRedirection(BuildContext context) async {
    if (Constant.session.getBoolData(SessionManager.keySkipLogin) ||
        Constant.session.getBoolData(SessionManager.isUserLogin)) {
      if (Constant.session.getData(SessionManager.keyLatitude) == "0" &&
          Constant.session.getData(SessionManager.keyLongitude) == "0") {
        Navigator.pushReplacementNamed(context, getLocationScreen,
            arguments: "location");
      } else if (Constant.session
          .getData(SessionManager.keyUserName)
          .isNotEmpty) {
        Navigator.pushReplacementNamed(
          context,
          mainHomeScreen,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          mainHomeScreen,
          (route) => false,
        );
      }
    }
  }

  static Future<String> mobileNumberValidation(BuildContext context,
      TextEditingController edtPhoneNumber, bool isAcceptedTerms) async {
    String? mobileValidate = await GeneralMethods.phoneValidation(
        edtPhoneNumber.text,
        getTranslatedValue(
          context,
          "lblEnterValidMobile",
        ));
    if (mobileValidate != null) {
      return mobileValidate;
    } else if (!isAcceptedTerms) {
      return getTranslatedValue(
        context,
        "lblAcceptTermsAndCondition",
      );
    } else {
      return "";
    }
  }
}
