import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/model/order.dart';
import 'package:egrocer/core/provider/activeOrdersProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/material.dart';
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
    return Column(
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
                  widget.order.activeStatus == "1"
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
                  ) : GestureDetector(
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
                    child: Container(
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
                    ),
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
              Text(
                GeneralMethods.getCurrencyFormat(
                    double.parse(widget.order.finalTotal)),
                style: const TextStyle(fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ],
    );
  }

  String getOrderedItemNames(List<OrderItem> orderItems) {
    String itemNames = "";
    for (var i = 0; i < orderItems.length; i++) {
      if (i == orderItems.length - 1) {
        itemNames = itemNames + orderItems[i].productName;
      } else {
        itemNames = "${orderItems[i].productName}, ";
      }
    }
    return itemNames;
  }



}
