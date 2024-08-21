import 'package:flutter/material.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/features/screens/orderSummaryScreen/widgets/orderItemContainer.dart';
import 'package:egrocer/core/model/order.dart';

import '../../../../core/widgets/generalMethods.dart';

class OrderItemsDetails extends StatelessWidget {
  final Order order;
  final List<OrderItem> orderItems;

  const OrderItemsDetails({Key? key, required this.order, required this.orderItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslatedValue(
            context,
            "lblItems",
          ),
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
        Widgets.getSizedBox(
          height: 5,
        ),
        Column(
          children: order.items
              .map((orderItem) => _buildOrderItemCard(context, orderItem))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildOrderItemCard(BuildContext context, OrderItem orderItem) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                orderItem.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderItem.productName,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${getTranslatedValue(context, "lblQuantity")}: ${orderItem.quantity}",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                      color: ColorsRes.subTitleMainTextColor,
                    ),
                  ),
                 /* const SizedBox(height: 5),
                  Text(
                    "${getTranslatedValue(context, "lblSize")}: ${orderItem.price}",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                      color: ColorsRes.subTitleMainTextColor,
                    ),
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
