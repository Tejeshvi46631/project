import 'dart:convert';

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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomeCenterUI extends StatefulWidget {
  Map<String, List<String>> map;
  final ScrollController scrollController;

  HomeCenterUI({super.key, required this.map, required this.scrollController});

  @override
  State<HomeCenterUI> createState() => _HomeCenterUIState();
}

class _HomeCenterUIState extends State<HomeCenterUI> {
  //List<Data> dataList=[];
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: setRefreshIndicator(
        refreshCallback: () async {
          Map<String, String> params =
              await Constant.getProductsDefaultParams();
          return await context
              .read<HomeScreenProvider>()
              .getHomeScreenApiProvider(context: context, params: params)
              .then((homeScreenData) async {
            widget.map =
                await HomeScreenFunction.getSliderImages(homeScreenData);
          });
        },
        child: SingleChildScrollView(
          controller: widget.scrollController,
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
                          ),
                        /* ChangeNotifierProvider<SliderImagesProvider>(
                                    create: (context) => SliderImagesProvider(),
                                    child: SliderImageWidget(
                                      sliders: homeScreenProvider
                                          .homeScreenData.sliders,
                                      sections: homeScreenProvider
                                          .homeScreenData.sections,
                                      category: homeScreenProvider
                                          .homeScreenData.category
                                          .where((element) =>
                                              element.hasChild == true)
                                          .toList(),
                                    ),
                                  ), */
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height * 0.28,
                        //   child: Padding(
                        //     padding: EdgeInsets.all(10.0),
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(10)),
                        //       child: ClipRRect(
                        //         borderRadius: Constant.borderRadius10,
                        //         clipBehavior: Clip.antiAliasWithSaveLayer,
                        //         child: Image.asset(
                        //           'assets/images/Papad Special.jpg',
                        //           fit: BoxFit.cover,
                        //         ),
                        //
                        //         /* Widgets.setNetworkImg(
                        //                                             image: Uri.parse(sliderData.imageUrl).toString(),
                        //                                             boxFit: BoxFit.cover,
                        //                                           ), */
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 10,
                        ),
                        //below slider offer images
                        if (homeScreenProvider.map.containsKey("below_slider"))
                          getOfferImages(
                              homeScreenProvider.map["below_slider"]!.toList()),
                        // CategoryListScreen(scrollController: ScrollController()),
                        // Divider(
                        //   indent: 5,
                        //   endIndent: 5,
                        //   color: Colors.white,
                        // ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("SHOP BY CATEGORY",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700)),
                            )),
                        // Divider(
                        //   indent: 5,
                        //   endIndent: 110,
                        //   color: Colors.white,
                        // ),
                        GridView.builder(
                            padding: EdgeInsets.all(8.0),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 6 / 6,
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            itemCount: homeScreenProvider
                                        .homeScreenData.category
                                        .where((element) =>
                                            element.hasChild == true)
                                        .toList()
                                        .length >
                                    12
                                ? 12
                                : homeScreenProvider.homeScreenData.category
                                    .where(
                                        (element) => element.hasChild == true)
                                    .toList()
                                    .length,
                            itemBuilder: (context, index) {
                              Category category = homeScreenProvider
                                  .homeScreenData.category
                                  .where((element) => element.hasChild == true)
                                  .toList()[index];
                              return InkWell(
                                onTap: () {
                                  print("Category IDD : ${category.id}");
                                  //fetchBanner();
                                  Navigator.pushNamed(
                                      context, productListScreenV2,
                                      arguments: [
                                        // "category",
                                        // category.allActiveChilds
                                        //     .map((e) => e['id'])
                                        //     .first
                                        //     .toString(),
                                        // category.allActiveChilds
                                        //     .map((e) => e['id'])
                                        //     .toList()
                                        //     .join(','),
                                        // category.id.toString(),
                                        category.name,
                                        homeScreenProvider
                                            .homeScreenData.sections
                                            .where((element) =>
                                                element.categoryid ==
                                                category.id)
                                            .toList(),
                                        homeScreenProvider
                                            .homeScreenData.sections
                                            .where((element) =>
                                                element.categoryid ==
                                                category.id)
                                            .toList()
                                            .first
                                            .title
                                      ]);
                                },
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                        width: 1, color: Colors.white),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0)),
                                    child: CachedNetworkImage(
                                      imageUrl: category.imageUrl,
                                      filterQuality: FilterQuality.low,
                                      placeholder: (context, url) =>
                                          Image.asset(
                                              "assets/images/photoEmpty.jpg"),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              );
                            }),
                        //Top Banners excluding 1st banner will render here
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
                                      .homeScreenData.topBanners[index + 1])),
                        HomeScreenCategory.categoryWidget(
                            homeScreenProvider.homeScreenData.category
                                .where((element) => element.hasChild == true)
                                .toList(),
                            sliders: homeScreenProvider.homeScreenData.sliders,
                            sections:
                                homeScreenProvider.homeScreenData.sections,
                            mixWithSliderBanners: homeScreenProvider
                                .homeScreenData.mixWithSliderBanners,
                            context: context)

                        // Container(
                        //   child: CategoryListWidget(
                        //     scrollController: widget.scrollController,
                        //   ),
                        //   constraints: BoxConstraints(maxHeight: 450),
                        // ),
                        //below category offer images
                        // if (map.containsKey("below_category")) getOfferImages(map["below_category"]!.toList()),
                        // sectionWidget(homeScreenProvider.homeScreenData.sections)
                      ],
                    )
                  : (homeScreenProvider.homeScreenState ==
                              HomeScreenState.loading ||
                          homeScreenProvider.homeScreenState ==
                              HomeScreenState.initial)
                      ? HomeScreenShimmer.getHomeScreenShimmer(context)
                      : Container();
            },
          ),
        ),
      ),
    );
  }
  // Future<List<Data>> fetchBanner()
  // async{
  //   try
  //   {
  //     // String userName=txtUserName.text.toString();
  //     // String emailID=txtEmailID.text.toString();
  //     // String password=txtPassword.text.toString();
  //
  //     final Map<String, dynamic> requestData = {
  //       // 'action': 'register_user',
  //       'city_id': '4',
  //       'latitude': '19.7514798',
  //       'longitude': '75.7138884',
  //     };
  //
  //     var request= http.Request("GET",Uri.parse("https://admin.chhayakart.com/customer/shop?").replace(queryParameters: requestData));
  //     http.StreamedResponse response=await request.send();
  //     if(response.statusCode==200)
  //     {
  //
  //       var rawData=await response.stream.bytesToString();
  //       var data=json.decode(rawData);
  //       var result=data['result'];
  //       for(var i in data['data'])
  //       {
  //         Data model=Data.fromJson(i);
  //         dataList.add(model);
  //       }
  //       // print("Data: ${dataList.first.id}");
  //       print(result);
  //     }
  //     // else
  //     // {
  //     //   print(response.reasonPhrase);
  //     //   // return dataList;
  //     // }
  //   }
  //   catch(e)
  //   {
  //     print("Exception $e");
  //     throw e;
  //   }
  //   return dataList;
  // }
}
