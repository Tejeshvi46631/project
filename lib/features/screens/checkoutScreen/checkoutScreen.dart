import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/model/address.dart';
import 'package:egrocer/core/model/cartData.dart';
import 'package:egrocer/core/provider/checkoutProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:egrocer/features/screens/checkoutScreen/utils/checkout_shimmer.dart';
import 'package:egrocer/features/screens/checkoutScreen/utils/delivery_shimmer.dart';
import 'package:egrocer/features/screens/checkoutScreen/widget/addressWidget.dart';
import 'package:egrocer/features/screens/checkoutScreen/widget/deliveryChargesWidget.dart';
import 'package:egrocer/features/screens/checkoutScreen/widget/paymentMethodWidget.dart';
import 'package:egrocer/features/screens/checkoutScreen/widget/swipeButtonWidget.dart';
import 'package:egrocer/features/screens/checkoutScreen/widget/timeSlotsWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key, required this.cartData}) : super(key: key);
  final CartData cartData;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late AddressData? selectedAddress;
  TextEditingController promoCode = new TextEditingController();
  String textLength = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then(
      (value) async {
        setState(() {
          Constant.isPromoCodeApplied = false;
        });
        print("entered in checkout");
        await context
            .read<CheckoutProvider>()
            .getSingleAddressProvider(context: context)
            .then(
          (selectedAddress) async {
            print(selectedAddress);
            await context.read<CheckoutProvider>().getOrderChargesProvider(
              context: context,
              params: {
                // ApiAndParams.cityId: selectedAddress?.cityId?.toString()??Constant.session.getData(SessionManager.keyCityId),
                ApiAndParams.latitude: selectedAddress?.latitude?.toString() ??
                    Constant.session.getData(SessionManager.keyLatitude),
                ApiAndParams.longitude:
                    selectedAddress?.longitude?.toString() ??
                        Constant.session.getData(SessionManager.keyLongitude),
                ApiAndParams.isCheckout: "1"
              },
            ).then(
              (value) async {
                await context
                    .read<CheckoutProvider>()
                    .getTimeSlotsSettings(context: context);
                await context
                    .read<CheckoutProvider>()
                    .getPaymentMethods(context: context)
                    .then(
                  (value) {
                    /* StripeService.secret = context
                        .read<CheckoutProvider>()
                        .paymentMethods
                        .data
                        .stripeSecretKey;
                    StripeService.init(
                        context
                            .read<CheckoutProvider>()
                            .paymentMethods
                            .data
                            .stripePublicKey,
                        "");*/
                  },
                );
              },
            );
          },
        );
       // _fbInitiateCheckoutEvent();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamedAndRemoveUntil(
          mainHomeScreen,
          (Route<dynamic> route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: ColorsRes.appColorWhite,
        appBar: AppBar(
          /*leading: InkWell(
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                mainHomeScreen,
                    (Route<dynamic> route) => false,
              );
            },
            child: Padding(
              padding: EdgeInsets.all(18),
              child: SizedBox(
                child: Widgets.defaultImg(
                  image: "ic_arrow_back",
                  iconColor: Colors.white,
                ),
                height: 10,
                width: 10,
              ),
            ),
          ),*/
          elevation: 0,
          title: Text(
            getTranslatedValue(
              context,
              "lblCheckout",
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          centerTitle: true,
          backgroundColor: ColorsRes.gradient2, // Theme.of(context).cardColor,
        ),
        body: Consumer<CheckoutProvider>(
          builder: (context, checkoutProvider, _) {
            print("Payoption selected :_ ${checkoutProvider.isPaymentOptionSelected}");
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      if (checkoutProvider.checkoutAddressState ==
                              CheckoutAddressState.addressLoading ||
                          checkoutProvider.checkoutTimeSlotsState ==
                              CheckoutTimeSlotsState.timeSlotsLoading ||
                          checkoutProvider.checkoutPaymentMethodsState ==
                              CheckoutPaymentMethodsState.paymentMethodLoading)
                        GetCheckoutShimmer(),
                      if (checkoutProvider.checkoutPaymentMethodsState ==
                                  CheckoutPaymentMethodsState
                                      .paymentMethodLoaded &&
                              checkoutProvider.checkoutTimeSlotsState ==
                                  CheckoutTimeSlotsState.timeSlotsLoaded &&
                              checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressLoaded ||
                          checkoutProvider.checkoutAddressState ==
                              CheckoutAddressState.addressBlank)
                        getAddressWidget(context),
                      context.read<CheckoutProvider>().subTotalAmount >= 350 &&
                              Constant.promoUsed == false
                          ? /*Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
                              margin: EdgeInsets.only(
                                  left: 0, right: 0, top: 6, bottom: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: CircleAvatar(
                                          backgroundColor: ColorsRes.appColor,
                                          radius: 90,
                                          child: Widgets.defaultImg(
                                            image: "discount_coupon_icon",
                                            height: 13,
                                            width: 13,
                                            iconColor: ColorsRes.mainIconColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Have a coupon code?",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: ColorsRes.mainTextColor,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextField(
                                    cursorColor: Colors.black,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    onChanged: (val) {
                                      setState(() {
                                        if (val.length > 1) {
                                          textLength = val;
                                        } else {
                                          Constant.isPromoCodeApplied = false;
                                          Constant.promoError = "";
                                          textLength = val;
                                        }
                                      });
                                    },
                                    controller: promoCode,
                                    textInputAction: TextInputAction.search,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorsRes.gradient2,
                                            width: 1.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorsRes.gradient2,
                                            width: 1.0),
                                      ),
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 4, 0),
                                        child: SizedBox(
                                          height: 20,
                                          width: 85,
                                          child: ElevatedButton(
                                            child: Text(
                                              "Apply",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            style: ButtonStyle(
                                              foregroundColor:
                                                  WidgetStateProperty.all<
                                                      Color>(Colors.white),
                                              backgroundColor:
                                                  textLength.isNotEmpty
                                                      ? WidgetStateProperty.all<
                                                              Color>(
                                                          ColorsRes.gradient2)
                                                      : WidgetStateProperty.all<
                                                          Color>(Colors.grey),
                                              shape: WidgetStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  side: BorderSide(
                                                    color: textLength.isNotEmpty
                                                        ? ColorsRes.gradient2
                                                        : Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onPressed: () async {
                                              if (promoCode.text ==
                                                  'NEWCKAPP') {
                                                setState(() {
                                                  Constant.discount =
                                                      50; // Setting the discount
                                                  Constant.promoError = "";
                                                  Constant.isPromoCodeApplied =
                                                      true;
                                                  Constant
                                                      .discountedAmount = context
                                                          .read<
                                                              CheckoutProvider>()
                                                          .taxSubTotalAmount -
                                                      50; // Subtracting 50
                                                  Constant.discount =
                                                      50; // Setting the discount
                                                  Constant.promoError = "";
                                                  context
                                                      .read<CartProvider>()
                                                      .calculateDiscountedAmount(
                                                          widget.cartData);
                                                });
                                              } else if (context
                                                      .read<PromoCodeProvider>()
                                                      .promoCode
                                                      .data
                                                      .first
                                                      .promoCode ==
                                                  promoCode.text) {
                                                print("Matched");
                                                setState(() {
                                                  Constant.isPromoCodeApplied =
                                                      true;
                                                  Constant.discountedAmount =
                                                      double.parse(context
                                                          .read<
                                                              PromoCodeProvider>()
                                                          .promoCode
                                                          .data
                                                          .first
                                                          .discountedAmount);
                                                  Constant.discount =
                                                      double.parse(context
                                                          .read<
                                                              PromoCodeProvider>()
                                                          .promoCode
                                                          .data
                                                          .first
                                                          .discount);
                                                  Constant.promoError = "";
                                                });
                                              } else {
                                                setState(() {
                                                  textLength = "";
                                                  Constant.promoError =
                                                      "Coupon Code do not match!";
                                                  Constant.isPromoCodeApplied =
                                                      false;
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      hintText: 'Coupon code',
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Constant.promoError.length > 2
                                      ? SizedBox(
                                          height: 10,
                                        )
                                      : Constant.isPromoCodeApplied
                                          ? SizedBox(
                                              height: 10,
                                            )
                                          : Container(),
                                  Constant.promoError.length > 2
                                      ? Text(Constant.promoError,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.red))
                                      : Constant.isPromoCodeApplied
                                          ? Text(Constant.promoSuccess,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.green))
                                          : Container()
                                ],
                              ),
                            )*/ SizedBox.shrink()
                          : Container(),
                      if (checkoutProvider.checkoutPaymentMethodsState ==
                                  CheckoutPaymentMethodsState
                                      .paymentMethodLoaded &&
                              checkoutProvider.checkoutTimeSlotsState ==
                                  CheckoutTimeSlotsState.timeSlotsLoaded &&
                              checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressLoaded ||
                          checkoutProvider.checkoutAddressState ==
                              CheckoutAddressState.addressBlank)
                        getTimeSlots(checkoutProvider.timeSlotsData, context),
                      if (checkoutProvider.checkoutPaymentMethodsState ==
                                  CheckoutPaymentMethodsState
                                      .paymentMethodLoaded &&
                              checkoutProvider.checkoutTimeSlotsState ==
                                  CheckoutTimeSlotsState.timeSlotsLoaded &&
                              checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressLoaded ||
                          checkoutProvider.checkoutAddressState ==
                              CheckoutAddressState.addressBlank)
                        // context.read<CheckoutProvider>().subTotalAmount >= 250
                        //     ?
                        getPaymentMethods(
                            checkoutProvider.paymentMethodsData, context),
                      Card(
                        child: Column(
                          children: [
                            if (checkoutProvider.checkoutPaymentMethodsState ==
                                        CheckoutPaymentMethodsState
                                            .paymentMethodLoaded &&
                                    checkoutProvider.checkoutTimeSlotsState ==
                                        CheckoutTimeSlotsState
                                            .timeSlotsLoaded &&
                                    checkoutProvider.checkoutAddressState ==
                                        CheckoutAddressState.addressLoaded ||
                                checkoutProvider.checkoutAddressState ==
                                    CheckoutAddressState.addressBlank)
                              //pass dicounted value here
                              getDeliveryCharges(context),
                            if (checkoutProvider.checkoutDeliveryChargeState ==
                                CheckoutDeliveryChargeState
                                    .deliveryChargeLoading)
                              GetDeliveryShimmer(),
                            context.read<CheckoutProvider>().subTotalAmount >=
                                    249
                                ? OrderSwipeButton(
                                    cartData: widget.cartData,
                                    isEnabled: (checkoutProvider
                                                    .checkoutPaymentMethodsState ==
                                                CheckoutPaymentMethodsState
                                                    .paymentMethodLoaded &&
                                            checkoutProvider
                                                    .checkoutTimeSlotsState ==
                                                CheckoutTimeSlotsState
                                                    .timeSlotsLoaded) &&
                                        (checkoutProvider
                                                    .checkoutAddressState ==
                                                CheckoutAddressState
                                                    .addressLoaded ||
                                            checkoutProvider
                                                    .checkoutAddressState ==
                                                CheckoutAddressState
                                                    .addressBlank) &&
                                        checkoutProvider
                                            .isPaymentOptionSelected,
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 45,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        // Set the background color to orange
                                        borderRadius: BorderRadius.circular(
                                            8), // Optional: add some corner rounding
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Minimum order value to place a order is ₹249',
                                          style: TextStyle(
                                            color: Colors
                                                .black, // Text color set to black
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

 /*void _fbInitiateCheckoutEvent() {
    try {
      var cartData = widget.cartData.data;
      var cartTotal =
          context.read<CheckoutProvider>().taxSubTotalAmount*//*.getTotalWithGST()*//* +
              context.read<CheckoutProvider>().totalDeliveryCharges;
      FacebookAnalytics.initiateCheckout(
          totalPrice: cartTotal,
          numItems: cartData.cart.length,
          currency: 'INR');
    } catch (e) {}
  }*/
}
