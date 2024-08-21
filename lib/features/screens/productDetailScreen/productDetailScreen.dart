import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/model/homeScreenData.dart';
import 'package:egrocer/core/model/productDetail.dart';
import 'package:egrocer/core/model/productListItem.dart';
import 'package:egrocer/core/provider/cartListProvider.dart';
import 'package:egrocer/core/provider/cartProvider.dart';
import 'package:egrocer/core/provider/productDetailProvider.dart';
import 'package:egrocer/core/provider/selectedVariantItemProvider.dart';
import 'package:egrocer/core/repository/facebook_analytics.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/productCartButton.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/productDetailScreen/function/functionCall.dart';
import 'package:egrocer/features/screens/productDetailScreen/ui/otherImagesBoxDecoration.dart';
import 'package:egrocer/features/screens/productDetailScreen/ui/productWidget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ProductDetailScreen extends StatefulWidget {
  final String? title;
  final String id;
  final ProductListItem? productListItem;
  List<ProductListItem?> listSimilarProductListItem = [];
  String? currentSectionID = '';

  ProductDetailScreen(
      {Key? key,
      this.title,
      required this.id,
      this.productListItem,
      this.currentSectionID,
      required this.listSimilarProductListItem})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late int currentImage;
  late int currentVideos;
  bool isVideo = false;
  late List<String> images;
  bool descTextShowFlag = false;
  YoutubePlayerController? youtubeVideoController;
  List<Sections?> shopByResionSections = [];
  List<ProductListItem> shopByReaginProduct = [];
  List<ProductListItem> similarProductList = [];
  List<String> videos = [
    "https://www.youtube.com/watch?v=B_yf5Z_hRCU",
    "https://www.youtube.com/watch?v=IapgfyZugy4",
  ];

  @override
  void initState() {
    super.initState();
    //fetch productList from api
    _fbViewContentEvent();
    Future.delayed(Duration.zero).then((value) async {
      Map<String, String> params = await Constant.getProductsDefaultParams();
      params[ApiAndParams.id] = widget.id;

      await context
          .read<ProductDetailProvider>()
          .getProductDetailProvider(context: context, params: params)
          .then((value) async {
        if (value) {
          currentImage = 0;
          currentVideos = 0;
          setOtherImages(currentImage,
              context.read<ProductDetailProvider>().productDetail!.data);
          ProductDetailFunction.setOtherVideo(
              currentVideos,
              context.read<ProductDetailProvider>().productDetail!.data,
              currentVideos,
              videos,
              context);

          shopByResionSections = Constant.gSections
              .where((element) => element.categoryid == "166")
              .toList();
          shopByReaginProduct = shopByResionSections
              .expand((section) => section!.products)
              .toList();
          similarProductList = Constant.gSections
              .where((e) => e.id == widget.currentSectionID)
              .expand((section) => section.products)
              .toList();
          // shopByResionSections.expand((e) => e?.products).toLis() ;
          setState(() {});
          print("Video List========>");
          print(shopByResionSections);
          print(shopByReaginProduct);
        }
      });
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: Text(
          widget.title ?? getTranslatedValue(context, "lblProducts"),
          softWrap: true,
          //style: TextStyle(color: ColorsRes.mainTextColor),
        ),
        actions: [
          setCartCounter(context: context),
        ],
      ),
      body: Stack(
        children: [
          Consumer<ProductDetailProvider>(
            builder: (context, productDetailProvider, child) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        productDetailProvider.productDetailState ==
                                ProductDetailState.loaded
                            ? ChangeNotifierProvider<
                                    SelectedVariantItemProvider>(
                                create: (context) =>
                                    SelectedVariantItemProvider(),
                                child: ProductDetailWidget(
                                  currentImage: currentImage,
                                  currentVideos: currentVideos,
                                  isVideo: isVideo,
                                  product:
                                      productDetailProvider.productDetail!.data,
                                  youtubeVideoController:
                                      youtubeVideoController,
                                  videos: videos,
                                  productListItem: widget.productListItem,
                                  listSimilarProductListItem:
                                      widget.listSimilarProductListItem,
                                  descTextShowFlag: descTextShowFlag,
                                  shopByReaginProduct: shopByReaginProduct,
                                  image: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Constant.size10,
                                        horizontal: Constant.size10),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (isVideo == false)
                                          Navigator.pushNamed(context,
                                              fullScreenProductImageScreen,
                                              arguments: [
                                                currentImage,
                                                images,
                                                isVideo
                                              ]);
                                      },
                                      child:
                                          Consumer<SelectedVariantItemProvider>(
                                        builder: (context,
                                            selectedVariantItemProvider,
                                            child) {
                                          print(
                                              'Product ID: ${widget.id.toString()}');
                                          print(
                                              'Product Variant ID: ${widget.productListItem!.variants.first.id}');
                                          print(
                                              'Count: ${int.parse(widget.productListItem!.variants.first.status.toString()) == 0 ? -1 : int.parse(widget.productListItem!.variants.first.cartCount)}');
                                          print(
                                              'Is Unlimited Stock: ${widget.productListItem!.isUnlimitedStock == "1"}');
                                          print(
                                              'Maximum Allowed Quantity: ${double.parse(widget.productListItem!.totalAllowedQuantity)}');
                                          print(
                                              'Available Stock: ${double.parse(widget.productListItem!.variants.first.stock)}');
                                          print('Is Grid: ${false}');
                                          return isVideo == false
                                              ? Stack(
                                                  children: [
                                                    ClipRRect(
                                                        borderRadius: Constant
                                                            .borderRadius10,
                                                        clipBehavior: Clip
                                                            .antiAliasWithSaveLayer,
                                                        child: Widgets
                                                            .setNetworkImg(
                                                          boxFit: BoxFit.fill,
                                                          image: images[
                                                              currentImage],
                                                          height: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                        )),
                                                    if (productDetailProvider
                                                            .productDetail!
                                                            .data
                                                            .variants[
                                                                selectedVariantItemProvider
                                                                    .getSelectedIndex()]
                                                            .status ==
                                                        "0")
                                                      PositionedDirectional(
                                                          top: 0,
                                                          end: 0,
                                                          start: 0,
                                                          bottom: 0,
                                                          child: getOutOfStockWidget(
                                                              height:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              context:
                                                                  context)),
                                                    PositionedDirectional(
                                                        bottom: 5,
                                                        end: 5,
                                                        child: Column(
                                                          children: [
                                                            if (productDetailProvider
                                                                    .productDetail!
                                                                    .data
                                                                    .indicator ==
                                                                1)
                                                              Widgets.defaultImg(
                                                                  height: 35,
                                                                  width: 35,
                                                                  image:
                                                                      "veg_indicator"),
                                                            if (productDetailProvider
                                                                    .productDetail!
                                                                    .data
                                                                    .indicator ==
                                                                2)
                                                              Widgets.defaultImg(
                                                                  height: 35,
                                                                  width: 35,
                                                                  image:
                                                                      "non_veg_indicator"),
                                                          ],
                                                        )),
                                                  ],
                                                )
                                              : Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: Constant
                                                          .borderRadius10,
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      child:
                                                          youtubeVideoController !=
                                                                  null
                                                              ? YoutubePlayer(
                                                                  controller:
                                                                      youtubeVideoController!,
                                                                  showVideoProgressIndicator:
                                                                      true,
                                                                  onReady: () {
                                                                    // Perform any actions when the video is ready to play
                                                                  },
                                                                  onEnded:
                                                                      (YoutubeMetaData
                                                                          metaData) {
                                                                    // Perform any actions when the video ends
                                                                  },
                                                                )
                                                              : SizedBox(),

                                                      /* idgets.setNetworkImg(
                          boxFit: BoxFit.fill,
                          image: images[currentImage],
                          height: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width,
                        ) */
                                                    ),
                                                    if (productDetailProvider
                                                            .productDetail
                                                            .data!
                                                            .productDetailvariants[
                                                                selectedVariantItemProvider
                                                                    .getSelectedIndex()]
                                                            .status ==
                                                        "0")
                                                      PositionedDirectional(
                                                          top: 0,
                                                          end: 0,
                                                          start: 0,
                                                          bottom: 0,
                                                          child: getOutOfStockWidget(
                                                              height:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              context:
                                                                  context)),
                                                    PositionedDirectional(
                                                        bottom: 5,
                                                        end: 5,
                                                        child: Column(
                                                          children: [
                                                            if (productDetailProvider
                                                                    .productDetail
                                                                    .product
                                                                    .indicator ==
                                                                1)
                                                              Widgets.defaultImg(
                                                                  height: 35,
                                                                  width: 35,
                                                                  image:
                                                                      "veg_indicator"),
                                                            if (productDetailProvider
                                                                    .productDetail
                                                                    .product
                                                                    .indicator ==
                                                                2)
                                                              Widgets.defaultImg(
                                                                  height: 35,
                                                                  width: 35,
                                                                  image:
                                                                      "non_veg_indicator"),
                                                          ],
                                                        )),
                                                  ],
                                                );
                                        },
                                      ),
                                    ),
                                  ),
                                  imageList: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(children: [
                                      ...List.generate(
                                          images.length > 1 ? images.length : 0,
                                          (index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              currentImage = index;
                                              isVideo = false;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Container(
                                              decoration:
                                                  getOtherImagesBoxDecoration(
                                                      isActive: currentImage ==
                                                          (index)),
                                              child: ClipRRect(
                                                borderRadius:
                                                    Constant.borderRadius13,
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                child: Widgets.setNetworkImg(
                                                  height: 60,
                                                  width: 60,
                                                  image: images[index],
                                                  boxFit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                      /*  ...List.generate(
                                      videos.length > 0 ? videos.length : 0,
                                      (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          currentVideos = index;
                                          isVideo = true;
                                          print("You Tube Player ID");
                                          print(videos[currentVideos]
                                              .getYouTubeVideoId());
                                          if (youtubeVideoController != null) {
                                            print("Intisilizetion Called");
                                            youtubeVideoController!.load(
                                                videos[currentVideos]
                                                    .getYouTubeVideoId());
                                          } else {
                                            youtubeVideoController =
                                                YoutubePlayerController(
                                                    initialVideoId: videos[
                                                            currentVideos]
                                                        .getYouTubeVideoId());
                                          }

                                          // videos[currentVideos];
                                          // youtubeVideoController =
                                          //     getcontroller(videos[currentVideos]);
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Container(
                                          height: 60.0,
                                          width: 60.0,
                                          decoration:
                                              getOtherImagesBoxDecoration(
                                                  isActive:
                                                      currentVideos == index),
                                          child: ClipRRect(
                                            borderRadius:
                                                Constant.borderRadius13,
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            child: Icon(
                                              Icons.play_arrow_outlined,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),*/
                                    ]),
                                  ),
                                ))
                            : productDetailProvider.productDetailState ==
                                    ProductDetailState.loading
                                ? ProductDetailFunction.getProductDetailShimmer(
                                    context: context)
                                : const SizedBox.shrink(),
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ChangeNotifierProvider<
                    SelectedVariantItemProvider>(
              create: (context) =>
              SelectedVariantItemProvider(),
              child:  Consumer<SelectedVariantItemProvider>(
                        builder: (context, selectedVariantItemProvider, child) {
                          return ProductRow(
                            productId: widget.id.toString(),
                            productVariantId: widget
                                .productListItem!
                                .variants[
                            selectedVariantItemProvider.getSelectedIndex()]
                                .id
                                .toString(),
                            count: int.parse(widget
                                .productListItem!
                                .variants[selectedVariantItemProvider
                                .getSelectedIndex()]
                                .status) ==
                                0
                                ? -1
                                : int.parse(widget
                                .productListItem!
                                .variants[selectedVariantItemProvider
                                .getSelectedIndex()]
                                .cartCount),
                            isUnlimitedStock:
                            widget.productListItem!.isUnlimitedStock == "1",
                            maximumAllowedQuantity: double.parse(widget
                                .productListItem!.totalAllowedQuantity
                                .toString()),
                            availableStock: double.parse(widget
                                .productListItem!
                                .variants[
                            selectedVariantItemProvider.getSelectedIndex()]
                                .stock),
                          );
                        }),
                  ),),
                ],
              );
            },
          ),
          PositionedDirectional(
            top: 0,
            end: 0,
            start: 0,
            bottom: 0,
            child: Consumer<CartListProvider>(
              builder: (context, cartListProvider, child) {
                return cartListProvider.cartListState == CartListState.loading
                    ? Container(
                        color: Colors.black.withOpacity(0.2),
                        child: const Center(child: CircularProgressIndicator()))
                    : const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  setOtherImages(int currentIndex, ProductData product) {
    currentImage = 0;
    images = [];
    // images.add(product.imageUrl);
    if (product.variants[currentIndex].images.isNotEmpty) {
      images.addAll(product.variants[currentIndex].images);
    } else {
      images.addAll(product.images);
    }
    context.read<ProductDetailProvider>().notify();
  }

  void _fbViewContentEvent() {
    try {
      FacebookAnalytics.viewContent(id: widget.id, content: {
        'name': widget.productListItem?.name ?? '',
        if ((widget.productListItem?.variants ?? []).isNotEmpty)
          'price': widget.productListItem?.variants.first.discountedPrice,
        'category_id': widget.productListItem?.categoryId
      });
    } catch (e) {}
  }
}

class ProductRow extends StatelessWidget {
  final String productId;
  final String productVariantId;
  final int count;
  final bool isUnlimitedStock;
  final double maximumAllowedQuantity;
  final double availableStock;

  ProductRow({
    required this.productId,
    required this.productVariantId,
    required this.count,
    required this.isUnlimitedStock,
    required this.maximumAllowedQuantity,
    required this.availableStock,
  });

  Future<void> _openWhatsApp() async {
    const whatsappNumber = "+919420920320";
    final url = "https://wa.me/$whatsappNumber";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        color: Colors.white,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: ProductCartButton(
              productId: productId,
              productVariantId: productVariantId,
              count: count,
              isUnlimitedStock: isUnlimitedStock,
              maximumAllowedQuantity: maximumAllowedQuantity,
              availableStock: availableStock,
              isGrid: false,
            )),
            SizedBox(width: 5),
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.whatsapp,
                size: 32,
              ),
              // Using WhatsApp icon from font_awesome_flutter
              color: Colors.green,
              onPressed: _openWhatsApp,
            ),
            SizedBox(width: 5),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 7.0,), // Optional: Adjusts margin around the container// Optional: Adjusts padding inside the container
                decoration: BoxDecoration(
                  color: Colors.green, // Optional: Background color of the container
                  borderRadius: BorderRadius.circular(8.0), // Optional: Rounded corners of the container
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Changes position of shadow
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () async {
                    final cartProvider = context.read<CartProvider>();
                    final cartListProvider = context.read<CartListProvider>();

                    if (Constant.session.isUserLoggedIn()) {
                      // Check if the product is already in the cart
                      int currentQuantity = int.parse(cartListProvider.getItemCartItemQuantity(productId, productVariantId));

                      if (currentQuantity > 0) {
                        // Show message that the product is already added
                        // Calculate discountedAmount after adding to cart
                        double discountedAmount = cartProvider.calculateDiscountedAmount(cartProvider.cartData);
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        pref.setDouble("discountedAmount", discountedAmount);

                        // Set discountedAmount in CartProvider
                        cartProvider.discountedAmount = discountedAmount;

                        // Navigate to checkout screen
                        Navigator.pushNamed(context, checkoutScreen, arguments: cartProvider.cartData);
                      } else {
                        // Proceed to add product to cart
                        Map<String, String> params = {};
                        params[ApiAndParams.productId] = productId;
                        params[ApiAndParams.productVariantId] = productVariantId;
                        params[ApiAndParams.qty] = "1"; // Adding only one unit for now

                        await cartListProvider.addRemoveCartItem(
                          context: context,
                          params: params,
                          isUnlimitedStock: isUnlimitedStock,
                          maximumAllowedQuantity: maximumAllowedQuantity,
                          availableStock: availableStock,
                          actionFor: "add",
                          from: "from",
                        );

                        // Calculate discountedAmount after adding to cart
                        double discountedAmount = cartProvider.calculateDiscountedAmount(cartProvider.cartData);
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        pref.setDouble("discountedAmount", discountedAmount);

                        // Set discountedAmount in CartProvider
                        cartProvider.discountedAmount = discountedAmount;

                        // Navigate to checkout screen
                        Navigator.pushNamed(context, checkoutScreen, arguments: cartProvider.cartData);
                      }
                    } else {
                      // User not logged in, show login message
                      GeneralMethods.showSnackBarMsg(
                        context,
                        getTranslatedValue(context, "lblRequiredLoginMessageForCart"),
                        requiredAction: true,
                        onPressed: () {
                          Navigator.pushNamed(context, loginScreen);
                        },
                      );
                    }

                  },
                  child: Center(
                    child: Text("Buy Now",style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
