

import 'dart:convert';

import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/model/homeScreenData.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/material.dart';

Future<List<Category>> getCategoryList({required BuildContext context, required Map<String, String> params}) async {
  var response = await GeneralMethods.sendApiRequest(apiName: ApiAndParams.apiCategories, params: params, isPost: false, context: context);
  Map getData = json.decode(response);

  if (getData[ApiAndParams.status].toString() == "1") {
    return (getData['data'] as List).map((e) => Category.fromJson(e)).toList();
  } else {
    return [];
  }
}
