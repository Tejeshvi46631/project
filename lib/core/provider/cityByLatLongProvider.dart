import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/provider/cityByLatLongApi.dart';
import 'package:egrocer/core/provider/cityByLatLongProvider.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

export 'package:geocoding/geocoding.dart';

enum CityByLatLongState {
  initial,
  loading,
  loaded,
  error,
}

class CityByLatLongProvider extends ChangeNotifier {
  CityByLatLongState cityByLatLongState = CityByLatLongState.initial;
  String message = '';
  late Map<String, dynamic> cityByLatLong;
  String address = "";
  late List<Placemark> addresses;
  bool isDeliverable = false;

  getCityByLatLongApiProvider({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    cityByLatLongState = CityByLatLongState.loading;
    notifyListeners();

    try {
      cityByLatLong = (await getCityByLatLongApi(context: context, params: params));

      if (cityByLatLong[ApiAndParams.status] == 0) {
        cityByLatLongState = CityByLatLongState.error;
        notifyListeners();
        isDeliverable = false;
      } else {
        Constant.session.setData(SessionManager.keyLatitude, params[ApiAndParams.latitude], false);
        Constant.session.setData(SessionManager.keyLongitude, params[ApiAndParams.longitude], false);

        print("${Constant.session.getData(SessionManager.keyLatitude)}");
        print("${Constant.session.getData(SessionManager.keyLongitude)}");

        cityByLatLongState = CityByLatLongState.loaded;
        notifyListeners();
        isDeliverable = true;
      }
    } catch (e) {
      message = e.toString();
      cityByLatLongState = CityByLatLongState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
      isDeliverable = false;
    }
  }
}
