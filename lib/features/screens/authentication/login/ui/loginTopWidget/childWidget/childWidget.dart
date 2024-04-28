import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginChildWidget {
  static Widget welcomeText(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        getTranslatedValue(
          context,
          "lblWelcome",
        ),
        style: const TextStyle(
            fontWeight: FontWeight.bold, letterSpacing: 0.5, fontSize: 30),
      ),
      subtitle: Text(
        getTranslatedValue(
          context,
          "lblLoginEnterNumberMessage",
        ),
        style: TextStyle(color: ColorsRes.grey),
      ),
    );
  }

  static Widget privacyTextDesc(BuildContext context) {
    return Expanded(
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .merge(const TextStyle(fontWeight: FontWeight.w400)),
          text: "${getTranslatedValue(
            context,
            "lblAgreementMsg1",
          )}\t",
          children: <TextSpan>[
            TextSpan(
                text: getTranslatedValue(
                  context,
                  "lblTermsOfService",
                ),
                style: TextStyle(
                  color: ColorsRes.appColor,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(context, webViewScreen,
                        arguments: "terms");
                  }),
            TextSpan(
                text: "\t${getTranslatedValue(
              context,
              "lblAnd",
            )}\t"),
            TextSpan(
                text: getTranslatedValue(
                  context,
                  "lblPrivacyPolicy",
                ),
                style: TextStyle(
                  color: ColorsRes.appColor,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(context, webViewScreen,
                        arguments: "privacy");
                  }),
          ],
        ),
      ),
    );
  }
}
