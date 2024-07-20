import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/model/promoCode.dart';
import 'package:egrocer/core/provider/cartProvider.dart';
import 'package:egrocer/core/provider/promoCodeProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/utils/styles/dashedRect.dart';
import 'package:egrocer/core/utils/styles/designConfig.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PromoBoxUi extends StatefulWidget {
  const PromoBoxUi({super.key});

  @override
  State<PromoBoxUi> createState() => _PromoBoxUiState();
}

class _PromoBoxUiState extends State<PromoBoxUi> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PromoCodeProvider>(
      builder: (context, promoCodeProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                print("enetered 1st");
                // Constant.isPromoCodeApplied = f
                // var oldAmount =
                //     context.read<CartProvider>().cartData.data.subTotal;
                Navigator.pushNamed(context, promoCodeScreen,
                    arguments: double.parse(context
                        .read<CartProvider>()
                        .cartData
                        .data
                        .subTotal))
                    .then((value) {
                  if (value != null) {
                    PromoCodeData promoCodeData = value as PromoCodeData;
                    setState(() {
                      Constant.isPromoCodeApplied = true;
                      Constant.discountedAmount =
                          double.parse(promoCodeData.discountedAmount);
                      Constant.discount = double.parse(promoCodeData.discount);
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
                    height: 45,
                    decoration: DesignConfig.boxDecoration(
                        ColorsRes.appColor.withOpacity(0.2), 10),
                    child: DashedRect(
                      color: ColorsRes.appColor,
                      strokeWidth: 1.0,
                      gap: 10,
                    ),
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
        );
      },
    );
  }
}
