import 'dart:developer' as dev;
import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/model/productListItem.dart';
import 'package:egrocer/core/provider/productWishListProvider.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductWishListIcon extends StatefulWidget {
  final bool? isListing;
  final ProductListItem? product;
  final Function? onTap;

  const ProductWishListIcon(
      {Key? key, this.isListing, this.product, this.onTap})
      : super(key: key);

  @override
  State<ProductWishListIcon> createState() => _ProductWishListIconState();
}

class _ProductWishListIconState extends State<ProductWishListIcon> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductAddOrRemoveFavoriteProvider>(
      builder: (providerContext, value, child) {
        providerContext
            .read<ProductAddOrRemoveFavoriteProvider>()
            .productListItem = widget.product;
        return Consumer<ProductWishListProvider>(
            builder: (providerContext, value, child) {
          return GestureDetector(
            onTap: () async {
              if (Constant.session.isUserLoggedIn()) {
                Map<String, String> params = {};
                params[ApiAndParams.productId] =
                    widget.product?.id.toString() ?? "0";

                dev.log(params.entries.toString(),
                    name: "Add To Wishlist Parms : ");
                await providerContext
                    .read<ProductAddOrRemoveFavoriteProvider>()
                    .getProductAddOrRemoveFavorite(
                        params: params,
                        context: context,
                        productId: int.parse(widget.product?.id ?? "0"))
                    // (context as Element).ma
                    .then((value) {
                  if (value) {
                    context
                        .read<ProductWishListProvider>()
                        .addRemoveFavoriteProduct(widget.product);
                    widget.product?.isFavorite =
                        (widget.product?.isFavorite == true ? false : true);
                    setState(() {});
                  }

                  // widget.onTap!(widget.product?.isFavorite);
                });
              } else {
                GeneralMethods.showSnackBarMsg(
                  context,
                  getTranslatedValue(
                    context,
                    "lblRequiredLoginMessageForWishlist",
                  ),
                  requiredAction: true,
                  onPressed: () {
                    Navigator.pushNamed(context, loginScreen);
                  },
                );
              }
            },
            child: Container(
              height: 30,
              width: 30,
              decoration: widget.isListing == false
                  ? BoxDecoration(color: Theme.of(context).cardColor)
                  : BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          )
                        ]),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Constant.size7, horizontal: Constant.size7),
                child: (providerContext
                                .read<ProductAddOrRemoveFavoriteProvider>()
                                .productAddRemoveFavoriteState ==
                            ProductAddRemoveFavoriteState.loading &&
                        providerContext
                                .read<ProductAddOrRemoveFavoriteProvider>()
                                .stateId ==
                            (widget.product?.id ?? 0))
                    ? Widgets.getLoadingIndicator()
                    :

                Icon(
                  size: 25,
                        color:  widget.product?.isFavorite == true? Colors.red:Colors.grey,
                        /* providerContext
                                .read<ProductWishListProvider>()
                                .wishlistProducts
                                .where((element) => element.id == product?.id)
                                .toList()
                                .length >
                            0 */
                        widget.product?.isFavorite == true
                            ? Icons.favorite
                            : Icons.favorite_border_outlined),

                /* Widgets.getDarkLightIcon(
                          iconColor: ColorsRes.appColor,
                          isActive: //Constant.session.isUserLoggedIn()
                              //?
                              providerContext
                                  .read<ProductWishListProvider>().w
                                  .contains(product?.id ?? 0), // : false,
                          image: "wishlist") */
              ),
            ),
          );
        });
      },
    );
  }
}
