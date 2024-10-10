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

  @override
  void initState() {
    super.initState();
    initializeSplash();
  }

  Future<void> initializeSplash() async {
    await initializeFirebase();
    await fetchPackageInfo();
    await getSettings();
  }

  Future<void> initializeFirebase() async {
    try {
      await SplashInit.firebaseCall(context);
    } catch (e) {
      print("Firebase initialization error: $e");
    }
  }

  Future<void> fetchPackageInfo() async {
    try {
      packageInfo = await PackageInfo.fromPlatform();
      currentAppVersion = packageInfo.version;
    } catch (e) {
      print("Error fetching package info: $e");
    }
  }

  Future<void> getSettings() async {
    try {
      await SplashSetting.getSetting(context, packageInfo, currentAppVersion, currentAppVersion);
    } catch (e) {
      print("Error getting settings: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Widgets.defaultImg(image: 'splash', boxFit: BoxFit.cover),
    );
  }
}
