import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/paymentMethods.dart';
import 'package:egrocer/core/provider/checkoutProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

getPaymentMethods(
    PaymentMethodsData? paymentMethodsData, BuildContext context) {
  final checkoutProvider = context.read<CheckoutProvider>();
  final isSubtotalLessThan249 = checkoutProvider.subTotalAmount < 249;
  return paymentMethodsData != null
      ? Card(
    color: Theme.of(context).cardColor,
    elevation: 0,
    child: Padding(
      padding: EdgeInsets.all(Constant.size10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // Container to provide a background color
            width: double.infinity, // Full-width container
            decoration: BoxDecoration(
              color: ColorsRes.buttoncolor, // Light green background color
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
            ),
            padding: EdgeInsets.symmetric(vertical: 11.0), // Adjust padding as needed
            child: Center(
              child: Text(
                getTranslatedValue(
                  context,
                  "lblPaymentMethod",
                ),
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
          Column(
            children: [
              if (paymentMethodsData.razorpayPaymentMethod == "1")
                GestureDetector(
                  onTap: () {
                    context.read<CheckoutProvider>().setSelectedPaymentMethod("Razorpay");
                  },
                  child: Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.symmetric(vertical: Constant.size5),
                    decoration: BoxDecoration(
                        color: context.read<CheckoutProvider>().selectedPaymentMethod == "Razorpay"
                            ? Constant.session.getBoolData(SessionManager.isDarkTheme)
                            ? ColorsRes.appColorBlack
                            : ColorsRes.appColorWhite
                            : Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                        borderRadius: Constant.borderRadius7,
                        border: Border.all(
                          width: context.read<CheckoutProvider>().selectedPaymentMethod == "Razorpay"
                              ? 1
                              : 0.3,
                          color: context.read<CheckoutProvider>().selectedPaymentMethod == "Razorpay"
                              ? ColorsRes.appColor
                              : ColorsRes.grey,
                        )),
                    child: Row(
                      children: [
                        Padding(
                            padding: EdgeInsetsDirectional.only(start: Constant.size10),
                            child: Widgets.setNetworkImg(
                                image: "https://th.bing.com/th/id/OIP.pKKpNogUNRPh_KEo3Cc77gHaB9?w=310&h=92&c=7&r=0&o=5&dpr=1.3&pid=1.7",
                                height: 30,
                                width: 30)),
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: Constant.size10),
                          child: Text('Gpay/PhonePe/Paytm'),
                        ),
                        const Spacer(),
                        Radio(
                          value: "Gpay/PhonePe/Paytm",
                          toggleable: false,
                          groupValue: context.read<CheckoutProvider>().selectedPaymentMethod,
                          activeColor: ColorsRes.appColor,
                          onChanged: (value) {
                            context.read<CheckoutProvider>().setSelectedPaymentMethod(value!);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              if (paymentMethodsData.codPaymentMethod == "1")
                GestureDetector(
                  onTap: !isSubtotalLessThan249
                      ? () {
                    context.read<CheckoutProvider>().setSelectedPaymentMethod("COD");
                  }
                      : null,
                  child: Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.symmetric(vertical: Constant.size5),
                    decoration: BoxDecoration(
                        color: context.read<CheckoutProvider>().selectedPaymentMethod == "COD"
                            ? Constant.session.getBoolData(SessionManager.isDarkTheme)
                            ? ColorsRes.appColorBlack
                            : ColorsRes.appColorWhite
                            : Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                        borderRadius: Constant.borderRadius7,
                        border: Border.all(
                          width: context.read<CheckoutProvider>().selectedPaymentMethod == "COD"
                              ? 1
                              : 0.3,
                          color: context.read<CheckoutProvider>().selectedPaymentMethod == "COD"
                              ? ColorsRes.appColor
                              : ColorsRes.grey,
                        )),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: Constant.size10),
                          child: Widgets.defaultImg(image: "ic_cod", width: 25, height: 25),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: Constant.size10),
                          child: Text(getTranslatedValue(
                            context,
                            "lblCashOnDelivery",
                          )),
                        ),
                        const Spacer(),
                        Radio(
                          value: "COD",
                          toggleable: false,
                          groupValue: context.read<CheckoutProvider>().selectedPaymentMethod,
                          activeColor: ColorsRes.appColor,
                          onChanged: isSubtotalLessThan249
                              ? null
                              : (value) {
                            context.read<CheckoutProvider>().setSelectedPaymentMethod("COD");
                          },
                        ),

                      ],
                    ),
                  ),
                ),
              GestureDetector(
                onTap: () {
                  context.read<CheckoutProvider>().setSelectedPaymentMethod("Razorpay");
                },
                child: Container(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.symmetric(vertical: Constant.size5),
                  decoration: BoxDecoration(
                      color: context.read<CheckoutProvider>().selectedPaymentMethod == "Razorpay"
                          ? Constant.session.getBoolData(SessionManager.isDarkTheme)
                          ? ColorsRes.appColorBlack
                          : ColorsRes.appColorWhite
                          : Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                      borderRadius: Constant.borderRadius7,
                      border: Border.all(
                        width: context.read<CheckoutProvider>().selectedPaymentMethod == "Razorpay" ? 1 : 0.3,
                        color: context.read<CheckoutProvider>().selectedPaymentMethod == "Razorpay" ? ColorsRes.appColor : ColorsRes.grey,
                      )),
                  child: Row(
                    children: [
                      Padding(
                          padding: EdgeInsetsDirectional.only(start: Constant.size10),
                          child: Widgets.setNetworkImg(
                              image: "https://th.bing.com/th/id/OIP.d0px8rOiJV_05QPderuBUAHaHa?pid=ImgDet&w=1000&h=1000&rs=1",
                              height: 25,
                              width: 25)),
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: Constant.size10),
                        child: Text('Card'),
                      ),
                      const Spacer(),
                      Radio(
                        value: "Razorpay",
                        toggleable: false,
                        groupValue: context.read<CheckoutProvider>().selectedPaymentMethod,
                        activeColor: ColorsRes.appColor,
                        onChanged: (value) {
                          context.read<CheckoutProvider>().setSelectedPaymentMethod("Razorpay");
                        },
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<CheckoutProvider>().setSelectedPaymentMethod("Net Banking");
                },
                child: Container(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.symmetric(vertical: Constant.size5),
                  decoration: BoxDecoration(
                      color: context.read<CheckoutProvider>().selectedPaymentMethod == "Net Banking"
                          ? Constant.session.getBoolData(SessionManager.isDarkTheme)
                          ? ColorsRes.appColorBlack
                          : ColorsRes.appColorWhite
                          : Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                      borderRadius: Constant.borderRadius7,
                      border: Border.all(
                        width: context.read<CheckoutProvider>().selectedPaymentMethod == "Razorpay" ? 1 : 0.3,
                        color: context.read<CheckoutProvider>().selectedPaymentMethod == "Razorpay" ? ColorsRes.appColor : ColorsRes.grey,
                      )),
                  child: Row(
                    children: [
                      Padding(
                          padding: EdgeInsetsDirectional.only(start: Constant.size10),
                          child: Widgets.setNetworkImg(
                              image: "https://cdn.iconscout.com/icon/free/png-256/free-netbanking-credit-debit-card-bank-transaction-32302.png",
                              height: 25,
                              width: 25)),
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: Constant.size10),
                        child: Text('Net Banking'),
                      ),
                      const Spacer(),
                      Radio(
                        value: "Net Banking",
                        toggleable: false,
                        groupValue: context.read<CheckoutProvider>().selectedPaymentMethod,
                        activeColor: ColorsRes.appColor,
                        onChanged: (value) {
                          context.read<CheckoutProvider>().setSelectedPaymentMethod(value!);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (paymentMethodsData.paystackPaymentMethod == "1")
                GestureDetector(
                  onTap: () {
                    context.read<CheckoutProvider>().setSelectedPaymentMethod("Paystack");
                  },
                  child: Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.symmetric(vertical: Constant.size5),
                    decoration: BoxDecoration(
                        color: context.read<CheckoutProvider>().selectedPaymentMethod == "Paystack"
                            ? Constant.session.getBoolData(SessionManager.isDarkTheme)
                            ? ColorsRes.appColorBlack
                            : ColorsRes.appColorWhite
                            : Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                        borderRadius: Constant.borderRadius7,
                        border: Border.all(
                          width: context.read<CheckoutProvider>().selectedPaymentMethod == "Paystack" ? 1 : 0.3,
                          color: context.read<CheckoutProvider>().selectedPaymentMethod == "Paystack" ? ColorsRes.appColor : ColorsRes.grey,
                        )),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: Constant.size10),
                          child: Widgets.defaultImg(image: "ic_paystack", width: 25, height: 25),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: Constant.size10),
                          child: Text(getTranslatedValue(
                            context,
                            "lblPaystack",
                          )),
                        ),
                        const Spacer(),
                        Radio(
                          value: "Paystack",
                          toggleable: false,
                          groupValue: context.read<CheckoutProvider>().selectedPaymentMethod,
                          activeColor: ColorsRes.appColor,
                          onChanged: (value) {
                            context.read<CheckoutProvider>().setSelectedPaymentMethod("Paystack");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              if (paymentMethodsData.stripePaymentMethod == "1")
                GestureDetector(
                  onTap: () {
                    context.read<CheckoutProvider>().setSelectedPaymentMethod("Stripe");
                  },
                  child: Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.symmetric(vertical: Constant.size5),
                    decoration: BoxDecoration(
                        color: context.read<CheckoutProvider>().selectedPaymentMethod == "Stripe"
                            ? Constant.session.getBoolData(SessionManager.isDarkTheme)
                            ? ColorsRes.appColorBlack
                            : ColorsRes.appColorWhite
                            : Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                        borderRadius: Constant.borderRadius7,
                        border: Border.all(
                          width: context.read<CheckoutProvider>().selectedPaymentMethod == "Stripe" ? 1 : 0.3,
                          color: context.read<CheckoutProvider>().selectedPaymentMethod == "Stripe" ? ColorsRes.appColor : ColorsRes.grey,
                        )),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: Constant.size10),
                          child: Widgets.defaultImg(image: "ic_stripe", width: 25, height: 25, iconColor: ColorsRes.mainTextColor),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: Constant.size10),
                          child: Text(getTranslatedValue(
                            context,
                            "lblStripe",
                          )),
                        ),
                        const Spacer(),
                        Radio(
                          value: "Stripe",
                          toggleable: false,
                          groupValue: context.read<CheckoutProvider>().selectedPaymentMethod,
                          activeColor: ColorsRes.appColor,
                          onChanged: (value) {
                            context.read<CheckoutProvider>().setSelectedPaymentMethod("Stripe");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              if (paymentMethodsData.paytmPaymentMethod == "1")
                GestureDetector(
                  onTap: () {
                    context.read<CheckoutProvider>().setSelectedPaymentMethod("Paytm");
                  },
                  child: Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.symmetric(vertical: Constant.size5),
                    decoration: BoxDecoration(
                        color: context.read<CheckoutProvider>().selectedPaymentMethod == "Paytm"
                            ? Constant.session.getBoolData(SessionManager.isDarkTheme)
                            ? ColorsRes.appColorBlack
                            : ColorsRes.appColorWhite
                            : Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                        borderRadius: Constant.borderRadius7,
                        border: Border.all(
                          width: context.read<CheckoutProvider>().selectedPaymentMethod == "Paytm" ? 1 : 0.3,
                          color: context.read<CheckoutProvider>().selectedPaymentMethod == "Paytm" ? ColorsRes.appColor : ColorsRes.grey,
                        )),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: Constant.size10),
                          child: Widgets.defaultImg(image: "ic_paytm", width: 25, height: 25),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: Constant.size10),
                          child: Text(getTranslatedValue(
                            context,
                            "lblPaytm",
                          )),
                        ),
                        const Spacer(),
                        Radio(
                          value: "Paytm",
                          toggleable: false,
                          groupValue: context.read<CheckoutProvider>().selectedPaymentMethod,
                          onChanged: (value) {
                            context.read<CheckoutProvider>().setSelectedPaymentMethod("Paytm");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Divider(color: ColorsRes.grey, height: 1, thickness: 0.1),
          Widgets.getSizedBox(
            height: Constant.size5,
          ),
          if (context.read<CheckoutProvider>().subTotalAmount < 250)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'COD not available for order value below ₹250 and FESTIVE KITS',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
            ),
        ],
      ),
    ),
  )
      : const SizedBox.shrink();
}
