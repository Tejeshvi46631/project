import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/provider/cartListProvider.dart';
import 'package:egrocer/core/widgets/common_drawer_widget.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/home/homeScreen/function/home_function.dart';
import 'package:egrocer/features/screens/home/homeScreen/ui/centerUi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final ScrollController scrollController;

  const HomeScreen({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, List<String>> map = {};

  @override
  void initState() {
    super.initState();
    // Fetch productList from API and check used promo code
    HomeScreenFunction.callInit(context);
    checkUsedPromoCode();
  }

  Future<void> checkUsedPromoCode() async {
    print("In Firestore");
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('users').get();
      bool promoUsed = querySnapshot.docs.any((doc) => Constant.session.getData(SessionManager.keyPhone) == doc["phone"]);
      Constant.promoUsed = promoUsed;
      print(promoUsed ? "Firestore Found Promo Code Used" : "Not Found");
    } catch (e) {
      print("Error fetching promo code: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          Column(
            children: [
              getSearchWidget(context: context),
              HomeCenterUI(map: map, scrollController: widget.scrollController),
            ],
          ),
          _buildCartLoadingIndicator(),
        ],
      ),
      drawer: const CommonDrawerWidget(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return getAppBar(
      context: context,
      title: Container(
        height: 50,
        margin: const EdgeInsets.only(bottom: 10),
        child: Image.asset(
          "assets/images/chhayakart-white-logo.png",
          fit: BoxFit.fill,
        ),
      ),
      centerTitle: true,
      actions: [
        setCartCounter(context: context),
        setNotificationCounter(context: context),
      ],
      showBackButton: false,
    );
  }

  Widget _buildCartLoadingIndicator() {
    return Consumer<CartListProvider>(
      builder: (context, cartListProvider, child) {
        return cartListProvider.cartListState == CartListState.loading
            ? Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.2),
            child: const Center(child: CircularProgressIndicator()),
          ),
        )
            : const SizedBox.shrink();
      },
    );
  }
}
