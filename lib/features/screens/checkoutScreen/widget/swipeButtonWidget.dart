import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/cartData.dart';
import 'package:egrocer/core/provider/checkoutProvider.dart';
import 'package:egrocer/core/repository/facebook_analytics.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:paytm/paytm.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constant/routeGenerator.dart';
import '../../../../core/provider/activeOrdersProvider.dart';
import '../../orderSummaryScreen/orderSummaryScreen.dart';

class OrderSwipeButton extends StatefulWidget {
  final BuildContext context;
  final bool isEnabled;
  final CartData cartData;

  const OrderSwipeButton(
      {Key? key,
      required this.context,
      required this.isEnabled,
      required this.cartData})
      : super(key: key);

  @override
  State<OrderSwipeButton> createState() => _SwipeButtonState();
}

class _SwipeButtonState extends State<OrderSwipeButton> {
  bool isPaymentUnderProcessing = false;
  final Razorpay _razorpay = Razorpay();
  late String razorpayKey = "";
  late String paystackKey = "";
  late double amount = 0.00;
  late PaystackPlugin paystackPlugin;

  Future<void> storePromoUser() async {
    await FirebaseFirestore.instance.collection('users').add({
      'phone': Constant.session.getData(SessionManager.keyPhone),
      // John Doe
      'promo_code': "NEWCKAPP",
      // Stokes and Sons
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      paystackPlugin = PaystackPlugin();
      _razorpay.on(
          Razorpay.EVENT_PAYMENT_SUCCESS, _handleRazorPayPaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleRazorPayPaymentError);
      _razorpay.on(
          Razorpay.EVENT_EXTERNAL_WALLET, _handleRazorPayExternalWallet);
    });
  }

