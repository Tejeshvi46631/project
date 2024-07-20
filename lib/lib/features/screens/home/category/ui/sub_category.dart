import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/homeScreenData.dart';
import 'package:egrocer/core/provider/categoryProvider.dart';
import 'package:egrocer/core/provider/homeScreenDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubCategory extends StatefulWidget {
  const SubCategory({super.key});

  @override
  State<SubCategory> createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryListProvider>(
      builder: (context, categoryListProvider, _) {
        List<Category> category = context
            .read<HomeScreenProvider>()
            .homeScreenData
            .category
            .where((e) => e.hasChild == false)
            .toList();
        return categoryListProvider.selectedCategoryIdsList.length > 1
            ? Container(
          margin: EdgeInsets.all(Constant.size10),
          padding: EdgeInsets.all(Constant.size10),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            runSpacing: 5,
            spacing: 5,
            children: List.generate(
              // categoryListProvider.selectedCategoryIdsList.length,
              category.length,
                  (index) {
                return GestureDetector(
                    onTap: () {
                      if (categoryListProvider
                          .selectedCategoryIdsList.length !=
                          index) {
                        categoryListProvider.setCategoryData(
                            index, context);
                      }
                    },
                    child: Text(
                      // "${categoryListProvider.selectedCategoryNamesList[index]}${categoryListProvider.selectedCategoryNamesList.length == (index + 1) ? "" : " > "}"),
                      category[index].name,
                    ));
              },
            ),
          ),
        )
            : const SizedBox.shrink();
      },
    );
  }
}
