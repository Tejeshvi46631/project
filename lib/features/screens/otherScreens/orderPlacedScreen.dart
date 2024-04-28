import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/provider/cartListProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class OrderPlacedScreen extends StatefulWidget {
  const OrderPlacedScreen({Key? key}) : super(key: key);

  @override
  State<OrderPlacedScreen> createState() => _OrderPlacedScreenState();
}

class _OrderPlacedScreenState extends State<OrderPlacedScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) =>
        context.read<CartListProvider>().clearCart(context: context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Stack(
          children: [
            Lottie.asset(
                Constant.getAssetsPath(3, "order_placed_back_animation"),
                height: double.maxFinite,
                width: double.maxFinite,
                repeat: false),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(Constant.size10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    Constant.getAssetsPath(3, "order_success_tick_animation"),
                    height: MediaQuery.of(context).size.width * 0.5,
                    width: MediaQuery.of(context).size.width * 0.5,
                    repeat: false,
                  ),
                  Widgets.getSizedBox(
                    height: Constant.size20,
                  ),
                  Text(
                    getTranslatedValue(
                      context,
                      "lblOrderPlaceMessage",
                    ),
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall!.merge(
                          TextStyle(
                            color: ColorsRes.mainTextColor,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                  ),
                  Widgets.getSizedBox(
                    height: Constant.size20,
                  ),
                  Text(
                    getTranslatedValue(
                      context,
                      "lblOrderPlaceDescription",
                    ),
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.merge(
                          const TextStyle(letterSpacing: 0.5),
                        ),
                  ),
                  Widgets.getSizedBox(
                    height: Constant.size20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        orderHistoryScreen,
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      textStyle:
                          Theme.of(context).textTheme.headlineSmall!.merge(
                                TextStyle(
                                  color: ColorsRes.appColor,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                    ),
                    child: Text(
                      getTranslatedValue(
                        context,
                        "lblContinueShopping",
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
