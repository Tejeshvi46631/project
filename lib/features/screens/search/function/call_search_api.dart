import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/provider/productSearchProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SearchApi{
  static callApi({required bool isReset,required BuildContext context,required TextEditingController edtSearch}) async {
    if (isReset) {
      context.read<ProductSearchProvider>().offset = 0;

      context.read<ProductSearchProvider>().products = [];
    }

    Map<String, String> params = await Constant.getProductsDefaultParams();

    params[ApiAndParams.sort] = ApiAndParams.productListSortTypes[
    context.read<ProductSearchProvider>().currentSortByOrderIndex];
    params[ApiAndParams.search] = edtSearch.text.trim().toString();

    await context
        .read<ProductSearchProvider>()
        .getProductSearchProvider(context: context, params: params);
  }

}