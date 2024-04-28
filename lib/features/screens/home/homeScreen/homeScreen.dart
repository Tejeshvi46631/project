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

    //fetch productList from api
    Future.delayed(Duration.zero).then(
      (value) async {
        HomeScreenFunction.callInit(context);
        checkUsedPromoCode();
      },
    );
  }

  @override
  dispose() {
    super.dispose();
  }

  static checkUsedPromoCode() async {
    print("In Firestore");
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(Constant.session.getData(SessionManager.keyPhone)==doc["phone"]){
          Constant.promoUsed=true;
          print("Firestore Found Promo Code Used");
        }else{
          Constant.promoUsed=false;
          print("Not Found");
        }
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: Container(
          height: 50,
          margin: EdgeInsets.only(bottom: 10),
          child: Image.asset(
            "assets/images/chhayakart-white-logo.png",
            fit: BoxFit.fill,
          ),
        ),
        //deliverAddressWidget(),
        centerTitle: true,
        actions: [
          setCartCounter(context: context),
          setNotificationCounter(context: context),
        ],
        showBackButton: false,
      ),
      body: Stack(
        children: [
          Column(
            children: [

              getSearchWidget(
                context: context,
              ),
              HomeCenterUI(map: map,scrollController: widget.scrollController,)
            ],
          ),
          Consumer<CartListProvider>(
            builder: (context, cartListProvider, child) {
              return cartListProvider.cartListState == CartListState.loading
                  ? PositionedDirectional(
                      top: 0,
                      end: 0,
                      start: 0,
                      bottom: 0,
                      child: Container(
                          color: Colors.black.withOpacity(0.2),
                          child:
                              const Center(child: CircularProgressIndicator())),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
      drawer: CommonDrawerWidget(),

    );
  }


}
