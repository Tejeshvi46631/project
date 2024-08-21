import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/model/homeScreenData.dart';
import 'package:egrocer/core/model/productDetail.dart';
import 'package:egrocer/core/model/productListItem.dart';
import 'package:egrocer/core/provider/selectedVariantItemProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/utils/styles/designConfig.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/productCartButton.dart';
import 'package:egrocer/core/widgets/productListItemContainer.dart';
import 'package:egrocer/core/widgets/productWishListIcon.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/productDetailScreen/ui/otherImagesBoxDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../core/widgets/expandedText.dart';

class ProductDetailWidget extends StatefulWidget {
  int currentImage;
  int currentVideos;
  bool isVideo = false;

  ProductData product;
  YoutubePlayerController? youtubeVideoController;
  List<String> videos;
  final ProductListItem? productListItem;
  List<ProductListItem?> listSimilarProductListItem = [];
  bool descTextShowFlag = false;
  List<ProductListItem> shopByReaginProduct;
  Widget image;
  Widget imageList;

  ProductDetailWidget(
      {super.key,
      required this.currentImage,
      required this.currentVideos,
      required this.isVideo,
      required this.product,
      required this.youtubeVideoController,
      required this.videos,
      required this.productListItem,
      required this.listSimilarProductListItem,
      required this.descTextShowFlag,
      required this.shopByReaginProduct,
      required this.image,
      required this.imageList});

  @override
  State<ProductDetailWidget> createState() => _ProductDetailWidgetState();
}

class _ProductDetailWidgetState extends State<ProductDetailWidget> {
  bool showFullDescription = false;

