import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/material.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/model/order.dart';


class OrderItemsDetails extends StatelessWidget {
  final Order order;
  final List<OrderItem> orderItems;

  const OrderItemsDetails({Key? key, required this.order, required this.orderItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return order.items.isNotEmpty ? Column(
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
    ) : SizedBox.shrink();
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
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    orderItem.product?.imageUrl ?? '',
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
                        orderItem.productName ?? '',
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${getTranslatedValue(context, "lblSize")}: ${orderItem.unit?.name}",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: ColorsRes.subTitleMainTextColor,
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

                    ],
                  ),
                ),
              ],
            ),
            // Check if the order status is "pending" and display a message
            if (order.items.first.orderStatus == 'Received') ...[
              Card(
                color: Colors.amberAccent,
                margin: const EdgeInsets.symmetric(vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.info_outline, color: Colors.orange),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          getTranslatedValue(context, "Items are yet to be dispatched."), // Assuming you have this key in your localization
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: ColorsRes.subTitleMainTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
