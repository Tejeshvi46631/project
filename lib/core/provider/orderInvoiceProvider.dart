
import 'package:egrocer/core/model/trackOrdersModel.dart';
import 'package:egrocer/core/repository/orderInvoiceApi.dart';
import 'package:egrocer/core/repository/trackOrderApi.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum OrderInvoiceState {
  initial,
  loading,
  loaded,
  error,
}

class OrderInvoiceProvider extends ChangeNotifier {
  OrderInvoiceState orderInvoiceState = OrderInvoiceState.initial;
  String message = '';
  late Uint8List orderInvoice;
  late TrackOrderModel trackOrderModel;

  Future<Uint8List?> getOrderInvoiceApiProvider(
      {required Map<String, dynamic> params,
      required BuildContext context}) async {
    orderInvoiceState = OrderInvoiceState.loading;
    notifyListeners();

    try {
      orderInvoice = await getOrderInvoiceApi(context: context, params: params);

      orderInvoiceState = OrderInvoiceState.loaded;
      notifyListeners();

      return orderInvoice;
    } catch (e) {
      message = e.toString();
      orderInvoiceState = OrderInvoiceState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
      return null;
    }
  }

  Future<TrackOrderModel?> getOrderTrackingDetailsProvider(
      {required Map<String, dynamic> params,
      required BuildContext context}) async {
    // orderInvoiceState = OrderInvoiceState.loading;
    notifyListeners();

    try {
      trackOrderModel =
          await getOrderTrackingDetailsApi(context: context, params: params);

      // orderInvoiceState = OrderInvoiceState.loaded;
      notifyListeners();

      return trackOrderModel;
    } catch (e) {
      message = e.toString();
      // orderInvoiceState = OrderInvoiceState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
      return null;
    }
  }
}
