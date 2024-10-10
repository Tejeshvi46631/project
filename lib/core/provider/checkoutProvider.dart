import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/model/address.dart';
import 'package:egrocer/core/model/cartData.dart';
import 'package:egrocer/core/model/checkout.dart';
import 'package:egrocer/core/model/initiateTransaction.dart';
import 'package:egrocer/core/model/paymentMethods.dart';
import 'package:egrocer/core/model/paytmTransationToken.dart';
import 'package:egrocer/core/model/placedPrePaidOrder.dart';
import 'package:egrocer/core/model/timeSlots.dart';
import 'package:egrocer/core/repository/facebook_analytics.dart';
import 'package:egrocer/core/webservices/addTransactionApi.dart';
import 'package:egrocer/core/webservices/addressApi.dart';
import 'package:egrocer/core/webservices/cartApi.dart';
import 'package:egrocer/core/webservices/initiateTransactionApi.dart';
import 'package:egrocer/core/webservices/paymentMethodsSettingsApi.dart';
import 'package:egrocer/core/webservices/placeOrderApi.dart';
import 'package:egrocer/core/webservices/timeSlotSettingsApi.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:provider/provider.dart';

enum CheckoutTimeSlotsState {
  timeSlotsLoading,
  timeSlotsLoaded,
  timeSlotsError,
}

enum CheckoutAddressState {
  addressLoading,
  addressLoaded,
  addressBlank,
  addressError,
}

enum CheckoutDeliveryChargeState {
  deliveryChargeLoading,
  deliveryChargeLoaded,
  deliveryChargeError,
}

enum CheckoutPaymentMethodsState {
  paymentMethodLoading,
  paymentMethodLoaded,
  paymentMethodError,
}

enum CheckoutPlaceOrderState {
  placeOrderLoading,
  placeOrderLoaded,
  placeOrderError,
}

class CheckoutProvider extends ChangeNotifier {
  CheckoutAddressState checkoutAddressState =
      CheckoutAddressState.addressLoading;

  CheckoutDeliveryChargeState checkoutDeliveryChargeState =
      CheckoutDeliveryChargeState.deliveryChargeLoading;

  CheckoutTimeSlotsState checkoutTimeSlotsState =
      CheckoutTimeSlotsState.timeSlotsLoading;

  CheckoutPaymentMethodsState checkoutPaymentMethodsState =
      CheckoutPaymentMethodsState.paymentMethodLoading;

  CheckoutPlaceOrderState checkoutPlaceOrderState =
      CheckoutPlaceOrderState.placeOrderLoading;

  String message = '';

  //Address variables
  late AddressData? selectedAddress = AddressData();

  // Order Delivery charge variables
  double subTotalAmount = 0.0;
  double taxSubTotalAmount = 0.0;
  double totalAmount = 0.0;
  double savedAmount = 0.0;
  //double deliveryCharge = 0.0;
  double totalDeliveryCharges = 0.0;
  double platformFee = 0.0;
  double shippingFee = 0.0;
  double codServicesFee = 0.0;
  late List<SellersInfo> sellerWiseDeliveryCharges;
  late DeliveryChargeData deliveryChargeData;
  bool isCodAllowed = true;
  bool isPaymentOptionSelected = false;

  //Timeslots variables
  late TimeSlotsData timeSlotsData;
  bool isTimeSlotsEnabled = true;
  int selectedDate = 0;
  int selectedTime = 0;
  String? selectedPaymentMethod;

  //Payment methods variables
  late PaymentMethods paymentMethods;
  late PaymentMethodsData paymentMethodsData;

  //Place order variables
  String placedOrderId = "";
  String razorpayOrderId = "";
  String transactionId = "";
  String payStackReference = "";
  String getBody = "";
  String checkSum = "";
  Object? result;

  String paytmTxnToken = "";


