import 'package:country_code_picker/country_code_picker.dart';
import 'package:egrocer/core/model/cartData.dart';
import 'package:egrocer/core/model/homeScreenData.dart';
import 'package:egrocer/core/model/order.dart';
import 'package:egrocer/core/model/productList.dart';
import 'package:egrocer/core/provider/activeOrdersProvider.dart';
import 'package:egrocer/core/provider/addressListProvider.dart';
import 'package:egrocer/core/provider/cartProvider.dart';
import 'package:egrocer/core/provider/checkoutProvider.dart';
import 'package:egrocer/core/provider/faqListProvider.dart';
import 'package:egrocer/core/provider/notificationListProvider.dart';
import 'package:egrocer/core/provider/notificationsSettingsProvider.dart';
import 'package:egrocer/core/provider/orderInvoiceProvider.dart';
import 'package:egrocer/core/provider/productDetailProvider.dart';
import 'package:egrocer/core/provider/productFilterProvider.dart';
import 'package:egrocer/core/provider/productListProvider.dart';
import 'package:egrocer/core/provider/productListProviderV2.dart';
import 'package:egrocer/core/provider/productSearchProvider.dart';
import 'package:egrocer/core/provider/productWishListProvider.dart';
import 'package:egrocer/core/provider/promoCodeProvider.dart';
import 'package:egrocer/core/provider/transactionListProvider.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/features/screens/authentication/login/login.dart';
import 'package:egrocer/features/screens/authentication/otp/otpVerificationScreen.dart';
import 'package:egrocer/features/screens/cartListScreen/cartListScreen.dart';
import 'package:egrocer/features/screens/cartListScreen/ui/promoCodeScreen.dart';
import 'package:egrocer/features/screens/checkoutScreen/checkoutScreen.dart';
import 'package:egrocer/features/screens/checkoutScreen/paypalPaymentScreen.dart';
import 'package:egrocer/features/screens/confirmLocationScreen/confirmLocationScreen.dart';
import 'package:egrocer/features/screens/home/homeScreen/mainHomeScreen.dart';
import 'package:egrocer/features/screens/home/ordersHistoryScreen/ordersHistoryScreen.dart';
import 'package:egrocer/features/screens/home/wishlist/drawer/wishlist_drawer.dart';
import 'package:egrocer/features/screens/introSlider/intro.dart';
import 'package:egrocer/features/screens/orderCompleteScreen/orderCompleteScreen.dart';
import 'package:egrocer/features/screens/orderSummaryScreen/orderSummaryScreen.dart';
import 'package:egrocer/features/screens/otherScreens/appUpdateScreen.dart';
import 'package:egrocer/features/screens/otherScreens/editProfile/editProfileScreen.dart';
import 'package:egrocer/features/screens/otherScreens/getLocation/getLocationScreen.dart';
import 'package:egrocer/features/screens/otherScreens/orderPlacedScreen.dart';
import 'package:egrocer/features/screens/otherScreens/underMaintenanceScreen.dart';
import 'package:egrocer/features/screens/otherScreens/webViewScreen.dart';
import 'package:egrocer/features/screens/productCategory/productListScreenV2.dart';

import 'package:egrocer/features/screens/productDetailScreen/productDetailScreen.dart';
import 'package:egrocer/features/screens/productImageFullScreen/productFullScreenImagesScreen.dart';
import 'package:egrocer/features/screens/productListFilterScreen/productListFilterScreen.dart';
import 'package:egrocer/features/screens/productListScreen/productListScreen.dart';
import 'package:egrocer/features/screens/profileMenuScreen/screens/addressScreen/addressDetailScreen.dart';
import 'package:egrocer/features/screens/profileMenuScreen/screens/addressScreen/addressListScreen.dart';
import 'package:egrocer/features/screens/profileMenuScreen/screens/faqListScreen.dart';
import 'package:egrocer/features/screens/profileMenuScreen/screens/notificationListScreen.dart';
import 'package:egrocer/features/screens/profileMenuScreen/screens/notificationsAndMailSettingsScreen.dart';
import 'package:egrocer/features/screens/profileMenuScreen/screens/transactionListScreen.dart';
import 'package:egrocer/features/screens/search/searchProductScreen.dart';
import 'package:egrocer/features/screens/splash/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/screens/orderSummaryScreen/widgets/OrdersucessfullySummaryScreen.dart';

