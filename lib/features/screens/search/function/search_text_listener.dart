import 'dart:async';

import 'package:egrocer/core/provider/productSearchProvider.dart';
import 'package:egrocer/features/screens/search/function/call_search_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SearchLister{
  static void searchTextListener(TextEditingController edtSearch,BuildContext context, Timer? delayTimer,) {
    if (edtSearch.text.isEmpty) {
      delayTimer?.cancel();
    }

    if (delayTimer?.isActive ?? false) delayTimer?.cancel();

    delayTimer = Timer(const Duration(milliseconds: 300), () {
      if (edtSearch.text.isNotEmpty) {
        if (edtSearch.text.length !=
            context.read<ProductSearchProvider>().searchedTextLength) {
          SearchApi.callApi(isReset: true, context: context, edtSearch: edtSearch);
          //
          context.read<ProductSearchProvider>().setSearchLength(edtSearch.text);
        }
      } else {
        context.read<ProductSearchProvider>().setSearchLength("");
        SearchApi.callApi(isReset: true, context: context, edtSearch: edtSearch);
      }
    });
  }
}