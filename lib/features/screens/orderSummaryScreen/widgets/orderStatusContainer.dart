import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/order.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/trackMyOrderButton.dart';
import 'package:flutter/material.dart';

class OSOrderStatusContainer extends StatelessWidget {
  final Order order;

  const OSOrderStatusContainer({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    String getStatusCompleteDate(int currentStatus) {
      if (order.status.isNotEmpty) {
        final statusValue = order.status.where((element) {
          return element.first.toString() == currentStatus.toString();
        }).toList();

        if (statusValue.isNotEmpty) {
          //[2, 04-10-2022 06:13:45am] so fetching last value
          return statusValue.first.last;
        }
      }

      return "";
    }

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
            child: Row(
              children: [
                Text(
                  getTranslatedValue(
                    context,
                    "lblOrder",
                  ),
                  softWrap: true,
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Text(
                  "#${order.id}",
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                order.activeStatus.isEmpty
                    ? const SizedBox()
                    : Text(Constant.getOrderActiveStatusLabelFromCode(
                        order.activeStatus)),
                const SizedBox(
                  height: 5,
                ),
                order.activeStatus.isEmpty
                    ? const SizedBox()
                    : Text(
                        getStatusCompleteDate(int.parse(order.activeStatus)),
                        style: TextStyle(
                            color: ColorsRes.subTitleMainTextColor,
                            fontSize: 12.5),
                      ),
              ],
            ),
          ),
          const Divider(),
          Center(
            child: LayoutBuilder(builder: (context, boxConstraints) {
              return TrackMyOrderButton(
                status: order.status,
                width: boxConstraints.maxWidth * (0.5),
                orderID: order.items.first.tracking_id,
              );
            }),
          )
        ],
      ),
    );
  }
}
