import 'dart:async';

import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class OtpScreenWidget{
  static enterCode(BuildContext context,Widget otpPinWidget,Widget proceedBtn,Widget resendOtpWidget,selectedCountryCode,phoneNumber) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Constant.size30, horizontal: Constant.size30),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        headerWidget(
          getTranslatedValue(
            context,
            "lblEnterVerificationCode",
          ),
          getTranslatedValue(
            context,
            "lblOtpSendMessage",
          ),
        ),
        Text(
          "${selectedCountryCode}-${phoneNumber}",
        ),
        const SizedBox(height: 30),
        otpPinWidget,
        const SizedBox(height: 30),
        proceedBtn,
        const SizedBox(height: 30),
        resendOtpWidget,
      ]),
    );
  }


  static headerWidget(String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: ColorsRes.grey),
      ),
    );
  }

  static resendOtpWidget(BuildContext context,Timer? timer,otpResendTime,GestureRecognizer? recognizer) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .merge(const TextStyle(fontWeight: FontWeight.w400)),
          text: "${getTranslatedValue(
            context,
            "lblDidNotGetCode",
          )}\t",
          children: <TextSpan>[
            TextSpan(
                text: timer != null && timer!.isActive
                    ? otpResendTime.toString()
                    : getTranslatedValue(
                  context,
                  "lblResendOtp",
                ),
                style: TextStyle(
                    color: ColorsRes.appColor, fontWeight: FontWeight.bold),
                recognizer: recognizer),
          ],
        ),
      ),
    );
  }

  static proceedBtn(bool isLoading,BuildContext context,Function call) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Widgets.BtnWidget(
      context,
      10,
      title: getTranslatedValue(
        context,
        "lblVerifyAndProceed",
      ),
      callback: call,
      isSetShadow: false,
    );
  }

}