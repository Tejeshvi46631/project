import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/order.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:intl/intl.dart';

import '../../../../core/constant/routeGenerator.dart';
import '../../../../core/model/productListItem.dart';

class BillDetails extends StatelessWidget {
  final Order order;
  final List<ProductListItem> shopByReaginProduct;
  final List<ProductListItem?> listSimilarProductListItem;

  const BillDetails(
      {super.key,
      required this.order,
      required this.shopByReaginProduct,
      required this.listSimilarProductListItem});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.only(bottom: 10, top: 10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                getTranslatedValue(
                  context,
                  "lblBillingDetails",
                ),
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        getTranslatedValue(
                          context,
                          "lblPaymentMethod",
                        ),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text(order.paymentMethod),
                    ],
                  ),
                  SizedBox(
                    height: Constant.size10,
                  ),
                  order.transactionId.isEmpty
                      ? const SizedBox()
                      : Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  getTranslatedValue(
                                    context,
                                    "lblTransactionId",
                                  ),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                const Spacer(),
                                Text(
                                  order.transactionId,
                                ),
                              ],
                            ),
                          ],
                        ),

                  /* Row(
                  children: [
                    Text(
                      getTranslatedValue(
                        context,
                        "lblDeliveryCharge",
                      ),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Text(
                      getCurrencyFormatdouble(order.deliveryCharge),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorsRes.appColor,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Text(
                      getTranslatedValue(
                        context,
                        "lblGST",
                      ),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Text(
                      getCurrencyFormatdouble(order.taxAmount),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorsRes.appColor,
                      ),
                    ),
                  ],
                ),*/
                  Row(
                    children: [
                      Text(
                        getTranslatedValue(
                          context,
                          "lblTotal",
                        ),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                     /* Text(
                        order.items.isNotEmpty
                            ? getCurrencyFormatdouble(order.items.first.subTotal.toString()).toString()
                            : getCurrencyFormatdouble(order.shippedItems.first.order.first.subTotal.toString()).toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: ColorsRes.appColor,
                        ),
                      ),*/
                      Text(
                        // Conditional logic for COD or other payment methods
                        order.paymentMethod == "COD"
                            ? getSubTotal(order, addCODCharge: true)
                            : getSubTotal(order),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: ColorsRes.appColor,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10), // Spacer between bill details and button
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    mainHomeScreen,
                  );
                },
                child: Text(
                  'Buy More Product',
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorsRes.appColorWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

/*String getSubTotal(Order order) {
  // Determine if items or shippedItems should be used
  String subTotal = order.items.isNotEmpty
      ? order.items.first.subTotal.toString()
      : order.shippedItems.first.order.first.subTotal.toString();

  // Format the subtotal with currency
  return getCurrencyFormatdouble(subTotal, "").toString();
}*/

String getSubTotal(Order order, {bool addCODCharge = false}) {
  // Determine if items or shippedItems should be used
  String subTotal = order.items.isNotEmpty
      ? order.items.first.subTotal.toString()
      : order.shippedItems.first.order.first.subTotal.toString();

  // Convert the subtotal to double and optionally add 46 for COD
  var total = getCurrencyFormatdouble(subTotal, "").toString();
  if (addCODCharge) {
    total = getCurrencyFormatdouble(subTotal, "46").toString();
  }

  return total.toString();
}

String getCurrencyFormatdouble(String amount1String, String amount2String) {
  // Parse both strings to doubles
  double amount1 = double.tryParse(amount1String) ?? 0.0;
  double amount2 = double.tryParse(amount2String) ?? 0.0;

  // Add the two amounts together
  double totalAmount = amount1 + amount2;

  // Parse decimal points from String to int
  int decimalDigits = int.tryParse(Constant.decimalPoints) ?? 2;

  // Format the total amount using NumberFormat.currency
  return NumberFormat.currency(
    symbol: Constant.currency,
    decimalDigits: decimalDigits,
    name: Constant.currencyCode,
  ).format(totalAmount);
}
/*String getCurrencyFormatdouble(String amount1String) {
  // Parse both strings to doubles
  double amount1 = double.tryParse(amount1String) ?? 0.0;

  // Add the two amounts together
  double totalAmount = amount1;

  // Parse decimal points from String to int
  int decimalDigits = int.tryParse(Constant.decimalPoints) ?? 2;

  // Format the total amount using NumberFormat.currency
  return NumberFormat.currency(
    symbol: Constant.currency,
    decimalDigits: decimalDigits,
    name: Constant.currencyCode,
  ).format(totalAmount);
}*/

