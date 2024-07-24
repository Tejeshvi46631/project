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
  final String expectedAppVersion = "1.0.16";

  @override
  void initState() {
    super.initState();
    initializeSplash();
  }

  Future<void> initializeSplash() async {
    await initializeFirebase();
    await fetchPackageInfo();
    await getSettings();
    await callHomeProvider();
    navigateToNextScreen();
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
      await SplashSetting.getSetting(context, packageInfo, currentAppVersion, expectedAppVersion);
    } catch (e) {
      print("Error getting settings: $e");
    }
  }

  Future<void> callHomeProvider() async {
    try {
      Map<String, String> params = await Constant.getProductsDefaultParams();
      await context.read<HomeScreenProvider>().getHomeScreenApiProvider(context: context, params: params);
    } catch (e) {
      print("Error calling home provider: $e");
    }
  }

  void navigateToNextScreen() {
    // TODO: Add logic to navigate to the next screen, e.g.:
    // Navigator.pushReplacementNamed(context, Routes.nextScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Widgets.defaultImg(image: 'splash_logo'),
      ),
    );
  }
}
