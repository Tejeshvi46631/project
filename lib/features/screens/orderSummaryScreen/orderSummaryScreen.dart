import 'package:egrocer/core/model/order.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/orderSummaryScreen/ui/stack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/provider/activeOrdersProvider.dart';


class OrderSummaryScreen extends StatefulWidget {
  final Order order;

  const OrderSummaryScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  late List<OrderItem> _orderItems = [];
  late List<ShippedItem> _shippedItems = [];
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

        appBar: getAppBar(
            context: context,
            title: Text(
              getTranslatedValue(
                context,
                "lblOrderSummary",
              ),
              softWrap: true,
              //style: TextStyle(color: ColorsRes.mainTextColor),
            )),
        body: OSStackWidget(order: widget.order,orderItems: _orderItems, shippedItems: _shippedItems,)
      );
    // );
  }
}
