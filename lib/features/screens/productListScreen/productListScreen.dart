import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/provider/productListProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/productListScreen/function/productListApiCall.dart';
import 'package:egrocer/features/screens/productListScreen/ui/productListStack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  final String? title;
  final String from;
  final String id;

  const ProductListScreen(
      {Key? key, this.title, required this.from, required this.id})
      : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool isFilterApplied = false;
  ScrollController scrollController = ScrollController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<ProductListProvider>().hasMoreData &&
            context.read<ProductListProvider>().productState !=
                ProductState.loadingMore) {
          ProductListApi.callApi(
              isReset: false,
              context: context,
              from: widget.from,
              id: widget.id);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    scrollController.addListener(scrollListener);

    //fetch productList from api
    Future.delayed(Duration.zero).then((value) async {
      ProductListApi.callApi(
          isReset: true, context: context, from: widget.from, id: widget.id);
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    Constant.resetTempFilters();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          context: context,
          title: Text(
            widget.title ??
                getTranslatedValue(
                  context,
                  "lblProducts",
                ),
            softWrap: true,
            //style: TextStyle(color: ColorsRes.mainTextColor),
          ),
          actions: [
            setCartCounter(context: context),
            setNotificationCounter(context: context)
          ]),
      body: ProductListStack(
          from: widget.from, id: widget.id, scrollController: scrollController),
    );
  }
}
