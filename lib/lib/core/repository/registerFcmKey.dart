

import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/material.dart';

Future registerFcmKey({required BuildContext context, required String fcmToken}) async {
  await GeneralMethods.sendApiRequest(
    apiName: ApiAndParams.apiAddFcmToken,
    params: {ApiAndParams.fcmToken: fcmToken},
    isPost: true,
    context: context,
  );
}
