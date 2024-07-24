import 'package:cached_network_image/cached_network_image.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/model/homeScreenData.dart';
import 'package:egrocer/core/provider/homeScreenDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BannerUi extends StatelessWidget {
  const BannerUi({
    Key? key,
    required this.banner,
    this.horizontalPadding = true,
  }) : super(key: key);

  final BannerModel banner;
  final bool horizontalPadding;

  @override
  Widget build(BuildContext context) {
    var splittedUrl = banner.navigateUrl?.replaceAll('/subCategory/', "").split("/");
    var subCategoryId = splittedUrl?.first;

    print("View all Split: $subCategoryId");

    String? selectedCategory;
    if (splittedUrl?.length == 2) {
      selectedCategory = splittedUrl?[1];
    }
    if (banner.type == 'wholesale') {
      return SizedBox();
    }

    return InkWell(
      onTap: () {
        final sectionsList = subCategoryId != null
            ? context
            .read<HomeScreenProvider>()
            .homeScreenData
            .sections.where((element) => element.categoryid == subCategoryId)
            .toList()
            : [];

        // Debugging prints
        print("SubCategoryId: $subCategoryId");
        print("Sections List: $sectionsList");

        Navigator.pushNamed(context, productListScreenV2, arguments: [
          banner.alt,
          sectionsList,
          selectedCategory?.split("_").last ?? "",
        ]);
      },
      child: SizedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 10.0, horizontal: horizontalPadding ? 10 : 0),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: ClipRRect(
              borderRadius: Constant.borderRadius10,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: CachedNetworkImage(
                imageUrl: banner.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.image_rounded),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

