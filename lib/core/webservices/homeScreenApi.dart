import 'dart:convert';

import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>> getHomeScreenDataApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  print('paramsprinted');
  print(params);
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiShop,
      params: params,
      isPost: false,
      context: context);
  print(await json.decode(response)["data"]);
  Map<String, dynamic> mainData = await json.decode(response)["data"];

  return mainData;
}
