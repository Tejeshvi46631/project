
import 'dart:convert';

import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>> getPlaceOrderApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  print("entered in order placed api");
  print(params);
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiPlaceOrder,
      params: params,
      isPost: true,
      context: context);
  print(response);
  return json.decode(response);
}
