import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/provider/cartProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartBtn extends StatefulWidget {
  const CartBtn({super.key});

  @override
  State<CartBtn> createState() => _CartBtnState();
}

class _CartBtnState extends State<CartBtn> {
  @override
  Widget build(BuildContext context) {
    return Widgets.BtnWidget(
      context,
      10,
      isSetShadow: false,
      callback: () async {
        final cartProvider = context.read<CartProvider>();

        // Calculate discountedAmount
        double discountedAmount =
        cartProvider.calculateDiscountedAmount(cartProvider.cartData);
        print("discountedAmount here: $discountedAmount");
SharedPreferences pref = await SharedPreferences.getInstance();
pref.setDouble("discountedAmount", discountedAmount);
        // Set discountedAmount in CartProvider
        cartProvider.discountedAmount = discountedAmount;

        // Navigate to checkout screen
        Navigator.pushNamed(context, checkoutScreen,
            arguments: cartProvider.cartData);
      },
      otherWidgets: Text(
        getTranslatedValue(
          context,
          "lblProceedToCheckout",
        ),
        softWrap: true,
        style: Theme.of(context).textTheme.titleMedium!.merge(TextStyle(
          color: ColorsRes.appColorWhite,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w500,
        )),
      ),
    );
  }
}
