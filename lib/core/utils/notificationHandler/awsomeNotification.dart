import 'dart:convert';
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LocalAwesomeNotification {
  AwesomeNotifications notification = AwesomeNotifications();

  init(BuildContext context) async{
    requestPermission();

    notification.initialize(
      'resource://mipmap/logo',
      [
        NotificationChannel(
          channelKey: Constant.notificationChannel,
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel',
          playSound: true,
          enableVibration: true,
          criticalAlerts: true,
          importance: NotificationImportance.High,
          ledColor: ColorsRes.appColor,
        )
      ],
      channelGroups: [],
      debug: true,
    );
    await AwesomeNotifications().isNotificationAllowed().then(
          (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );
    await listenTap(context);
  }

  listenTap(BuildContext context) {
    try {
      AwesomeNotifications().setListeners(
          onNotificationCreatedMethod: (receivedNotification) async {},
          onActionReceivedMethod: (ReceivedAction event) async {
            Map<String, dynamic> data = jsonDecode(event.payload!["data"].toString());

            String notificationTypeId = data["id"];
            String notificationType = data["type"];

            Future.delayed(
              Duration.zero,
              () {
                if (notificationType == "default" || notificationType == "user") {
                  if (currentRoute != notificationListScreen) {
                    Navigator.pushNamed(Constant.navigatorKay.currentContext!, notificationListScreen);
                  }
                } else if (notificationType == "category") {
                  Navigator.pushNamed(Constant.navigatorKay.currentContext!, productListScreen, arguments: ["category", notificationTypeId.toString(), getTranslatedValue(Constant.navigatorKay.currentContext!, "lblAppName")]);
                } else if (notificationType == "product") {
                  Navigator.pushNamed(Constant.navigatorKay.currentContext!, productDetailScreen, arguments: [notificationTypeId.toString(), getTranslatedValue(Constant.navigatorKay.currentContext!, "lblAppName"), null]);
                } else if (notificationType == "url") {
                  launchUrl(Uri.parse(notificationTypeId.toString()), mode: LaunchMode.externalApplication);
                }
              },
            );
          },
        onNotificationDisplayedMethod: onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod,);
    } catch (e, st) {
      print(st.toString());
    }
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onActionReceivedMethod');
    final payload = receivedAction.payload ?? {};
    if (payload["navigate"] == "true") {
     // navigation
    }
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  createImageNotification({required RemoteMessage notificationData, required bool isLocked}) async {
    try {
      Map<String, dynamic> data = jsonDecode(notificationData.data["data"].toString());
      await notification.createNotification(
        content: NotificationContent(
          id: Random().nextInt(5000),
          color: ColorsRes.appColor,
          title: data["title"],
          locked: isLocked,
          payload: Map.from(notificationData.data),
          autoDismissible: true,
          showWhen: true,
          notificationLayout: NotificationLayout.BigPicture,
          body: data["message"],
          wakeUpScreen: true,
          largeIcon: data["image"],
          bigPicture: data["image"],
          channelKey: Constant.notificationChannel,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  createNotification({required RemoteMessage notificationData, required bool isLocked}) async {
    try {
      Map<String, dynamic> data = jsonDecode(notificationData.data["data"].toString());
      await notification.createNotification(
        content: NotificationContent(
          id: Random().nextInt(5000),
          color: ColorsRes.appColor,
          title: data["title"],
          locked: isLocked,
          payload: Map.from(notificationData.data),
          autoDismissible: true,
          showWhen: true,
          notificationLayout: NotificationLayout.Default,
          body: data["message"],
          wakeUpScreen: true,
          channelKey: Constant.notificationChannel,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  requestPermission() async {
    NotificationSettings notificationSettings = await FirebaseMessaging.instance.getNotificationSettings();

    if (notificationSettings.authorizationStatus == AuthorizationStatus.notDetermined) {
      await notification.requestPermissionToSendNotifications(
        channelKey: Constant.notificationChannel,
        permissions: [NotificationPermission.Alert, NotificationPermission.Sound, NotificationPermission.Badge, NotificationPermission.Vibration, NotificationPermission.Light],
      );

      if (notificationSettings.authorizationStatus == AuthorizationStatus.authorized || notificationSettings.authorizationStatus == AuthorizationStatus.provisional) {}
    } else if (notificationSettings.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }
  }
}