  void _handleRazorPayPaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      isPaymentUnderProcessing = false;
      storePromoUser();
    });
    context.read<CheckoutProvider>().transactionId =
        response.paymentId.toString();
    context.read<CheckoutProvider>().addTransaction(context: context);
    print("Payment Successful");
    _fbEventPurchaseSuccess(context, widget.cartData);
    GeneralMethods.showSnackBarMsg(context, "Payment Successful");
  }

  void _handleRazorPayPaymentError(PaymentFailureResponse response) {
    setState(() {
      isPaymentUnderProcessing = false;
    });
    try {
      Map<dynamic, dynamic> message =
          jsonDecode(response.message ?? "")["error"];
    } catch (e) {}
    GeneralMethods.showSnackBarMsg(context, "Payment failed");
    print("Payment failed");
    _fbEventPurchaseFail(context, widget.cartData);
    GeneralMethods.showSnackBarMsg(context, response.code.toString());
    GeneralMethods.showSnackBarMsg(context, response.error.toString());
  }

  void _handleRazorPayExternalWallet(ExternalWalletResponse response) {
    setState(() {
      isPaymentUnderProcessing = false;
    });

    print("Payment ExternalWallet");
    GeneralMethods.showSnackBarMsg(context, response.toString());
  }

  void openRazorPayGateway() async {
    print('razorpaychanges');
    print(razorpayKey);
    print(context.read<CheckoutProvider>().razorpayOrderId);
    final options = {
      //'key': "rzp_test_Ins7nrNtRLbZTy",
      'key': razorpayKey, //this should be come from server
      'order_id': context.read<CheckoutProvider>().razorpayOrderId,
      'amount': (amount * 100).toInt(),
      // 'amount': amount,
      'name': 'chhayakart',
      // 'name': getTranslatedValue(
      //   context,
      //   "lblAppName",
      // ),
      'image': 'https://admin.chhayakart.com/storage/logo/1680098508_37047.png',
      // 'currency': 'INR',
      'prefill': {
        'contact': Constant.session.getData(SessionManager.keyPhone),
        'email': Constant.session.getData(SessionManager.keyEmail)
      }
    };
    print(options);
    _razorpay.open(options);
  }

  // Using package flutter_paystack
  Future openPaystackPaymentGateway() async {
    await paystackPlugin.initialize(
        publicKey: context
            .read<CheckoutProvider>()
            .paymentMethodsData
            .paystackPublicKey);

    Charge charge = Charge()
      ..amount = (amount * 100).toInt()
      ..currency = context
          .read<CheckoutProvider>()
          .paymentMethodsData
          .paystackCurrencyCode
      ..reference = context.read<CheckoutProvider>().payStackReference
      ..email = Constant.session.getData(SessionManager.keyEmail);

    CheckoutResponse response = await paystackPlugin.checkout(
      context,
      fullscreen: false,
      logo: Widgets.defaultImg(
        height: 50,
        width: 50,
        image: "logo",
      ),
      method: CheckoutMethod.card,
      charge: charge,
    );

    if (response.status) {
      context.read<CheckoutProvider>().addTransaction(context: context);
    } else {
      setState(() {
        isPaymentUnderProcessing = false;
      });
      GeneralMethods.showSnackBarMsg(context, response.message);
    }
  }

  //Paytm Payment Gateway
  openPaytmPaymentGateway() async {
    try {
      GeneralMethods.sendApiRequest(
              apiName: ApiAndParams.apiPaytmTransactionToken,
              params: {
                ApiAndParams.orderId:
                    context.read<CheckoutProvider>().placedOrderId,
                ApiAndParams.amount:
                    context.read<CheckoutProvider>().totalAmount.toString()
              },
              isPost: false,
              context: context)
          .then((value) async {
        await Paytm.payWithPaytm(
                mId: context
                    .read<CheckoutProvider>()
                    .paymentMethodsData
                    .paytmMerchantId,
                orderId: context.read<CheckoutProvider>().placedOrderId,
                txnToken: context.read<CheckoutProvider>().paytmTxnToken,
                txnAmount: context
                    .read<CheckoutProvider>()
                    .totalAmount
                    .getTotalWithGST()
                    .toString(),
                callBackUrl:
                    '${context.read<CheckoutProvider>().paymentMethodsData.paytmMode == "sandbox" ? 'https://securegw-stage.paytm.in' : 'https://securegw.paytm.in'}/theia/paytmCallback?ORDER_ID=${context.read<CheckoutProvider>().placedOrderId}',
                staging: context
                        .read<CheckoutProvider>()
                        .paymentMethodsData
                        .paytmMode ==
                    "sandbox",
                appInvokeEnabled: false)
            .then((value) {
          Map<dynamic, dynamic> response = value["response"];
          if (response["STATUS"] == "TXN_SUCCESS") {
            print("$response");
            context.read<CheckoutProvider>().transactionId =
                response["TXNID"].toString();
            context.read<CheckoutProvider>().addTransaction(context: context);
          } else {
            setState(() {
              isPaymentUnderProcessing = false;
            });
            GeneralMethods.showSnackBarMsg(context, response["STATUS"]);
          }
        });
      });
    } catch (e) {
      setState(() {
        isPaymentUnderProcessing = false;
      });
      GeneralMethods.showSnackBarMsg(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: ColorsRes.buttoncolor, // Custom background color
          borderRadius: BorderRadius.circular(10.0), // Rounded border radius
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsRes.buttoncolor,
            foregroundColor: Colors.white,
          ),
          onPressed: widget.isEnabled && !isPaymentUnderProcessing
              ? () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.remove("discountedAmount");
            setState(()  {

              isPaymentUnderProcessing = true;
            });

            try {
              razorpayKey =
                  context.read<CheckoutProvider>().paymentMethodsData.razorpayKey;

              Order? placedOrder;

              if (context
                  .read<CheckoutProvider>()
                  .selectedPaymentMethod == "COD") {
                placedOrder = (await context
                    .read<CheckoutProvider>()
                    .placeOrder(context: context, cartData: widget.cartData)) as Order?;
              } else {
                if (Constant.isPromoCodeApplied) {
                  amount = await ((context
                      .read<CheckoutProvider>()
                      .subTotalAmount -
                      Constant.discount)
                      .getTotalWithGST() +
                      context.read<CheckoutProvider>().deliveryCharge);
                } else {
                  amount = await (context
                      .read<CheckoutProvider>()
                      .subTotalAmount
                      .getTotalWithGST() +
                      context.read<CheckoutProvider>().deliveryCharge);
                }

                placedOrder = await context
                    .read<CheckoutProvider>()
                    .placeOrder(context: context, cartData: widget.cartData)
                    .then((value) async {
                  if (context
                      .read<CheckoutProvider>()
                      .checkoutPlaceOrderState !=
                      CheckoutPlaceOrderState.placeOrderError) {
                    openRazorPayGateway();
                  }
                 // return value;
                });
              }








            } catch (error) {
              GeneralMethods.showSnackBarMsg(
                  context, "Order placement failed");
            } finally {
              setState(() {
                isPaymentUnderProcessing = false;
              });
            }
          }
              : null,
          child: isPaymentUnderProcessing
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              SizedBox(width: 10),
              Text(
                  "Your order is being processed, please wait..."),
            ],
          )
              : Text(
            "Proceed To Pay",
            style: TextStyle(
              color: Colors.white, // Set text color to white
              fontSize: 16, // Adjust font size as needed
              fontWeight: FontWeight.bold, // Adjust font weight as needed
            ),
          ),
        ),
      ),
    );
  }

  void _fbEventPurchaseSuccess(BuildContext context, CartData cartData) {
    try {
      var cartTotal =
          context.read<CheckoutProvider>().subTotalAmount.getTotalWithGST() +
              context.read<CheckoutProvider>().deliveryCharge;
      var placedOrderId = context.read<CheckoutProvider>().placedOrderId;
      FacebookAnalytics.purchaseSuccess(
          amount: cartTotal,
          currency: 'INR',
          parameters: {
            'orderId': placedOrderId,
            'paymentMethod': 'Razorpay',
            'numItems': cartData.data.cart.length,
            'items': cartData.data.cart
                .map((e) =>
                    {'name': e.name, 'price': e.discountedPrice, 'qty': e.qty})
                .toList()
          });
    } catch (e) {}
  }

  void _fbEventPurchaseFail(BuildContext context, CartData cartData) {
    try {
      var cartTotal =
          context.read<CheckoutProvider>().subTotalAmount.getTotalWithGST() +
              context.read<CheckoutProvider>().deliveryCharge;
      var placedOrderId = context.read<CheckoutProvider>().placedOrderId;
      FacebookAnalytics.customEvent(name: 'purchaseFail', parameters: {
        'orderId': placedOrderId,
        'amount': cartTotal,
        'currency': 'INR',
        'paymentMethod': 'Razorpay',
        'numItems': cartData.data.cart.length,
        'items': cartData.data.cart
            .map((e) =>
                {'name': e.name, 'price': e.discountedPrice, 'qty': e.qty})
            .toList()
      });
    } catch (e) {}
  }
}
