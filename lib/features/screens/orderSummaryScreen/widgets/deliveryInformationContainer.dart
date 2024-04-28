import 'package:egrocer/core/model/order.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/material.dart';

class DeliveryInformationContainer extends StatelessWidget {
  final Order order;

  const DeliveryInformationContainer({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              getTranslatedValue(
                context,
                "lblDeliveryInformation",
              ),
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslatedValue(
                    context,
                    "lblDeliverTo",
                  ),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 2.5,
                ),
                Text(
                  order.address,
                  style: TextStyle(
                      color: ColorsRes.subTitleMainTextColor, fontSize: 13.0),
                ),
                Text(
                  order.mobile,
                  style: TextStyle(
                      color: ColorsRes.subTitleMainTextColor, fontSize: 12.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
