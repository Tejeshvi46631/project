import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/model/address.dart';
import 'package:egrocer/core/provider/checkoutProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/utils/styles/designConfig.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

getAddressWidget(BuildContext context) {
  print(context.read<CheckoutProvider>().selectedAddress!.toJson());

  return Card(
    color: Theme.of(context).cardColor,
    elevation: 0,
    child: Padding(
      padding: EdgeInsets.all(Constant.size10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              getTranslatedValue(
                context,
                "lblAddressDetail",
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
          context.read<CheckoutProvider>().checkoutAddressState ==
                  CheckoutAddressState.addressLoaded
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context
                                  .read<CheckoutProvider>()
                                  .selectedAddress
                                  ?.name ??
                              "",
                          softWrap: true,
                          style: const TextStyle(fontSize: 18),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, addressListScreen,
                                    arguments: "checkout")
                                .then((value) {
                              context
                                  .read<CheckoutProvider>()
                                  .setSelectedAddress(
                                      context, value as AddressData);
                            });
                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: DesignConfig.boxPrimary(5),
                            padding: const EdgeInsets.all(5),
                            margin: EdgeInsets.zero,
                            child: Widgets.defaultImg(
                                image: "edit_icon",
                                iconColor: ColorsRes.mainIconColor,
                                height: 20,
                                width: 20),
                          ),
                        )
                      ],
                    ),
                    Widgets.getSizedBox(
                      height: Constant.size7,
                    ),
                    Text(
                      context.read<CheckoutProvider>().selectedAddress!.id !=
                              null
                          ? "${context.read<CheckoutProvider>().selectedAddress!.area ?? ''},${context.read<CheckoutProvider>().selectedAddress!.landmark ?? ''}, ${context.read<CheckoutProvider>().selectedAddress!.address ?? ''}, ${context.read<CheckoutProvider>().selectedAddress!.state ?? ''}, ${context.read<CheckoutProvider>().selectedAddress!.city ?? ''}, ${context.read<CheckoutProvider>().selectedAddress!.country ?? ''} - ${context.read<CheckoutProvider>().selectedAddress!.pincode ?? ''} "
                          : "No Address Available",
                      softWrap: true,
                      style: TextStyle(
                          /*fontSize: 18,*/
                          color: ColorsRes.subTitleMainTextColor),
                    ),
                    Widgets.getSizedBox(
                      height: Constant.size7,
                    ),
                    Text(
                      context
                              .read<CheckoutProvider>()
                              .selectedAddress
                              ?.mobile ??
                          "",
                      softWrap: true,
                      style: TextStyle(
                          /*fontSize: 18,*/
                          color: ColorsRes.subTitleMainTextColor),
                    ),
                  ],
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, addressListScreen,
                            arguments: "checkout")
                        .then((value) {
                      if (value != null) {
                        context
                            .read<CheckoutProvider>()
                            .setSelectedAddress(context, value as AddressData);
                      }
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: Constant.size10),
                    child: Text(
                        getTranslatedValue(
                          context,
                          "lblAddNewAddress",
                        ),
                        softWrap: true,
                        style: TextStyle(
                          color: ColorsRes.appColorRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                  ),
                ),
        ],
      ),
    ),
  );
}