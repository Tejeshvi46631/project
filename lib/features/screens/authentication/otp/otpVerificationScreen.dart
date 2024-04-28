import 'dart:async';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:egrocer/features/screens/authentication/otp/ui/otpBody.dart';
import 'package:egrocer/features/screens/authentication/otp/ui/otpFunction.dart';
import 'package:egrocer/features/screens/authentication/otp/ui/otpWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:telephony/telephony.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String otpVerificationId;
  final String phoneNumber;
  final FirebaseAuth firebaseAuth;
  final CountryCode selectedCountryCode;

  const OtpVerificationScreen(
      {Key? key,
      required this.otpVerificationId,
      required this.phoneNumber,
      required this.firebaseAuth,
      required this.selectedCountryCode})
      : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _LoginAccountState();
}

class _LoginAccountState extends State<OtpVerificationScreen> {
  String editOtp = "";
  bool isDark = Constant.session.getBoolData(SessionManager.isDarkTheme);
  int otpLength = 6;
  int otpResendTime = Constant.otpResendSecond + 1;
  Timer? _timer;
  bool isLoading = false;
  String resendOtpVerificationId = "";
  OtpFieldController otpFieldController = OtpFieldController();
  Telephony telephony = Telephony.instance;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      if (mounted) {
        otpFieldController.set(['', '', '', '', '', '']);
      }
    });
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        print(message.address); // +977981******67, sender nubmer
        print(message.body); // Your OTP code is 34567
        print(message.date); // 1659690242000, timestamp

        // get the message
        String sms = message.body.toString();

        if (message.body!.contains('chayyakartaug.firebaseapp.com')) {
          // verify SMS is sent for OTP with sender number
          String otpcode = sms.replaceAll(new RegExp(r'[^0-9]'), '');
          // prase code from the OTP sms
          otpFieldController.set(otpcode.split(""));
          // split otp code to list of number
          // and populate to otb boxes
          setState(() {
            // refresh UI
          });
        } else {
          print("Normal message.");
        }
      },
      listenInBackground: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Otp.body(OtpScreenWidget.enterCode(
            context,
            Otp.otpPinWidget(
              otpLength,
              otpFieldController,
              context,
              (val) {
                editOtp = val.toString();
              },
            ),
            OtpScreenWidget.proceedBtn(
              isLoading,
              context,
              () {
                verifyOtp();
              },
            ),
            OtpScreenWidget.resendOtpWidget(
                context,
                _timer,
                otpResendTime,
                TapGestureRecognizer()
                  ..onTap = () {
                    if (_timer == null || !_timer!.isActive) {
                      firebaseLoginProcess();
                      startResendTimer();
                    }
                  }),
            widget.selectedCountryCode,
            widget.phoneNumber)));
  }

  verifyOtp() async {
    String msg = await checkOtpValidation();

    if (msg != "") {
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = true;
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: resendOtpVerificationId.isNotEmpty
                ? resendOtpVerificationId
                : widget.otpVerificationId,
            smsCode: editOtp);

        widget.firebaseAuth.signInWithCredential(credential).then((value) {
          User? user = value.user!;
          OtpFunction.backendApiProcess(
              user, widget.phoneNumber, widget.selectedCountryCode, context);
        }).catchError((e) {
          setState(() {
            isLoading = false;
          });

          msg = e.toString();
          if (msg.contains("]")) {
            msg = msg.split("]").last;
          }
        });
      });
    }

    if (msg.isNotEmpty) {
      GeneralMethods.showSnackBarMsg(context, msg, snackBarSecond: 2);
    }
  }

  checkOtpValidation() async {
    bool checkInternet = await GeneralMethods.checkInternet();
    String? msg;

    if (checkInternet) {
      if (editOtp.length < otpLength) {
        msg = getTranslatedValue(
          context,
          "lblEnterOtp",
        );
      } else {
        if (isLoading) return;
        setState(() {
          isLoading = true;
        });
        return "";
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
    if (widget.phoneNumber.isNotEmpty) {
      await FirebaseAuth.instance.verifyPhoneNumber(
        timeout: Duration(seconds: Constant.otpTimeOutSecond),
        phoneNumber:
            '${widget.selectedCountryCode.dialCode} - ${widget.phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          GeneralMethods.showSnackBarMsg(context, e.message!);
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          if (mounted) {
            isLoading = false;
            setState(() {
              resendOtpVerificationId = verificationId;
            });
          }
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

  void startResendTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        setState(() {
          if (otpResendTime == 0) {
            timer.cancel();
            Constant.otpResendSecond + 1;
          } else {
            otpResendTime--;
          }
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }
}
