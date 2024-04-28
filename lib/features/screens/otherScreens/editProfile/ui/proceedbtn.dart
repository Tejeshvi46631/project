import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/provider/userProfileProvider.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileProceedBtn extends StatelessWidget {
  late TextEditingController edtUsername;
  final formKey;
  late TextEditingController edtEmail;
  late TextEditingController edtMobile;
  String tempName;
  String tempEmail;
  String selectedImagePath;
  final String? from;

  EditProfileProceedBtn(
      {super.key,
      required this.edtUsername,
      required this.edtEmail,
      required this.edtMobile,
      required this.tempName,
      required this.tempEmail,
      required this.selectedImagePath,
      required this.from,required this.formKey});


  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, userProfileProvider, _) {
        return userProfileProvider.profileState == ProfileState.loading
            ? const Center(child: CircularProgressIndicator())
            : Widgets.gradientBtnWidget(context, 10,
                title: getTranslatedValue(
                  context,
                  "lblUpdate",
                ), callback: () {
                print("enterted");
                if (tempName != edtUsername.text ||
                    tempEmail != edtEmail.text ||
                    selectedImagePath.isNotEmpty ||
                    formKey.currentState!.validate()) {
                  Map<String, String> params = {};
                  params[ApiAndParams.name] = edtUsername.text.trim();
                  params[ApiAndParams.email] = edtEmail.text.trim();
                  print("Changing screen");
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      getLocationScreen, (Route<dynamic> route) => false,
                      arguments: "location");
                  userProfileProvider
                      .updateUserProfile(
                          context: context,
                          selectedImagePath: selectedImagePath,
                          params: params)
                      .then((value) {
                    if (from == "register") {
                      print("Changing screen");
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          getLocationScreen, (Route<dynamic> route) => false,
                          arguments: "location");
                    }
                  });
                }
              });
      },
    );
  }
}
