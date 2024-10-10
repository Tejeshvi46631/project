import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/model/order.dart';
import 'package:egrocer/core/provider/activeOrdersProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderDetailContainer extends StatefulWidget {
  Order order;
  OrderDetailContainer({super.key,required this.order});

  @override
  State<OrderDetailContainer> createState() => _OrderDetailContainerState();
}

class _OrderDetailContainerState extends State<OrderDetailContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
      widget.order.transactionId == 0 ? null :
      Navigator.pushNamed(context, orderDetailScreen,
          arguments: widget.order)
          .then((value) {
        if (value != null) {
          context
              .read<ActiveOrdersProvider>()
              .updateOrder(value as Order);
        }
      });
    },
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Constant.size10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "${getTranslatedValue(
                      context,
                      "lblOrder",
                    )} ${widget.order.id}",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  /*widget.order.orderStatus == "Cancelled"
                      ? RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${widget.order.items.length} items \n",
                          style: TextStyle(color: Colors.black), // Style for the item count text
                        ),
                        TextSpan(
                          text: "Cancelled",
                          style: TextStyle(color: Colors.red), // Style for the "Cancelled" text
                        ),
                      ],
                    ),
                  ) : */ Column(
                      children: [
                       /* Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent)),
                          padding: const EdgeInsets.symmetric(vertical: 2.5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                getTranslatedValue(
                                  context,
                                  "lblViewDetails",
                                ),
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: ColorsRes.subTitleMainTextColor),
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 12.0,
                                color: ColorsRes.subTitleMainTextColor,
                              )
                            ],
                          ),
                        ),*/
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${widget.order.itemsCount} items \n",
                                  style: TextStyle(color: Colors.black), // Style for the item count text
                                ),
                                TextSpan(
                                  text: widget.order.orderStatus,
                                  style: widget.order.orderStatus == 'Cancelled' ? TextStyle(color: ColorsRes.gradient2) : TextStyle(color: ColorsRes.appColorGreen), // Style for the "Cancelled" text
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const Divider(),
              Text(
                "${getTranslatedValue(
                  context,
                  "lblPlacedOrderOn",
                )} ${GeneralMethods.formatDate(DateTime.parse(widget.order.createdAt))}",
                style: TextStyle(
                    fontSize: 12.5, color: ColorsRes.subTitleMainTextColor),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                getOrderedItemNames(widget.order.items),
                style: const TextStyle(fontSize: 12.5),
              ),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Text(
                getTranslatedValue(
                  context,
                  "lblTotal",
                ),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              /*Text(
                GeneralMethods.getCurrencyFormat(
                    double.parse((widget.order.items.isNotEmpty
                        ? widget.order.items.first.subTotal
                        : widget.order.shippedItems.first.order.first.subTotal // fallback to shipped items
                    ).toString(),)),
                style: const TextStyle(fontWeight: FontWeight.w500),
              )*/
              Text(
                // Conditional logic for COD or other payment methods
                widget.order.paymentMethod == "COD"
                    ? getSubTotal(widget.order, addCODCharge: true)
                    : getSubTotal(widget.order),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: ColorsRes.appColor,
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }

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

  String getOrderedItemNames(List<OrderItem> orderItems) {
    String itemNames = "";
    for (var i = 0; i < orderItems.length; i++) {
      if (i == orderItems.length - 1) {
        itemNames = itemNames + orderItems[i].productName!;
      } else {
        itemNames = "${orderItems[i].productName}, ";
      }
    }
    return itemNames;
  }



}
