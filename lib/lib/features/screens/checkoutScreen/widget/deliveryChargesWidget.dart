import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/provider/checkoutProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/provider/cartProvider.dart';

Future<double?> getvalue() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  double? value = pref.getDouble("discountedAmount");
  print("VALUEDOUBLE: $value");
  return value;
}

Widget getDeliveryCharges(BuildContext context) {
  final cartProvider = Provider.of<CartProvider>(context);

  return FutureBuilder<double?>(
    future: getvalue(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (snapshot.hasData) {
        double? discountedAmount = snapshot.data;
        String discountedAmountString = GeneralMethods.getCurrencyFormat(discountedAmount ?? 0);

        return Container(
          padding: EdgeInsetsDirectional.all(Constant.size10),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: Constant.borderRadius10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity, // Full-width container
                decoration: BoxDecoration(
                  color: ColorsRes.buttoncolor, // Custom background color
                  borderRadius: BorderRadius.circular(10.0), // Rounded border radius
                ),
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Adjust padding as needed
                child: Center(
                  child: Text(
                    getTranslatedValue(context, "lblOrderSummary"),
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white, // Text color set to white
                    ),
                  ),
                ),
              ),
              Widgets.getSizedBox(
                height: Constant.size5,
              ),
              Divider(color: ColorsRes.grey, height: 1, thickness: 0.1),
              Widgets.getSizedBox(
                height: Constant.size5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      getTranslatedValue(
                        context,
                        "lblSubTotal",
                      ),
                      softWrap: true,
                      style: const TextStyle(fontSize: 17)),
                  Text(
                      GeneralMethods.getCurrencyFormat(context.read<CheckoutProvider>().subTotalAmount),
                      softWrap: true,
                      style: const TextStyle(fontSize: 17))
                ],
              ),
              Widgets.getSizedBox(
                height: Constant.size7,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                          getTranslatedValue(
                            context,
                            "lblDeliveryCharge",
                          ),
                          softWrap: true,
                          style: const TextStyle(fontSize: 17)),
                      GestureDetector(
                        onTapDown: (details) async {
                          await showMenu(
                            color: Theme.of(context).cardColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                )),
                            context: context,
                            position: RelativeRect.fromLTRB(
                                details.globalPosition.dx,
                                details.globalPosition.dy - 60,
                                details.globalPosition.dx,
                                details.globalPosition.dy),
                            items: List.generate(
                              context
                                  .read<CheckoutProvider>()
                                  .sellerWiseDeliveryCharges
                                  .length +
                                  1,
                                  (index) => PopupMenuItem(
                                child: index == 0
                                    ? Column(
                                  children: [
                                    Text(
                                      getTranslatedValue(
                                        context,
                                        "lblSellerWiseDeliveryChargesDetail",
                                      ),
                                      softWrap: true,
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 16),
                                    ),
                                  ],
                                )
                                    : Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      context
                                          .read<CheckoutProvider>()
                                          .sellerWiseDeliveryCharges[index - 1]
                                          .sellerName,
                                      softWrap: true,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                        GeneralMethods.getCurrencyFormat(
                                            double.parse(context
                                                .read<CheckoutProvider>()
                                                .sellerWiseDeliveryCharges[
                                            index - 1]
                                                .deliveryCharge)),
                                        softWrap: true,
                                        style: const TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                            ),
                            elevation: 8.0,
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsetsDirectional.only(
                            start: 2,
                          ),
                          child: Icon(
                            Icons.info_outline_rounded,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                      GeneralMethods.getCurrencyFormat(
                          context.read<CheckoutProvider>().deliveryCharge),
                      softWrap: true,
                      style: const TextStyle(fontSize: 17))
                ],
              ),
              Widgets.getSizedBox(
                height: Constant.size5,
              ),
              Divider(color: ColorsRes.grey, height: 1, thickness: 0.1),
              Widgets.getSizedBox(
                height: Constant.size5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      getTranslatedValue(
                        context,
                        "GST",
                      ),
                      softWrap: true,
                      style: const TextStyle(fontSize: 17)),
                  Text(
                      GeneralMethods.getCurrencyFormat(context
                          .read<CheckoutProvider>()
                          .totalAmount
                          .getGSTAmount()),
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 17,
                          color: ColorsRes.appColor,
                          fontWeight: FontWeight.w500)),
                ],
              ),
              Divider(color: ColorsRes.grey, height: 1, thickness: 0.1),
              Widgets.getSizedBox(
                height: Constant.size5,
              ),
              Constant.isPromoCodeApplied
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      getTranslatedValue(
                        context,
                        "Coupon Code",
                      ),
                      softWrap: true,
                      style: const TextStyle(fontSize: 17)),
                  Text(
                      "-" +
                          GeneralMethods.getCurrencyFormat(Constant.discount),
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.red,
                          fontWeight: FontWeight.w500)),
                ],
              )
                  : Container(),
              Divider(color: ColorsRes.grey, height: 1, thickness: 0.1),
              Widgets.getSizedBox(
                height: Constant.size5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      getTranslatedValue(
                        context,
                        "lblTotal",
                      ),
                      softWrap: true,
                      style: const TextStyle(fontSize: 17)),
                  Text(
                      GeneralMethods.getCurrencyFormat(Constant.isPromoCodeApplied
                          ? (Constant.discountedAmount)
                          : (context
                          .read<CheckoutProvider>()
                          .subTotalAmount
                          .getTotalWithGST()) +
                          context.read<CheckoutProvider>().deliveryCharge),
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 17,
                          color: ColorsRes.appColor,
                          fontWeight: FontWeight.w500)),
                ],
              ),
              Divider(color: ColorsRes.grey, height: 1, thickness: 0.1),
              Widgets.getSizedBox(
                height: Constant.size5,
              ),
              Container(
                color: ColorsRes.buttoncolor, // Replace with your desired color
                padding: EdgeInsets.all(12), // Adjust padding as needed
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          getTranslatedValue(
                            context,
                            "Yay! ",
                          ),
                          softWrap: true,
                          style: const TextStyle(fontSize: 17),
                        ),
                        Image.asset(
                          'assets/images/offer.png', // Path to your image file
                          height: 20, // Adjust height as needed
                        ),
                        Text(
                          getTranslatedValue(
                            context,
                            " Your total discount is ",
                          ),
                          softWrap: true,
                          style: const TextStyle(fontSize: 17),
                        ),
                        Text(
                          discountedAmountString,
                          softWrap: true,
                          style: const TextStyle(
                            fontSize: 17,
                            //color: ColorsRes.appColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      } else {
        return Center(child: Text('No data available'));
      }
    },
  );
}
