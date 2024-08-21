
import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/homeScreenData.dart';
import 'package:egrocer/core/model/productList.dart';
import 'package:egrocer/core/model/productListItem.dart';
import 'package:egrocer/core/webservices/categoryApi.dart';
import 'package:egrocer/core/webservices/productApi.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/material.dart';

enum CategoryState {
  initial,
  loading,
  loaded,
  error,
}

enum ProductState {
  initial,
  loaded,
  loading,
  loadingMore,
  error,
}

class CategoryListProvider extends ChangeNotifier {
  CategoryState categoryState = CategoryState.initial;
  String message = '';
  List<Category> categories = [];
  Map<String, List<Category>> subCategoriesList = {};
  List<String> selectedCategoryIdsList = [];
  List<String> selectedCategoryNamesList = [];
  String currentSelectedCategoryId = "0";

  getCategoryApiProvider({
    required Map<String, String> params,
    required BuildContext context,
  }) async {
    categoryState = CategoryState.loading;
    notifyListeners();
    try {
      categories = (await getCategoryList(context: context, params: params)).cast<Category>();

      categoryState = CategoryState.loaded;

      notifyListeners();
    } catch (e) {
      message = e.toString();
      categoryState = CategoryState.error;
      GeneralMethods.showSnackBarMsg(context, message);
      notifyListeners();
    }
  }

  setCategoryData(int index, BuildContext context) {
    currentSelectedCategoryId = selectedCategoryIdsList[index];
    categories = subCategoriesList["$index"] as List<Category>;

    if (index == 0) {
      selectedCategoryIdsList.clear();
      selectedCategoryNamesList.clear();
      selectedCategoryIdsList = ["0"];
      selectedCategoryNamesList = [
        getTranslatedValue(
          context,
          "lblAll",
        )
      ];
      currentSelectedCategoryId = "0";
    } else {
      selectedCategoryIdsList.removeRange(index, selectedCategoryIdsList.length - 1);
      selectedCategoryNamesList.removeRange(index, selectedCategoryNamesList.length - 1);
    }

    notifyListeners();
  }

  removeLastCategoryData() {
    selectedCategoryIdsList.removeLast();
    selectedCategoryNamesList.removeLast();
    categories = subCategoriesList["${selectedCategoryIdsList.last}"] as List<Category>;
    notifyListeners();
  }

  ProductState productState = ProductState.initial;
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
