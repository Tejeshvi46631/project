import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/notificationSettings.dart';
import 'package:egrocer/core/provider/activeOrdersProvider.dart';
import 'package:egrocer/core/provider/productListProvider.dart';
import 'package:egrocer/core/provider/productWishListProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/webservices/notificationSettingsApi.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/home/category/categoryListScreen.dart';
import 'package:egrocer/features/screens/home/homeScreen/homeScreen.dart';
import 'package:egrocer/features/screens/home/ordersHistoryScreen/ordersHistoryScreen.dart';
import 'package:egrocer/features/screens/home/whatapp/contactInfoScreen.dart';
import 'package:egrocer/features/screens/home/wishlist/wishListScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({Key? key}) : super(key: key);

  @override
  State<HomeMainScreen> createState() => HomeMainScreenState();
}

class HomeMainScreenState extends State<HomeMainScreen> {
  NetworkStatus networkStatus = NetworkStatus.online;
  int currentPage = 0;

  List<ScrollController> scrollController = [
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController()
  ];

  //total pageListing
  List<Widget> pages = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    checkConnectionState();

    pages = [
      ChangeNotifierProvider<ProductListProvider>(
        create: (context) {
          return ProductListProvider();
        },
        child: HomeScreen(
          scrollController: scrollController[0],
        ),
      ),
      /* ChangeNotifierProvider<ProductListProviderV2>(
        create: (context) {
          return ProductListProviderV2();
        },
        child: HomeScreen(
          scrollController: scrollController[0],
        ),
      ), */
      CategoryListScreen(
        scrollController: scrollController[1],
      ),
      ContactinfoScreen(
        scrollController: scrollController[2],
      ),
      ChangeNotifierProvider<ProductWishListProvider>(
        create: (context) {
          return ProductWishListProvider();
        },
        child: WishListScreen(
          scrollController: scrollController[3],
        ),
      ),

      ChangeNotifierProvider<ActiveOrdersProvider>(
        create: (context) {
          return ActiveOrdersProvider();
        },
        child: OrdersHistoryScreen(
            // scrollController: scrollController[3],
            ),
      ),


    ];

    Future.delayed(
      Duration.zero,
      () async {
        if (Constant.session.isUserLoggedIn()) {
          await getAppNotificationSettingsRepository(
                  params: {}, context: context)
              .then(
            (value) async {
              if (value[ApiAndParams.status].toString() == "1") {
                late AppNotificationSettings notificationSettings =
                    AppNotificationSettings.fromJson(value);
                if (notificationSettings.data!.isEmpty) {
                  await updateAppNotificationSettingsRepository(params: {
                    ApiAndParams.statusIds: "1,2,3,4,5,6,7,8",
                    ApiAndParams.mobileStatuses: "1,1,1,1,1,1,1,1",
                    ApiAndParams.mailStatuses: "1,1,1,1,1,1,1,1"
                  }, context: context);
                }
              }
            },
          );
        }
      },
    );

    super.initState();
  }

  //internet connection checking
  checkConnectionState() async {
    networkStatus = await GeneralMethods.checkInternet()
        ? NetworkStatus.online
        : NetworkStatus.offline;

    Connectivity().onConnectivityChanged.listen(
          (ConnectivityResult status) {
        if (mounted) {
          setState(
                () {
              networkStatus = GeneralMethods.getNetworkStatus(status);
            },
          );
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: homeBottomNavigation(
          currentPage, selectBottomMenu, pages.length, context),
      body: networkStatus == NetworkStatus.online
          ? PopScope(
        canPop: currentPage == 0,
        onPopInvoked: (didPop) {
          if (didPop) return;
          if (currentPage != 0) {
            if (mounted) {
              setState(() {
                currentPage = 0;
              });
            }
          }
        },
        child: IndexedStack(
          index: currentPage,
          children: pages,
        ),
      )
          : Center(
        child: Text(
          getTranslatedValue(
            context,
            "lblCheckInternet",
          ),
        ),
      ),
    );
  }

  homeBottomNavigation(int selectedIndex, Function selectBottomMenu,
      int totalPage, BuildContext context) {
    List lblHomeBottomMenu = [
      getTranslatedValue(
        context,
        "lblHomeBottomMenuHome",
      ),
      getTranslatedValue(
        context,
        "lblHomeBottomMenuCategory",
      ),
      getTranslatedValue(
        context,
        "lblContactUs",
      ),
      getTranslatedValue(
        context,
        "lblHomeBottomMenuWishlist",
      ),
      getTranslatedValue(
        context,
        "lblAllOrders",
      ),
    ];
    return BottomNavigationBar(
        items: List.generate(
          totalPage,
          (index) => BottomNavigationBarItem(
            backgroundColor: Theme.of(context).cardColor,
            icon: Widgets.getHomeBottomNavigationBarIcons(
                isActive: selectedIndex == index)[index],
            label: lblHomeBottomMenu[index],
          ),
        ),
        type: BottomNavigationBarType.shifting,
        currentIndex: selectedIndex,
        selectedItemColor: ColorsRes.mainTextColor,
        unselectedItemColor: Colors.transparent,
        onTap: (int ind) {
          selectBottomMenu(ind);
        },
        elevation: 5);
  }

  //change current screen based on bottom menu selection
  selectBottomMenu(int index) {
    if (mounted) {
      setState(
        () {
          if (index == currentPage) {
            scrollController[currentPage].animateTo(0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.linear);
          }
          if (index == 2) {
            _openWhatsApp();
          }

          currentPage = index;
        },
      );
    }
  }

  _openWhatsApp() async {
    String whatsappNumber = "+919420920320";
    String url = "https://wa.me/$whatsappNumber";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
