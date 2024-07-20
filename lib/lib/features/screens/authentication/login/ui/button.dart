import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/authentication/login/ui/function.dart';
import 'package:flutter/material.dart';

class LoginScreenButton {
  static Widget proceedBtn(
      bool isLoading, BuildContext context, Function callbackFun) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Widgets.BtnWidget(context, 10,
            isSetShadow: false,
            title: getTranslatedValue(
              context,
              "lblLogin",
            ).toUpperCase(),
            callback: callbackFun);
  }

  static Widget skipLoginText(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Constant.session.setBoolData(SessionManager.keySkipLogin, true, false);
        await LoginFunctions.getRedirection(context);
      },
      child: Container(
        alignment: Alignment.center,
        child: Text(
          getTranslatedValue(
            context,
            "lblSkipLogin",
          ),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: ColorsRes.appColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
