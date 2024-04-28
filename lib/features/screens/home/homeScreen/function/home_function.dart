import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/model/homeScreenData.dart';
import 'package:egrocer/core/provider/cartListProvider.dart';
import 'package:egrocer/core/provider/userProfileProvider.dart';
import 'package:egrocer/core/repository/registerFcmKey.dart';
import 'package:egrocer/core/webservices/userDetailApi.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:egrocer/features/screens/home/homeScreen/widget/customDialog.dart';
import 'package:egrocer/features/screens/splash/utils/appSettingsApi.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreenFunction {
  static Future<Map<String, List<String>>> getSliderImages(
      HomeScreenData homeScreenData) async {
    Map<String, List<String>> map = {};

    for (int i = 0; i < homeScreenData.offers.length; i++) {
      Offers offerImage = homeScreenData.offers[i];
      if (offerImage.position == "top") {
        addOfferImagesIntoMap(map, "top", offerImage.imageUrl);
      } else if (offerImage.position == "below_category") {
        addOfferImagesIntoMap(map, "below_category", offerImage.imageUrl);
      } else if (offerImage.position == "below_slider") {
        addOfferImagesIntoMap(map, "below_slider", offerImage.imageUrl);
      } else if (offerImage.position == "below_section") {
        addOfferImagesIntoMap(map,
            "below_section-${offerImage.sectionPosition}", offerImage.imageUrl);
      }
    }
    return map;
  }

  static Map<String, List<String>> addOfferImagesIntoMap(
      Map<String, List<String>> map, String key, String imageUrl) {
    if (map.containsKey(key)) {
      map[key]?.add(imageUrl);
    } else {
      map[key] = [];
      map[key]?.add(imageUrl);
    }
    return map;
  }

  static() {}

  static callInit(BuildContext context) async {
    if (Constant.session.getBoolData(SessionManager.keyPopupOfferEnabled)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog();
        },
      );
    }

    try {
      FirebaseMessaging.instance.getToken().then((token) {
        if (Constant.session.getData(SessionManager.keyFCMToken).isEmpty) {
          Constant.session.setData(SessionManager.keyFCMToken, token!, false);
          registerFcmKey(context: context, fcmToken: token);
        }
      });
    } catch (ignore) {}

    await getAppSettings(context: context);

    // Map<String, String> params = await Constant.getProductsDefaultParams();
    // await context
    //     .read<HomeScreenProvider>()
    //     .getHomeScreenApiProvider(context: context, params: params)
    //     .then((homeScreenData) async {
    //   if (homeScreenData != null) {
    //     HomeScreenData homeData = homeScreenData;
    //
    //     map = await getSliderImages(homeData);
    //   }
    // });

    if (Constant.session.getBoolData(SessionManager.isUserLogin)) {
      await context
          .read<CartListProvider>()
          .getAllCartItems(context: context);

      await getUserDetail(context: context).then(
            (value) {
          if (value[ApiAndParams.status].toString() == "1") {
            context
                .read<UserProfileProvider>()
                .updateUserDataInSession(value);
          }
        },
      );
    }
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      if (deepLink.path.split("/")[1] == "product") {
        Navigator.pushNamed(
          context,
          productDetailScreen,
          arguments: [
            deepLink.path.split("/")[2].toString(),
            getTranslatedValue(
              context,
              "lblProductDetail",
            ),
            null
          ],
        );
      }
    }

    FirebaseDynamicLinks.instance.onLink.listen(
          (dynamicLinkData) {
        if (dynamicLinkData.link.path.split("/")[1] == "product") {
          Navigator.pushNamed(
            context,
            productDetailScreen,
            arguments: [
              dynamicLinkData.link.path.split("/")[2].toString(),
              getTranslatedValue(
                context,
                "lblProductDetail",
              ),
              null
            ],
          );
        }
      },
    );
  }
}
