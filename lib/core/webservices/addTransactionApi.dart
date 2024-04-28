import 'dart:convert';

import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>> getAddTransactionApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiAddTransaction,
      params: params,
      isPost: true,
      context: context);
  print("Response of api");
  print(response.toString());
  return json.decode(response);
}
