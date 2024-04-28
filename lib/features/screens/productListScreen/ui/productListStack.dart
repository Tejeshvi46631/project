import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/provider/cartListProvider.dart';
import 'package:egrocer/core/provider/productChangeListingProvider.dart';
import 'package:egrocer/core/provider/productListProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/utils/styles/designConfig.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/productListScreen/function/productListApiCall.dart';
import 'package:egrocer/features/screens/productListScreen/ui/productListWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListStack extends StatefulWidget {
  final String from;
  final String id;
  ScrollController scrollController;

  ProductListStack(
      {super.key,
      required this.from,
      required this.id,
      required this.scrollController});

  @override
  State<ProductListStack> createState() => _ProductListStackState();
}

class _ProductListStackState extends State<ProductListStack> {
  @override
  Widget build(BuildContext context) {
    List lblSortingDisplayList = [
      getTranslatedValue(context, "lblSortingDisplayListDefault"),
      getTranslatedValue(context, "lblSortingDisplayListNewestFirst"),
      getTranslatedValue(context, "lblSortingDisplayListOldestFirst"),
      getTranslatedValue(context, "lblSortingDisplayListPriceHighToLow"),
      getTranslatedValue(context, "lblSortingDisplayListPriceLowToHigh"),
      getTranslatedValue(context, "lblSortingDisplayListDiscountHighToLow"),
      getTranslatedValue(context, "lblSortingDisplayListPopularity"),
    ];
    return Stack(
      children: [
        Column(
          children: [
            getSearchWidget(
              context: context,
            ),
            Widgets.getSizedBox(
              height: Constant.size5,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: Constant.size5),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.pushNamed(
                          context,
                          productListFilterScreen,
                          arguments: [
                            context
                                .read<ProductListProvider>()
                                .productList
                                .brands,
                            double.parse(context
                                .read<ProductListProvider>()
                                .productList
                                .maxPrice),
                            double.parse(context
                                .read<ProductListProvider>()
                                .productList
                                .minPrice),
                            context
                                .read<ProductListProvider>()
                                .productList
                                .sizes
                          ],
                        ).then((value) async {
                          if (value == true) {
                            context.read<ProductListProvider>().offset = 0;
                            context.read<ProductListProvider>().products = [];
                            ProductListApi.callApi(
                                isReset: true,
                                context: context,
                                from: widget.from,
                                id: widget.id);
                          }
                        });
                      },
                      child: Card(
                          color: Theme.of(context).cardColor,
                          elevation: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Widgets.defaultImg(
                                  image: "filter_icon",
                                  height: 17,
                                  width: 17,
                                  padding: const EdgeInsetsDirectional.only(
                                      top: 7, bottom: 7, end: 7),
                                  iconColor: Theme.of(context).primaryColor),
                              Text(
                                getTranslatedValue(
                                  context,
                                  "lblFilter",
                                ),
                                softWrap: true,
                              )
                            ],
                          )),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          shape: DesignConfig.setRoundedBorderSpecific(20,
                              istop: true),
                          builder: (BuildContext context1) {
                            return Wrap(
                              children: [
                                Container(
                                  padding: EdgeInsetsDirectional.only(
                                      start: Constant.size15,
                                      end: Constant.size15,
                                      top: Constant.size15,
                                      bottom: Constant.size15),
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          PositionedDirectional(
                                            child: GestureDetector(
                                              onTap: () =>
                                                  Navigator.pop(context),
                                              child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Widgets.defaultImg(
                                                  image: "ic_arrow_back",
                                                  iconColor:
                                                      ColorsRes.mainTextColor,
                                                  height: 15,
                                                  width: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              getTranslatedValue(
                                                context,
                                                "lblSortBy",
                                              ),
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .merge(
                                                    const TextStyle(
                                                      letterSpacing: 0.5,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Widgets.getSizedBox(height: 10),
                                      Column(
                                        children: List.generate(
                                          ApiAndParams
                                              .productListSortTypes.length,
                                          (index) {
                                            return GestureDetector(
                                              onTap: () async {
                                                Navigator.pop(context);
                                                context
                                                    .read<ProductListProvider>()
                                                    .products = [];

                                                context
                                                    .read<ProductListProvider>()
                                                    .offset = 0;

                                                context
                                                    .read<ProductListProvider>()
                                                    .currentSortByOrderIndex = index;

                                                ProductListApi.callApi(
                                                    isReset: true,
                                                    context: context,
                                                    from: widget.from,
                                                    id: widget.id);
                                              },
                                              child: Container(
                                                padding:
                                                    EdgeInsetsDirectional.all(
                                                        10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    context
                                                                .read<
                                                                    ProductListProvider>()
                                                                .currentSortByOrderIndex ==
                                                            index
                                                        ? Icon(
                                                            Icons
                                                                .radio_button_checked,
                                                            color: ColorsRes
                                                                .appColor,
                                                          )
                                                        : Icon(
                                                            Icons
                                                                .radio_button_off,
                                                            color: ColorsRes
                                                                .appColor,
                                                          ),
                                                    Widgets.getSizedBox(
                                                        width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        lblSortingDisplayList[
                                                            index],
                                                        softWrap: true,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .merge(
                                                              const TextStyle(
                                                                letterSpacing:
                                                                    0.5,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Card(
                          color: Theme.of(context).cardColor,
                          elevation: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Widgets.defaultImg(
                                  image: "sorting_icon",
                                  height: 17,
                                  width: 17,
                                  padding: const EdgeInsetsDirectional.only(
                                      top: 7, bottom: 7, end: 7),
                                  iconColor: Theme.of(context).primaryColor),
                              Text(
                                getTranslatedValue(
                                  context,
                                  "lblSortBy",
                                ),
                                softWrap: true,
                              )
                            ],
                          )),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context
                            .read<ProductChangeListingTypeProvider>()
                            .changeListingType();
                      },
                      child: Card(
                          color: Theme.of(context).cardColor,
                          elevation: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Widgets.defaultImg(
                                  image: context
                                              .watch<
                                                  ProductChangeListingTypeProvider>()
                                              .getListingType() ==
                                          false
                                      ? "grid_view_icon"
                                      : "list_view_icon",
                                  height: 17,
                                  width: 17,
                                  padding: const EdgeInsetsDirectional.only(
                                      top: 7, bottom: 7, end: 7),
                                  iconColor: Theme.of(context).primaryColor),
                              Text(
                                context
                                            .watch<
                                                ProductChangeListingTypeProvider>()
                                            .getListingType() ==
                                        false
                                    ? getTranslatedValue(
                                        context,
                                        "lblGridView",
                                      )
                                    : getTranslatedValue(
                                        context,
                                        "lblListView",
                                      ),
                                softWrap: true,
                              )
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: setRefreshIndicator(
                    refreshCallback: () async {
                      context.read<ProductListProvider>().offset = 0;
                      context.read<ProductListProvider>().products = [];

                      ProductListApi.callApi(
                          isReset: true,
                          context: context,
                          from: widget.from,
                          id: widget.id);
                    },
                    child: SingleChildScrollView(
                      controller: widget.scrollController,
                      child: ProductListWidget(),
                    )))
          ],
        ),
        Consumer<CartListProvider>(
          builder: (context, cartListProvider, child) {
            return cartListProvider.cartListState == CartListState.loading
                ? PositionedDirectional(
                    top: 0,
                    end: 0,
                    start: 0,
                    bottom: 0,
                    child: Container(
                        color: Colors.black.withOpacity(0.2),
                        child:
                            const Center(child: CircularProgressIndicator())),
                  )
                : const SizedBox.shrink();
          },
        )
      ],
    );
  }
}
