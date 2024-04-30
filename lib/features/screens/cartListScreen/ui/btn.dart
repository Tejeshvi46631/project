import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/provider/cartProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartBtn extends StatefulWidget {
  const CartBtn({super.key});

  @override
  State<CartBtn> createState() => _CartBtnState();
}

class _CartBtnState extends State<CartBtn> {
  @override
  Widget build(BuildContext context) {
    return Widgets.BtnWidget(context, 10, isSetShadow: false, callback: () {
      Navigator.pushNamed(context, checkoutScreen,
          arguments: context.read<CartProvider>().cartData);
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
              fontWeight: FontWeight.w500)),
        ));
  }
}
