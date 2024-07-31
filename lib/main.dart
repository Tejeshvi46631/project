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
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:egrocer/features/screens/main/mainProviderWidget.dart';
import 'package:egrocer/features/screens/main/notificationCall.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/provider/activeOrdersProvider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    // Use the App Check debug provider in debug mode
    if (kDebugMode) {
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.debug,
      );
    } else {
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.playIntegrity,
        appleProvider: AppleProvider.appAttest,
      );
    }
  } catch (e) {
    print("Error initializing Firebase: $e");
  }


  final prefs = await SharedPreferences.getInstance();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ActiveOrdersProvider()),
        ChangeNotifierProvider(create: (_) => CategoryListProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CityByLatLongProvider()),
        ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
        ChangeNotifierProvider(create: (_) => ProductChangeListingTypeProvider()),
        ChangeNotifierProvider(create: (_) => FaqProvider()),
        ChangeNotifierProvider(create: (_) => ProductAddOrRemoveFavoriteProvider()),
        ChangeNotifierProvider(create: (_) => ProductWishListProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => CartListProvider()),
        ChangeNotifierProvider(create: (_) => PromoCodeProvider()),
        ChangeNotifierProvider(create: (_) => SessionManager(prefs: prefs)),
      ],
      child: Consumer<SessionManager>(
        builder: (context, sessionManager, child) {
          Constant.session = sessionManager;
          Constant.searchedItemsHistoryList = sessionManager.prefs
              .getStringList(SessionManager.keySearchHistory) ??
              [];

          FirebaseMessaging.instance.requestPermission(alert: true, sound: true, badge: true);

          final currLang = sessionManager.getCurrLang();
          final view = View.of(context);

          if (sessionManager.getData(SessionManager.appThemeName).toString().isEmpty) {
            sessionManager.setData(SessionManager.appThemeName, Constant.themeList[0], false);
            sessionManager.setBoolData(SessionManager.isDarkTheme,
                view.platformDispatcher.platformBrightness == Brightness.dark, false);
          }

          // Update theme on brightness change
          view.platformDispatcher.onPlatformBrightnessChanged = () {
            if (sessionManager.getData(SessionManager.appThemeName) == Constant.themeList[0]) {
              sessionManager.setBoolData(SessionManager.isDarkTheme,
                  view.platformDispatcher.platformBrightness == Brightness.dark, true);
            }
          };

          // Initialize notifications
          MainNotification.call(context);

          return MainProvider.widgetCall(currLang, context);
        },
      ),
    );
  }
}
