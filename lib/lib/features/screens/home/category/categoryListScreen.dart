import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/provider/categoryProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/home/category/ui/category_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryListScreen extends StatefulWidget {
  final ScrollController scrollController;

  const CategoryListScreen({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  @override
  void initState() {
    super.initState();
    //fetch categoryList from api
    Future.delayed(Duration.zero).then((value) {
      context.read<CategoryListProvider>().selectedCategoryIdsList = ["0"];
      context.read<CategoryListProvider>().selectedCategoryNamesList = [
        getTranslatedValue(
          context,
          "lblAll",
        )
      ];

      Map<String, String> params = {};
      params[ApiAndParams.categoryId] = context
              .read<CategoryListProvider>()
              .selectedCategoryIdsList[
          context.read<CategoryListProvider>().selectedCategoryIdsList.length -
              1];

      context
          .read<CategoryListProvider>()
          .getCategoryApiProvider(context: context, params: params);
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
        showBackButton: false,
        title: Text(
          getTranslatedValue(
            context,
            "lblCategories",
          ),
          //style: TextStyle(color: ColorsRes.mainTextColor),
        ),
        actions: [
          setCartCounter(context: context),
          setNotificationCounter(context: context),
        ],
      ),
      body: Column(
        children: [
          getSearchWidget(
            context: context,
          ),
          Expanded(
            child: setRefreshIndicator(
              refreshCallback: () {
                Map<String, String> params = {};
                params[ApiAndParams.categoryId] = context
                    .read<CategoryListProvider>()
                    .selectedCategoryIdsList[context
                        .read<CategoryListProvider>()
                        .selectedCategoryIdsList
                        .length -
                    1];

                return context
                    .read<CategoryListProvider>()
                    .getCategoryApiProvider(context: context, params: params);
              },
              child: ListView(
                children: [
                  // subCategorySequenceWidget(),

                  CategoryHomeWidget()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



}
