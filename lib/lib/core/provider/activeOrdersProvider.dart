
import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/order.dart';
import 'package:egrocer/core/webservices/ordersApi.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/material.dart';

enum ActiveOrdersState {
  initial,
  loading,
  loaded,
  loadingMore,
  error,
}

class ActiveOrdersProvider extends ChangeNotifier {
  ActiveOrdersState activeOrdersState = ActiveOrdersState.initial;
  String message = '';
  List<Order> orders = [];
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  void updateOrder(Order order) {
    final orderIndex = orders.indexWhere((element) => element.id == order.id);
    if (orderIndex != -1) {
      orders[orderIndex] = order;
      notifyListeners();
    }
  }
  Order? getCurrentOrder() {
    // Example: Get the last order in the list
    if (orders.isNotEmpty) {
      return orders.last;
    }
    return null;
  }
  Future<void> getOrders({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    print("entered in getorder");
    print(offset);
    if (offset == 0) {
      activeOrdersState = ActiveOrdersState.loading;
    } else {
      activeOrdersState = ActiveOrdersState.loadingMore;
    }
    notifyListeners();

    try {
      params[ApiAndParams.limit] = Constant.defaultDataLoadLimitAtOnce.toString();
      print(params[ApiAndParams.limit]);
      params[ApiAndParams.offset] = offset.toString();
      print(params[ApiAndParams.offset]);
      Map<String, dynamic> getData =
      await fetchOrders(context: context, params: params);

      if (getData[ApiAndParams.status].toString() == "1") {
        totalData = int.parse(getData[ApiAndParams.total].toString());

        List<Order> tempOrders = (getData['data'] as List)
            .map((e) => Order.fromJson(Map.from(e ?? {})))
            .toList();

        orders.addAll(tempOrders);
      }

      hasMoreData = totalData > orders.length;
      if (hasMoreData) {
        offset += Constant.defaultDataLoadLimitAtOnce;
      }
      activeOrdersState = ActiveOrdersState.loaded;
      print(activeOrdersState);
      notifyListeners();
    } catch (e) {
      message = e.toString();
      print(message);
      activeOrdersState = ActiveOrdersState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
    }
  }
}
