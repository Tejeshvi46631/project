import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:egrocer/features/screens/authentication/otp/services/getLoginApi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class OtpFunction {
  static backendApiProcess(
      User user, phoneNumber, selectedCountryCode, BuildContext context) async {
    Map<String, dynamic> params = {
      ApiAndParams.mobile: phoneNumber,
      // ApiAndParams.authUid: "123456", // Temp used for testing
      ApiAndParams.authUid: user.uid, // In live this will use
      ApiAndParams.countryCode:
          selectedCountryCode.dialCode?.replaceAll("+", ""),
      // In live this will use
      ApiAndParams.fcmToken:
          Constant.session.getData(SessionManager.keyFCMToken)
    };

    await getLoginApi(context: context, params: params).then((mainData) async {
      if (mainData[ApiAndParams.status].toString() == "1") {
        setUserDataInSession(user, mainData, context);
      } else {
        GeneralMethods.showSnackBarMsg(context, mainData[ApiAndParams.message],
            snackBarSecond: 2);
      }
    });
  }

  static setUserDataInSession(User firebaseUser, Map<String, dynamic> mainData,
      BuildContext context) async {
    Map<String, dynamic> data =
        await mainData[ApiAndParams.data] as Map<String, dynamic>;

    Map<String, dynamic> userData =
        await data[ApiAndParams.user] as Map<String, dynamic>;

    Constant.session.setBoolData(SessionManager.isUserLogin, true, false);

    Constant.session
        .setData(SessionManager.keyAuthUid, firebaseUser.uid, false);
    print("testing september ");
    print(userData[ApiAndParams.status]);
    Constant.session
        .setUserData(
          /*firebaseUid: Constant.session.getData(SessionManager.keyFirebaseId),*/
          name: userData[ApiAndParams.name],
          email: userData[ApiAndParams.email],
          profile: userData[ApiAndParams.profile].toString(),
          countryCode: userData[ApiAndParams.countryCode],
          mobile: userData[ApiAndParams.mobile],
          lblReferralCode: userData[ApiAndParams.lblReferralCode],
          // status: int.parse(userData[ApiAndParams.status]),
          status: 1,
          token: data[ApiAndParams
              .accessToken], /*balance: userData[ApiAndParams.balance].toString()*/
        )
        .then((value) async => await getRedirection(context));
  }

  static getRedirection(BuildContext context) async {
    if (Constant.session.getIntData(SessionManager.keyUserStatus) == 0) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          editProfileScreen, (Route<dynamic> route) => false,
          arguments: "register");
    } else {
      if (Constant.session.getBoolData(SessionManager.keySkipLogin) ||
          Constant.session.getBoolData(SessionManager.isUserLogin)) {
        if (Constant.session.getData(SessionManager.keyLatitude) == "0" &&
            Constant.session.getData(SessionManager.keyLongitude) == "0") {
          Navigator.of(context).pushNamedAndRemoveUntil(
              getLocationScreen, (Route<dynamic> route) => false,
              arguments: "location");
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
            mainHomeScreen,
            (Route<dynamic> route) => false,
          );
        }
      }
    }
  }
}
