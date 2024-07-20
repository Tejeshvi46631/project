
import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/address.dart';
import 'package:egrocer/core/webservices/addressApi.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:flutter/material.dart';

enum AddressState {
  initial,
  loading,
  loaded,
  loadingMore,
  editing,
  error,
}

class AddressProvider extends ChangeNotifier {
  AddressState addressState = AddressState.initial;
  String message = '';
  List<AddressData> addresses = [];
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;
  int selectedAddressId = 0;

  getAddressProvider({required BuildContext context}) async {
    if (offset == 0) {
      addressState = AddressState.loading;
    } else {
      addressState = AddressState.loadingMore;
    }
    notifyListeners();

    // try {
    Map<String, String> params = {};

    params[ApiAndParams.limit] = Constant.defaultDataLoadLimitAtOnce.toString();
    params[ApiAndParams.offset] = offset.toString();

    Map<String, dynamic> getData =
        (await getAddressApi(context: context, params: params));
    print(params);
    if (getData[ApiAndParams.status].toString() == "1") {
      totalData = int.parse(getData[ApiAndParams.total].toString());
      List<AddressData> tempAddresses = (getData['data'] as List)
          .map((e) => AddressData.fromJson(Map.from(e)))
          .toList();

      if (offset == 0) {
        selectedAddressId = int.parse(tempAddresses[0].id.toString());
      }

      addresses.addAll(tempAddresses);

      hasMoreData = totalData > addresses.length;
      if (hasMoreData) {
        offset += Constant.defaultDataLoadLimitAtOnce;
      }
      addressState = AddressState.loaded;
      notifyListeners();
    } else {
      addressState = AddressState.error;
      notifyListeners();
    }
    // } catch (e) {
    //   message = e.toString();
    //   addressState = AddressState.error;
    //   GeneralMethods.showSnackBarMsg(context, message);
    //   notifyListeners();
    // }
  }

  setSelectedAddress(int addressId) {
    selectedAddressId = addressId;
    notifyListeners();
  }

  void deleteAddress(
      {required BuildContext context, required AddressData address}) async {
    addressState = AddressState.editing;
    notifyListeners();

    try {
      Map<String, String> params = {ApiAndParams.id: address.id.toString()};

      Map<String, dynamic> getData =
          (await deleteAddressApi(context: context, params: params));

      if (getData[ApiAndParams.status].toString() == "1") {
        addresses.remove(address);
        addressState = AddressState.loaded;
        notifyListeners();
      } else {
        addressState = AddressState.error;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      addressState = AddressState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
    }
  }

  void addOrUpdateAddress(
      {required BuildContext context,
      var address,
      required Map<String, String> params,
      required Function function}) async {
    addressState = AddressState.editing;
    notifyListeners();

    try {
      Map<String, dynamic> getData = {};

      if (params.containsKey(ApiAndParams.id)) {
        getData = (await updateAddressApi(context: context, params: params));
      } else {
        getData = (await addAddressApi(context: context, params: params));
        print(getData);
      }
      print(getData[ApiAndParams.status]);
      late AddressData tempAddress;
      if (getData[ApiAndParams.status].toString() == "1") {
        print(getData[ApiAndParams.data]);
        tempAddress = AddressData.fromJson(getData[ApiAndParams.data]);

        print(tempAddress);
        if (params.containsKey(ApiAndParams.id)) {
          addresses.remove(address);
        }

        addresses.add(tempAddress);

        if (int.parse(tempAddress.isDefault.toString()) == 1) {
          selectedAddressId = int.parse(tempAddress.id.toString());
        }

        addressState = AddressState.loaded;
        notifyListeners();
        Constant.session.setData(
            SessionManager.keyAddress,
            "${tempAddress.city} ${tempAddress.state} ${tempAddress.country}",
            true);
        function();
      } else {
        print("third error");
        addressState = AddressState.error;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      addressState = AddressState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
    }
  }
}
