import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/utils/styles/designConfig.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IntroSliderWidget{

  static pageWidget(int index,List introSlider,BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Widgets.defaultImg(
            padding: EdgeInsetsDirectional.all(Constant.size15),
            image: introSlider[index]["image"],
          ),
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                child: infoWidget(index,introSlider,context),
                padding: const EdgeInsetsDirectional.only(start: 20, end: 20, bottom: 10),
                margin: const EdgeInsetsDirectional.only(start: 20, end: 20, bottom: 20, top: 50),
                decoration: DesignConfig.boxDecoration(ColorsRes.appColor, 30),
              ),
              Container(
                  width: 100,
                  height: 100,
                  //child:Image.asset(Constant.getImagePath("intro_logo.png"))),
                  decoration: ShapeDecoration(
                    color: ColorsRes.appColor,
                    shape: CircleBorder(
                      side: BorderSide(width: 5, color: Colors.white),
                    ),
                  ),
                  child: Center(
                      child: Widgets.defaultImg(
                        image: "splash_logo",
                        height: 50,
                        width: 50,
                      ))),
            ],
          ),
        )
      ],
    );
  }

  static infoWidget(int index,List introSlider,BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Text(
          introSlider[index]["title"],
          softWrap: true,
          style: Theme.of(context).textTheme.headlineSmall!.merge(
            TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      Text(
        introSlider[index]["description"],
        softWrap: true,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall!.merge(
          TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    ]);
  }

  static buttonWidget(int index,BuildContext context,List introSlider,currentPosition) {
    return GestureDetector(
      onTap: () {
        if (Constant.session.getBoolData(SessionManager.keySkipLogin) || Constant.session.getBoolData(SessionManager.isUserLogin)) {
          if (Constant.session.getData(SessionManager.keyLatitude) == "0" && Constant.session.getData(SessionManager.keyLongitude) == "0") {
            Navigator.pushNamed(context, getLocationScreen, arguments: "location");
          } else {
            Navigator.pushNamed(
              context,
              mainHomeScreen,
            );
          }
        } else {
          Navigator.pushReplacementNamed(context, loginScreen);
        }
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          vertical: Constant.size15,
        ),
        margin: const EdgeInsets.only(top: 80),
        decoration: DesignConfig.boxDecoration(index == introSlider.length - 1 ? Colors.white : Colors.transparent, 10),
        child: index == introSlider.length - 1
            ? Text(
          getTranslatedValue(
            context,
            "lblGetStarted",
          ),
          softWrap: true,
          style: Theme.of(context).textTheme.headlineSmall!.merge(
            TextStyle(
              color: ColorsRes.appColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        )
            : dotWidget(introSlider,currentPosition),
      ),
    );
  }

  static dotWidget(List introSlider,  int currentPosition ) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(introSlider.length, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            margin: const EdgeInsetsDirectional.only(end: 10.0),
            width: currentPosition == index ? 30 : 13,
            height: currentPosition == index ? 12 : 13,
            decoration: DesignConfig.boxDecoration(Colors.white, 13),
          );
        }),
      ),
    );
  }
}