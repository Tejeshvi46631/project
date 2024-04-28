import 'package:country_code_picker/country_code_picker.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/utils/styles/designConfig.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:egrocer/features/screens/authentication/login/ui/loginTopWidget/loginUpperWidget.dart';
import 'package:egrocer/features/screens/authentication/login/ui/logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginAccount extends StatefulWidget {
  const LoginAccount({Key? key}) : super(key: key);

  @override
  State<LoginAccount> createState() => _LoginAccountState();
}

class _LoginAccountState extends State<LoginAccount> {



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            LoginLogo.upperPart(context),
            Card(
              shape: DesignConfig.setRoundedBorderSpecific(10,
                  istop: true, isbtm: true),
              margin: EdgeInsets.symmetric(
                  horizontal: Constant.size5, vertical: Constant.size5),
              child: LoginUpperWidget(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
