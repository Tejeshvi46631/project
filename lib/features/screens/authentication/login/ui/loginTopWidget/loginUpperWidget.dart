import 'package:country_code_picker/country_code_picker.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/utils/styles/designConfig.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/authentication/login/ui/button.dart';
import 'package:egrocer/features/screens/authentication/login/ui/function.dart';
import 'package:egrocer/features/screens/authentication/login/ui/loginTopWidget/childWidget/childWidget.dart';
import 'package:egrocer/features/screens/authentication/login/ui/mobileNoWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginUpperWidget extends StatefulWidget {
  LoginUpperWidget({
    super.key,
  });

  @override
  State<LoginUpperWidget> createState() => _LoginUpperWidgetState();
}

class _LoginUpperWidgetState extends State<LoginUpperWidget> {
  CountryCode? selectedCountryCode;
  bool isLoading = false, isAcceptedTerms = false;
  TextEditingController edtPhoneNumber = TextEditingController(text: "");
  bool isDark = Constant.session.getBoolData(SessionManager.isDarkTheme);
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String otpVerificationId = "";
  String phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: Constant.size30, horizontal: Constant.size20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        LoginChildWidget.welcomeText(context),
        Widgets.getSizedBox(
          height: Constant.size40,
        ),
        Container(
            decoration: DesignConfig.boxDecoration(
                Theme.of(context).scaffoldBackgroundColor, 10),
            child: Row(
              children: [
                const SizedBox(width: 5),
                Icon(
                  Icons.phone_android,
                  color: ColorsRes.mainTextColor,
                ),
                IgnorePointer(
                  ignoring: isLoading,
                  child: CountryCodePicker(
                    onInit: (countryCode) {
                      selectedCountryCode = countryCode;
                    },
                    onChanged: (countryCode) {
                      selectedCountryCode = countryCode;
                    },
                    initialSelection: Constant.initialCountryCode,
                    textOverflow: TextOverflow.ellipsis,
                    showCountryOnly: false,
                    alignLeft: false,
                    backgroundColor:
                        isDark ? Colors.black : Colors.black,
                    textStyle: TextStyle(color: ColorsRes.mainTextColor),
                    dialogBackgroundColor:
                        isDark ? Colors.black : Colors.black,
                    padding: EdgeInsets.zero,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: ColorsRes.grey,
                  size: 15,
                ),
                Widgets.getSizedBox(
                  width: Constant.size10,
                ),
                Flexible(
                  child: TextField(
                    controller: edtPhoneNumber,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: ColorsRes.mainTextColor,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintStyle: TextStyle(color: Colors.grey[300]),
                      hintText: "9999999999",
                    ),
                  ),
                )
              ],
            )),
        Widgets.getSizedBox(
          height: Constant.size15,
        ),
        Row(
          children: [
            Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: isAcceptedTerms,
              activeColor: ColorsRes.appColor,
              onChanged: (bool? val) {
                setState(() {
                  isAcceptedTerms = val!;
                });
              },
            ),
            LoginChildWidget.privacyTextDesc(context)
          ],
        ),
        Widgets.getSizedBox(
          height: Constant.size40,
        ),
        LoginScreenButton.proceedBtn(isLoading, context, () {
          loginWithPhoneNumber();
        }),
        Widgets.getSizedBox(
          height: Constant.size40,
        ),
        LoginScreenButton.skipLoginText(context),
      ]),
    );
  }

  loginWithPhoneNumber() async {
    bool checkInternet = await GeneralMethods.checkInternet();
    String? msg = "";
    String? mobileValidation = await LoginFunctions.mobileNumberValidation(
        context,edtPhoneNumber, isAcceptedTerms);

    if (checkInternet) {
      if (mobileValidation != "") {
        msg = mobileValidation;
      } else {
        if (isLoading) return;
        setState(() {
          isLoading = true;
        });
        firebaseLoginProcess();
      }
    } else {
      msg = getTranslatedValue(
        context,
        "lblCheckInternet",
      );
    }

    if (msg != "") {
      GeneralMethods.showSnackBarMsg(context, msg, snackBarSecond: 2);
    }
  }

  firebaseLoginProcess() async {
    if (edtPhoneNumber.text.isNotEmpty) {
      await FirebaseAuth.instance.verifyPhoneNumber(
        timeout: Duration(seconds: Constant.otpTimeOutSecond),
        phoneNumber:
            '${selectedCountryCode!.dialCode}${edtPhoneNumber.text}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          GeneralMethods.showSnackBarMsg(context, e.message!);
          setState(() {
            isLoading = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          isLoading = false;
          setState(() {
            phoneNumber =
                '${selectedCountryCode!.dialCode} - ${edtPhoneNumber.text}';
            otpVerificationId = verificationId;
            List<dynamic> firebaseArguments = [
              firebaseAuth,
              otpVerificationId,
              edtPhoneNumber.text,
              selectedCountryCode!
            ];
            Navigator.pushNamed(context, otpScreen,
                arguments: firebaseArguments);
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        },
      );
    }
  }
}
