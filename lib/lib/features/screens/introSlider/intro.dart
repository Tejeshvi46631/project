//
// import 'package:egrocer/core/widgets/generalMethods.dart';
// import 'package:egrocer/features/screens/introSlider/ui/introWidget.dart';
// import 'package:flutter/material.dart';
//
// class IntroSliderScreen extends StatefulWidget {
//   const IntroSliderScreen({Key? key}) : super(key: key);
//
//   @override
//   IntroSliderScreenState createState() => IntroSliderScreenState();
// }
//
// class IntroSliderScreenState extends State<IntroSliderScreen> {
//   final _pageController = PageController();
//   int currentPosition = 0;
//   static List introSlider = [];
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: _buildPageView(),
//     );
//   }
//
//   _buildPageView() {
//     introSlider = [
//       {
//         "image": "location",
//         "title": getTranslatedValue(
//           context,
//           "lblIntroTitle1",
//         ),
//         "description": getTranslatedValue(
//           context,
//           "lblIntroDesc1",
//         ),
//       },
//       {
//         "image": "order",
//         "title": getTranslatedValue(
//           context,
//           "lblIntroTitle2",
//         ),
//         "description": getTranslatedValue(
//           context,
//           "lblIntroDesc2",
//         ),
//       },
//       {
//         "image": "delivered",
//         "title": getTranslatedValue(
//           context,
//           "lblIntroTitle3",
//         ),
//         "description": getTranslatedValue(
//           context,
//           "lblIntroDesc3",
//         ),
//       },
//     ];
//
//     return Stack(
//       children: [
//         IntroSliderWidget.pageWidget(currentPosition,introSlider,context),
//         PageView.builder(
//           itemCount: introSlider.length,
//           controller: _pageController,
//           itemBuilder: (BuildContext context, int index) {
//             return Container();
//           },
//           onPageChanged: (int index) {
//             currentPosition = index;
//             setState(
//                   () {},
//             );
//           },
//         ),
//         Positioned(
//           bottom: 50,
//           left: currentPosition == introSlider.length - 1 ? 80 : 0,
//           right: currentPosition == introSlider.length - 1 ? 80 : 0,
//          // child: IntroSliderWidget.buttonWidget(currentPosition,context,introSlider,currentPosition),
//         ),
//       ],
//     );
//   }
//
//
// }
