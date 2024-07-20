import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/productListItem.dart';
import 'package:egrocer/core/provider/productChangeListingProvider.dart';
import 'package:egrocer/core/provider/productWishListProvider.dart';
import 'package:egrocer/core/widgets/defaultBlankItemMessageScreen.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/productGridItemContainer.dart';
import 'package:egrocer/core/widgets/productListItemContainer.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishListProductCard extends StatefulWidget {
  const WishListProductCard({super.key});

  @override
  State<WishListProductCard> createState() => _WishListProductCardState();
}

class _WishListProductCardState extends State<WishListProductCard> {
  @override
  Widget build(BuildContext context) {
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
