import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/provider/homeScreenDataProvider.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


/*class CategoryListScreen extends StatefulWidget {

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
}*/

class CategoryListScreen extends StatefulWidget {
  final ScrollController scrollController;

  const CategoryListScreen({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  String _selectedIndexTitle = "";

  var filteredCategories;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    final provider = context.read<HomeScreenProvider>();
    Map<String, String> params = await Constant.getProductsDefaultParams();
    await provider
        .getHomeScreenApiProvider(context: context, params: params)
        .then((_) {
      setState(() {
        // Filter and limit the categories to the first 12 that have hasChild == true
        filteredCategories = provider.homeScreenData.category
            .where((element) => element.hasChild == true)
            .toList()
            .reversed
            .toList();

        // Initialize the TabController with the length of the filtered categories
        _tabController = TabController(
          length: filteredCategories.length,
          vsync: this,
        );

        // Initialize the selected index title
        if (filteredCategories.isNotEmpty) {
          _selectedIndexTitle = filteredCategories[0].name;
        }

        // Add listener to update the title based on the selected tab
        _tabController!.addListener(() {
          setState(() {
            _selectedIndexTitle =
                filteredCategories[_tabController!.index].name;
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _tabController?.dispose(); // Properly dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        showBackButton: false,
        title: Text(
          getTranslatedValue(context, "lblCategories"),
        ),
        actions: [
          setCartCounter(context: context),
          setNotificationCounter(context: context),
        ],
      ),
      body: Column(
        children: [
          getSearchWidget(context: context),
          Expanded(
            child: Consumer<HomeScreenProvider>(
              builder: (context, homeScreenProvider, _) {
                if (_tabController == null) {
                  // Show loading or any fallback UI while the TabController is not initialized
                  return Center(child: CircularProgressIndicator());
                }

                // Assuming filteredCategories is defined outside the builder method
                final filteredCategories = homeScreenProvider
                    .homeScreenData.category
                    .where((element) => element.hasChild == true)
                    .toList()
                    .reversed
                    .toList();

                return Row(
                  children: [
                    Container(
                      width: 100, // Width for the vertical tabs
                      child: SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                            filteredCategories.length,
                                (index) {
                              // Reverse the index for display
                              /*final displayIndex = filteredCategories.length - 1 - index;*/
                              final section = filteredCategories[index];
                              final bool isSelected = _tabController!.index == index;
                              final Color color = isSelected ? Colors.orange[200]! : Colors.transparent;

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _tabController!.index = index;
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: index == 0 ? 16 : 0,
                                    bottom: 16.0,
                                  ),
                                  child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(12.0),
                                        bottomRight: Radius.circular(12.0),
                                      ),
                                      side: BorderSide(color: color),
                                    ),
                                    child: Container(
                                      color: isSelected ? Colors.grey[200] : Colors.transparent,
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                              child: Widgets.setNetworkImg(
                                                boxFit: BoxFit.cover,
                                                image: section.imageUrl,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 2,),
                                          Center(
                                            child: Text(
                                              section.name,
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: isSelected
                                                    ? Colors.black
                                                    : Colors.black.withOpacity(0.6),
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              height: 60,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black54,
                                  width: 0.7, // Border width
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _selectedIndexTitle,
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_outlined,
                                    // Use the right arrow icon
                                    color: Colors.orange, // Icon color
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: _tabController,
                              children: filteredCategories.map((category) {
                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: category.allActiveChilds
                                      .where((child) => child['name'] != 'DIWALI KITS')
                                      .length,
                                  itemBuilder: (context, index) {
                                    final childCategory = category.allActiveChilds
                                        .where((child) => child['name'] != 'DIWALI KITS')
                                        .toList()[index];
                                    final filteredSections = homeScreenProvider.homeScreenData.sections
                                        .where((element) => element.categoryid == category.id)
                                        .toList();
                                    final firstSectionTitle = filteredSections.isNotEmpty ? filteredSections.first.title : '';

                                    return InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          productListScreenV2,
                                          arguments: [
                                            childCategory['name'],
                                            filteredSections,
                                            firstSectionTitle,
                                          ],
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                          height: 60,
                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                          alignment: Alignment.centerLeft,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black54,
                                              width: 0.5, // Border width
                                            ),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                height: 50,
                                                width: 50,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                                  child: Widgets.setNetworkImg(
                                                    boxFit: BoxFit.cover,
                                                    image: childCategory['image_url'],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10), // Add some space between image and text
                                              Expanded(
                                                child: Text(
                                                  childCategory['name'],
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios_outlined,
                                                color: Colors.orange, // Icon color
                                                size: 24,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
