import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/homeScreenData.dart';
import 'package:egrocer/core/provider/cartProvider.dart';
import 'package:egrocer/core/provider/homeScreenDataProvider.dart';
import 'package:egrocer/features/screens/splash/ui/timer.dart';
import 'package:egrocer/features/screens/splash/utils/appSettingsApi.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class SplashSetting{
  static getSetting(BuildContext context,PackageInfo packageInfo,String currentAppVersion,String expectedAppVersion) async {
    getAppSettings(context: context).then((value) async {

      Map<String, String> params = await Constant.getProductsDefaultParams();
      await context
          .read<HomeScreenProvider>()
          .getHomeScreenApiProvider(context: context, params: params)
          .then((homeScreenData) async {
        // if (homeScreenData != null) {
        //   print("In Splash");
        //   HomeScreenData homeData = homeScreenData;
        //
        //   homeScreenData.map = await homeScreenData.getSliderImages(homeData);
        // }
      });


      currentAppVersion = packageInfo.version;
      print("PACKAGE VERSION11");
      print(packageInfo.version);
      LocationPermission permission;
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      } else if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
      SplashTimer.startTime(currentAppVersion, expectedAppVersion, context);
    });

  }
}