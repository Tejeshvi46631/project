
import 'dart:convert';

import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>> getPromoCodeApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  print(ApiAndParams.apiPromoCode);
  print(params);
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiPromoCode,
      params: params,
      isPost: false,
      context: context);

  return json.decode(response);
}
