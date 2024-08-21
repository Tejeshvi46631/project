import 'dart:io';

import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/utils/styles/designConfig.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/profileMenuScreen/profileMenuScreen.dart';
import 'package:egrocer/features/screens/profileMenuScreen/widget/profileHeader.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class CommonDrawerWidget extends StatefulWidget {
  const CommonDrawerWidget({
    super.key,
  });

  @override
  State<CommonDrawerWidget> createState() => _CommonDrawerWidgetState();
}

class _CommonDrawerWidgetState extends State<CommonDrawerWidget> {
  List profileMenus = [];
  List aboutMenus = [];
  bool isUserLogin = Constant.session.isUserLoggedIn();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 1), () {
      setProfileMenuList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          profileHeader(
            context: context,
            isUserLogin: isUserLogin,
          ),
          ...profileMenus.map((e) {
            return Theme(
              data: ThemeData(
                splashColor: ColorsRes.appColorLightHalfTransparent,
                highlightColor: Colors.transparent,
              ),
              child: ListTile(
                onTap: () {
                  e['clickFunction'](context);
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                leading: Container(
                  decoration: DesignConfig.boxDecoration(
                      ColorsRes.appColorLightHalfTransparent, 5),
                  padding: const EdgeInsets.all(8),
                  child: Widgets.defaultImg(
                      image: e['icon'],
                      iconColor: ColorsRes.appColor,
                      height: 20,
                      width: 20),
                ),
                title: Text(
                  e['label'],
                  style: Theme.of(context).textTheme.bodyMedium!.merge(
                        const TextStyle(
                          letterSpacing: 0.5,
                        ),
                      ),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                  color: ColorsRes.subTitleMainTextColor,
                ),
              ),
            );
          }).toList(),
          if (aboutMenus.isNotEmpty)
            Theme(
              data: ThemeData(
                splashColor: ColorsRes.appColorLightHalfTransparent,
                highlightColor: Colors.transparent,
              ),
              child: ExpansionTile(
                leading: Container(
                  decoration: DesignConfig.boxDecoration(
                      ColorsRes.appColorLightHalfTransparent, 5),
                  padding: const EdgeInsets.all(4),
                  child: Widgets.defaultImg(
                      image: "list_view_icon",
                      iconColor: ColorsRes.appColor,
                      height: 20,
                      width: 20),
                ),
                title: Text("About"),
                children: aboutMenus.map((e) {
                  return Theme(
                    data: ThemeData(
                      splashColor: ColorsRes.appColorLightHalfTransparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: ListTile(
                      onTap: () {
                        e['clickFunction'](context);
                      },
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      leading: Container(
                        decoration: DesignConfig.boxDecoration(
                            ColorsRes.appColorLightHalfTransparent, 5),
                        padding: const EdgeInsets.all(8),
                        child: Widgets.defaultImg(
                            image: e['icon'],
                            iconColor: ColorsRes.appColor,
                            height: 20,
                            width: 20),
                      ),
                      title: Text(
                        e['label'],
                        style: Theme.of(context).textTheme.bodyMedium!.merge(
                              const TextStyle(
                                letterSpacing: 0.5,
                              ),
                            ),
                      ),
                      trailing: Icon(
                        Icons.navigate_next,
                        color: ColorsRes.subTitleMainTextColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          if (isUserLogin)
            Theme(
              data: ThemeData(
                splashColor: ColorsRes.appColorLightHalfTransparent,
                highlightColor: Colors.transparent,
              ),
              child: ListTile(
                onTap: () {
                  Constant.session.logoutUser(context);
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                leading: Container(
                  decoration: DesignConfig.boxDecoration(
                      ColorsRes.appColorLightHalfTransparent, 5),
                  padding: const EdgeInsets.all(8),
                  child: Widgets.defaultImg(
                      image: "logout_icon",
                      iconColor: ColorsRes.appColor,
                      height: 20,
                      width: 20),
                ),
                title: Text(
                  getTranslatedValue(
                    context,
                    "lblLogout",
                  ),
                  style: Theme.of(context).textTheme.bodyMedium!.merge(
                        const TextStyle(
                          letterSpacing: 0.5,
                        ),
                      ),
                ),
                trailing: Icon(
                  Icons.navigate_next,
                  color: ColorsRes.subTitleMainTextColor,
                ),
              ),
            )
        ],
      ),
    );
  }

  setProfileMenuList() {
    profileMenus = [];
    aboutMenus = [];
    profileMenus = [
      {
        "icon": "home_icon",
        "label": getTranslatedValue(
          context,
          "lblHomeBottomMenuHome",
        ),
        "clickFunction": (context) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            mainHomeScreen,
            (Route<dynamic> route) => false,
          );
        },
        "isResetLabel": false
      },
      if (isUserLogin)
        {
          "icon": "profile_icon",
          "label": "My Profile",
          "clickFunction": (context) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  ProfileScreen(scrollController: ScrollController()),
            ));
            Navigator.pushNamed(context,
                ProfileScreen(scrollController: ScrollController()) as String);
          },
          "isResetLabel": false
        },
      if (isUserLogin)
        {
          "icon": "orders",
          "label": "My Orders",
          "clickFunction": (context) {
            Navigator.pushNamed(
              context,
              orderHistoryScreen,
            );
          },
          "isResetLabel": false
        },
      if (isUserLogin)
        {
          "icon": "wishlist_icon",
          "label": "My Wishlist",
          "clickFunction": (context) {
            Navigator.pushNamed(
              context,
              wishlistScreen,
            );
          },
          "isResetLabel": false
        },
      /*  if (isUserLogin)
        {
          "icon": "notification_icon",
          "label": getTranslatedValue(
            context,
            "lblNotification",
          ),
          "clickFunction": (context) {
            Navigator.pushNamed(context, notificationListScreen);
          },
          "isResetLabel": false
        }, */
      if (isUserLogin)
        {
          "icon": "transaction_icon",
          "label": getTranslatedValue(
            context,
            "lblTransactionHistory",
          ),
          "clickFunction": (context) {
            Navigator.pushNamed(context, transactionListScreen);
          },
          "isResetLabel": false
        },
/*      if (isUserLogin)
        {
          "icon": "refer_friend_icon",
          "label": getTranslatedValue(context, "lblReferAndEarn,
          "clickFunction": ReferAndEarn(),
          "isResetLabel": false
        },*/

      // {
      //   "icon": "rate_icon",
      //   "label": getTranslatedValue(
      //     context,
      //     "lblRateUs",
      //   ),
      //   "clickFunction": (BuildContext context) {
      //     launchUrl(
      //         Uri.parse(Platform.isAndroid
      //             ? Constant.playStoreUrl
      //             : Constant.appStoreUrl),
      //         mode: LaunchMode.externalApplication);
      //   },
      // },
      {
        "icon": "share_icon",
        "label": getTranslatedValue(
          context,
          "lblShareApp",
        ),
        "clickFunction": (BuildContext context) {
          String shareAppMessage = getTranslatedValue(
            context,
            "lblShareAppMessage",
          );
          if (Platform.isAndroid) {
            shareAppMessage = "$shareAppMessage${Constant.playStoreUrl}";
          } else if (Platform.isIOS) {
            shareAppMessage = "$shareAppMessage${Constant.appStoreUrl}";
          }
          Share.share(shareAppMessage, subject: "Share app");
        },
      },
      /*  if (isUserLogin)
        {
          "icon": "logout_icon",
          "label": getTranslatedValue(
            context,
            "lblLogout",
          ),
          "clickFunction": Constant.session.logoutUser,
          "isResetLabel": false
        }, */
    ];

    aboutMenus = [
      {
        "icon": "about_icon",
        "label": "About Chayakart",
        "clickFunction": (context) {
          Navigator.pushNamed(
            context,
            webViewScreen,
            arguments: getTranslatedValue(
              context,
              "lblAboutUs",
            ),
          );
        },
        "isResetLabel": false
      },
      {
        "icon": "terms_icon",
        "label": getTranslatedValue(
          context,
          "lblTermsAndConditions",
        ),
        "clickFunction": (context) {
          Navigator.pushNamed(context, webViewScreen,
              arguments: getTranslatedValue(
                context,
                "lblTermsAndConditions",
              ));
        }
      },
      {
        "icon": "privacy_icon",
        "label": getTranslatedValue(
          context,
          "lblPolicies",
        ),
        "clickFunction": (context) {
          Navigator.pushNamed(context, webViewScreen,
              arguments: getTranslatedValue(
                context,
                "lblPolicies",
              ));
        }
      },
      {
        "icon": "contact_icon",
        "label": getTranslatedValue(
          context,
          "lblContactUs",
        ),
        "clickFunction": (context) {
          Navigator.pushNamed(
            context,
            webViewScreen,
            arguments: getTranslatedValue(
              context,
              "lblContactUs",
            ),
          );
        }
      },
    ];
    setState(() {});
  }
}
