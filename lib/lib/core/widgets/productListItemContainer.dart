
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/model/productListItem.dart';
import 'package:egrocer/core/provider/selectedVariantItemProvider.dart';
import 'package:egrocer/core/utils/styles/designConfig.dart';
import 'package:egrocer/core/widgets/productVariantDropDownMenuGrid.dart';
import 'package:egrocer/core/widgets/productVariantDropDownMenuList.dart';
import 'package:egrocer/core/widgets/productWishListIcon.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListItemContainer extends StatefulWidget {
  final ProductListItem product;
  String? currentSectionID = '';
  List<ProductListItem?> listSimilarProductListItem = [];
  ProductListItemContainer(
      {Key? key,
      required this.product,
      this.currentSectionID,
      required this.listSimilarProductListItem})
      : super(key: key);

  @override
  State<ProductListItemContainer> createState() => _State();
}

class _State extends State<ProductListItemContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProductListItem product = widget.product;
    List<Variants> variants = product.variants;
    return Padding(
      padding: const EdgeInsetsDirectional.only(
          bottom: 5, start: 10, end: 10, top: 5),
      child: variants.length > 0
          ? GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, productDetailScreen, arguments: [
                  product.id.toString(),
                  product.name,
                  product,
                  widget.currentSectionID,
                  widget.listSimilarProductListItem,
                ]);
              },
              child: ChangeNotifierProvider<SelectedVariantItemProvider>(
                create: (context) => SelectedVariantItemProvider(),
                child: Container(
                  decoration: DesignConfig.boxDecoration(
                      Theme.of(context).cardColor, 8),
                  child: Stack(
                    children: [
                      Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Consumer<SelectedVariantItemProvider>(
                              builder: (context, selectedVariantItemProvider,
                                  child) {
                                return Stack(
                                  children: [
                                    ClipRRect(
                                        borderRadius: Constant.borderRadius10,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child: Widgets.setNetworkImg(
                                          boxFit: BoxFit.fill,
                                          image: product.imageUrl,
                                          height: 125,
                                          width: 125,
                                        )),
                                    if (product
                                            .variants[
                                                selectedVariantItemProvider
                                                    .getSelectedIndex()]
                                            .status ==
                                        0)
                                      PositionedDirectional(
                                        top: 0,
                                        end: 0,
                                        start: 0,
                                        bottom: 0,
                                        child: getOutOfStockWidget(
                                          height: 125,
                                          width: 125,
                                          textSize: 15,
                                          context: context,
                                        ),
                                      ),

                                  ],
                                );
                              },
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Constant.size10,
                                        horizontal: Constant.size10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Widgets.getSizedBox(
                                          height: Constant.size10,
                                        ),
                                        Text(
                                          product.name,
                                          softWrap: true,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Widgets.getSizedBox(
                                          height: Constant.size10,
                                        ),
                                        ProductVariantDropDownMenuGrid(
                                          variants: variants,
                                          from: "",
                                          product: product,
                                          isGrid: false,
                                        ),
                                      ],
                                    ),

                                  ),
                                  // PositionedDirectional(
                                  //   end: 5,
                                  //   bottom: 5,
                                  //   child: ProductWishListIcon(
                                  //     product: product,
                                  //   ),
                                  // ),
                                ],
                              ),

                            )
                          ]),


                    ],
                  ),
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
