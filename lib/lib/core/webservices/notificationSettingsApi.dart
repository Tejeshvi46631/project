import 'dart:convert';

import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>> getAppNotificationSettingsRepository(
    {required Map<String, dynamic> params,
    required BuildContext context}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiNotificationSettings,
      params: params,
      isPost: false,
      context: context);

  return json.decode(response);
}

Future<Map<String, dynamic>> updateAppNotificationSettingsRepository(
    {required Map<String, dynamic> params,
    required BuildContext context}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiNotificationSettingsUpdate,
      params: params,
      isPost: true,
      context: context);

  return json.decode(response);
}
