import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';

class EditProfileUserInfo extends StatelessWidget {
  late TextEditingController edtUsername;
  final formKey;
  late TextEditingController edtEmail;
  late TextEditingController edtMobile;

  EditProfileUserInfo(
      {super.key,
      required this.edtUsername,
      required this.edtEmail,
      required this.edtMobile,
      required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(children: [
          Widgets.textFieldWidget(
              edtUsername,
              GeneralMethods.emptyValidation,
              getTranslatedValue(
                context,
                "lblUserName",
              ),
              TextInputType.text,
              getTranslatedValue(
                context,
                "lblEnterUserName",
              ),
              context,
              hint: getTranslatedValue(
                context,
                "lblUserName",
              ),
              floatingLbl: false,
              borderRadius: 8,
              sicon: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8, start: 8),
                  child: Widgets.defaultImg(
                      image: "user_icon", iconColor: ColorsRes.grey)),
              prefixIconConstaint:
                  const BoxConstraints(maxHeight: 40, maxWidth: 40),
              bgcolor: Theme.of(context).scaffoldBackgroundColor),
          const SizedBox(height: 15),
          Widgets.textFieldWidget(
              edtEmail,
              GeneralMethods.emailValidation,
              getTranslatedValue(
                context,
                "lblEmail",
              ),
              TextInputType.emailAddress,
              getTranslatedValue(
                context,
                "lblEnterValidEmail",
              ),
              context,
              hint: getTranslatedValue(
                context,
                "lblEmail",
              ),
              floatingLbl: false,
              borderRadius: 8,
              sicon: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8, start: 8),
                  child: Widgets.defaultImg(
                      image: "mail_icon", iconColor: ColorsRes.grey)),
              prefixIconConstaint:
                  const BoxConstraints(maxHeight: 40, maxWidth: 40),
              bgcolor: Theme.of(context).scaffoldBackgroundColor),
          const SizedBox(height: 15),
          Widgets.textFieldWidget(
              edtMobile,
              GeneralMethods.phoneValidation,
              edtMobile.text.trim().isEmpty
                  ? getTranslatedValue(
                      context,
                      "lblMobileNumber",
                    )
                  : "",
              TextInputType.phone,
              getTranslatedValue(
                context,
                "lblEnterValidMobile",
              ),
              context,
              hint: getTranslatedValue(
                context,
                "lblMobileNumber",
              ),
              borderRadius: 8,
              floatingLbl: false,
              sicon: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8, start: 8),
                  child: Widgets.defaultImg(
                      image: "phone_icon", iconColor: ColorsRes.grey)),
              prefixIconConstaint:
                  const BoxConstraints(maxHeight: 40, maxWidth: 40),
              bgcolor: Theme.of(context).scaffoldBackgroundColor),
        ]));
  }
}
