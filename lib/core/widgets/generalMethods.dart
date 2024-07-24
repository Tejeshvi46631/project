import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:egrocer/core/constant/appLocalization.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/geoAddress.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class GeneralMethods {
  static String formatDate(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
  }

  static Future<bool> checkInternet() async {
    bool check = false;

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      check = true;
    }
    return check;
  }

  static NetworkStatus getNetworkStatus(ConnectivityResult status) {
    return status == ConnectivityResult.mobile ||
            status == ConnectivityResult.wifi
        ? NetworkStatus.online
        : NetworkStatus.offline;
  }

  static showSnackBarMsg(BuildContext context, String msg,
      {int snackBarSecond = 2,
      bool requiredAction = false,
      VoidCallback? onPressed}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: requiredAction ? "Login" : "",
          onPressed: onPressed ?? () {},
        ),
        content: Text(
          msg,
          softWrap: true,
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
        duration: Duration(seconds: snackBarSecond),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }

  static List<Locale> langList() {
    return Constant.supportedLanguages
        .map(
          (languageCode) => GeneralMethods.getLocaleFromLangCode(languageCode),
        )
        .toList();
  }

  static Locale getLocaleFromLangCode(String languageCode) {
    List<String> result = languageCode.split("-");
    return result.length == 1
        ? Locale(result.first)
        : Locale(result.first, result.last);
  }

  static String setFirstLetterUppercase(String value) {
    if (value.isNotEmpty) value = value.replaceAll("_", ' ');
    return value.toTitleCase();
  }

  static Future sendApiRequest(
      {required String apiName,
      required Map<String, dynamic> params,
      required bool isPost,
      required BuildContext context,
      bool? isRequestedForInvoice}) async {
    print("APi Name =======>" + apiName);
    String token = Constant.session.getData(SessionManager.keyToken);

    Map<String, String> headersData = {
      "accept": "application/json",
    };

    if (token.trim().isNotEmpty) {
      headersData["Authorization"] = "Bearer $token";
    }

    headersData["x-access-key"] = "903361";
    headersData["X-Client-Type"] = "mobile";
    print(headersData["Authorization"]);
    String mainUrl =
        apiName.contains("http") ? apiName : "${Constant.baseUrl}$apiName";
    print("${Constant.baseUrl}$apiName");
    http.Response response;
    if (isPost) {
      response = await http.post(Uri.parse(mainUrl),
          body: params.isNotEmpty ? params : null, headers: headersData);
    } else {
      mainUrl = await Constant.getGetMethodUrlWithParams(
          apiName.contains("http") ? apiName : "${Constant.baseUrl}$apiName",
          params);
      print(mainUrl);
      response = await http.get(Uri.parse(mainUrl), headers: headersData);
    }

    if (response.statusCode == 200) {
      print('response status 200');
      if (response.body == "null") {
        return null;
      }

      return isRequestedForInvoice == true ? response.bodyBytes : response.body;
    } else {
      if (Constant.session.isUserLoggedIn()) {
        print(response.reasonPhrase);
        print(response.statusCode);
        GeneralMethods.showSnackBarMsg(
          context,
          "${getTranslatedValue(
            context,
            "lblSomethingWentWrong",
          )}\n\n$mainUrl\n\nStatus Code - ${response.statusCode}",
        );
      }
      return null;
    }
  }

  static Future sendApiMultiPartRequest(
      {required String apiName,
      required Map<String, String> params,
      required List<String> fileParamsNames,
      required List<String> fileParamsFilesPath,
      required BuildContext context}) async {
    Map<String, String> headersData = {};

    String token = Constant.session.getData(SessionManager.keyToken);

    String mainUrl =
        apiName.contains("http") ? apiName : "${Constant.baseUrl}$apiName";

    headersData["Authorization"] = "Bearer $token";

    headersData["x-access-key"] = "903361";
    print(headersData);
    var request = http.MultipartRequest('POST', Uri.parse(mainUrl));
    request.fields.addAll(params);

    if (fileParamsNames.isNotEmpty) {
      // for (int i = 0; i <= fileParamsNames.length; i++) {
      request.files.add(await http.MultipartFile.fromPath(
          fileParamsNames[0].toString(), fileParamsFilesPath[0].toString()));
      // }
    }
    request.headers.addAll(headersData);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      GeneralMethods.showSnackBarMsg(
          context,
          response.reasonPhrase ??
              getTranslatedValue(
                context,
                "lblSomethingWentWrong",
              ));
      return null;
    }
  }

  static String? validateEmail(String value) {
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (value.trim().isEmpty || !regex.hasMatch(value)) {
      return "";
    } else {
      return null;
    }
  }

  static emptyValidation(String val, String msg) {
    if (val.trim().isEmpty) {
      return msg;
    }
    return null;
  }

  static emailValidation(String val, String msg) {
    return validateEmail(val.trim());
  }

  static phoneValidation(String value, String msg) {
    String pattern = r'[0-9]';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty || !regExp.hasMatch(value)) {
      return msg;
    }
    return null;
  }

  static getUserLocation() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();

      getUserLocation();
    } else if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        await Geolocator.openLocationSettings();
        getUserLocation();
      } else {
        getUserLocation();
      }
    }
  }

  static Future<GeoAddress?> displayPrediction(
      Prediction? p, BuildContext context) async {
    if (p != null) {
      GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: Constant.googleApiKey);

      PlacesDetailsResponse detail =
          await places.getDetailsByPlaceId(p.placeId!);

      String zipcode = "";
      GeoAddress address = GeoAddress();

      address.placeId = p.placeId;

      for (AddressComponent component in detail.result.addressComponents) {
        if (component.types.contains('locality')) {
          address.city = component.longName;
        }
        if (component.types.contains('administrative_area_level_2')) {
          address.district = component.longName;
        }
        if (component.types.contains('administrative_area_level_1')) {
          address.state = component.longName;
        }
        if (component.types.contains('country')) {
          address.country = component.longName;
        }
        if (component.types.contains('postal_code')) {
          zipcode = component.longName;
        }
      }

      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;

//if zipcode not found
      if (zipcode.trim().isEmpty) {
        zipcode = await getZipCode(lat, lng, context);
      }
//
      address.address = detail.result.formattedAddress;
      address.lattitud = lat.toString();
      address.longitude = lng.toString();
      address.zipcode = zipcode;
      return address;
    }
    return null;
  }

  static getZipCode(double lat, double lng, BuildContext context) async {
    String zipcode = "";
    var result = await sendApiRequest(
        apiName: "${Constant.apiGeoCode}$lat,$lng",
        params: {},
        isPost: false,
        context: context);
    if (result != null) {
      var getData = json.decode(result);
      if (getData != null) {
        Map data = getData['results'][0];
        List addressInfo = data['address_components'];
        for (var info in addressInfo) {
          List type = info['types'];
          if (type.contains('postal_code')) {
            zipcode = info['long_name'];
            break;
          }
        }
      }
    }
    return zipcode;
  }

  static Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else if (permission == LocationPermission.deniedForever) {
      return Future.error('Location Not Available');
    }

    return await Geolocator.getCurrentPosition();
  }

  static Future<Map<String, dynamic>> getCityNameAndAddress(
      LatLng currentLocation, BuildContext context) async {
    try {
      Map<String, dynamic> response = json.decode(
          await GeneralMethods.sendApiRequest(
              apiName:
                  "${Constant.apiGeoCode}${currentLocation.latitude},${currentLocation.longitude}",
              params: {},
              isPost: false,
              context: context));
      final possibleLocations = response['results'] as List;
      Map location = {};
      String cityName = '';
      String stateName = '';
      String pinCode = '';
      String countryName = '';
      String landmark = '';
      String area = '';

      if (possibleLocations.isNotEmpty) {
        for (var locationFullDetails in possibleLocations) {
          Map latLng = Map.from(locationFullDetails['geometry']['location']);
          double lat = double.parse(latLng['lat'].toString());
          double lng = double.parse(latLng['lng'].toString());
          if (lat == currentLocation.latitude &&
              lng == currentLocation.longitude) {
            location = Map.from(locationFullDetails);
            break;
          }
        }
//If we could not find location with given lat and lng
        if (location.isNotEmpty) {
          final addressComponents = location['address_components'] as List;
          if (addressComponents.isNotEmpty) {
            for (var component in addressComponents) {
              if ((component['types'] as List).contains('locality') &&
                  cityName.isEmpty) {
                cityName = component['long_name'].toString();
              }
              if ((component['types'] as List)
                      .contains('administrative_area_level_1') &&
                  stateName.isEmpty) {
                stateName = component['long_name'].toString();
              }
              if ((component['types'] as List).contains('country') &&
                  countryName.isEmpty) {
                countryName = component['long_name'].toString();
              }
              if ((component['types'] as List).contains('postal_code') &&
                  pinCode.isEmpty) {
                pinCode = component['long_name'].toString();
              }
              if ((component['types'] as List).contains('sublocality') &&
                  landmark.isEmpty) {
                landmark = component['long_name'].toString();
              }
              if ((component['types'] as List).contains('route') &&
                  area.isEmpty) {
                area = component['long_name'].toString();
              }
            }
          }
        } else {
          location = Map.from(possibleLocations.first);
          final addressComponents = location['address_components'] as List;
          if (addressComponents.isNotEmpty) {
            for (var component in addressComponents) {
              if ((component['types'] as List).contains('locality') &&
                  cityName.isEmpty) {
                cityName = component['long_name'].toString();
              }
              if ((component['types'] as List)
                      .contains('administrative_area_level_1') &&
                  stateName.isEmpty) {
                stateName = component['long_name'].toString();
              }
              if ((component['types'] as List).contains('country') &&
                  countryName.isEmpty) {
                countryName = component['long_name'].toString();
              }
              if ((component['types'] as List).contains('postal_code') &&
                  pinCode.isEmpty) {
                pinCode = component['long_name'].toString();
              }
              if ((component['types'] as List).contains('sublocality') &&
                  landmark.isEmpty) {
                landmark = component['long_name'].toString();
              }
              if ((component['types'] as List).contains('route') &&
                  area.isEmpty) {
                area = component['long_name'].toString();
              }
            }
          }
        }

        return {
          'address': possibleLocations.first['formatted_address'],
          'city': cityName,
          'state': stateName,
          'pin_code': pinCode,
          'country': countryName,
          'area': area,
          'landmark': landmark,
          'latitude': currentLocation.latitude,
          'longitude': currentLocation.longitude,
        };
      }
      return {};
    } catch (e) {
      GeneralMethods.showSnackBarMsg(context, e.toString());
      return {};
    }
  }

  static Future<String> createDynamicLink({
    required String shareUrl,
    required BuildContext context,
    String? title,
    String? imageUrl,
    String? description,
  }) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: Constant.deepLinkPrefix,
      link: Uri.parse(shareUrl),
      androidParameters: AndroidParameters(
        packageName: Constant.packageName,
        minimumVersion: 1,
      ),
      iosParameters: IOSParameters(
        bundleId: Constant.packageName,
        minimumVersion: '1',
        appStoreId: Constant.appStoreId,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: title ??
              getTranslatedValue(
                context,
                "lblAppName",
              ),
          imageUrl: Uri.parse(imageUrl ?? ""),
          description: description),
    );
    print(parameters);
    final ShortDynamicLink shortLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    Uri uri = shortLink.shortUrl;
    return uri.toString();
  }

  //Tejeshvi Changes Done Fof round up value
  static String getCurrencyFormat(double amount) {
    // Round up the amount using the ceil() method
    int roundedAmount = amount.ceil();

    // Format the rounded integer as currency
    return NumberFormat.currency(
        symbol: Constant.currency,
        decimalDigits: 0, // Setting decimalDigits to 0 for integer formatting
        name: Constant.currencyCode
    ).format(roundedAmount);
  }
  String getCurrencyFormatdouble(String amountString) {
    // Parse amountString to double
    double amount = double.tryParse(amountString) ?? 0.0;

    // Parse decimal points from String to int
    int decimalDigits = int.tryParse(Constant.decimalPoints) ?? 2;

    // Format the amount using NumberFormat.currency
    return NumberFormat.currency(
      symbol: Constant.currency,
      decimalDigits: decimalDigits,
      name: Constant.currencyCode,
    ).format(amount);
  }

}

String getTranslatedValue(BuildContext context, String key) {
  return AppLocalization.of(context)?.getTranslatedValues(key) ?? key;
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

extension getGstData on double {
  double getTotalWithGST() {
    double temp = this;

    return this + (temp * 5 / 100);
  }

  double getGSTAmount() => this * 5 / 100;
}

extension getDeliveryAmount on List {
  double getDeliveryCharges() {
    List temp = this;
    int length = temp.length;
    double delveryamount = 40.0;
    double extraAmount = 9 * (length - 1);
    delveryamount += extraAmount;

    return delveryamount;
  }
}

extension YouTubeUrlParsing on String {
  String getYouTubeVideoId() {
    String t = this.split("v=")[1];
    // Return an empty string if no match is found
    return t;
  }
}

proccedToShareApp(BuildContext context) {
  String shareAppMessage = getTranslatedValue(
    context,
    "lblShareAppMessage",
  );
  if (Platform.isAndroid) {
    shareAppMessage = "$shareAppMessage${Constant.playStoreUrl}";
  } else if (Platform.isIOS) {
    shareAppMessage = "$shareAppMessage${Constant.appStoreUrl}";
  }
  Share.share(shareAppMessage, subject: "Share app");
}
