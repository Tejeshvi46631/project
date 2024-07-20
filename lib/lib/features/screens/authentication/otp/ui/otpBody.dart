import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/utils/styles/designConfig.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class Otp {
  static Widget body(Widget child){
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Constant.size10, vertical: Constant.size20),
            child: Widgets.defaultImg(
              image: "logo",
            ),
          ),
          Card(
            shape: DesignConfig.setRoundedBorder(10),
            margin: EdgeInsets.symmetric(horizontal: Constant.size5, vertical: Constant.size5),
            child: child,
          ),
        ],
      ),
    );
  }

  static Widget otpPinWidget(otpLength,otpFieldController,BuildContext context,Function(String)? onCompleted) {
    return OTPTextField(
      length: otpLength,
      controller: otpFieldController,
      fieldWidth: MediaQuery.of(context).size.width * 0.12,
      width: MediaQuery.of(context).size.width,
      textFieldAlignment: MainAxisAlignment.spaceEvenly,
      fieldStyle: FieldStyle.box,
      outlineBorderRadius: 10,
      inputFormatter: [FilteringTextInputFormatter.digitsOnly],
      otpFieldStyle: OtpFieldStyle(
          borderColor: ColorsRes.appColor,
          enabledBorderColor: ColorsRes.appColor),
      keyboardType: TextInputType.number,
      style: TextStyle(
        color: ColorsRes.appColor,
        fontWeight: FontWeight.bold,
      ),
      onChanged: (value) => () {},
      onCompleted: onCompleted,
    );
  }
}