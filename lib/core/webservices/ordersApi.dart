
import 'dart:convert';

import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>> fetchOrders({required Map<String, String> params, required BuildContext context}) async {
  try {
    print("entered in fetchorder");
    final result = await GeneralMethods.sendApiRequest(apiName: ApiAndParams.apiOrdersHistory, params: params, isPost: false, context: context);
    print(result);
    return Map.from(jsonDecode(result));
  } catch (e) {
    //
    return {};
  }
}

Future<Map<String, dynamic>> updateOrderStatus({required Map<String, String> params, required BuildContext context}) async {
  try {
    final response = await GeneralMethods.sendApiRequest(apiName: ApiAndParams.apiUpdateOrderStatus, params: params, isPost: true, context: context);

    if (response == null) {
      throw Exception("Something went wrong");
    }

    return Map.from(response);
  } catch (e) {
    rethrow;
  }
}
