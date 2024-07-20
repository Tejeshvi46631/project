import 'dart:io';

import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/webservices/ordersApi.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum UpdateOrderStatus { initial, inProgress, success, failure }

class UpdateOrderStatusProvider extends ChangeNotifier {
  UpdateOrderStatus _updateOrderStatus = UpdateOrderStatus.initial;
  String errorMessage = "";

  UpdateOrderStatus getUpdateOrderStatus() {
    return _updateOrderStatus;
  }

  void updateStatus(
      {required String orderId,
      String? orderItemId,
      required String status,
      required Function callBack,
      required BuildContext context}) async {
    try {
      _updateOrderStatus = UpdateOrderStatus.inProgress;
      notifyListeners();

      late PackageInfo packageInfo;
      packageInfo = await PackageInfo.fromPlatform();

      Map<String, String> params = {
        "order_id": orderId,
        "order_item_id": orderItemId ?? "",
        "status": status,
        "device_type": Platform.isAndroid
            ? "android"
            : Platform.isIOS
                ? "ios"
                : "other",
        "app_version": packageInfo.version.toString()
      };

      if (orderItemId == null) {
        params.remove("order_item_id");
      }

      final result = await updateOrderStatus(
        params: params,
        context: context,
      );

      if (result[ApiAndParams.status].toString() == "1") {
        callBack.call();
      } else {
        Navigator.of(context).pop(false);
      }
    } catch (e) {
      _updateOrderStatus = UpdateOrderStatus.failure;
      errorMessage = e.toString();
      notifyListeners();
      Navigator.of(context).pop(false);
    }
  }
}
