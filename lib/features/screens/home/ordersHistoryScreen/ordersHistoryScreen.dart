import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/model/order.dart';
import 'package:egrocer/core/provider/activeOrdersProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/home/ordersHistoryScreen/widgets/orderDetailContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersHistoryScreen extends StatefulWidget {
  const OrdersHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrdersHistoryScreen> createState() => _OrdersHistoryScreenState();
}

class _OrdersHistoryScreenState extends State<OrdersHistoryScreen>
    with TickerProviderStateMixin {
  late ScrollController scrollController = ScrollController()
    ..addListener(scrollListener);

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<ActiveOrdersProvider>().hasMoreData) {
          context
              .read<ActiveOrdersProvider>()
              .getOrders(params: {}, context: context);
        }
      }
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      print("entered in s initstate of orderscreen");
      context
          .read<ActiveOrdersProvider>()
          .getOrders(params: {}, context: context);
    });
  }

  Widget _buildOrderContainer(Order order) {
    return Container(
      margin: EdgeInsets.only(bottom: Constant.size10),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10)),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: Constant.size5),
      child: Column(
        children: [
          OrderDetailContainer(order: order),
        ],
      ),
    );
  }

  Widget _buildOrders() {
    return Consumer<ActiveOrdersProvider>(
      builder: (context, provider, _) {
        if (provider.activeOrdersState == ActiveOrdersState.loaded ||
            provider.activeOrdersState == ActiveOrdersState.loadingMore) {
          return ListView(
            padding: EdgeInsets.symmetric(
              horizontal: Constant.size10,
              vertical: Constant.size10,
            ),
            controller: scrollController,
            shrinkWrap: true,
            children: [
              setRefreshIndicator(
                refreshCallback: () async {
                  context.read<ActiveOrdersProvider>().orders.clear();
                  context.read<ActiveOrdersProvider>().offset = 0;
                  context
                      .read<ActiveOrdersProvider>()
                      .getOrders(params: {}, context: context);
                },
                child: Column(
                  children: List.generate(
                    provider.orders.length,
                    (index) => _buildOrderContainer(
                      provider.orders[index],
                    ),
                  ),
                ),
              ),
              if (provider.activeOrdersState == ActiveOrdersState.loadingMore)
                _buildOrderContainerShimmer(),
            ],
          );
        }
        if (provider.activeOrdersState == ActiveOrdersState.error) {
          return const SizedBox();
        }
        return _buildOrdersHistoryShimmer();
      },
    );
  }

  Widget _buildOrderContainerShimmer() {
    return CustomShimmer(
      height: 140,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsetsDirectional.only(top: 10),
    );
  }

  Widget _buildOrdersHistoryShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(10, (index) => index)
              .map((e) => _buildOrderContainerShimmer())
              .toList(),
        ),
      ),
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
              "lblOrdersHistory",
            ),
            //style: TextStyle(color: ColorsRes.mainTextColor),
          ),
          showBackButton: false),
      body: _buildOrders(),
    );
  }
}
