
import 'package:egrocer/core/utils/notificationHandler/awsomeNotification.dart';
import 'package:egrocer/core/utils/notificationHandler/notificationService.dart';
import 'package:flutter/cupertino.dart';

class MainNotification{
   static call(BuildContext context){
    LocalAwesomeNotification().init(context);
    LocalAwesomeNotification().requestPermission();
    NotificationService.init(context);
  }
}
