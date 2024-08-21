import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/model/homeScreenData.dart';
import 'package:egrocer/core/provider/homeScreenDataProvider.dart';
import 'package:egrocer/features/screens/splash/ui/timer.dart';
import 'package:egrocer/features/screens/splash/utils/appSettingsApi.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class SplashSetting {
  static Future<void> getSetting(BuildContext context, PackageInfo packageInfo, String currentAppVersion, String expectedAppVersion) async {
    try {
      await getAppSettings(context: context);

     /* Map<String, String> params = await Constant.getProductsDefaultParams();
      await context.read<HomeScreenProvider>().getHomeScreenApiProvider(context: context, params: params);*/
      Navigator.pushNamed(context, mainHomeScreen,);

      currentAppVersion = packageInfo.version;
      print("PACKAGE VERSION: ${packageInfo.version}");

      LocationPermission permission = await _checkAndRequestLocationPermission();

      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw 'Location Not Available';
      }

      SplashTimer.startTime(currentAppVersion, expectedAppVersion, context);
    } catch (e) {
      print("Error in getSetting: $e");
    }
  }

  static Future<LocationPermission> _checkAndRequestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission;
  }
}
