import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PhonePayScreen extends StatefulWidget {
  const PhonePayScreen({super.key});

  @override
  State<PhonePayScreen> createState() => _PhonePayScreenState();
}

class _PhonePayScreenState extends State<PhonePayScreen> {
  String environmentValue = "SANDBOX";
  String appId = "";
  String merchantId = "PGTESTPAYUAT";
  bool enableLogging = false;

  String checksum = "";
  String saltKey = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";
  String saltIndex = "1";
  String callBackUrl =
      "https://webhook.site/4acffbfd-32d1-49aa-bd1c-41fb670de9a2";
  String body = "";
  Object? result;
  String apiEndPoint = "/pg/v1/pay";

  @override
  void initState() {
    phonePayInit();
    body = getCheckSum().toString();
    super.initState();
  }

  getCheckSum() {
    final requestData = {
      "merchantId": merchantId,
      "merchantTransactionId": "MT7850590068188104",
      "merchantUserId": "MUID123",
      "amount": 10000,
      "callbackUrl": callBackUrl,
      "mobileNumber": "9999999999",
      "paymentInstrument": {"type": "PAY_PAGE"}
    };

    String base64Body = base64.encode(utf8.encode(json.encode(requestData).toString()));
    checksum = '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltKey))}###$saltIndex';

    return base64Body;
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  void startPgTransactions() async {
    PhonePePaymentSdk.startTransaction(body, callBackUrl, checksum, "")
        .then((response) => {
              setState(() {
                if (response != null) {
                  String status = response['status'].toString();
                  String error = response['error'].toString();
                  if (status == 'SUCCESS') {
                    // "Flow Completed - Status: Success!";
                  } else {
                    "Flow Completed - Status: $status and Error: $error";
                  }
                } else {
                  // "Flow Incomplete";
                }
              })
            })
        .catchError((error) {
      // handleError(error)
      return <dynamic>{};
    });
  }

  void phonePayInit() {
    PhonePePaymentSdk.init(environmentValue, appId, merchantId, enableLogging)
        .then((val) => {
              setState(() {
                result = 'PhonePe SDK Initialized - $val';
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void handleError(error) {
    setState(() {
      result = {"error": error};
    });
  }
}
