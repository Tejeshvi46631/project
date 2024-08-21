import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/productListItem.dart';
import 'package:egrocer/core/provider/selectedVariantItemProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/utils/styles/designConfig.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/productCartButton.dart';
import 'package:egrocer/core/widgets/productWishListIcon.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductVariantDropDownMenuGrid extends StatefulWidget {
  final List<Variants> variants;
  final String from;
  final ProductListItem product;
  final bool isGrid;

  const ProductVariantDropDownMenuGrid({
    Key? key,
    required this.variants,
    required this.from,
    required this.product,
    required this.isGrid,
  }) : super(key: key);

  @override
  State<ProductVariantDropDownMenuGrid> createState() => _ProductVariantDropDownMenuGridState();
}

class _ProductVariantDropDownMenuGridState extends State<ProductVariantDropDownMenuGrid> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedVariantItemProvider>(
      builder: (context, selectedVariantItemProvider, _) {
        return widget.variants.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(top: 5, start: 0, end: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  double.parse(widget.variants[selectedVariantItemProvider.getSelectedIndex()].discountedPrice) != 0
                                      ? GeneralMethods.getCurrencyFormat(
                                    double.parse(widget.variants[selectedVariantItemProvider.getSelectedIndex()].discountedPrice),
                                  )
                                      : GeneralMethods.getCurrencyFormat(
                                    double.parse(widget.variants[selectedVariantItemProvider.getSelectedIndex()].price),
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ColorsRes.appColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Widgets.getSizedBox(width: 5),
                              if (double.parse(widget.variants[selectedVariantItemProvider.getSelectedIndex()].discountedPrice) != 0)
                                Flexible(
                                  child: Text(
                                    GeneralMethods.getCurrencyFormat(double.parse(widget.variants[selectedVariantItemProvider.getSelectedIndex()].price)),
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ColorsRes.subTitleMainTextColor,
                                      decoration: TextDecoration.lineThrough,
                                      decorationThickness: 2,
                                    ),
                                  ),
                                ),
                              Widgets.getSizedBox(width: 5),
                              if (double.parse(widget.variants[selectedVariantItemProvider.getSelectedIndex()].discountedPrice) != 0)
                                Flexible(
                                  child: Text(
                                    "(${(calculateDiscountPercentage(
                                        double.parse(widget.variants[selectedVariantItemProvider.getSelectedIndex()].price),
                                        double.parse(widget.variants[selectedVariantItemProvider.getSelectedIndex()].discountedPrice)
                                    )).toStringAsFixed(0)}% off)",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ColorsRes.subTitleMainTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Widgets.getSizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      if (widget.variants.length > 1) {
                        {
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
                            builder: (BuildContext context) {
                              return Container(
                                padding: EdgeInsetsDirectional.only(start: Constant.size15, end: Constant.size15, top: Constant.size15, bottom: Constant.size15),
                                child: Wrap(
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.only(start: Constant.size15, end: Constant.size15),
                                      child: Row(
                                        children: [
                                          ClipRRect(borderRadius: Constant.borderRadius10, clipBehavior: Clip.antiAliasWithSaveLayer, child: Widgets.setNetworkImg(boxFit: BoxFit.fill, image: widget.product.imageUrl, height: 70, width: 70)),
                                          Widgets.getSizedBox(
                                            width: Constant.size10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              widget.product.name,
                                              softWrap: true,
                                              style: const TextStyle(fontSize: 20),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsetsDirectional.only(start: Constant.size15, end: Constant.size15, top: Constant.size15, bottom: Constant.size15),
                                      child: ListView.separated(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: widget.variants.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      child: RichText(
                                                        maxLines: 2,
                                                        softWrap: true,
                                                        overflow: TextOverflow.clip,
                                                        // maxLines: 1,
                                                        text: TextSpan(children: [
                                                          // TextSpan(
                                                          //   style: TextStyle(fontSize: 15, color: ColorsRes.mainTextColor, decorationThickness: 2),
                                                          //   text: "${widget.variants[index].measurement} ",
                                                          // ),
                                                          WidgetSpan(
                                                            child: Text(
                                                              widget.variants[index].stockUnitName,
                                                              softWrap: true,
                                                              //superscript is usually smaller in size
                                                              // textScaleFactor: 0.7,
                                                              style: const TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                          TextSpan(text: double.parse(widget.variants[index].discountedPrice) != 0 ? " | " : "", style: TextStyle(color: ColorsRes.mainTextColor)),
                                                          TextSpan(
                                                            style: TextStyle(fontSize: 13, color: ColorsRes.mainTextColor, decoration: TextDecoration.lineThrough, decorationThickness: 2),
                                                            text: double.parse(widget.variants[index].discountedPrice) != 0 ? GeneralMethods.getCurrencyFormat(double.parse(widget.variants[index].price)) : "",
                                                          ),
                                                        ]),
                                                      ),
                                                    ),
                                                    Text(
                                                      double.parse(widget.variants[index].discountedPrice) != 0 ? GeneralMethods.getCurrencyFormat(double.parse(widget.variants[index].discountedPrice)) : GeneralMethods.getCurrencyFormat(double.parse(widget.variants[index].price)),
                                                      softWrap: true,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(fontSize: 17, color: ColorsRes.appColor, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              ProductCartButton(
                                                productId: widget.product.id.toString(),
                                                productVariantId: widget.variants[index].id.toString(),
                                                count: int.parse(widget.variants[index].status) == 0 ? -1 : int.parse(widget.variants[index].cartCount),
                                                isUnlimitedStock: widget.product.isUnlimitedStock == "1",
                                                maximumAllowedQuantity: double.parse(widget.product.totalAllowedQuantity.toString()),
                                                availableStock: double.parse(widget.variants[index].stock),
                                                isGrid: false,
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder: (BuildContext context, int index) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(vertical: Constant.size7),
                                            child: Divider(
                                              color: ColorsRes.grey,
                                              height: 5,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      }
                    },
                    child: Container(
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: Constant.borderRadius5,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      margin: EdgeInsetsDirectional.only(end: 5),
                      child: Container(
                        padding: widget.variants.length > 1 ? EdgeInsets.zero : EdgeInsets.all(5),
                        alignment: AlignmentDirectional.center,
                        height: 35,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              flex: 10,
                              child: Padding(
                                padding: EdgeInsetsDirectional.only(start: 5),
                                child: Text(
                                  " ${widget.variants[0].stockUnitName}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ColorsRes.mainTextColor,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            if (widget.variants.length > 1)
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: EdgeInsetsDirectional.only(start: 5, end: 5),
                                  child: Widgets.defaultImg(
                                    image: "ic_drop_down",
                                    height: 10,
                                    width: 10,
                                    boxFit: BoxFit.cover,
                                    iconColor: ColorsRes.mainTextColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Widgets.getSizedBox(
                    height: Constant.size10,
                  ),
                  Divider(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    height: 1,
                    thickness: 1,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 100,
                        child: ProductCartButton(
                          productId: widget.product.id.toString(),
                          productVariantId: widget.variants[selectedVariantItemProvider.getSelectedIndex()].id.toString(),
                          count: int.parse(widget.variants[selectedVariantItemProvider.getSelectedIndex()].status) == 0 ? -1 : int.parse(widget.variants[selectedVariantItemProvider.getSelectedIndex()].cartCount),
                          isUnlimitedStock: widget.product.isUnlimitedStock == "1",
                          maximumAllowedQuantity: double.parse(widget.product.totalAllowedQuantity.toString()),
                          availableStock: double.parse(widget.variants[selectedVariantItemProvider.getSelectedIndex()].stock),
                          isGrid: widget.isGrid,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: ProductWishListIcon(
                          product: Constant.session.isUserLoggedIn() ? widget.product : null,
                          isListing: false,
                        ),
                      ),
                    ],
                  )
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }
  double calculateDiscountPercentage(double originalPrice, double discountedPrice) {
    if (originalPrice == 0) return 0;
    return ((originalPrice - discountedPrice) / originalPrice) * 100;
  }
}
