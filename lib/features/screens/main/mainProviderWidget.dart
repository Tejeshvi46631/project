import 'package:country_code_picker/country_code_picker.dart';
import 'package:egrocer/core/constant/appLocalization.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/main/mainProviderWidget/mainfunction.dart';
import 'package:egrocer/features/screens/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/homeScreen/mainHomeScreen.dart';

class MainProvider {
  static MaterialApp widgetCall(currLang,BuildContext context) {
    return MaterialApp(
      navigatorKey: Constant.navigatorKay,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: "/",
      scrollBehavior: ScrollGlowBehavior(),
      debugShowCheckedModeBanner: false,
      locale: currLang,
      title: getTranslatedValue(
        context,
        "lblAppName",
      ),
      theme: ColorsRes.setAppTheme(),
      home: const HomeMainScreen(),
      localizationsDelegates: const [
        TranslationsDelegate(),
        CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: Constant.supportedLanguages.map(
        (languageCode) {
          return GeneralMethods.getLocaleFromLangCode(languageCode);
        },
      ).toList(),
    );
  }

}
