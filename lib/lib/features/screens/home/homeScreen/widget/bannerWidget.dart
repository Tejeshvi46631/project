import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/model/homeScreenData.dart';
import 'package:egrocer/core/provider/homeScreenDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BannerUi extends StatelessWidget {
  const BannerUi(
      {super.key, required this.banner, this.horizontalPadding = true});

  final BannerModel banner;
  final bool horizontalPadding;

  @override
  Widget build(BuildContext context) {
    var splittedUrl =
        banner.navigateUrl?.replaceAll('/subCategory/', "").split("/");
    var subCategoryId = splittedUrl?.first;
    String? selectedCategory;
    if (splittedUrl?.length == 2) {
      selectedCategory = splittedUrl?[1];
    }
    if (banner.type == 'wholesale') {
      return SizedBox();
    }
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, productListScreenV2, arguments: [
          banner.alt,
          subCategoryId != null
              ? context
                  .read<HomeScreenProvider>()
                  .homeScreenData
                  .sections
                  .where((element) => element.categoryid == subCategoryId)
                  .toList()
              : [],
          selectedCategory?.split("_").last ?? "",
        ]);
      },
      child: SizedBox(
        // height: MediaQuery.of(context).size.height * 0.28,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 10.0, horizontal: horizontalPadding ? 10 : 0),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: ClipRRect(
              borderRadius: Constant.borderRadius10,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.network(
                banner.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