const String introSliderScreen = 'introSliderScreen';
const String splashScreen = 'splashScreen';
const String loginScreen = 'loginScreen';
const String webViewScreen = 'webViewScreen';
const String otpScreen = 'otpScreen';
const String editProfileScreen = 'editProfileScreen';
const String getLocationScreen = 'getLocationScreen';
const String confirmLocationScreen = 'confirmLocationScreen';
const String mainHomeScreen = 'mainHomeScreen';
const String homeScreen = 'homeScreen';
const String categoryScreen = 'categoryScreen';
const String wishlistScreen = 'wishlistScreen';
const String cartScreen = 'cartScreen';
const String checkoutScreen = 'checkoutScreen';
const String promoCodeScreen = 'promoCodeScreen';
const String productListScreen = 'productListScreen';
const String productListScreenV2 = 'productListScreenV2';
const String productSearchScreen = 'productSearchScreen';
const String productListFilterScreen = 'productListFilterScreen';
const String productDetailScreen = 'productDetailScreen';
const String fullScreenProductImageScreen = 'fullScreenProductImageScreen';
const String addressListScreen = 'addressListScreen';
const String addressDetailScreen = 'addressDetailScreen';
const String orderDetailScreen = 'orderDetailScreen';
const String orderHistoryScreen = 'orderHistoryScreen';
const String notificationListScreen = 'orderHistoryScreen';
const String transactionListScreen = 'transactionListScreen';
const String faqListScreen = 'faqListScreen';
const String orderPlaceScreen = 'orderPlaceScreen';
const String orderCompleteScreen = 'orderCompleteScreen';
const String notificationsAndMailSettingsScreenScreen =
    'notificationsAndMailSettingsScreenScreen';
const String underMaintenanceScreen = 'underMaintenanceScreen';
const String appUpdateScreen = 'appUpdateScreen';
const String paypalPaymentScreen = 'paypalPaymentScreen';
const String orderSuccessfullySummaryScreen = 'orderSuccessfullySummaryScreen';