  Future<AddressData?> getSingleAddressProvider(
      {required BuildContext context}) async {
    try {
      print("entered in try block");
      Map<String, dynamic> getAddress = (await getAddressApi(
          context: context, params: {ApiAndParams.isDefault: "1"}));
      if (getAddress[ApiAndParams.status].toString() == "1") {
        Address addressData = Address.fromJson(getAddress);
        print("View Address :: ${addressData.data?.toString()}");
        selectedAddress = addressData.data?[0];
        // print(selectedAddress);

        checkoutAddressState = CheckoutAddressState.addressLoaded;
        // print(checkoutAddressState);
        notifyListeners();
        return selectedAddress;
      } else {
        print("entered in else part of checkout");
        checkoutAddressState = CheckoutAddressState.addressBlank;
        notifyListeners();
        return selectedAddress;
      }
    } catch (e) {
      print("entered in catch block");
      message = e.toString();
      checkoutAddressState = CheckoutAddressState.addressError;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
      return selectedAddress;
    }
  }

  setSelectedAddress(BuildContext context, var address) async {
    if (address != AddressData()) {
      if (selectedAddress != AddressData()) {
        selectedAddress = address;

        checkoutAddressState = CheckoutAddressState.addressLoaded;
        notifyListeners();

        await getOrderChargesProvider(
          context: context,
          params: {
            ApiAndParams.cityId: selectedAddress!.cityId.toString(),
            ApiAndParams.latitude: selectedAddress!.latitude.toString(),
            ApiAndParams.longitude: selectedAddress!.longitude.toString(),
            ApiAndParams.isCheckout: "1"
          },
        );
      }
    } else if (selectedAddress == null && address == null) {
      checkoutAddressState = CheckoutAddressState.addressBlank;
      notifyListeners();
    }
  }

  setAddressEmptyState() {
    selectedAddress = null;
    checkoutAddressState = CheckoutAddressState.addressBlank;
    notifyListeners();
  }

