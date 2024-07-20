

import 'package:egrocer/core/model/order.dart';

import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/home/homeScreen/mainHomeScreen.dart';
import 'package:egrocer/features/screens/orderSummaryScreen/ui/stack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constant/routeGenerator.dart';
import '../../../core/provider/activeOrdersProvider.dart';
import '../../../core/utils/styles/colorsRes.dart';


class OrderSummaryScreen extends StatefulWidget {
  final Order order;

  const OrderSummaryScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  late List<OrderItem> _orderItems = [];
   late Order order;
  @override
  void initState() {
    super.initState();
    _fetchOrderData();
  }
  void _fetchOrderData() async {
    // Simulate fetching order data from some source
    Future.delayed(Duration.zero, () {
      context.read<ActiveOrdersProvider>().getOrders(params: {}, context: context).then((_) {
        final provider = context.read<ActiveOrdersProvider>();
        if (provider.orders.isNotEmpty) {
          order = provider.orders.first;
          //_navigateToOrderSummary(provider.orders.first);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return

    Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(getTranslatedValue(
              context,
              "lblOrderSummary",

            ),
              style: TextStyle(
                color: Colors.white,

              ),            ),
          ),
            backgroundColor:  ColorsRes.gradient2,
        ),
        body: OSStackWidget(order: widget.order,orderItems: _orderItems,)
      );
    // );
  }
}
