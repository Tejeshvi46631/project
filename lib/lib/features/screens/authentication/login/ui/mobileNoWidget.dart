import 'package:country_code_picker/country_code_picker.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LoginMobileWidget extends StatefulWidget {
  bool isLoading;
  CountryCode? selectedCountryCode;
  bool isDark;
  TextEditingController edtPhoneNumber;

  LoginMobileWidget(
      {super.key,
      required this.isLoading,
      required this.selectedCountryCode,
      required this.isDark,
      required this.edtPhoneNumber});

  @override
  State<LoginMobileWidget> createState() => _LoginMobileWidgetState();
}

class _LoginMobileWidgetState extends State<LoginMobileWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 5),
        Icon(
          Icons.phone_android,
          color: ColorsRes.mainTextColor,
        ),
        IgnorePointer(
          ignoring: widget.isLoading,
          child: CountryCodePicker(
            onInit: (countryCode) {
              widget.selectedCountryCode = countryCode;
            },
            onChanged: (countryCode) {
              widget.selectedCountryCode = countryCode;
            },
            initialSelection: Constant.initialCountryCode,
            textOverflow: TextOverflow.ellipsis,
            showCountryOnly: false,
            alignLeft: false,
            backgroundColor: widget.isDark ? Colors.black : Colors.black,
            textStyle: TextStyle(color: ColorsRes.mainTextColor),
            dialogBackgroundColor: widget.isDark ? Colors.black : Colors.black,
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
            controller: widget.edtPhoneNumber,
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
    );
  }
}
