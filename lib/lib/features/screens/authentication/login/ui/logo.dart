import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginLogo {
  static Widget upperPart(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Constant.size10, vertical: Constant.size20),
      child: Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.width * 0.6),
        child: Widgets.defaultImg(
          image: "logo",
        ),
      ),
    );
  }


}
