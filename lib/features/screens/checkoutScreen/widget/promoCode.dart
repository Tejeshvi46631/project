import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/model/promoCode.dart';
import 'package:egrocer/core/provider/cartProvider.dart';
import 'package:egrocer/core/provider/checkoutProvider.dart';
import 'package:egrocer/core/provider/promoCodeProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/utils/styles/dashedRect.dart';
import 'package:egrocer/core/utils/styles/designConfig.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PromoCodeWidget extends StatefulWidget {
  CheckoutProvider cartProvider;

  PromoCodeWidget({super.key, required this.cartProvider});

  @override
  State<PromoCodeWidget> createState() => _PromoCodeWidgetState();
}

class _PromoCodeWidgetState extends State<PromoCodeWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PromoCodeProvider>(
      builder: (context, promoCodeProvider, child) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(2, 8, 2, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  print("entered 1st");
                  Navigator.pushNamed(context, promoCodeScreen,
                          arguments: double.parse(
                              widget.cartProvider.subTotalAmount.toString()))
                      .then((value) {
                    if (value != null) {
                      PromoCodeData promoCodeData = value as PromoCodeData;
                      setState(() {
                        Constant.isPromoCodeApplied = true;
                        Constant.discountedAmount =
                            double.parse(promoCodeData.discountedAmount);
                        Constant.discount =
                            double.parse(promoCodeData.discount);
                        Constant.selectedCoupon = promoCodeData.promoCode;

                        //value as bool;
                      });
                    }
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: double.maxFinite,
                      height: 50,
                      decoration: DesignConfig.boxDecoration(Colors.white, 13),
                      // child: DashedRect(
                      //   color: ColorsRes.appColor,
                      //   strokeWidth: 1.0,
                      //   gap: 10,
                      // ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 12),
                        SizedBox(
                            height: 30,
                            width: 30,
                            child: CircleAvatar(
                              backgroundColor: ColorsRes.appColor,
                              radius: 100,
                              child: Widgets.defaultImg(
                                image: "discount_coupon_icon",
                                height: 15,
                                width: 15,
                                iconColor: ColorsRes.mainIconColor,
                              ),
                            )),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            Constant.isPromoCodeApplied == true
                                ? Constant.selectedCoupon
                                : getTranslatedValue(
                                    context,
                                    "lblApplyDiscountCode",
                                  ),
                            softWrap: true,
                          ),
                        ),
                        if (Constant.isPromoCodeApplied)
                          Text(
                            getTranslatedValue(
                              context,
                              "lblChangeCoupon",
                            ),
                            style: TextStyle(color: ColorsRes.appColor),
                          ),
                        const SizedBox(width: 12),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (Constant.isPromoCodeApplied == true)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textDirection: Directionality.of(context),
                  children: [
                    Text(
                      "${getTranslatedValue(
                        context,
                        "lblCoupon",
                      )} (${Constant.selectedCoupon})",
                      softWrap: true,
                      style: const TextStyle(fontSize: 17),
                    ),
                    Text(
                      "${GeneralMethods.getCurrencyFormat(Constant.discount)}",
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
