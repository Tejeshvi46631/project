
import 'dart:convert';

import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/model/trackOrdersModel.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/material.dart';

Future<TrackOrderModel> getOrderTrackingDetailsApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiGetTrackingDetails,
      params: params,
      isPost: false,
      context: context,
      isRequestedForInvoice: false);

  return await TrackOrderModel.fromJson(jsonDecode(response));
}
