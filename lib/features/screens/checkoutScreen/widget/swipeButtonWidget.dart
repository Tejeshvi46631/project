import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/cartData.dart';
import 'package:egrocer/core/provider/checkoutProvider.dart';
import 'package:egrocer/core/repository/facebook_analytics.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class OrderSwipeButton extends StatefulWidget {
  final bool isEnabled;
  final CartData cartData;

  const OrderSwipeButton({
    Key? key,
    required this.isEnabled,
    required this.cartData,
  }) : super(key: key);

  @override
  State<OrderSwipeButton> createState() => _OrderSwipeButtonState();
}

class _OrderSwipeButtonState extends State<OrderSwipeButton> {
  bool isPaymentUnderProcessing = false;
  final Razorpay _razorpay = Razorpay();
  late String razorpayKey = "";
  late double amount = 0.00;

  @override
  void initState() {
    super.initState();
    _initializeRazorpay();
  }

  void _initializeRazorpay() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleRazorPayPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleRazorPayPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleRazorPayExternalWallet);
  }

  Future<void> storePromoUser() async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'phone': Constant.session.getData(SessionManager.keyPhone),
        'promo_code': "NEWCKAPP",
      });
    } catch (e) {
      print("Error storing promo user: $e");
    }
  }

  void _handleRazorPayPaymentSuccess(PaymentSuccessResponse response) async {
    setState(() => isPaymentUnderProcessing = false);
    await storePromoUser();

    context.read<CheckoutProvider>().transactionId = response.paymentId ?? "";
    context.read<CheckoutProvider>().addTransaction(context: context);

    _fbEventPurchaseSuccess(widget.cartData);
    GeneralMethods.showSnackBarMsg(context, "Payment Successful");
  }

  void _handleRazorPayPaymentError(PaymentFailureResponse response) {
    setState(() => isPaymentUnderProcessing = false);

    final errorMessage = response.message != null
        ? jsonDecode(response.message!)["error"]
        : "Unknown error";
    GeneralMethods.showSnackBarMsg(context, "Payment failed: $errorMessage");
    _fbEventPurchaseFail(widget.cartData);
  }

  void _handleRazorPayExternalWallet(ExternalWalletResponse response) {
    setState(() => isPaymentUnderProcessing = false);
    GeneralMethods.showSnackBarMsg(context, "External wallet selected");
  }

  Future<void> openRazorPayGateway() async {
    final provider = context.read<CheckoutProvider>();
    final options = {
      'key': razorpayKey,
      'order_id': provider.razorpayOrderId,
      'amount': (amount * 100).toInt(),
      'name': 'chhayakart',
      'image': 'https://admin.chhayakart.com/storage/logo/1680098508_37047.png',
      'prefill': {
        'contact': Constant.session.getData(SessionManager.keyPhone),
        'email': Constant.session.getData(SessionManager.keyEmail),
      },
    };
    _razorpay.open(options);
  }

  Future<void> _processOrder() async {
    setState(() => isPaymentUnderProcessing = true);
    final provider = context.read<CheckoutProvider>();

    try {
      razorpayKey =
          context.read<CheckoutProvider>().paymentMethodsData.razorpayKey;

      print("get Data ${provider.selectedAddress}");
      if (context.read<CheckoutProvider>().selectedAddress!.id ==
          null) {
        GeneralMethods.showSnackBarMsg(
              context, "Please Select Delivery Address");
      } else {
        if (provider.selectedPaymentMethod == "COD") {
          await provider.placeOrder(context: context, cartData: widget.cartData);
        } else {
          amount = Constant.isPromoCodeApplied
              ? provider.taxSubTotalAmount - Constant.discount
              : provider.taxSubTotalAmount;

           await provider.placeOrder(context: context, cartData: widget.cartData);
          if (provider.checkoutPlaceOrderState !=
              CheckoutPlaceOrderState.placeOrderError) {
              await openRazorPayGateway();
          }
        }
      }
    } catch (e) {
      GeneralMethods.showSnackBarMsg(context, "Order placement failed: $e");
    } finally {
      setState(() => isPaymentUnderProcessing = false);
    }
  }

  void _fbEventPurchaseSuccess(CartData cartData) {
    try {
      final provider = context.read<CheckoutProvider>();
      final cartTotal = provider.subTotalAmount.getTotalWithGST() +
          provider.totalDeliveryCharges;
      final placedOrderId = provider.placedOrderId;

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
              .toList(),
        },
      );
    } catch (e) {
      print("Error logging purchase success event: $e");
    }
  }

  void _fbEventPurchaseFail(CartData cartData) {
    try {
      final provider = context.read<CheckoutProvider>();
      final cartTotal = provider.subTotalAmount.getTotalWithGST() +
          provider.totalDeliveryCharges;
      final placedOrderId = provider.placedOrderId;

      FacebookAnalytics.customEvent(
        name: 'purchaseFail',
        parameters: {
          'orderId': placedOrderId,
          'amount': cartTotal,
          'currency': 'INR',
          'paymentMethod': 'Razorpay',
          'numItems': cartData.data.cart.length,
          'items': cartData.data.cart
              .map((e) =>
                  {'name': e.name, 'price': e.discountedPrice, 'qty': e.qty})
              .toList(),
        },
      );
    } catch (e) {
      print("Error logging purchase fail event: $e");
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
          color: ColorsRes.buttoncolor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsRes.buttoncolor,
            foregroundColor: Colors.white,
          ),
          onPressed: widget.isEnabled && !isPaymentUnderProcessing
              ? () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.remove("discountedAmount");
                  await _processOrder();
                }
              : widget.isEnabled == false ? () { GeneralMethods.showSnackBarMsg(
              context, "Please Select Payment Option");} : null,
          child: isPaymentUnderProcessing
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Processing your order, please wait...",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
              : Text(
                  "Proceed To Pay",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}

