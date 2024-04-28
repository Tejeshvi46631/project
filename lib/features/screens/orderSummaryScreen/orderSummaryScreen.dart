import 'dart:io' as io;
import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/order.dart';
import 'package:egrocer/core/provider/orderInvoiceProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/orderSummaryScreen/ui/stack.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class OrderSummaryScreen extends StatefulWidget {
  final Order order;

  const OrderSummaryScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  late final List<OrderItem> _orderItems = widget.order.items;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context)
            .pop(widget.order.copyWith(orderItems: _orderItems));
        return Future.value(false);
      },
      child: Scaffold(
        appBar: getAppBar(
            context: context,
            title: Text(
              getTranslatedValue(
                context,
                "lblOrderSummary",
              ),
             // style: TextStyle(color: ColorsRes.mainTextColor),
            ),
            showBackButton: false),
        body: OSStackWidget(order: widget.order,orderItems: _orderItems,)
      ),
    );
  }
}
