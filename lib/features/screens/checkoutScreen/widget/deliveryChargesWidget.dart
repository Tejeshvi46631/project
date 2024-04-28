import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/provider/checkoutProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

getDeliveryCharges(BuildContext context) {
  return Container(
    padding: EdgeInsetsDirectional.all(Constant.size10),
    decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: Constant.borderRadius10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            getTranslatedValue(
              context,
              "lblOrderSummary",
            ),
            softWrap: true,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: ColorsRes.mainTextColor)),
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
                GeneralMethods.getCurrencyFormat( context.read<CheckoutProvider>().subTotalAmount),
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
                GeneralMethods.getCurrencyFormat( context
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
        Constant.isPromoCodeApplied?Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                getTranslatedValue(
                  context,
                  "Coupon Code",
                ),
                softWrap: true,
                style: const TextStyle(fontSize: 17)),
            Text("-"+GeneralMethods.getCurrencyFormat(Constant.discount),
                softWrap: true,
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.red,
                    fontWeight: FontWeight.w500)),
          ],
        ):Container(),
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
      ],
    ),
  );
}