/// Phone integration
/*class OrderSwipeButton extends StatefulWidget {
  final bool isEnabled;
  final dynamic cartData;

  const OrderSwipeButton(
      {Key? key, required this.isEnabled, required this.cartData})
      : super(key: key);

  @override
  _OrderSwipeButtonState createState() => _OrderSwipeButtonState();
}

class _OrderSwipeButtonState extends State<OrderSwipeButton> {
  bool isPaymentUnderProcessing = false;
  double amount = 0.0;

  String jsonString = "";
  Object? result;
  String environmentValue = 'PRODUCTION';
  String appId = "";
  String callBackUrl = "https://chhayakart.com/phonepe/verify.php";
  String merchantId = "M22MGVH4OZHZT";
  bool enableLog = true;
  String packageName = "com.chayakart";
  String body = "";
  String checksum = "";
  String saltKey = "24b34dd1-f28f-4d0c-bce4-47be8372e6dc";
  String saltIndex = "1";
  String apiEndPoint = "/pg/v1/pay";

 *//* getCheckSum() {
    final requestData = {
      "merchantId": "M22MGVH4OZHZT",
      "merchantTransactionId": "DMT${getRandomNumber()}",
      "amount": 41600,
      "merchantUserId": 15915,
      "redirectUrl": "https://chhayakart.com/phonepe/success.php",
      "redirectMode": "REDIRECT",
      "callbackUrl": callBackUrl,
      "paymentInstrument": {"type": "PAY_PAGE"}
    };
    *//**//*final requestData = {
      "merchantId": merchantId,
      "merchantTransactionId": "DMT${getRandomNumber()}",
      "merchantUserId": "MU${getRandomNumber()}",
      "amount": (amount * 100).toInt(),
      "callbackUrl": callBackUrl,
      "mobileNumber": Constant.session.getData(SessionManager.keyPhone),
      "paymentInstrument": {"type": "PAY_PAGE"}
    };*//**//*

    String base64Body = base64.encode(utf8.encode(json.encode(requestData)));

    checksum =
        '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltKey)).toString()}###$saltIndex';

    return base64Body;
  }*//*

  @override
  void initState() {
    super.initState();
    phonePayInit();
  }

  String generateSha256Hash(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  String getRandomNumber() {
    Random random = Random();
    String randomMerchant = "";
    for (int i = 0; i < 15; i++) {
      randomMerchant += random.nextInt(10).toString();
    }
    return randomMerchant;
  }

  void phonePayInit() {
    PhonePePaymentSdk.init(environmentValue, appId, merchantId, enableLog)
        .then((val) {
      print("PhonePe SDK Initialized: $val");
      result = 'PhonePe SDK Initialized - $val';
    }).catchError((error) {
      print("PhonePe Initialization error: $error");
      GeneralMethods.showSnackBarMsg(
          context, "PhonePe Initialization failed: $error");
    });
  }

  // First Point
  *//*startTransaction() async {
    *//**//*  final provider = context.read<CheckoutProvider>();
     String body = provider.getBody;
     String checksum = provider.checkSum;*//**//*
    print("Body hai yaa $body");
    print("Checksum hai yaa $checksum");

    try {
      PhonePePaymentSdk.startTransaction(
              body, callBackUrl, checksum, packageName)
          .then((response) => {
                setState(() {
                  if (response != null) {
                    String status = response['status'].toString();
                    String error = response['error'].toString();
                    if (status == 'SUCCESS') {
                      setState(() {
                        isPaymentUnderProcessing = false;
                        // storePromoUser();
                      });
                      context
                          .read<CheckoutProvider>()
                          .addTransaction(context: context);
                      print("Payment Successful");
                      GeneralMethods.showSnackBarMsg(
                          context, "Payment Successful");
                      result = "Flow Completed - Status: Success!";
                    } else {
                      result = "Flow Error - Status: $status and Error: $error";
                      GeneralMethods.showSnackBarMsg(
                          context, "Payment failed: $error");
                    }
                  } else {
                    result = "Flow Incomplete";
                  }
                })
              })
          .catchError((error) {
        //  handleError(error);
        return <dynamic>{};
      });
    } catch (error) {
      // handleError(error);
    }
  }*//*

  Future<void> _processOrder() async {
    setState(() => isPaymentUnderProcessing = true);

    final provider = context.read<CheckoutProvider>();

    try {
      if (provider.selectedPaymentMethod == "COD") {
         await provider.placeOrder(context: context, cartData: widget.cartData, isPaymentUnderProcessing: isPaymentUnderProcessing);
      } else {
        // Assuming that PhonePe is selected
        amount = Constant.isPromoCodeApplied
            ? provider.taxSubTotalAmount - Constant.discount
            : provider.taxSubTotalAmount;

         await provider.placeOrder(context: context, cartData: widget.cartData, isPaymentUnderProcessing: isPaymentUnderProcessing);

        if (provider.checkoutPlaceOrderState !=
            CheckoutPlaceOrderState.placeOrderError) {
         // body = getCheckSum().toString();
          // provider.getBody = provider.checkSum.toString();
         // await startTransaction();
        }
      }
    } catch (e) {
      GeneralMethods.showSnackBarMsg(context, "Order placement failed: $e");
    } finally {
      setState(() => isPaymentUnderProcessing = false);
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
          color: ColorsRes.buttoncolor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsRes.buttoncolor,
            foregroundColor: Colors.white,
          ),
          onPressed: widget.isEnabled && !isPaymentUnderProcessing
              ? () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.remove("discountedAmount");
                  await _processOrder();
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
                    Expanded(
                      child: Text(
                        "Processing your order, please wait...",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
              : Text(
                  "Proceed To Pay",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  void _fbEventPurchaseSuccess(CartData cartData) {
    try {
      final provider = context.read<CheckoutProvider>();
      final cartTotal = provider.subTotalAmount.getTotalWithGST() +
          provider.totalDeliveryCharges;
      final placedOrderId = provider.placedOrderId;

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
              .toList(),
        },
      );
    } catch (e) {
      print("Error logging purchase success event: $e");
    }
  }

  void _fbEventPurchaseFail(CartData cartData) {
    try {
      final provider = context.read<CheckoutProvider>();
      final cartTotal = provider.subTotalAmount.getTotalWithGST() +
          provider.totalDeliveryCharges;
      final placedOrderId = provider.placedOrderId;

      FacebookAnalytics.customEvent(
        name: 'purchaseFail',
        parameters: {
          'orderId': placedOrderId,
          'amount': cartTotal,
          'currency': 'INR',
          'paymentMethod': 'Razorpay',
          'numItems': cartData.data.cart.length,
          'items': cartData.data.cart
              .map((e) =>
                  {'name': e.name, 'price': e.discountedPrice, 'qty': e.qty})
              .toList(),
        },
      );
    } catch (e) {
      print("Error logging purchase fail event: $e");
    }
  }
}*/
