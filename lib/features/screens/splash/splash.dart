import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/provider/cartProvider.dart';
import 'package:egrocer/core/provider/homeScreenDataProvider.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/splash/ui/firebaseFunction.dart';
import 'package:egrocer/features/screens/splash/ui/getSettingsFunction.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<Splash> {
  late PackageInfo packageInfo;
  String currentAppVersion = "";
  String expectedAppVersion = "1.0.16";

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((value) async {
      try {
        SplashInit.firebaseCall(context);
      } catch (ignore) {}
      packageInfo = await PackageInfo.fromPlatform();
      SplashSetting.getSetting(
          context, packageInfo, currentAppVersion, expectedAppVersion);
    });
  }

  callHomeProvider() async {
    Map<String, String> params = await Constant.getProductsDefaultParams();
    await context
        .read<HomeScreenProvider>()
        .getHomeScreenApiProvider(context: context, params: params)
        .then((homeScreenData) async {
      print("In mainnn");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Widgets.defaultImg(image: 'splash_logo'),
      ),
    );
  }
}
