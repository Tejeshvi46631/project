import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/model/homeScreenData.dart';
import 'package:egrocer/core/provider/homeScreenDataProvider.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/home/homeScreen/function/home_function.dart';
import 'package:egrocer/features/screens/home/homeScreen/ui/categoryWidget.dart';
import 'package:egrocer/features/screens/home/homeScreen/ui/homeScreenShimer.dart';
import 'package:egrocer/features/screens/home/homeScreen/widget/bannerWidget.dart';
import 'package:egrocer/features/screens/home/homeScreen/widget/offerImagesWidget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeCenterUI extends StatefulWidget {
  final ScrollController scrollController;
  final Map<String, List<String>>? map;

  HomeCenterUI({Key? key, required this.scrollController, this.map})
      : super(key: key);

  @override
  State<HomeCenterUI> createState() => _HomeCenterUIState();
}

class _HomeCenterUIState extends State<HomeCenterUI> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Start a timer to trigger refresh after 1 second (adjust as needed)
    _timer = Timer(Duration(seconds: 1), () {
      _refreshData();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _refreshData() async {
    // Perform data fetching logic here
    Map<String, String> params = await Constant.getProductsDefaultParams();
    await context
        .read<HomeScreenProvider>()
        .getHomeScreenApiProvider(context: context, params: params);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          controller: widget.scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          child: Consumer<HomeScreenProvider>(
            builder: (context, homeScreenProvider, _) {
              return homeScreenProvider.homeScreenState ==
                      HomeScreenState.loaded
                  ? Column(
                      children: [
                        if (homeScreenProvider
                            .homeScreenData.topBanners.isNotEmpty)
                          BannerUi(
                            banner: homeScreenProvider
                                .homeScreenData.topBanners.first,
                            label: "assets/images/banner.png",
                          ),
                        // Below slider offer images
                        if (homeScreenProvider.map.containsKey("below_slider"))
                          getOfferImages(
                              homeScreenProvider.map["below_slider"]!.toList()),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "SHOP BY CATEGORY",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        GridView.builder(
                          padding: EdgeInsets.all(8.0),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 6 / 6,
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: homeScreenProvider.homeScreenData.category
                                      .where((element) => element.hasChild == true)
                                      .toList()
                                      .length > 12
                              ? 12
                              : homeScreenProvider.homeScreenData.category
                                  .where((element) => element.hasChild == true)
                                  .toList()
                                  .length,
                          itemBuilder: (context, index) {
                            final displayIndex = homeScreenProvider.homeScreenData.category
                                .where((element) => element.hasChild == true)
                                .toList()
                                .length - 1 - index;
                            Category category = homeScreenProvider
                                .homeScreenData.category
                                .where((element) => element.hasChild == true)
                                .toList()[displayIndex];
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  productListScreenV2,
                                  arguments: [
                                    category.name,
                                    homeScreenProvider.homeScreenData.sections
                                        .where((element) =>
                                            element.categoryid == category.id)
                                        .toList(),
                                    homeScreenProvider.homeScreenData.sections
                                        .where((element) =>
                                            element.categoryid == category.id)
                                        .toList()
                                        .first
                                        .title,
                                  ],
                                );
                              },
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border:
                                      Border.all(width: 1, color: Colors.white),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: category.imageUrl,
                                    filterQuality: FilterQuality.high,
                                    placeholder: (context, url) => Image.asset(
                                      "assets/images/photoEmpty.jpg",
                                      fit: BoxFit.cover,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: InkWell(
                            onTap: () {
                              launchUrl(
                                  Uri.parse(Platform.isAndroid
                                      ? Constant.playStoreUrl
                                      : Constant.appStoreUrl),
                                  mode: LaunchMode.externalApplication);
                            },
                            child: Container(
                              height: 100,
                              width: double.infinity,
                              child: Image.asset(
                                "assets/images/playstorebanner.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        // Top Banners excluding 1st banner will render here
                        if (homeScreenProvider
                                .homeScreenData.topBanners.length >
                            0)
                          ListView.builder(
                            itemCount: homeScreenProvider
                                    .homeScreenData.topBanners.length -
                                1,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => BannerUi(
                              banner: homeScreenProvider
                                  .homeScreenData.topBanners[index + 1],
                            ),
                          ),
                        HomeScreenCategory.categoryWidget(
                          homeScreenProvider.homeScreenData.category
                              .where((element) => element.hasChild == true)
                              .toList(),
                          sliders: homeScreenProvider.homeScreenData.sliders,
                          sections: homeScreenProvider.homeScreenData.sections,
                          mixWithSliderBanners: homeScreenProvider
                              .homeScreenData.mixWithSliderBanners,
                          context: context,
                        ),
                      ],
                    )
                  : homeScreenProvider.homeScreenState ==
                              HomeScreenState.loading ||
                          homeScreenProvider.homeScreenState ==
                              HomeScreenState.initial
                      ? /*HomeScreenShimmer.getHomeScreenShimmer(context)*/ Container(
                height: 600,
                child: Widgets.defaultImg(image: 'splash', boxFit: BoxFit.cover),
              )
                      : Container();
            },
          ),
        ),
      ),
    );
  }
}
