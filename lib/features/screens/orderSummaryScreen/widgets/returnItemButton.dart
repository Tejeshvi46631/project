import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/order.dart';
import 'package:egrocer/core/provider/updateOrderStatusProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/features/screens/orderSummaryScreen/widgets/returnProductDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OSReturnIremButton extends StatefulWidget {
  final OrderItem orderItem;
  final Order order;
  final List<OrderItem> orderItems;

  const OSReturnIremButton(
      {super.key,
      required this.orderItem,
      required this.order,
      required this.orderItems});

  @override
  State<OSReturnIremButton> createState() => _OSReturnIremButtonState();
}

class _OSReturnIremButtonState extends State<OSReturnIremButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) =>
                ChangeNotifierProvider<UpdateOrderStatusProvider>(
                  create: (context) => UpdateOrderStatusProvider(),
                  child: ReturnProductDialog(
                      orderId: widget.order.id.toString(),
                      orderItemId: widget.orderItem.id.toString()),
                )).then((value) {
          //If we get true as value means we need to update this product's status to 8
          if (value != null) {
            if (value) {
              final orderItemIndex = widget.orderItems
                  .indexWhere((element) => element.id == widget.orderItem.id);

              //Update order items
              if (orderItemIndex != -1) {
                widget.orderItems[orderItemIndex] = widget.orderItem
                    .updateStatus(
                        Constant.orderStatusCode[7]); //Returned status

                setState(() {});
              }
            } else {
              GeneralMethods.showSnackBarMsg(
                  context,
                  getTranslatedValue(
                    context,
                    "lblUnableToReturnProduct",
                  ));
            }
          }
        });
      },
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.transparent)),
        child: Text(
          getTranslatedValue(
            context,
            "lblReturn",
          ),
          softWrap: true,
          style: TextStyle(color: ColorsRes.appColorRed),
        ),
      ),
    );
  }
}