  bool descTextShowFlag = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.image,
        widget.imageList,
        Widgets.getSizedBox(
          height: Constant.size5,
        ),
        Widgets.getSizedBox(
          height: Constant.size5,
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Constant.size10, vertical: Constant.size10),
          margin: EdgeInsets.symmetric(horizontal: Constant.size10),
          decoration:
          DesignConfig.boxDecoration(Theme.of(context).cardColor, 5),
          child: Consumer<SelectedVariantItemProvider>(
            builder: (context, selectedVariantItemProvider, _) {
              return widget.product.variants.isNotEmpty
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    softWrap: true,
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Widgets.getSizedBox(
                    height: Constant.size10,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              double.parse(widget
                                  .product
                                  .variants[
                              selectedVariantItemProvider
                                  .getSelectedIndex()]
                                  .discountedPrice) !=
                                  0
                                  ? GeneralMethods.getCurrencyFormat(
                                  double.parse(widget
                                      .product
                                      .variants[
                                  selectedVariantItemProvider
                                      .getSelectedIndex()]
                                      .discountedPrice))
                                  : GeneralMethods.getCurrencyFormat(
                                  double.parse(widget
                                      .product
                                      .variants[
                                  selectedVariantItemProvider
                                      .getSelectedIndex()]
                                      .price)),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: ColorsRes.appColor,
                                  fontWeight: FontWeight.w500),
                            ),
                            Widgets.getSizedBox(width: 5),
                            if (double.parse(widget
                                .product
                                .variants[selectedVariantItemProvider
                                .getSelectedIndex()]
                                .discountedPrice) !=
                                0)
                              if (double.parse(widget
                                  .product
                                  .variants[
                              selectedVariantItemProvider
                                  .getSelectedIndex()]
                                  .discountedPrice) !=
                                  0)
                                Text(
                                  GeneralMethods.getCurrencyFormat(
                                      double.parse(widget
                                          .product
                                          .variants[
                                      selectedVariantItemProvider
                                          .getSelectedIndex()]
                                          .price)),
                                  maxLines: 2,
                                  softWrap: true,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color:
                                    ColorsRes.subTitleMainTextColor,
                                    decoration:
                                    TextDecoration.lineThrough,
                                    decorationThickness: 2,
                                  ),
                                ),
                            Widgets.getSizedBox(width: 5),
                            Widgets.getSizedBox(width: 5),
                            if (double.parse(widget.product.variants[selectedVariantItemProvider.getSelectedIndex()].discountedPrice) != 0)
                              Text(
                                "(${(calculateDiscountPercentage(
                                    double.parse(widget.product.variants[selectedVariantItemProvider.getSelectedIndex()].price),
                                    double.parse(widget.product.variants[selectedVariantItemProvider.getSelectedIndex()].discountedPrice)
                                )).toStringAsFixed(0)}% off)",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: ColorsRes.subTitleMainTextColor,
                                    fontWeight: FontWeight.w500),
                              ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: ProductWishListIcon(
                                  product:
                                  Constant.session.isUserLoggedIn()
                                      ? widget.productListItem
                                      : null,
                                  isListing: false,
                                ),
                              ),
                              Widgets.getSizedBox(width: 7),
                              GestureDetector(
                                onTap: () async {
                                  await GeneralMethods.createDynamicLink(
                                      context: context,
                                      shareUrl:
                                      "${Constant.hostUrl}product/${widget.product.id}",
                                      imageUrl:
                                      widget.product.imageUrl,
                                      title: widget.product.name,
                                      description:
                                      "<h1>${widget.product.name}</h1><br><br><h2>${widget.product.variants[0].measurement} ${widget.product.variants[0].stockUnitName}</h2>")
                                      .then(
                                        (value) async => await Share.share(
                                        "${widget.product.name}\n\n$value",
                                        subject: "Share app"),
                                  );
                                },
                                child: Widgets.defaultImg(
                                    image: "share_icon",
                                    height: 18,
                                    width: 18,
                                    padding:
                                    const EdgeInsetsDirectional.only(
                                        top: 9, bottom: 0, end: 7),
                                    iconColor:
                                    Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Widgets.getSizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (widget.product.variants.length > 1) {
                              {
                                showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: DesignConfig
                                      .setRoundedBorderSpecific(20,
                                      istop: true),
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: EdgeInsetsDirectional.only(
                                          start: Constant.size15,
                                          end: Constant.size15,
                                          top: Constant.size15,
                                          bottom: Constant.size15),
                                      child: Wrap(
                                        children: [
                                          Padding(
                                            padding: EdgeInsetsDirectional
                                                .only(
                                                start:
                                                Constant.size15,
                                                end: Constant.size15),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                    borderRadius: Constant
                                                        .borderRadius10,
                                                    clipBehavior: Clip
                                                        .antiAliasWithSaveLayer,
                                                    child: Widgets
                                                        .setNetworkImg(
                                                        boxFit: BoxFit
                                                            .fill,
                                                        image: widget
                                                            .product
                                                            .imageUrl,
                                                        height: 70,
                                                        width: 70)),
                                                Widgets.getSizedBox(
                                                  width: Constant.size10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    widget.product.name,
                                                    softWrap: true,
                                                    style:
                                                    const TextStyle(
                                                        fontSize: 20),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          //TODO : Product Varients display Here
                                          Container(
                                            padding: EdgeInsetsDirectional
                                                .only(
                                                start:
                                                Constant.size15,
                                                end: Constant.size15,
                                                top: Constant.size15,
                                                bottom:
                                                Constant.size15),
                                            child: ListView.separated(
                                              physics:
                                              const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: widget.product
                                                  .variants.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                  int index) {
                                                return Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          SizedBox(
                                                            child:
                                                            RichText(
                                                              maxLines: 2,
                                                              softWrap:
                                                              true,
                                                              overflow:
                                                              TextOverflow
                                                                  .clip,
                                                              // maxLines: 1,
                                                              text: TextSpan(
                                                                  children: [
                                                                    WidgetSpan(
                                                                      child:
                                                                      Text(
                                                                        widget.product.variants[index].stockUnitName,
                                                                        softWrap: true,
                                                                        //superscript is usually smaller in size
                                                                        // textScaleFactor: 0.7,
                                                                        style: const TextStyle(
                                                                          fontSize: 14,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                        text: double.parse(widget.product.variants[index].discountedPrice) != 0 ? " | " : "",
                                                                        style: TextStyle(color: ColorsRes.mainTextColor)),
                                                                    TextSpan(
                                                                      style: TextStyle(
                                                                          fontSize: 13,
                                                                          color: ColorsRes.mainTextColor,
                                                                          decoration: TextDecoration.lineThrough,
                                                                          decorationThickness: 2),
                                                                      text: double.parse(widget.product.variants[index].discountedPrice) != 0
                                                                          ? GeneralMethods.getCurrencyFormat(double.parse(widget.product.variants[index].price))
                                                                          : "",
                                                                    ),
                                                                  ]),
                                                            ),
                                                          ),
                                                          Text(
                                                            double.parse(widget
                                                                .product
                                                                .variants[
                                                            index]
                                                                .discountedPrice) !=
                                                                0
                                                                ? GeneralMethods.getCurrencyFormat(double.parse(widget
                                                                .product
                                                                .variants[
                                                            index]
                                                                .discountedPrice))
                                                                : GeneralMethods.getCurrencyFormat(double.parse(widget
                                                                .product
                                                                .variants[
                                                            index]
                                                                .price)),
                                                            softWrap:
                                                            true,
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontSize:
                                                                17,
                                                                color: ColorsRes
                                                                    .appColor,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    ProductCartButton(
                                                      productId: widget
                                                          .product.id
                                                          .toString(),
                                                      productVariantId:
                                                      widget
                                                          .product
                                                          .variants[
                                                      index]
                                                          .id
                                                          .toString(),
                                                      count: int.parse(widget
                                                          .product
                                                          .variants[
                                                      index]
                                                          .status) ==
                                                          0
                                                          ? -1
                                                          : int.parse(widget
                                                          .product
                                                          .variants[
                                                      index]
                                                          .cartCount),
                                                      isUnlimitedStock: widget
                                                          .product
                                                          .isUnlimitedStock ==
                                                          "1",
                                                      maximumAllowedQuantity:
                                                      double.parse(widget
                                                          .product
                                                          .totalAllowedQuantity
                                                          .toString()),
                                                      availableStock: double
                                                          .parse(widget
                                                          .product
                                                          .variants[
                                                      index]
                                                          .stock),
                                                      isGrid: false,
                                                    ),
                                                  ],
                                                );
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                  int index) {
                                                return Padding(
                                                  padding: EdgeInsets
                                                      .symmetric(
                                                      vertical:
                                                      Constant
                                                          .size7),
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
                            margin: EdgeInsetsDirectional.only(end: 10),
                            decoration: BoxDecoration(
                              borderRadius: Constant.borderRadius5,
                              color: Theme.of(context)
                                  .scaffoldBackgroundColor,
                            ),
                            child: Container(
                              padding: widget.product.variants.length > 1
                                  ? EdgeInsets.zero
                                  : EdgeInsets.all(5),
                              alignment: AlignmentDirectional.center,
                              height: 35,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Spacer(),
                                  Text(
                                    " ${widget.product.variants[0].stockUnitName}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ColorsRes.mainTextColor,
                                    ),
                                  ),
                                  Spacer(),
                                  if (widget.product.variants.length > 1)
                                    Padding(
                                      padding: EdgeInsetsDirectional.only(
                                          start: 5, end: 5),
                                      child: Widgets.defaultImg(
                                        image: "ic_drop_down",
                                        height: 10,
                                        width: 10,
                                        boxFit: BoxFit.cover,
                                        iconColor:
                                        ColorsRes.mainTextColor,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      /*Expanded(
                              child: ProductCartButton(
                                productId: widget.product.id.toString(),
                                productVariantId: widget
                                    .product
                                    .variants[selectedVariantItemProvider
                                        .getSelectedIndex()]
                                    .id
                                    .toString(),
                                count: int.parse(widget
                                            .product
                                            .variants[
                                                selectedVariantItemProvider
                                                    .getSelectedIndex()]
                                            .status) ==
                                        0
                                    ? -1
                                    : int.parse(widget
                                        .product
                                        .variants[selectedVariantItemProvider
                                            .getSelectedIndex()]
                                        .cartCount),
                                isUnlimitedStock:
                                    widget.product.isUnlimitedStock == "1",
                                maximumAllowedQuantity: double.parse(widget
                                    .product.totalAllowedQuantity
                                    .toString()),
                                availableStock: double.parse(widget
                                    .product
                                    .variants[selectedVariantItemProvider
                                        .getSelectedIndex()]
                                    .stock),
                                isGrid: false,
                              ),
                            ),*/
                    ],
                  ),
                ],
              )
                  : const SizedBox.shrink();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Card(
            child: Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Widgets.getSizedBox(
                    height: Constant.size5,
                  ),
                  Text(
                    "Delivery available Across India",
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 17,
                        color: ColorsRes.mainTextColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Widgets.getSizedBox(
                    height: Constant.size5,
                  ),
                  Row(
                    children: [
                      Text(
                        "IN Stock | ",
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.green,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "We Deliver in 3 to 7 working days",
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15,
                            color: ColorsRes.mainTextColor,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  Text(
                    "in all cities districts across india",
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15,
                        color: ColorsRes.mainTextColor,
                        fontWeight: FontWeight.w300),
                  ),
                  Widgets.getSizedBox(
                    height: Constant.size10,
                  ),
                  Text(
                    "Sold by",
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 17,
                        color: ColorsRes.mainTextColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    widget.product.sellerName,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 17,
                        color: ColorsRes.gradient2,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Card(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Description",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 8),
                  showFullDescription
                      ? HtmlWidget(
                    widget.product.description,
                  )
                      : HtmlWidget(
                    _abbreviateDescription(widget.product.description),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          child: Text(
                            showFullDescription ? "View Less" : "View More",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                            WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  // Set transparent background based on button state
                                  if (states.contains(WidgetState.disabled)) {
                                    return Colors
                                        .white; // Make it transparent when disabled
                                  }
                                  return Colors
                                      .white; // Make it transparent otherwise
                                }),
                            side: WidgetStateProperty.resolveWith<BorderSide>(
                                  (Set<WidgetState> states) {
                                // Orange border color
                                return BorderSide(
                                  color: Colors.orange,
                                  width: 1.0, // Border width
                                );
                              },
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              showFullDescription = !showFullDescription;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size5,
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding:
          EdgeInsets.only(left: 10.0, top: 8.0, right: 8.0, bottom: 8.0),
          child: Text(
            "Features & Details",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 5),
          child: Card(
            child: Container(
              padding: const EdgeInsetsDirectional.only(top:10, end: 10, bottom: 10),
              child: HtmlWidget(
                widget.product.features,
                enableCaching: true,
                renderMode: RenderMode.column,
                buildAsync: false,
                textStyle: TextStyle(color: ColorsRes.mainTextColor),
              ),
            ),
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Card(
            child: Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Widgets.getSizedBox(
                    height: Constant.size5,
                  ),
                  Text(
                    "Return Policy",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "This Product is Non-Returnable",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                    textAlign: TextAlign.left,
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, webViewScreen,
                          arguments: getTranslatedValue(
                            context,
                            "lblPolicies",
                          ));
                    },
                    child: Text(
                      "Know More",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blueAccent,
                      ),
                    ),
                  ),
                /*  ElevatedButton(
                    child: ,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                            // Set transparent background based on button state
                            if (states.contains(WidgetState.disabled)) {
                              return Colors.white; // Make it transparent when disabled
                            }
                            return Colors.white; // Make it transparent otherwise
                          }),
                      side: WidgetStateProperty.resolveWith<BorderSide>(
                            (Set<WidgetState> states) {
                          // Orange border color
                          return BorderSide(
                            color: Colors.orange,
                            width: 1.0, // Border width
                          );
                        },
                      ),
                    ),
                    onPressed: () {

                    },
                  )*/
                ],
              ),
            ),
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size5,
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding:
          EdgeInsets.only(left: 10.0, top: 8.0, right: 8.0, bottom: 8.0),
          child: Text(
            "Season's Best Seller",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 5),
          child: Card(
            child: Container(
              margin: const EdgeInsetsDirectional.all(10),
              height: 350,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 2.3,
                    crossAxisSpacing: 1.3,
                    childAspectRatio: 1 / 2,
                    crossAxisCount: 1,
                    mainAxisExtent: 200),
                itemCount: widget.shopByReaginProduct.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset:
                              Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ProductListItemContainer(
                          showHorizontal: true,
                          product: widget.shopByReaginProduct[index],
                          listSimilarProductListItem:
                          widget.shopByReaginProduct,
                        )),
                  );
                },
              ),
            ),
          ),
        ),
        Widgets.getSizedBox(
          height: Constant.size5,
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding:
          EdgeInsets.only(left: 10.0, top: 8.0, right: 8.0, bottom: 8.0),
          child: Text(
            "You might like",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 5),
          child: Card(
            child: Container(
              margin: const EdgeInsetsDirectional.all(10),
              height: 350,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 2.3,
                    crossAxisSpacing: 1.3,
                    childAspectRatio: 1 / 2,
                    crossAxisCount: 1,
                    mainAxisExtent: 200),
                itemCount: widget.listSimilarProductListItem.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset:
                              Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ProductListItemContainer(
                          showHorizontal: true,
                          product: widget.listSimilarProductListItem[index]!,
                          listSimilarProductListItem:
                          widget.listSimilarProductListItem,
                        )),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

double calculateDiscountPercentage(double originalPrice, double discountedPrice) {
  if (originalPrice == 0) return 0;
  return ((originalPrice - discountedPrice) / originalPrice) * 100;
}

String _abbreviateDescription(String description) {
  // Return the first few characters or lines of the description for abbreviation
  // You can customize this logic based on your requirements
  return description.substring(0, 100); // Example: Show first 100 characters
}
