

import 'package:egrocer/core/model/order.dart';

import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/home/homeScreen/mainHomeScreen.dart';
import 'package:egrocer/features/screens/orderSummaryScreen/ui/stack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constant/routeGenerator.dart';
import '../../../../core/provider/activeOrdersProvider.dart';



class OrdersucessfullySummaryScreen extends StatefulWidget {


  const OrdersucessfullySummaryScreen({Key? key}) : super(key: key);

  @override
  State<OrdersucessfullySummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrdersucessfullySummaryScreen> {

  @override
  void dispose() {
    // Clean up resources here
    super.dispose();
  }
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
          _navigateToOrderSummary(provider.orders.first);
        }
      });
    });
  }
  void _navigateToOrderSummary(Order order) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      orderDetailScreen,
      arguments: order,
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: Text(
          getTranslatedValue(
            context,
            "lblOrderSummary",
          ),
        ),

      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }


}
