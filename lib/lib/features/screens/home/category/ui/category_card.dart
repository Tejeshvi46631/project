import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/model/homeScreenData.dart';
import 'package:egrocer/core/provider/categoryProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/home/category/ui/categoryItemContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryHomeWidget extends StatefulWidget {
  const CategoryHomeWidget({super.key});

  @override
  State<CategoryHomeWidget> createState() => _CategoryHomeWidgetState();
}

class _CategoryHomeWidgetState extends State<CategoryHomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer<CategoryListProvider>(
          builder: (context, categoryListProvider, _) {
            if (categoryListProvider.categoryState == CategoryState.loaded) {
              return Card(
                color: Theme.of(context).cardColor,
                elevation: 0,
                margin: EdgeInsets.symmetric(
                    horizontal: Constant.size10, vertical: Constant.size10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (categoryListProvider.selectedCategoryIdsList.length > 1)
                      GestureDetector(
                        onTap: () {
                          categoryListProvider.removeLastCategoryData();
                        },
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(
                            top: 15,
                            start: 15,
                            bottom: 5,
                          ),
                          child: SizedBox(
                            child: Widgets.defaultImg(
                              image: "ic_arrow_back",
                              iconColor: ColorsRes.mainTextColor,
                            ),
                            height: 18,
                            width: 18,
                          ),
                        ),
                      ),
                    GridView.builder(
                      itemCount: categoryListProvider.categories
                          .where((element) => element.hasChild == false)
                          .toList()
                          .length,
                      padding: EdgeInsets.symmetric(
                          horizontal: Constant.size10,
                          vertical: Constant.size10),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        Category category = categoryListProvider.categories
                            .where((element) => element.hasChild == false)
                            .toList()[index];
                        // categoryListProvider.categories[index];

                        categoryListProvider.subCategoriesList[
                            categoryListProvider.selectedCategoryIdsList[
                                categoryListProvider
                                        .selectedCategoryIdsList.length -
                                    1]] = categoryListProvider.categories;
                        return CategoryItemContainer(
                          category: category,
                          voidCallBack: () {
                            if (category.hasChild) {
                              addItemsInCategorySequenceList(category)
                                  .then((value) {
                                Map<String, String> params = {};
                                params[ApiAndParams.categoryId] =
                                    category.id.toString();

                                context
                                    .read<CategoryListProvider>()
                                    .getCategoryApiProvider(
                                        context: context, params: params);
                              });
                            } else {
                              Navigator.pushNamed(context, productListScreen,
                                  arguments: [
                                    "category",
                                    category.id.toString(),
                                    category.name
                                  ]);
                            }
                          },
                        );
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 0.8,
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10),
                    ),
                  ],
                ),
              );
            } else {
              return categoryListProvider.categoryState == CategoryState.loading
                  ? getCategoryShimmer(context: context, count: 9)
                  : const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }

  Future addItemsInCategorySequenceList(Category category) async {
    if (context.read<CategoryListProvider>().selectedCategoryIdsList.length <=
        0) {
      context.read<CategoryListProvider>().selectedCategoryIdsList.add("0");
      context
          .read<CategoryListProvider>()
          .selectedCategoryNamesList
          .add(getTranslatedValue(context, "lblAll"));

      context
          .read<CategoryListProvider>()
          .selectedCategoryIdsList
          .add(category.id.toString());
      context
          .read<CategoryListProvider>()
          .selectedCategoryNamesList
          .add(category.name);
    } else {
      context
          .read<CategoryListProvider>()
          .selectedCategoryIdsList
          .add(category.id.toString());
      context
          .read<CategoryListProvider>()
          .selectedCategoryNamesList
          .add(category.name);
    }
  }
}
