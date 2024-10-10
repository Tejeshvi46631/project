import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/material.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/model/order.dart';
import 'package:flutter/services.dart';
import 'package:easy_stepper/easy_stepper.dart';

class ShippedItemsDetails extends StatelessWidget {
  final Order order;
  final List<ShippedItem> shippedItems;

  const ShippedItemsDetails(
      {Key? key, required this.order, required this.shippedItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return order.shippedItems.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTranslatedValue(context, "Shipment Item"),
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
              Widgets.getSizedBox(height: 5),
              const SizedBox(height: 10),
              // Optimized Order Status Stepper using Easy Stepper
              _buildOrderStatusStepper(context),
              const SizedBox(height: 10),
              // Tracking number with copy icon
              _buildTrackingRow(context),
              const SizedBox(height: 10),
              // Shipped via with live tracking link
              _buildShippedViaRow(context),
              const SizedBox(height: 10),
              Column(
                children: order.shippedItems.first.order
                    .map((shippedItem) =>
                        _buildOrderItemCard(context, shippedItem))
                    .toList(),
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  // Optimized Easy Stepper widget
  Widget _buildOrderStatusStepper(BuildContext context) {
    final value = order.shippedItems.first.order.first.orderStatus!;

    return EasyStepper(
      activeStep: _getOrderStatusIndex(value),
      stepRadius: 25,
      showLoadingAnimation: false,
      borderThickness: 5.0,
      finishedStepBorderColor: Colors.grey,
      finishedStepTextColor: Colors.grey,
      finishedStepBackgroundColor: ColorsRes.bgColorLight,
      steps: [
        EasyStep(
          customStep: Icon(
            Icons.receipt_long,
            color: _getOrderStatusIndex(value) >= 0 ? ColorsRes.gradient2 : Colors.grey,
          ),
          title: getTranslatedValue(context, "Order \n Confirmed"),
        ),
        EasyStep(
          customStep: Icon(
            Icons.local_shipping,
            color: _getOrderStatusIndex(value) >= 1 ? ColorsRes.gradient2 : Colors.grey,
          ),
          title: getTranslatedValue(context, "Shipped"),
        ),
        EasyStep(
          customStep: Icon(
            Icons.delivery_dining,
            color: _getOrderStatusIndex(value) >= 2 ? ColorsRes.gradient2 : Colors.grey,
          ),
          title: getTranslatedValue(context, "Out for \n Delivery"),
        ),
        EasyStep(
          customStep: Icon(
            Icons.home,
            color: _getOrderStatusIndex(value) >= 3 ? ColorsRes.gradient2 : Colors.grey,
          ),
          title: getTranslatedValue(context, "Delivered"),
        ),
      ],
    );
  }

  // Helper method to map order status to step index
  int _getOrderStatusIndex(String status) {
    switch (status) {
      case 'Received':
        return 0;
      case 'Shipped':
        return 1;
      case 'Out for Delivery':
        return 2;
      case 'Delivered':
        return 3;
      default:
        return 0;
    }
  }

  // Optimized tracking number row with copy feature
  Widget _buildTrackingRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "${getTranslatedValue(context, "Tracking Number")}: ${order.shippedItems.first.trackingId}",
            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
          ),
        ),
        GestureDetector(
          onTap: () {
            Clipboard.setData(
                ClipboardData(text: order.shippedItems.first.trackingId));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text(getTranslatedValue(context, "Tracking number copied")),
            ));
          },
          child: const Icon(
            Icons.copy,
            color: Colors.blue,
            size: 18,
          ),
        ),
      ],
    );
  }

  // Optimized shipped via row with live tracking link
  Widget _buildShippedViaRow(BuildContext context) {
    final trackingUrl =
        'https://www.dtdc.in/tracking/tracking_results.asp?Ttype=awbno&strCnno=${order.shippedItems.first.orderSource}';

    return Row(
      children: [
        Expanded(
          child: Text(
            "${getTranslatedValue(context, "Shipped via")}: DTDC",
            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (order.shippedItems.first.orderSource.isNotEmpty) {
              launchUrl(trackingUrl);
            }
          },
          child: Row(
            children: const [
              Icon(Icons.track_changes, color: Colors.blue, size: 18),
              SizedBox(width: 5),
              Text(
                "Live Tracking",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Card widget for each shipped item
  Widget _buildOrderItemCard(BuildContext context, OrderItem shippedItem) {
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
                shippedItem.product?.imageUrl ?? '',
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
                    shippedItem.productName ?? '',
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${getTranslatedValue(context, "lblSize")}: ${shippedItem.unit?.name}",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                      color: ColorsRes.subTitleMainTextColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${getTranslatedValue(context, "lblQuantity")}: ${shippedItem.quantity}",
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
      ),
    );
  }

  // Method to launch URL (you may need to add the url_launcher package)
  void launchUrl(String url) {
    print("Launching URL: $url");
    // Implement URL launcher here, e.g., with url_launcher package
  }
}
