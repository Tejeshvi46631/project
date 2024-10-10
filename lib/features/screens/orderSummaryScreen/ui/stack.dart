import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/order.dart';
import 'package:egrocer/core/provider/orderInvoiceProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/orderSummaryScreen/widgets/ShippedItemsDetails.dart';
import 'package:egrocer/features/screens/orderSummaryScreen/widgets/billDetails.dart';
import 'package:egrocer/features/screens/orderSummaryScreen/widgets/deliveryInformationContainer.dart';
import 'package:egrocer/features/screens/orderSummaryScreen/widgets/orderItemContainer.dart';
import 'package:egrocer/features/screens/orderSummaryScreen/widgets/orderStatusContainer.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io' as io;

import '../widgets/OrderItemsDetails.dart';

class OSStackWidget extends StatefulWidget {
  final Order order;
  final List<ShippedItem> shippedItems;
  final List<OrderItem> orderItems;

  const OSStackWidget(
      {super.key, required this.order, required this.orderItems, required this.shippedItems});

  @override
  State<OSStackWidget> createState() => _OSStackWidgetState();
}

class _OSStackWidgetState extends State<OSStackWidget> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PositionedDirectional(
          start: 0,
          end: 0,
          top: 0,
          bottom: 0,
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.only(
                top: Constant.size10,
                start: Constant.size10,
                end: Constant.size10,
                bottom: Constant.size65),
            child: Column(
              children: [
                OSOrderStatusContainer(order: widget.order),
                ShippedItemsDetails(order: widget.order, shippedItems: widget.shippedItems),
                OrderItemsDetails(order: widget.order, orderItems: widget.orderItems),
                DeliveryInformationContainer(order: widget.order),
                BillDetails(order: widget.order, shopByReaginProduct: [], listSimilarProductListItem: [],)
                
              ],
            ),
          ),
        ),
        // PositionedDirectional(
        //   bottom: 90,
        //   start: 20,
        //   end: 10,
        //   child: Consumer<OrderInvoiceProvider>(
        //     builder: (context, orderInvoiceProvider, child) {
        //       return Widgets.gradientBtnWidget(
        //         context,
        //         10,
        //         callback: () {
        //           orderInvoiceProvider.getOrderInvoiceApiProvider(
        //             params: {ApiAndParams.orderId: widget.order.id.toString()},
        //             context: context,
        //           ).then(
        //             (htmlContent) async {
        //               try {
        //                 if (htmlContent != null) {
        //                   final appDocDirPath = io.Platform.isAndroid
        //                       ? (await ExternalPath
        //                           .getExternalStoragePublicDirectory(
        //                               ExternalPath.DIRECTORY_DOWNLOADS))
        //                       : (await getApplicationDocumentsDirectory()).path;
        //
        //                   final targetFileName =
        //                       "${getTranslatedValue(context, "lblAppName")}-${getTranslatedValue(context, "lblInvoice")}#${widget.order.id.toString()}.pdf";
        //
        //                   io.File file =
        //                       io.File("$appDocDirPath/$targetFileName");
        //
        //                   // Write down the file as bytes from the bytes got from the HTTP request.
        //                   await file.writeAsBytes(htmlContent, flush: false);
        //                   await file.writeAsBytes(htmlContent);
        //
        //                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //                     action: SnackBarAction(
        //                       label: getTranslatedValue(context, "lblShowFile"),
        //                       onPressed: () {
        //                         OpenFilex.open(file.path);
        //                       },
        //                     ),
        //                     content: Text(
        //                       getTranslatedValue(
        //                           context, "lblFileSavedSuccessfully"),
        //                       softWrap: true,
        //                       style: TextStyle(color: ColorsRes.mainTextColor),
        //                     ),
        //                     duration: const Duration(seconds: 5),
        //                     backgroundColor:
        //                         Theme.of(context).scaffoldBackgroundColor,
        //                   ));
        //                 }
        //               } catch (_) {}
        //             },
        //           );
        //         },
        //         otherWidgets: orderInvoiceProvider.orderInvoiceState ==
        //                 OrderInvoiceState.loading
        //             ? Center(
        //                 child: CircularProgressIndicator(
        //                   color: ColorsRes.appColorWhite,
        //                 ),
        //               )
        //             : Text(
        //                 getTranslatedValue(context, "lblGetInvoice"),
        //                 softWrap: true,
        //                 style: Theme.of(context).textTheme.titleMedium!.merge(
        //                       TextStyle(
        //                         color: ColorsRes.appColorWhite,
        //                         letterSpacing: 0.5,
        //                         fontWeight: FontWeight.w500,
        //                       ),
        //                     ),
        //               ),
        //         isSetShadow: false,
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }

  Widget _buildOrderItemsDetails() {
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
          children: widget.order.items
              .map((orderItem) => OSOrderItemContainer(
                  orderItem: orderItem,
                  order: widget.order,
                  orderItems: widget.orderItems))
              .toList(),
        )
      ],
    );
  }
}
