import 'package:egrocer/core/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayPalPaymentScreen extends StatefulWidget {
  final String paymentUrl;

  const PayPalPaymentScreen({Key? key, required this.paymentUrl})
      : super(key: key);

  @override
  State<PayPalPaymentScreen> createState() => _PayPalPaymentScreenState();
}

class _PayPalPaymentScreenState extends State<PayPalPaymentScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          Navigator.pop(context, false);
          return Future.value(false);
        },
        child: WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(Theme.of(context).scaffoldBackgroundColor)
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {
                  // Update loading bar.
                },
                onPageStarted: (String url) {
                  print("start URL $url");
                },
                onPageFinished: (String url) {
                  print("finish URL $url");
                },
                onWebResourceError: (WebResourceError error) {},
                onNavigationRequest: (NavigationRequest request) {
                  //Paypal success redirect url - Constant.baseUrl/customer/paypal_redirect/success
                  //Paypal fail redirect url - Constant.baseUrl/customer/paypal_redirect/fail
                  print("navigation URL ${request.url}");

                  if (request.url.startsWith(Constant.baseUrl)) {
                    String redirectUrl = request.url.split("?")[0];
                    String paymentStatus = redirectUrl.split("/").last;
                    if (paymentStatus.toLowerCase() == "success") {
                      Navigator.pop(context, true);
                      return NavigationDecision.prevent;
                    } else if (paymentStatus.toLowerCase() == "fail") {
                      Navigator.pop(context, false);
                      return NavigationDecision.navigate;
                    }
                  }
                  return NavigationDecision.navigate;
                },
              ),
            )
            ..loadRequest(
              Uri.parse(
                widget.paymentUrl.toString(),
              ),
            ),
        ),
      ),
    );
  }
}
