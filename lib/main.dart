import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/firebase_options.dart';
import 'package:egrocer/core/provider/cartListProvider.dart';
import 'package:egrocer/core/provider/cartProvider.dart';
import 'package:egrocer/core/provider/categoryProvider.dart';
import 'package:egrocer/core/provider/cityByLatLongProvider.dart';
import 'package:egrocer/core/provider/faqListProvider.dart';
import 'package:egrocer/core/provider/homeScreenDataProvider.dart';
import 'package:egrocer/core/provider/productChangeListingProvider.dart';
import 'package:egrocer/core/provider/productWishListProvider.dart';
import 'package:egrocer/core/provider/promoCodeProvider.dart';
import 'package:egrocer/core/provider/userProfileProvider.dart';
import 'package:egrocer/core/repository/facebook_analytics.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:egrocer/features/screens/main/mainInitialize.dart';
import 'package:egrocer/features/screens/main/mainProviderWidget.dart';
import 'package:egrocer/features/screens/main/notificationCall.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/provider/activeOrdersProvider.dart';
export 'package:awesome_notifications/awesome_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isNotEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      await Firebase.initializeApp();
    }

    await FirebaseMessaging.instance.setAutoInitEnabled(true);
  } catch (_) {}

  FacebookAnalytics.initFbAppEvents();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);


  runApp(
    MyApp(prefs: prefs),
  );
}

class MyApp extends StatefulWidget {
  final SharedPreferences prefs;

  const MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    MainNotification.call(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ActiveOrdersProvider>(
          create: (context) => ActiveOrdersProvider(),
        ),
        ChangeNotifierProvider<CategoryListProvider>(
          create: (context) {
            return CategoryListProvider();
          },
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (context) {
            return CartProvider();
          },
        ),
        ChangeNotifierProvider<CityByLatLongProvider>(
          create: (context) {
            return CityByLatLongProvider();
          },
        ),

        ChangeNotifierProvider<HomeScreenProvider>(
          create: (context) {
            return HomeScreenProvider();
          },
        ),
        ChangeNotifierProvider<ProductChangeListingTypeProvider>(
          create: (context) {
            return ProductChangeListingTypeProvider();
          },
        ),
        ChangeNotifierProvider<FaqProvider>(
          create: (context) {
            return FaqProvider();
          },
        ),
        ChangeNotifierProvider<ProductAddOrRemoveFavoriteProvider>(
          create: (context) {
            return ProductAddOrRemoveFavoriteProvider();
          },
        ),
        ChangeNotifierProvider<ProductWishListProvider>(
          create: (context) {
            return ProductWishListProvider();
          },
        ),
        ChangeNotifierProvider<UserProfileProvider>(
          create: (context) {
            return UserProfileProvider();
          },
        ),
        ChangeNotifierProvider<CartListProvider>(
          create: (context) {
            return CartListProvider();
          },
        ),
        ChangeNotifierProvider<PromoCodeProvider>(
          create: (context) {
            return PromoCodeProvider();
          },
        ),
        /*   ChangeNotifierProvider<ProductListProviderV2>(
          create: (context) {
            return ProductListProviderV2();
          },
        ), */
      ],
      child: ChangeNotifierProvider<SessionManager>(
        create: (_) => SessionManager(prefs: widget.prefs),
        child: Consumer<SessionManager>(
          builder: (context, SessionManager sessionNotifier, child) {
            Constant.session = Provider.of<SessionManager>(context);
            Constant.searchedItemsHistoryList = Constant.session.prefs
                    .getStringList(SessionManager.keySearchHistory) ??
                [];

            FirebaseMessaging.instance
                .requestPermission(alert: true, sound: true, badge: true);

            Locale currLang = Constant.session.getCurrLang();

            final window = WidgetsBinding.instance.window;

            if (Constant.session
                .getData(SessionManager.appThemeName)
                .toString()
                .isEmpty) {
              Constant.session.setData(
                  SessionManager.appThemeName, Constant.themeList[0], false);
              Constant.session.setBoolData(SessionManager.isDarkTheme,
                  window.platformBrightness == Brightness.dark, false);
            }

            // This callback is called every time the brightness changes from the device.
            window.onPlatformBrightnessChanged = () {
              if (Constant.session.getData(SessionManager.appThemeName) ==
                  Constant.themeList[0]) {
                Constant.session.setBoolData(SessionManager.isDarkTheme,
                    window.platformBrightness == Brightness.dark, true);
              }
            };


            return MainProvider.widgetCall(currLang, context);
          },
        ),
      ),
    );
  }
}
