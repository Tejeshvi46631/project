import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/productListItem.dart';
import 'package:egrocer/core/provider/productChangeListingProvider.dart';
import 'package:egrocer/core/provider/productWishListProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/defaultBlankItemMessageScreen.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/productGridItemContainer.dart';
import 'package:egrocer/core/widgets/productListItemContainer.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishListDrawerScreen extends StatefulWidget {
  const WishListDrawerScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<WishListDrawerScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<WishListDrawerScreen> {
  ScrollController scrollController = new ScrollController();

  @override
  void dispose() {
    Constant.resetTempFilters();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((value) async {
      //fetch productList from api

      callApi(isReset: true);
    });
  }

  callApi({required isReset}) async {
    if (isReset) {
      context.read<ProductWishListProvider>().offset = 0;
      context.read<ProductWishListProvider>().wishlistProducts = [];
    }
    Map<String, String> params = await Constant.getProductsDefaultParams();

    await context
        .read<ProductWishListProvider>()
        .getProductWishListProvider(context: context, params: params);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: Text(
          getTranslatedValue(
            context,
            "lblWishList",
          ),
          //style: TextStyle(color: ColorsRes.mainTextColor),
        ),
        actions: [
          setCartCounter(context: context),
          setNotificationCounter(context: context)
        ],
        showBackButton: false,
      ),
      body: Column(
        children: [
          getSearchWidget(
            context: context,
          ),
          Widgets.getSizedBox(
            height: Constant.size10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Constant.size10),
            child: GestureDetector(
              onTap: () {
                context
                    .read<ProductChangeListingTypeProvider>()
                    .changeListingType();
              },
              child: context
                      .watch<ProductWishListProvider>()
                      .wishlistProducts
                      .isNotEmpty
                  ? Card(
                      margin: EdgeInsets.zero,
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
                          )
                        ],
                      ))
                  : const SizedBox.shrink(),
            ),
          ),
          Expanded(
            child: setRefreshIndicator(
              refreshCallback: () async {
                callApi(isReset: true);
              },
              child: SingleChildScrollView(
                controller: scrollController,
                child: productWidget(),
              ),
            ),
          )
        ],
      ),
    );
  }

  productWidget() {
    return Consumer<ProductWishListProvider>(
      builder: (context, productWishlistProvider, _) {
        List<ProductListItem> wishlistProducts =
            productWishlistProvider.wishlistProducts;
        if (productWishlistProvider.productWishListState ==
            ProductWishListState.initial) {
          return getProductListShimmer(
              context: context,
              isGrid: context
                  .read<ProductChangeListingTypeProvider>()
                  .getListingType());
        } else if (productWishlistProvider.productWishListState ==
            ProductWishListState.loading) {
          return getProductListShimmer(
              context: context,
              isGrid: context
                  .read<ProductChangeListingTypeProvider>()
                  .getListingType());
        } else if (productWishlistProvider.productWishListState ==
                ProductWishListState.loaded ||
            productWishlistProvider.productWishListState ==
                ProductWishListState.loadingMore) {
          return Column(
            children: [
              context
                          .read<ProductChangeListingTypeProvider>()
                          .getListingType() ==
                      true
                  ? /* GRID VIEW UI */ GridView.builder(
                      itemCount: wishlistProducts.length,
                      padding: EdgeInsets.symmetric(
                          horizontal: Constant.size10,
                          vertical: Constant.size10),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductGridItemContainer(
                            product: wishlistProducts[index]);
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.8,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                    )
                  : /* LIST VIEW UI */ Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            List.generate(wishlistProducts.length, (index) {
                          return ProductListItemContainer(
                            product: wishlistProducts[index],
                            listSimilarProductListItem: wishlistProducts,
                          );
                        }),
                      ),
                    ),
              if (productWishlistProvider.productWishListState ==
                  ProductWishListState.loadingMore)
                getProductItemShimmer(
                    context: context,
                    isGrid: context
                        .read<ProductChangeListingTypeProvider>()
                        .getListingType()),
            ],
          );
        } else {
          return DefaultBlankItemMessageScreen(
            title: getTranslatedValue(
              context,
              "lblEmptyWishListMessage",
            ),
            description: getTranslatedValue(
              context,
              "lblEmptyWishListDescription",
            ),
            image: "empty_wishlist_icon",
          );
        }
      },
    );
  }
}
