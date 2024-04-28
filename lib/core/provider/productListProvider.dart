import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/productList.dart';
import 'package:egrocer/core/model/productListItem.dart';
import 'package:egrocer/core/webservices/productApi.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/material.dart';

enum ProductState {
  initial,
  loaded,
  loading,
  loadingMore,
  error,
}

class ProductListProvider extends ChangeNotifier {
  ProductState productState = ProductState.initial;
  String message = '';
  int currentSortByOrderIndex = 0;
  late ProductList productList;
  List<ProductListItem> products = [];
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  getProductListProvider(
      {required Map<String, dynamic> params,
      required BuildContext context}) async {
    if (offset == 0) {
      productState = ProductState.loading;
    } else {
      productState = ProductState.loadingMore;
    }
    notifyListeners();

    params[ApiAndParams.limit] = Constant.defaultDataLoadLimitAtOnce.toString();
    params[ApiAndParams.offset] = offset.toString();

    try {
      Map<String, dynamic> response =
          await getProductListApi(context: context, params: params);
      if (response[ApiAndParams.status].toString() == "1") {
        productList = ProductList.fromJson(response);

        totalData = int.parse(productList.total);

        products.addAll(productList.data);

        productState = ProductState.loaded;

        hasMoreData = totalData > products.length;

        if (hasMoreData) {
          offset += Constant.defaultDataLoadLimitAtOnce;
        }
        productState = ProductState.loaded;
      } else {
        productState = ProductState.error;
      }

      notifyListeners();
    } catch (e) {
      message = e.toString();
      productState = ProductState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
    }
  }
}
