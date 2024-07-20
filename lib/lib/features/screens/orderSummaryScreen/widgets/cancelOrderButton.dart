import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/order.dart';
import 'package:egrocer/core/provider/activeOrdersProvider.dart';
import 'package:egrocer/core/provider/updateOrderStatusProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/features/screens/home/ordersHistoryScreen/widgets/cancelOrderDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OSCancelOrderButton extends StatefulWidget {
  final Order order;
  final String orderItemId;
  final double width;

  const OSCancelOrderButton({
    super.key,
    required this.order,
    required this.orderItemId,
    required this.width
  });

  @override
  State<OSCancelOrderButton> createState() => _OSCancelOrderButtonState();
}

class _OSCancelOrderButtonState extends State<OSCancelOrderButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) =>
                ChangeNotifierProvider<UpdateOrderStatusProvider>(
                  create: (context) => UpdateOrderStatusProvider(),
                  child: CancelOrderDialog(
                      orderId: widget.order.id.toString(),
                      orderItemId: widget.orderItemId),
                )).then((value) {
          if (value != null) {
            //
            if (value) {
              //
              //change order status to cancelled and also all it's products
              List<OrderItem> orderItems = List.from(widget.order.items);

              for (var i = 0; i < widget.order.items.length; i++) {
                orderItems[i] = widget.order.items[i]
                    .updateStatus(Constant.orderStatusCode[6]); //Cancelled
              }

              context.read<ActiveOrdersProvider>().updateOrder(widget.order
                  .copyWith(
                      orderItems: orderItems,
                      updatedActiveStatus:
                          Constant.orderStatusCode[6] //Cancelled
                      ));
            } else {
              GeneralMethods.showSnackBarMsg(
                  context,
                  getTranslatedValue(
                    context,
                    "lblUnableToCancelOrder",
                  ));
            }
          }
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: widget.width,
        child: Text(
          getTranslatedValue(
            context,
            "lblCancel",
          ),
          style: TextStyle(color: ColorsRes.appColor),
        ),
      ),
    );
  }
}
