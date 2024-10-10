import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/notificationSettings.dart';
import 'package:egrocer/core/provider/activeOrdersProvider.dart';
import 'package:egrocer/core/provider/productListProvider.dart';
import 'package:egrocer/core/provider/productWishListProvider.dart';
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

  final List<ScrollController> scrollControllers = List.generate(5, (_) => ScrollController());

  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    checkConnectionState();
    initializePages();
    fetchNotificationSettings();
  }

  @override
  void dispose() {
    // Only dispose controllers if they are not being used anymore.
    for (var controller in scrollControllers) {
      if (controller.hasClients) {
        // Optionally, you can check if the controller is still attached to any scrolling widget
        controller.dispose();
      }
    }
    super.dispose();
  }

  void initializePages() {
    pages = [
      ChangeNotifierProvider<ProductListProvider>(
        create: (context) => ProductListProvider(),
        child: HomeScreen(scrollController: scrollControllers[0]),
      ),
      CategoryListScreen(scrollController: scrollControllers[1]),
      ContactinfoScreen(scrollController: scrollControllers[2]),
      ChangeNotifierProvider<ProductWishListProvider>(
        create: (context) => ProductWishListProvider(),
        child: WishListScreen(scrollController: scrollControllers[3]),
      ),
      ChangeNotifierProvider<ActiveOrdersProvider>(
        create: (context) => ActiveOrdersProvider(),
        child: OrdersHistoryScreen(),
      ),
    ];
  }

  Future<void> fetchNotificationSettings() async {
    if (Constant.session.isUserLoggedIn()) {
      final response = await getAppNotificationSettingsRepository(params: {}, context: context);
      if (response[ApiAndParams.status] == "1") {
        final notificationSettings = AppNotificationSettings.fromJson(response);
        if (notificationSettings.data!.isEmpty) {
          await updateAppNotificationSettingsRepository(
            params: {
              ApiAndParams.statusIds: "1,2,3,4,5,6,7,8",
              ApiAndParams.mobileStatuses: "1,1,1,1,1,1,1,1",
              ApiAndParams.mailStatuses: "1,1,1,1,1,1,1,1"
            },
            context: context,
          );
        }
      }
    }
  }

  /*//internet connection checking
  checkConnectionState() async {
    networkStatus = await GeneralMethods.checkInternet()
        ? NetworkStatus.online
        : NetworkStatus.offline;

    Connectivity().onConnectivityChanged.listen(
          (List<ConnectivityResult> statusList) {
        if (mounted) {
          setState(() {
            // Assuming you need to handle only the first result in the list
            networkStatus = GeneralMethods.getNetworkStatus(statusList.first);
          });
        }
      },
    );
  }*/

  //internet connection checking
  checkConnectionState() async {
    networkStatus = await GeneralMethods.checkInternet()
        ? NetworkStatus.online
        : NetworkStatus.offline;

    Connectivity().onConnectivityChanged.listen(
          (ConnectivityResult status) {
        if (mounted) {
          setState(() {
            networkStatus = GeneralMethods.getNetworkStatus(status);
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBar(),
      body: networkStatus == NetworkStatus.online
          ? PopScope(
        canPop: currentPage == 0,
        onPopInvoked: (didPop) {
          if (!didPop && currentPage != 0) {
            setState(() {
              currentPage = 0;
            });
          }
        },
        child: IndexedStack(
          index: currentPage,
          children: pages,
        ),
      )
          : Center(
        child: Text(
          getTranslatedValue(context, "lblCheckInternet"),
        ),
      ),
    );
  }


  Widget buildBottomNavigationBar() {
    final lblHomeBottomMenu = [
      getTranslatedValue(context, "lblHomeBottomMenuHome"),
      getTranslatedValue(context, "lblHomeBottomMenuCategory"),
      getTranslatedValue(context, "lblContactUs"),
      getTranslatedValue(context, "lblHomeBottomMenuWishlist"),
      getTranslatedValue(context, "lblAllOrders"),
    ];

    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.red,
          width: 2.0,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: ClipRRect(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        child: NavigationBar(
          animationDuration: const Duration(seconds: 1),
          selectedIndex: currentPage,
          onDestinationSelected: (index) => selectBottomMenu(index),
          destinations: List.generate(
            pages.length,
                (index) => NavigationDestination(
              icon: Widgets.getHomeBottomNavigationBarIcons(isActive: currentPage == index)[index],
              label: lblHomeBottomMenu[index],
            ),
          ),
          backgroundColor: Theme.of(context).cardColor,
          elevation: 5,
          //surfaceTintColor: Colors.black,
          indicatorColor: Colors.orange,
        ),
      ),
    );
  }



  /* BottomNavigationBar buildBottomNavigationBar() {
    final lblHomeBottomMenu = [
      getTranslatedValue(context, "lblHomeBottomMenuHome"),
      getTranslatedValue(context, "lblHomeBottomMenuCategory"),
      getTranslatedValue(context, "lblContactUs"),
      getTranslatedValue(context, "lblHomeBottomMenuWishlist"),
      getTranslatedValue(context, "lblAllOrders"),
    ];

    return BottomNavigationBar(
      items: List.generate(
        pages.length,
            (index) => BottomNavigationBarItem(
          backgroundColor: Theme.of(context).cardColor,
          icon: Widgets.getHomeBottomNavigationBarIcons(isActive: currentPage == index)[index],
          label: lblHomeBottomMenu[index],
        ),
      ),
      type: BottomNavigationBarType.shifting,
      currentIndex: currentPage,
      selectedItemColor: ColorsRes.mainTextColor,
      unselectedItemColor: Colors.transparent,
      onTap: (index) => selectBottomMenu(index),
      elevation: 5,
    );
  }*/

  void selectBottomMenu(int index) {
    if (mounted) {
      setState(() {
        if (index == currentPage) {
          scrollControllers[currentPage].animateTo(0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.linear);
        }
        if (index == 2) {
          _openWhatsApp();
        }
        currentPage = index;
      });
    }
  }

  Future<void> _openWhatsApp() async {
    const whatsappNumber = "+919420920320";
    final url = "https://wa.me/$whatsappNumber";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
