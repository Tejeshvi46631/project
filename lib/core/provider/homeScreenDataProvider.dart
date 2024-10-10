
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/homeScreenData.dart';
import 'package:egrocer/core/webservices/homeScreenApi.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum HomeScreenState {
  initial,
  loading,
  loaded,
  error,
}

class HomeScreenProvider extends ChangeNotifier {
  HomeScreenState homeScreenState = HomeScreenState.initial;
  String message = '';
  late HomeScreenData homeScreenData;
  Map<String, List<String>> map = {};

  Future<Map<String, List<String>>> getSliderImages(
      HomeScreenData homeScreenData) async {
    Map<String, List<String>> map = {};

    Map<String, List<String>> addOfferImagesIntoMap(
        Map<String, List<String>> map, String key, String imageUrl) {
      if (map.containsKey(key)) {
        map[key]?.add(imageUrl);
      } else {
        map[key] = [];
        map[key]?.add(imageUrl);
      }
      return map;
    }


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

  Future getHomeScreenApiProvider(
      {required Map<String, dynamic> params,
        required BuildContext context}) async {
    homeScreenState = HomeScreenState.loading;
    notifyListeners();

    try {
      homeScreenData = HomeScreenData.fromJson(
          await getHomeScreenDataApi(context: context, params: params));
      homeScreenData.category
          .removeWhere((element) => element.name == "SHOP BY REGION");
      homeScreenData.category.removeWhere((element) => element.id == "166");
      Constant.gSections = homeScreenData.sections;
      homeScreenState = HomeScreenState.loaded;
      // HomeScreenData homeData = homeScreenData;
      map = await getSliderImages(homeScreenData);

      notifyListeners();

      return homeScreenData;
    } catch (e) {
      message = e.toString();
      homeScreenState = HomeScreenState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
      return null;
    }
  }
}