String currentRoute = splashScreen;

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    currentRoute = settings.name ?? "";

    switch (settings.name) {
      // case introSliderScreen:
      //   return CupertinoPageRoute(
      //     builder: (_) => const IntroSliderScreen(),
      //   );

      case splashScreen:
        return CupertinoPageRoute(
          builder: (_) => const Splash(),
        );
// Route generator snippet
    // Route generator snippet
      case orderSuccessfullySummaryScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<ActiveOrdersProvider>(
            create: (context) => ActiveOrdersProvider(),
            child: const OrdersucessfullySummaryScreen(),
          ),
        );

      case loginScreen:
        return CupertinoPageRoute(
          builder: (_) => const LoginAccount(),
        );
    //
      case webViewScreen:
        return CupertinoPageRoute(
          builder: (_) => WebViewScreen(dataFor: settings.arguments as String),
        );

      case otpScreen:
        List<dynamic> firebaseArguments = settings.arguments as List<dynamic>;
        return CupertinoPageRoute(
          builder: (_) => OtpVerificationScreen(
              firebaseAuth: firebaseArguments[0] as FirebaseAuth,
              otpVerificationId: firebaseArguments[1] as String,
              phoneNumber: firebaseArguments[2] as String,
              selectedCountryCode: firebaseArguments[3] as CountryCode),
        );
    //
      case editProfileScreen:
        return CupertinoPageRoute(
          builder: (_) => EditProfile(from: settings.arguments as String),
        );
    //
      case getLocationScreen:
        return CupertinoPageRoute(
          builder: (_) => GetLocation(from: settings.arguments as String),
        );
    //
      case confirmLocationScreen:
        List<dynamic> confirmLocationArguments =
        settings.arguments as List<dynamic>;
        return CupertinoPageRoute(
          builder: (_) => ConfirmLocation(
            address: confirmLocationArguments[0],
            from: confirmLocationArguments[1] as String,
          ),
        );
    //
      case mainHomeScreen:
        return CupertinoPageRoute(
          builder: (_) => HomeMainScreen(),
        );
    //
      case cartScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<CartProvider>(
            create: (context) => CartProvider(),
            child: const CartListScreen(),
          ),
        );
    //
      case wishlistScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<ProductWishListProvider>(
            create: (context) => ProductWishListProvider(),
            child: const WishListDrawerScreen(),
          ),
        );
    //
      case checkoutScreen:
        var checkoutArguments = settings.arguments as CartData;
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<CheckoutProvider>(
            create: (context) => CheckoutProvider(),
            child: CheckoutScreen(
              cartData: checkoutArguments,
            ),
          ),
        );
    //
      case promoCodeScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<PromoCodeProvider>(
            create: (context) => PromoCodeProvider(),
            child: PromoCodeListScreen(amount: settings.arguments as double),
          ),
        );
    //
      case productListScreen:
        List<dynamic> productListArguments =
        settings.arguments as List<dynamic>;
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<ProductListProvider>(
            create: (context) => ProductListProvider(),
            child: ProductListScreen(
              from: productListArguments[0] as String,
              id: productListArguments[1] as String,
              title: GeneralMethods.setFirstLetterUppercase(
                productListArguments[2],
              ),
            ),
          ),
        );
      case productListScreenV2:
        List<dynamic> productListArguments =
        settings.arguments as List<dynamic>;
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<ProductListProviderV2>(
            create: (context) => ProductListProviderV2(),
            child: ProductListScreenV2(
              // from: productListArguments[0] as String,
              // id: productListArguments[1] as String,
              sections: productListArguments[1] as List<Sections>,
              title: GeneralMethods.setFirstLetterUppercase(
                productListArguments[0],
              ),
              currentSubCategory: productListArguments[2],
            ),
          ),
        );
    //
      case productSearchScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<ProductSearchProvider>(
            create: (context) => ProductSearchProvider(),
            child: ProductSearchScreen(),
          ),
        );
    //
      case productListFilterScreen:
        List<dynamic> productListFilterArguments =
        settings.arguments as List<dynamic>;
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<ProductFilterProvider>(
            create: (context) => ProductFilterProvider(),
            child: ProductListFilterScreen(
              brands: productListFilterArguments[0] as List<Brands>,
              maxPrice: productListFilterArguments[1] as double,
              minPrice: productListFilterArguments[2] as double,
              sizes: productListFilterArguments[3] as List<Sizes>,
            ),
          ),
        );

      case productDetailScreen:
        List<dynamic> productDetailArguments =
        settings.arguments as List<dynamic>;
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<ProductDetailProvider>(
            create: (context) => ProductDetailProvider(),
            child: ProductDetailScreen(
              id: productDetailArguments[0] as String,
              title: productDetailArguments[1] as String,
              productListItem: productDetailArguments[2],
              currentSectionID: productDetailArguments[3],
              listSimilarProductListItem: productDetailArguments[4],
            ),
          ),
        );
    //
      case fullScreenProductImageScreen:
        List<dynamic> productFullScreenImagesScreen =
        settings.arguments as List<dynamic>;
        return CupertinoPageRoute(
          builder: (_) => ProductFullScreenImagesScreen(
            initialPage: productFullScreenImagesScreen[0] as int,
            images: productFullScreenImagesScreen[1] as List<String>,
            isVideo: productFullScreenImagesScreen[2] as bool,
          ),
        );
    //
      case addressListScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<AddressProvider>(
            create: (context) => AddressProvider(),
            child: AddressListScreen(
              from: settings.arguments as String,
            ),
          ),
        );
    //
      case addressDetailScreen:
        List<dynamic> addressDetailArguments =
        settings.arguments as List<dynamic>;
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<AddressProvider>(
            create: (context) => AddressProvider(),
            child: AddressDetailScreen(
              address: addressDetailArguments[0],
              addressProviderContext: addressDetailArguments[1] as BuildContext,
            ),
          ),
        );
    //
      case orderHistoryScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<ActiveOrdersProvider>(
            create: (context) => ActiveOrdersProvider(),
            child: const OrdersHistoryScreen(),
          ),
        );
    //
      case orderDetailScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (context) => OrderInvoiceProvider(),
            child: OrderSummaryScreen(
              order: settings.arguments as Order,
            ),
          ),
        );
    //
      case notificationListScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<NotificationProvider>(
            create: (context) => NotificationProvider(),
            child: const NotificationListScreen(),
          ),
        );
    //
      case transactionListScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<TransactionProvider>(
            create: (context) => TransactionProvider(),
            child: const TransactionListScreen(),
          ),
        );
    //
      case faqListScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<FaqProvider>(
            create: (context) => FaqProvider(),
            child: const FaqListScreen(),
          ),
        );
    //
      case notificationsAndMailSettingsScreenScreen:
        return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider<NotificationsSettingsProvider>(
            create: (context) => NotificationsSettingsProvider(),
            child: const NotificationsAndMailSettingsScreenScreen(),
          ),
        );
    //
      case orderPlaceScreen:
        return CupertinoPageRoute(
          builder: (_) => const OrderPlacedScreen(),
        );
    //
      case orderCompleteScreen:
        return CupertinoPageRoute(
          builder: (_) => OrderCompleteScreen(),
        );
    //
      case underMaintenanceScreen:
        return CupertinoPageRoute(
          builder: (_) => const UnderMaintenanceScreen(),
        );
    //
      case appUpdateScreen:
        return CupertinoPageRoute(
          builder: (_) =>
              AppUpdateScreen(canIgnoreUpdate: settings.arguments as bool),
        );
    //
      case paypalPaymentScreen:
        return CupertinoPageRoute(
          builder: (_) =>
              PayPalPaymentScreen(paymentUrl: settings.arguments as String),
        );

      default:
      // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

