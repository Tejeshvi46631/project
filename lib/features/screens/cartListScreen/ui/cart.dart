import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/model/cartData.dart';
import 'package:egrocer/core/provider/cartProvider.dart';
import 'package:egrocer/core/provider/promoCodeProvider.dart';
import 'package:egrocer/core/widgets/cartListItemContainer.dart';
import 'package:egrocer/core/widgets/defaultBlankItemMessageScreen.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/cartListScreen/ui/btn.dart';
import 'package:egrocer/features/screens/checkoutScreen/widget/promoCode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({super.key});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return (cartProvider.cartState == CartState.initial ||
            cartProvider.cartState == CartState.loading)
            ? getCartListShimmer(
          context: context,
        )
            : (cartProvider.cartState == CartState.loaded)
            ? Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsetsDirectional.only(
                    bottom: Constant.size10),
                children: List.generate(
                  cartProvider.cartData.data.cart.length,
                      (index) {
                    Cart cart =
                    cartProvider.cartData.data.cart[index];
                    return Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: Constant.size10,
                        end: Constant.size10,
                      ),
                      child: CartListItemContainer(
                        cart: cart,
                        from: 'cartList',
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: EdgeInsetsDirectional.all(Constant.size10),
              margin: EdgeInsetsDirectional.only(
                  bottom: Constant.size10,
                  start: Constant.size10,
                  end: Constant.size10),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: Constant.borderRadius10),
              child: Column(
                children: [
                  //   ChangeNotifierProvider<PromoCodeProvider>(
                  //   create: (context) => PromoCodeProvider(),
                  //   child: Consumer<PromoCodeProvider>(
                  //     builder: (context, promoCodeProvider, _) {
                  //       return PromoCodeWidget(cartProvider:cartProvider ,);
                  //     },
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    textDirection: Directionality.of(context),
                    children: [
                      Text(
                          "${getTranslatedValue(context, "lblSubTotal")} (${cartProvider.cartData.data.cart.length} ${cartProvider.cartData.data.cart.length > 1 ? getTranslatedValue(context, "lblItems") : getTranslatedValue(context, "lblItem")})",
                          softWrap: true,
                          style: const TextStyle(fontSize: 17)),
                      Text(
                          "${GeneralMethods.getCurrencyFormat(Constant.isPromoCodeApplied == true ? Constant.discountedAmount : double.parse(cartProvider.subTotal.toString()))}",
                          softWrap: true,
                          style: const TextStyle(fontSize: 17)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  CartBtn(),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context, mainHomeScreen,
                      );
                    },
                    child: Text('Add More Product'),
                  )

                ],

              ),
            )
          ],
        )
            : DefaultBlankItemMessageScreen(
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
            Navigator.of(context).pushNamedAndRemoveUntil(
              mainHomeScreen,
                  (Route<dynamic> route) => false,
            );
          },
          image: "no_product_icon",
        );
      },
    );
  }

  getCartListShimmer({required BuildContext context}) {
    return ListView(
      children: List.generate(10, (index) {
        return const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
          child: CustomShimmer(
            width: double.maxFinite,
            height: 125,
          ),
        );
      }),
    );
  }
}
