import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/order.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/orderSummaryScreen/widgets/cancelItemButton.dart';
import 'package:egrocer/features/screens/orderSummaryScreen/widgets/cancelOrderButton.dart';
import 'package:egrocer/features/screens/orderSummaryScreen/widgets/returnItemButton.dart';
import 'package:flutter/material.dart';

class OSOrderItemContainer extends StatelessWidget {
  final OrderItem orderItem;
  final Order order;
  final List<OrderItem> orderItems;

  const OSOrderItemContainer(
      {super.key,
      required this.orderItem,
      required this.order,
      required this.orderItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor),
      child: LayoutBuilder(builder: (context, boxConstraints) {
        return Column(
          children: [
            Row(
              children: [
                ClipRRect(
                    borderRadius: Constant.borderRadius10,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Widgets.setNetworkImg(
                      boxFit: BoxFit.fill,
                      image: orderItem.imageUrl ?? "",
                      width: boxConstraints.maxWidth * (0.25),
                      height: boxConstraints.maxWidth * (0.25),
                    )),
                SizedBox(
                  width: boxConstraints.maxWidth * (0.05),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderItem.productName ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "x ${orderItem.quantity}",
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                     /* Text(
                        "${orderItem.measurement} ${orderItem.unit}",
                        style:
                            TextStyle(color: ColorsRes.subTitleMainTextColor),
                      ),*/
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        GeneralMethods.getCurrencyFormat(
                            double.parse(orderItem.price.toString())),
                        style: TextStyle(
                            color: ColorsRes.appColor,
                            fontWeight: FontWeight.w500),
                      ),
                      orderItem.cancelStatus == Constant.orderStatusCode[6]
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                OSCancelItemButton(
                                    order: order,
                                    orderItem: orderItem,
                                    orderItems: orderItems),
                              ],
                            )
                          : const SizedBox(),
                      orderItem.returnStatus == Constant.orderStatusCode[7]
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                OSReturnIremButton(
                                    order: order,
                                    orderItem: orderItem,
                                    orderItems: orderItems),
                              ],
                            )
                          : const SizedBox(),
                      (orderItem.activeStatus == Constant.orderStatusCode[6] ||
                              orderItem.activeStatus ==
                                  Constant.orderStatusCode[7])
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  Constant.getOrderActiveStatusLabelFromCode(
                                      orderItem.activeStatus ?? ''),
                                  style:
                                      TextStyle(color: ColorsRes.appColorRed),
                                )
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
            if (_showCancelOrderButton(order) &&
                _showReturnOrderButton(order) &&
                orderItem.activeStatus != "7" &&
                orderItem.activeStatus != "8")
              const Divider(),
            if (orderItem.activeStatus != "7" && orderItem.activeStatus != "8")
              LayoutBuilder(
                builder: (context, boxConstraints) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _showCancelOrderButton(order)
                          ? OSCancelOrderButton(
                              order: order,
                              orderItemId: orderItem.id.toString(),
                              width: boxConstraints.maxWidth * (0.5),
                            )
                          : SizedBox() /* (_showReturnOrderButton(widget.order)
                              ? _buildReturnOrderButton(
                                  order: widget.order,
                                  orderItemId: orderItem.id,
                                  width: boxConstraints.maxWidth * (0.5),
                                )
                              : const SizedBox()) */
                      ,
                    ],
                  );
                },
              ),
          ],
        );
      }),
    );
  }

  bool _showCancelOrderButton(Order order) {
    bool cancelOrder = true;

    for (var orderItem in order.items) {
      if (orderItem.cancelStatus == "0") {
        cancelOrder = false;
        break;
      }
    }

    return cancelOrder;
  }

  bool _showReturnOrderButton(Order order) {
    bool returnOrder = true;

    for (var orderItem in order.items) {
      if (orderItem.returnStatus == "0") {
        returnOrder = false;
        break;
      }
    }

    return returnOrder;
  }
}
