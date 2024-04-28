import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/provider/productSearchProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScroll{
  static  scrollListener(ScrollController scrollController,BuildContext context,TextEditingController edtSearch) async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (context.read<ProductSearchProvider>().hasMoreData) {
        Map<String, String> params = await Constant.getProductsDefaultParams();

        params[ApiAndParams.search] = edtSearch.text.trim();

        await context
            .read<ProductSearchProvider>()
            .getProductSearchProvider(context: context, params: params);
      }
    }
  }
}