  Future getOrderChargesProvider(
      {required BuildContext context,
        required Map<String, String> params}) async {
    try {
      checkoutDeliveryChargeState =
          CheckoutDeliveryChargeState.deliveryChargeLoading;
      notifyListeners();
      print(params);
      Map<String, dynamic> getCheckoutData =
      (await getCartListApi(context: context, params: params));
      print(getCheckoutData);
      if (getCheckoutData[ApiAndParams.status].toString() == "1") {
        print("entered ordercharge");
        Checkout checkoutData = Checkout.fromJson(getCheckoutData);

        deliveryChargeData = checkoutData.data;

        isCodAllowed = deliveryChargeData.isCodAllowed != 0;
        print("Cart List Data with Delevery Charge==============>");
        print(deliveryChargeData.toJson());
        print("=======================================>");

        subTotalAmount = double.parse(deliveryChargeData.subTotal.toString());
        taxSubTotalAmount = double.parse(deliveryChargeData.taxSubTotal.toString());
        totalAmount = double.parse(deliveryChargeData.totalAmount.toString());
        savedAmount = double.parse(deliveryChargeData.savedAmount.toString());
        totalDeliveryCharges = Constant.deliveryAmount;
        totalDeliveryCharges = double.parse(deliveryChargeData.codServicesFee.toString());
        platformFee = double.parse(deliveryChargeData.platformFee.toString());
        shippingFee = double.parse(deliveryChargeData.shippingFee.toString());
        codServicesFee = double.parse(deliveryChargeData.codServicesFee.toString());
        sellerWiseDeliveryCharges =
            deliveryChargeData.deliveryCharge!.sellersInfo!;

        checkoutDeliveryChargeState =
            CheckoutDeliveryChargeState.deliveryChargeLoaded;
        print(checkoutDeliveryChargeState);
        checkoutAddressState = CheckoutAddressState.addressLoaded;
        print(checkoutAddressState);
        notifyListeners();
        // setData();
      } else {
        checkoutDeliveryChargeState =
            CheckoutDeliveryChargeState.deliveryChargeError;
        checkoutAddressState = CheckoutAddressState.addressBlank;
        print(checkoutDeliveryChargeState);
        print(checkoutAddressState);
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      checkoutDeliveryChargeState =
          CheckoutDeliveryChargeState.deliveryChargeError;
      checkoutAddressState = CheckoutAddressState.addressBlank;
      print(checkoutDeliveryChargeState);
      print(checkoutAddressState);

      notifyListeners();
      GeneralMethods.showSnackBarMsg(context, message);
    }
  }

  setData() {
    if (deliveryChargeData.deliveryCharge != null) {
      deliveryChargeData.deliveryCharge!.totalDeliveryCharge = Constant.deliveryAmount.toString();
    }
    deliveryChargeData.totalAmount =
        (double.parse(deliveryChargeData.totalAmount.toString()) + Constant.deliveryAmount)
            .toString();
    subTotalAmount = double.parse(deliveryChargeData.subTotal.toString());
    totalAmount = double.parse(deliveryChargeData.totalAmount.toString());
    notifyListeners();
  }

  Future getTimeSlotsSettings({required BuildContext context}) async {
    try {
      Map<String, dynamic> getTimeSlotsSettings =
      (await getTimeSlotSettingsApi(context: context, params: {}));

      if (getTimeSlotsSettings[ApiAndParams.status].toString() == "1") {
        print("entered in if gettime");
        TimeSlotsSettings timeSlots =
        TimeSlotsSettings.fromJson(getTimeSlotsSettings);
        timeSlotsData = timeSlots.data;
        isTimeSlotsEnabled = timeSlots.data.timeSlotsIsEnabled == "true";

        selectedDate = 0;
        // DateFormat dateFormat = DateFormat("yyyy-MM-d hh:mm:ss");
        // DateTime now = new DateTime.now();
        // DateTime currentTime = dateFormat.parse(
        //     "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}");
        //
        //2022-10-18 11:36:14.267721
        if (int.parse(timeSlotsData.timeSlotsDeliveryStartsFrom ?? "0") > 1) {
          selectedTime = 0;
        }
        /* else {
          for (int i = 0; i < timeSlotsData.timeSlots.length; i++) {
            DateTime timeSlotTime = dateFormat.parse(
                "${currentTime.year}-${currentTime.month}-${currentTime.day} ${timeSlotsData.timeSlots[i].lastOrderTime}");
          }
        }*/

        checkoutTimeSlotsState = CheckoutTimeSlotsState.timeSlotsLoaded;
        notifyListeners();
      } else {
        isTimeSlotsEnabled = false;
        GeneralMethods.showSnackBarMsg(
          context,
          message,
        );
        checkoutTimeSlotsState = CheckoutTimeSlotsState.timeSlotsError;
        notifyListeners();
      }
    } catch (e) {
      isTimeSlotsEnabled = false;

      checkoutTimeSlotsState = CheckoutTimeSlotsState.timeSlotsError;
      notifyListeners();
    }
  }

  setSelectedDate(int index) {
    print("enter in setselected");
    selectedTime = 0;
    // selectedDate = index;
    // DateTime currentTime = DateTime.now();
    // DateFormat dateFormat = DateFormat("yyyy-MM-d hh:mm:ss");
    //2022-10-18 11:36:14.267721
    if (int.parse(timeSlotsData.timeSlotsDeliveryStartsFrom ?? "0") > 1) {
      selectedTime = 0;
    }
    /* else {
      for (int i = 0; i < timeSlotsData.timeSlots.length; i++) {
        DateTime timeSlotTime = dateFormat.parse(
            "${currentTime.year}-${currentTime.month}-${currentTime.day} ${timeSlotsData.timeSlots[i].lastOrderTime}");
      }
    }*/
    notifyListeners();
  }

  setSelectedTime(int index) {
    selectedTime = index;
    notifyListeners();
  }

  Future getPaymentMethods({required BuildContext context}) async {
    try {
      Map<String, dynamic> getPaymentMethodsSettings =
      (await getPaymentMethodsSettingsApi(context: context, params: {}));

      if (getPaymentMethodsSettings[ApiAndParams.status].toString() == "1") {
        paymentMethods = PaymentMethods.fromJson(getPaymentMethodsSettings);
        paymentMethodsData = paymentMethods.data;

        if (paymentMethodsData.codMode == "global" && !isCodAllowed) {
          isCodAllowed = true;
        } else if (paymentMethodsData.codMode == "product" && !isCodAllowed) {
          isCodAllowed = true;
        }

        if (paymentMethodsData.codPaymentMethod == "1" &&
            isCodAllowed == false) {
          selectedPaymentMethod = "COD";
        } else if (paymentMethodsData.razorpayPaymentMethod == "1") {
          selectedPaymentMethod = "Razorpay";
        } /*else if (paymentMethodsData.paystackPaymentMethod == "1") {
          selectedPaymentMethod = "Paystack";
        } else if (paymentMethodsData.stripePaymentMethod == "1") {
          selectedPaymentMethod = "Stripe";
        } else if (paymentMethodsData.paytmPaymentMethod == "1") {
          selectedPaymentMethod = "Paytm";
        } else if (paymentMethodsData.paypalPaymentMethod == "1") {
          selectedPaymentMethod = "Paypal";
        }*/

        checkoutPaymentMethodsState =
            CheckoutPaymentMethodsState.paymentMethodLoaded;
        notifyListeners();
      } else {
        GeneralMethods.showSnackBarMsg(context, message);
        checkoutPaymentMethodsState =
            CheckoutPaymentMethodsState.paymentMethodError;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      GeneralMethods.showSnackBarMsg(context, message);
      checkoutPaymentMethodsState =
          CheckoutPaymentMethodsState.paymentMethodError;
      notifyListeners();
    }
  }
  setSelectedPaymentMethod(String? method) {
    isPaymentOptionSelected = false;
    selectedPaymentMethod = method;
    isPaymentOptionSelected = true;
    notifyListeners(); // Notify listeners when the state changes

  }

  Future placeOrder(
      {required BuildContext context, required CartData cartData}) async {
    try {
      print("entered in place order");
      late DateTime dateTime;
      if (int.parse(timeSlotsData.timeSlotsDeliveryStartsFrom.toString()) ==
          1) {
        dateTime = DateTime.now();
      } else {
        dateTime = DateTime.now()
            .add(Duration(days: int.parse(timeSlotsData.timeSlotsAllowedDays)));
      }
      final orderStatus = selectedPaymentMethod == "COD" ? "2" : "1";
      print(orderStatus);

      Map<String, String> params = {};
      params[ApiAndParams.productVariantId] =
          deliveryChargeData.productVariantId.toString();
      params[ApiAndParams.quantity] = deliveryChargeData.quantity.toString();

//TODO: Amount Data for Place Order
      params[ApiAndParams.total] =
          taxSubTotalAmount.toString(); // deliveryChargeData.subTotal.toString();
      params[ApiAndParams.deliveryCharge] = totalDeliveryCharges.toString();
      // deliveryChargeData.deliveryCharge.totalDeliveryCharge.toString();

      params[ApiAndParams.finalTotal] = Constant.isPromoCodeApplied
          ? ((
          // double.parse(deliveryChargeData.totalAmount)
          taxSubTotalAmount - Constant.discount)
          /*.getTotalWithGST() +
          deliveryCharge*/)
          .toString()
          : //double.parse(deliveryChargeData.totalAmount)
      (taxSubTotalAmount/*.getTotalWithGST() + deliveryCharge*/).toString();

      params[ApiAndParams.paymentMethod] = selectedPaymentMethod.toString();
      params[ApiAndParams.addressId] = selectedAddress!.id.toString();
      params[ApiAndParams.deliveryTime] =
      "${dateTime.day}-${dateTime.month}-${dateTime.year} ${timeSlotsData.timeSlots[selectedTime].title}";
      params[ApiAndParams.status] = orderStatus;
      params[ApiAndParams.discount] = Constant.discount.toString();
      params[ApiAndParams.order_from] = "1";
      print(params);

      Map<String, dynamic> getPlaceOrderResponse =
      (await getPlaceOrderApi(context: context, params: params));
      if (getPlaceOrderResponse[ApiAndParams.status].toString() == "1") {
        if (selectedPaymentMethod == "Razorpay" ||
            selectedPaymentMethod == "Stripe") {
          PlacedPrePaidOrder placedPrePaidOrder =
          PlacedPrePaidOrder.fromJson(getPlaceOrderResponse);
          placedOrderId = placedPrePaidOrder.data.orderId.toString();
        }
        if (selectedPaymentMethod == "Net Banking" ||
            selectedPaymentMethod == "Stripe") {
          PlacedPrePaidOrder placedPrePaidOrder =
          PlacedPrePaidOrder.fromJson(getPlaceOrderResponse);
          placedOrderId = placedPrePaidOrder.data.orderId.toString();
        }
        // if (selectedPaymentMethod == "paymentoption" ||
        //     selectedPaymentMethod == "Stripe") {
        //   PlacedPrePaidOrder placedPrePaidOrder =
        //   PlacedPrePaidOrder.fromJson(getPlaceOrderResponse);
        //   placedOrderId = placedPrePaidOrder.data.orderId.toString();
        // }
        //
        else if (selectedPaymentMethod == "Paystack") {
          payStackReference =
          "Charged_From_${GeneralMethods.setFirstLetterUppercase(Platform.operatingSystem)}_${DateTime.now().millisecondsSinceEpoch}";
          transactionId = payStackReference;
        } else if (selectedPaymentMethod == "COD") {
          print("enter orderplacescreen");
          _fbEventPurchaseSuccess(context, cartData);
          Navigator.pushNamedAndRemoveUntil(
            context,
            orderSuccessfullySummaryScreen, (route) => false,// Use the string route name here
          );

        } else if (selectedPaymentMethod == "Paytm") {
          PlacedPrePaidOrder placedPrePaidOrder =
          PlacedPrePaidOrder.fromJson(getPlaceOrderResponse);
          placedOrderId = placedPrePaidOrder.data.orderId.toString();
          initiatePaytmTransaction(context: context);
        } else if (selectedPaymentMethod == "Paypal") {
          PlacedPrePaidOrder placedPrePaidOrder =
          PlacedPrePaidOrder.fromJson(getPlaceOrderResponse);
          placedOrderId = placedPrePaidOrder.data.orderId.toString();
          initiatePaypalTransaction(context: context);
        }
      } else {
        GeneralMethods.showSnackBarMsg(
            context, getPlaceOrderResponse[ApiAndParams.message]);
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      GeneralMethods.showSnackBarMsg(context, message);
      checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
      notifyListeners();
    }
  }


  /// Phone Pay just enable this
  /*Future placeOrder(
      {required BuildContext context, required CartData cartData, required bool isPaymentUnderProcessing }) async {
    try {
      print("entered in place order");
      late DateTime dateTime;
      if (int.parse(timeSlotsData.timeSlotsDeliveryStartsFrom.toString()) ==
          1) {
        dateTime = DateTime.now();
      } else {
        dateTime = DateTime.now()
            .add(Duration(days: int.parse(timeSlotsData.timeSlotsAllowedDays)));
      }
      final orderStatus = selectedPaymentMethod == "COD" ? "2" : "1";
      print(orderStatus);

      Map<String, String> params = {};
      params[ApiAndParams.productVariantId] =
          deliveryChargeData.productVariantId.toString();
      params[ApiAndParams.quantity] = deliveryChargeData.quantity.toString();

//TODO: Amount Data for Place Order
      params[ApiAndParams.total] =
          taxSubTotalAmount.toString(); // deliveryChargeData.subTotal.toString();
      params[ApiAndParams.deliveryCharge] = totalDeliveryCharges.toString();
      // deliveryChargeData.deliveryCharge.totalDeliveryCharge.toString();

      if(selectedPaymentMethod == "COD"){
        params[ApiAndParams.finalTotal] = Constant.isPromoCodeApplied
            ? ((
            // double.parse(deliveryChargeData.totalAmount)
            taxSubTotalAmount - Constant.discount)
            *//*.getTotalWithGST()*//* +
            totalDeliveryCharges)
            .toString()
            : //double.parse(deliveryChargeData.totalAmount)
        (taxSubTotalAmount*//*.getTotalWithGST()*//* + totalDeliveryCharges).toString();
      }else{
        params[ApiAndParams.finalTotal] = Constant.isPromoCodeApplied
            ? ((
            // double.parse(deliveryChargeData.totalAmount)
            taxSubTotalAmount - Constant.discount)
            *//* .getTotalWithGST() +
          totalDeliveryCharges*//*)
            .toString()
            : //double.parse(deliveryChargeData.totalAmount)
        (taxSubTotalAmount*//*.getTotalWithGST() + totalDeliveryCharges*//*).toString();
      }

      params[ApiAndParams.paymentMethod] = selectedPaymentMethod.toString();
      params[ApiAndParams.addressId] = selectedAddress!.id.toString();
      params[ApiAndParams.deliveryTime] =
      "${dateTime.day}-${dateTime.month}-${dateTime.year} ${timeSlotsData.timeSlots[selectedTime].title}";
      params[ApiAndParams.status] = orderStatus;
      params[ApiAndParams.discount] = Constant.discount.toString();
      params[ApiAndParams.order_from] = "1";
      print(params);

      Map<String, dynamic> getPlaceOrderResponse =
      (await getPlaceOrderApi(context: context, params: params));
      if (getPlaceOrderResponse[ApiAndParams.status].toString() == "1") {
        if (selectedPaymentMethod == "Gpay/PhonePe/Paytm" ||
            selectedPaymentMethod == "Stripe") {
          PlacedPrePaidOrder placedPrePaidOrder =
          PlacedPrePaidOrder.fromJson(getPlaceOrderResponse);
          placedOrderId = placedPrePaidOrder.data.orderId.toString();
          initiateRazorpayTransaction(context: context, isPaymentUnderProcessing: isPaymentUnderProcessing);
        }
        if (selectedPaymentMethod == "Net Banking" ||
            selectedPaymentMethod == "Stripe") {
          PlacedPrePaidOrder placedPrePaidOrder =
          PlacedPrePaidOrder.fromJson(getPlaceOrderResponse);
          placedOrderId = placedPrePaidOrder.data.orderId.toString();
          initiateRazorpayTransaction(context: context, isPaymentUnderProcessing: isPaymentUnderProcessing);
        }
        if (selectedPaymentMethod == "Card Payment" ||
            selectedPaymentMethod == "Stripe") {
          PlacedPrePaidOrder placedPrePaidOrder =
          PlacedPrePaidOrder.fromJson(getPlaceOrderResponse);
          placedOrderId = placedPrePaidOrder.data.orderId.toString();
          initiateRazorpayTransaction(context: context, isPaymentUnderProcessing: isPaymentUnderProcessing);
        }

        else if (selectedPaymentMethod == "Paystack") {
          payStackReference =
          "Charged_From_${GeneralMethods.setFirstLetterUppercase(Platform.operatingSystem)}_${DateTime.now().millisecondsSinceEpoch}";
          transactionId = payStackReference;
        } else if (selectedPaymentMethod == "COD") {
          print("enter orderplacescreen");
          _fbEventPurchaseSuccess(context, cartData);
          Navigator.pushNamedAndRemoveUntil(
            context,
            orderSuccessfullySummaryScreen, (route) => false,// Use the string route name here
          );

        } *//*else if (selectedPaymentMethod == "Paytm") {
          PlacedPrePaidOrder placedPrePaidOrder =
          PlacedPrePaidOrder.fromJson(getPlaceOrderResponse);
          placedOrderId = placedPrePaidOrder.data.orderId.toString();
          initiatePaytmTransaction(context: context);
        } else if (selectedPaymentMethod == "Paypal") {
          PlacedPrePaidOrder placedPrePaidOrder =
          PlacedPrePaidOrder.fromJson(getPlaceOrderResponse);
          placedOrderId = placedPrePaidOrder.data.orderId.toString();
          initiatePaypalTransaction(context: context);
        }*//*
      } else {
        GeneralMethods.showSnackBarMsg(
            context, getPlaceOrderResponse[ApiAndParams.message]);
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      GeneralMethods.showSnackBarMsg(context, message);
      checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
      notifyListeners();
    }
  }*/

  Future initiatePaytmTransaction({required BuildContext context}) async {
    try {
      Map<String, String> params = {};

      params[ApiAndParams.orderId] = placedOrderId;
      params[ApiAndParams.amount] = totalAmount.getTotalWithGST().toString();

      Map<String, dynamic> getPaytmTransactionTokenResponse =
      (await getPaytmTransactionTokenApi(context: context, params: params));

      if (getPaytmTransactionTokenResponse[ApiAndParams.status].toString() ==
          "1") {
        PaytmTransactionToken paytmTransactionToken =
        PaytmTransactionToken.fromJson(getPaytmTransactionTokenResponse);
        paytmTxnToken = paytmTransactionToken.data?.txnToken ?? "";
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderLoaded;
        notifyListeners();
      } else {
        GeneralMethods.showSnackBarMsg(context, message);
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      GeneralMethods.showSnackBarMsg(context, message);
      checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
      notifyListeners();
    }
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

  Future<void> startTransaction(BuildContext context, bool isPaymentUnderProcessing) async {
    String body = getBody;
    String checksum = checkSum;
    String packageName = ''; // Replace with actual package name
    String callBackUrl = 'https://chhayakart.com/phonepe/verify.php'; // Replace with actual callback URL

    print("Body: $body");
    print("Checksum: $checksum");

    try {
      PhonePePaymentSdk.startTransaction(body, callBackUrl, checksum, packageName)
          .then((response) {
        if (response != null) {
          String status = response['status'].toString();
          String error = response['error'].toString();

          if (status == 'SUCCESS') {
            isPaymentUnderProcessing = false;
            storePromoUser();
            addTransaction(context: context);  // Add transaction logic
            print("Payment Successful");
            GeneralMethods.showSnackBarMsg(context, "Payment Successful");
            result = "Flow Completed - Status: Success!";
          } else {
            result = "Flow Error - Status: $status and Error: $error";
            GeneralMethods.showSnackBarMsg(context, "Payment failed: $error");
          }
        } else {
          result = "Flow Incomplete";
        }
        notifyListeners();
      }).catchError((error) {
        handleError(error);
        notifyListeners();
      });
    } catch (error) {
      handleError(error);
      notifyListeners();
    }
  }

  void handleError(dynamic error) {
    if (error is Exception) {
      result = error.toString();
    } else {
      result = "Error: $error";
    }
    notifyListeners();
  }



  Future initiateRazorpayTransaction({required BuildContext context, required bool isPaymentUnderProcessing}) async {
    try {
      Map<String, String> params = {};

      params[ApiAndParams.paymentMethod] = 'PhonePe'/*selectedPaymentMethod.toString()*/;
      params[ApiAndParams.orderId] = placedOrderId;

      Map<String, dynamic> getInitiatedTransactionResponse =
      (await getInitiatedTransactionApi(context: context, params: params));

      print("Get Value: $params");

      if (getInitiatedTransactionResponse[ApiAndParams.status].toString() ==
          "1") {
        InitiateTransaction initiateTransaction =
        InitiateTransaction.fromJson(getInitiatedTransactionResponse);
        razorpayOrderId = initiateTransaction.data.transactionId;
        getBody = initiateTransaction.data.paymentBody;
        checkSum = initiateTransaction.data.checkSum;
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderLoaded;
        await startTransaction(context, isPaymentUnderProcessing);
        print("Get Body: ${getBody.toString()}");
        print("Get CheckSum: ${checkSum.toString()}");
        print("Get Status: ${getInitiatedTransactionResponse[ApiAndParams.status].toString()}");
        print("Get Response: ${getInitiatedTransactionResponse.toString()}");
        notifyListeners();
      } else {
        GeneralMethods.showSnackBarMsg(context, message);
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      GeneralMethods.showSnackBarMsg(context, message);
      checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
      notifyListeners();
    }
  }

  Future initiatePaypalTransaction({required BuildContext context}) async {
    try {
      Map<String, String> params = {};

      params[ApiAndParams.paymentMethod] = selectedPaymentMethod.toString();
      params[ApiAndParams.orderId] = placedOrderId;

      Map<String, dynamic> getInitiatedTransactionResponse =
      (await getInitiatedTransactionApi(context: context, params: params));

      if (getInitiatedTransactionResponse[ApiAndParams.status].toString() ==
          "1") {
        Map<String, dynamic> data =
        getInitiatedTransactionResponse[ApiAndParams.data];
        Navigator.pushNamed(context, paypalPaymentScreen,
            arguments: data["paypal_redirect_url"])
            .then((value) {
          if (value == true) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              orderSuccessfullySummaryScreen, (route) => false,// Use the string route name here
            );
          } else {
            GeneralMethods.showSnackBarMsg(
              context,
              getTranslatedValue(context, "lblPaymentCancelledByUser"),
            );
          }
        });
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderLoaded;
        notifyListeners();
      } else {
        GeneralMethods.showSnackBarMsg(context, message);
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      GeneralMethods.showSnackBarMsg(context, message);
      checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
      notifyListeners();
    }
  }

  Future addTransaction({required BuildContext context}) async {
    print("ENTERED IN TRANSACTION");
    try {
      late PackageInfo packageInfo;
      packageInfo = await PackageInfo.fromPlatform();

      Map<String, String> params = {};

      params[ApiAndParams.orderId] = placedOrderId;
      params[ApiAndParams.deviceType] =
          GeneralMethods.setFirstLetterUppercase(Platform.operatingSystem);
      params[ApiAndParams.appVersion] = packageInfo.version;
      params[ApiAndParams.transactionId] = transactionId;
      params[ApiAndParams.paymentMethod] = "PhonePe";
      // if(selectedPaymentMethod.toString()=="Net Banking"){
      //   params[ApiAndParams.paymentMethod] = "Razorpay";
      // }else{
      //   params[ApiAndParams.paymentMethod] = selectedPaymentMethod.toString();
      // }

      print("LOG OF API");
      print(placedOrderId);
      print(GeneralMethods.setFirstLetterUppercase(Platform.operatingSystem)
          .toString());
      print(packageInfo.version.toString());
      print(transactionId);
      print(selectedPaymentMethod.toString());

      Map<String, dynamic> addedTransaction =
      (await getAddTransactionApi(context: context, params: params));
      print(addedTransaction[ApiAndParams.status].toString());
      if (addedTransaction[ApiAndParams.status].toString() == "1") {
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderLoaded;
        notifyListeners();
        Navigator.pushNamedAndRemoveUntil(
          context,
          orderSuccessfullySummaryScreen, (route) => false,// Use the string route name here
        );
      } else {
        print("IN PAYEMNT FAILED MESSAGE");
        GeneralMethods.showSnackBarMsg(
            context, addedTransaction[ApiAndParams.message]);
        checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      GeneralMethods.showSnackBarMsg(context, message);
      checkoutPlaceOrderState = CheckoutPlaceOrderState.placeOrderError;
      notifyListeners();
    }
  }

  void _fbEventPurchaseSuccess(BuildContext context, CartData cartData) {
    try {
      var cartTotal =
          context.read<CheckoutProvider>().taxSubTotalAmount/*.getTotalWithGST()*/ +
              context.read<CheckoutProvider>().totalDeliveryCharges;
      FacebookAnalytics.purchaseSuccess(
          amount: cartTotal,
          currency: 'INR',
          parameters: {
            'paymentMethod': selectedPaymentMethod,
            'numItems': cartData.data.cart.length,
            'items': cartData.data.cart
                .map((e) =>
            {'name': e.name, 'price': e.discountedPrice, 'qty': e.qty})
                .toList()
          });
    } catch (e) {}
  }
}