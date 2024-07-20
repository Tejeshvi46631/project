import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/provider/cartListProvider.dart';
import 'package:egrocer/core/provider/cartProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/defaultBlankItemMessageScreen.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/cartListScreen/ui/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartListScreen extends StatefulWidget {
  const CartListScreen({Key? key}) : super(key: key);

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {
  @override
  void initState() {
    super.initState();

    Constant.isPromoCodeApplied = false;
    Constant.selectedCoupon = "";
    Constant.discountedAmount = 0.0;
    Constant.discount = 0.0;

    //fetch cartList from api
    Future.delayed(Duration.zero).then((value) async {
      await context.read<CartProvider>().getCartListProvider(context: context);
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          context: context,
          title: Text(
            getTranslatedValue(
              context,
              "lblCart",
            ),
            softWrap: true,
            //style: TextStyle(color: ColorsRes.mainTextColor),
          )),
      body: Stack(
        children: [
          setRefreshIndicator(
            refreshCallback: () async {
              await context
                  .read<CartProvider>()
                  .getCartListProvider(context: context);
            },
            child: Stack(
              children: [
                (context.watch<CartListProvider>().cartList.isNotEmpty ||
                        context.read<CartProvider>().cartState ==
                            CartState.error)
                    ? CartWidget()
                    : PositionedDirectional(
                        top: 0,
                        start: 0,
                        end: 0,
                        bottom: 0,
                        child: DefaultBlankItemMessageScreen(
                          image: "cart_empty",
                          title: getTranslatedValue(
                            context,
                            "lblEmptyCartListMessage",
                          ),
                          description: getTranslatedValue(
                            context,
                            "lblEmptyCartListDescription",
                          ),
                          btntext: getTranslatedValue(
                            context,
                            "lblEmptyCartListButtonName",
                          ),
                          callback: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      )
              ],
            ),
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
          )
        ],
      ),
    );
  }
}
