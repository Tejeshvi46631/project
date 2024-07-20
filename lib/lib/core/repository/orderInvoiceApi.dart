import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/material.dart';

Future getOrderInvoiceApi(
    {required BuildContext context,
    required Map<String, dynamic> params}) async {
  var response = await GeneralMethods.sendApiRequest(
      apiName: ApiAndParams.apiDownloadOrderInvoice,
      params: params,
      isPost: true,
      context: context,
      isRequestedForInvoice: true);

  return await response;
}
