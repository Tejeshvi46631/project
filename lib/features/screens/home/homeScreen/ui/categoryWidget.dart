import 'package:cached_network_image/cached_network_image.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/model/homeScreenData.dart';
import 'package:egrocer/core/provider/sliderImagesProvider.dart';
import 'package:egrocer/features/screens/home/homeScreen/widget/bannerWidget.dart';
import 'package:egrocer/features/screens/home/homeScreen/widget/sliderImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreenCategory {
  static Widget categoryWidget(List<Category> categories,
      {List<Sliders>? sliders,
      List<Sections>? sections,
      List<BannerModel> mixWithSliderBanners = const [],
      int? catID,
      required BuildContext context}) {
    print("Category widget call==================================*#====>");
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
            color: Theme.of(context).cardColor,
            elevation: 0,
            margin: EdgeInsetsDirectional.only(
                start: Constant.size10,
                end: Constant.size10,
                top: Constant.size10,
                bottom: Constant.size5),
            child:
                //  GridView.builder(
                ListView.builder(
              itemCount: categories.length,
              /*  Constant.homeCategoryMaxLength == 0
                  ? categories.length
                  : categories.length >= Constant.homeCategoryMaxLength
                      ? Constant.homeCategoryMaxLength
                      : categories.length, */
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                Category _category = categories[index];
                List<Sections> _sections = sections
                        ?.where((element) =>
                            element.categoryid == _category.id.toString())
                        .toList() ??
                    [];

                if (_category.hasChild) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        _category.name,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GridView.builder(
                        //padding: EdgeInsets.all(8.0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 6 / 7.5,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 0),
                        itemCount: _sections.length,
                        // category.allActiveChilds.length,
                        itemBuilder: (context, index) {
                          /*  dev.log(_sections[index].id,
                                  name: "Sub Category ID: ");
                              dev.log(_sections[index].title,
                                  name: "Sub Category : "); */
                          /* String subCatImage = category.allActiveChilds
                                  .where((element) =>
                                      element['name']
                                          .toString()
                                          .toLowerCase() ==
                                      _sections[index].title.toLowerCase())
                                  .first['image_url'];

                              dev.log(subCatImage,
                                  name: "Sub Category Image : "); */
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  print("Category ID : " +
                                      _category.id.toString());
                                  Navigator.pushNamed(
                                      context, productListScreenV2,
                                      arguments: [
                                        // "category",
                                        // category.allActiveChilds[index]
                                        //         ['id']
                                        //     .toString(),

                                        // category.id.toString(),
                                        _category.name,
                                        _sections,
                                        _sections[index].title,
                                        print("list ${_sections.toList()}"),
                                        print("index tile ${_sections[index].title}"),
                                        print("index tilename ${_category.name}")
                                        /*  sections
                                                ?.where((element) =>
                                                    element.categoryid ==
                                                    category.id.toString())
                                                .toList() */
                                      ]);
                                },
                                child: Container(
                                  // height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                        width: 1, color: Colors.white),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 170,
                                        // height: 150,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0)),
                                          child: CachedNetworkImage(
                                            imageUrl: _category.allActiveChilds
                                                .where((element) =>
                                            element['name']
                                                .toString()
                                                .toLowerCase() ==
                                                _sections[index]
                                                    .title
                                                    .toLowerCase())
                                                .first['image_url'],
                                            filterQuality: FilterQuality.low,
                                            fit: BoxFit.contain,
                                            placeholder: (context, url) =>
                                                Image.asset(
                                                    "assets/images/photoEmpty.jpg"),
                                            errorWidget:
                                                (context, url, error) =>
                                                Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        /*  category.allActiveChilds[index]
                                                    ['name'] */
                                        _sections[index].title,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            overflow: TextOverflow.fade),
                                        maxLines: 2,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      if ((mixWithSliderBanners.length - 1) >= (index * 2))
                        BannerUi(
                          banner: mixWithSliderBanners[index * 2],
                          horizontalPadding: false,
                        ),
                      if (sliders != null &&
                          // sliders
                          //         .where((element) =>
                          //             ((element.type == "category") &&
                          //                 (category.allActiveChilds
                          //                     .map((element2) {
                          //                       return element2['id'];
                          //                     })
                          //                     .toList()
                          //                     .contains(element.typeId))))
                          //         .toList()
                          //         .length >
                          //     1
                          sliders
                                  .where((slider) {
                                    return slider.type == "category" &&
                                        _category.allActiveChilds.any((child) =>
                                            child["id"].toString() ==
                                            slider.typeId.toString());
                                  })
                                  .toList()
                                  .length >
                              0)
                        ChangeNotifierProvider<SliderImagesProvider>(
                          create: (context) => SliderImagesProvider(),
                          child: SliderImageWidget(
                            sliders: sliders.where((slider) {
                              return slider.type == "category" &&
                                  _category.allActiveChilds.any((child) =>
                                      child["id"].toString() ==
                                      slider.typeId.toString());
                            }).toList(),
                            sections: _sections,

                            /* sliders
                                .where((element) =>
                                    ((element.type == "category") &&
                                        category.allActiveChilds
                                            .map((element2) => element2['id'])
                                            .toList()
                                            .contains(element.typeId)
                                    //  element.typeId.contains()
                                    // (element.typeId == category.id.toString())

                                    ))
                                .toList(), */
                          ),
                        ),
                      if ((mixWithSliderBanners.length - 1) >= (index * 2 + 1))
                        BannerUi(
                          banner: mixWithSliderBanners[index * 2 + 1],
                          horizontalPadding: false,
                        ),
                    ],
                  );

                  /*   ExpansionTile(
                      title: Text(category.name),
                      subtitle: Text(category.subtitle),
                      controlAffinity: ListTileControlAffinity.leading,
                      children: <Widget>[
                        ...category.allActiveChilds
                            .map((e) => ListTile(
                                  title: Text(e["name"]),
                                ))
                            .toList()
                      ]

                      ); */
                } else {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(_category.name),
                        subtitle: Text(_category.subtitle),
                      ),
                      if (sliders != null)
                        ChangeNotifierProvider<SliderImagesProvider>(
                          create: (context) => SliderImagesProvider(),
                          child: SliderImageWidget(
                            sliders: sliders
                                .where((element) =>
                                    ((element.type == "category") &&
                                        (element.typeId ==
                                            _category.id.toString())))
                                .toList(),
                            sections: sections!,
                          ),
                        ),
                    ],
                  );
                  // return CategoryItemContainer(
                  //     category: category,
                  //     voidCallBack: () {
                  //       Navigator.pushNamed(context, productListScreen,
                  //           arguments: [
                  //             "category",
                  //             category.id.toString(),
                  //             category.name
                  //           ]);
                  //     });
                }
              },
              /*  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.8,
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10), */
            ))
      ],
    );
  }
}
