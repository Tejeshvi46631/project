import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/provider/updateOrderStatusProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/customCircularProgressIndicator.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CancelOrderDialog extends StatelessWidget {
  final String orderId;
  final String orderItemId;

  const CancelOrderDialog({
    required this.orderId,
    required this.orderItemId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (context.read<UpdateOrderStatusProvider>().getUpdateOrderStatus() ==
            UpdateOrderStatus.inProgress) {
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: AlertDialog(
        title: Text(
          getTranslatedValue(
            context,
            "lblSureToCancelOrder",
          ),
        ),
        actions: [
          Consumer<UpdateOrderStatusProvider>(builder: (context, provider, _) {
            if (provider.getUpdateOrderStatus() ==
                UpdateOrderStatus.inProgress) {
              return const Center(
                child: CustomCircularProgressIndicator(),
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    getTranslatedValue(
                      context,
                      "lblNo",
                    ),
                    style: TextStyle(color: ColorsRes.mainTextColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<UpdateOrderStatusProvider>().updateStatus(
                        orderId: orderId,
                        orderItemId: orderItemId,
                        status: Constant.orderStatusCode[7],
                        //7 is for cancelled
                        callBack: () {
                          Navigator.of(context).pop(true);
                        },
                        context: context);
                  },
                  child: Text(
                    getTranslatedValue(
                      context,
                      "lblYes",
                    ),
                    style: TextStyle(color: ColorsRes.appColor),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
