import 'dart:convert';

import 'package:egrocer/core/model/homeScreenData.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/productListItemContainer.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProductListScreenV2 extends StatefulWidget {
  String title;
  List<Sections> sections;
  String currentSubCategory;
  ProductListScreenV2(
      {super.key,
      required this.title,
      required this.sections,
      this.currentSubCategory = ''});

  @override
  State<ProductListScreenV2> createState() => _ProductListScreenV2State();
}

class _ProductListScreenV2State extends State<ProductListScreenV2> {

  @override
  Widget build(BuildContext context) {
    print("View Sesctions ${widget.sections.indexWhere((element) => element.title == widget.currentSubCategory)}");
    print("View Sesctions one${jsonEncode(widget.sections)}");
    return DefaultTabController(
      length: widget.sections.length,
      initialIndex: widget.sections.indexWhere(
                  (element) => element.title == widget.currentSubCategory) !=
              -1
          ? widget.sections.indexWhere(
              (element) => element.title == widget.currentSubCategory)
          : 0,
      child: Scaffold(
        appBar: getAppBar(
          context: context,
          title: Container(
            height: 50,
            margin: EdgeInsets.only(bottom: 10),
            child: Image.asset(
              "assets/images/chhayakart-white-logo.png",
              fit: BoxFit.fill,
            ),
          ),
          actions: [
            setCartCounter(context: context),
            setNotificationCounter(context: context)
          ],
          bottom: TabBar(
            indicatorColor: Colors.transparent,
            labelColor: Colors.black,
            labelPadding:EdgeInsets.fromLTRB(4, 0, 4,0),
            unselectedLabelColor: Colors.black,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white),
            //Theme.of(context).cardColor,
            tabs: widget.sections
                .map(
                  (e) => Container(
                    width: 110,
                    height: 40,
                    child: Tab(
                      text: e.title,
                    ),
                  ),
                )
                .toList(),
            labelStyle: TextStyle(fontSize: 13),
            padding: EdgeInsets.fromLTRB(4, 0, 4,8),
            isScrollable: true,
          ),
          appBarLeading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              )),
          showBackButton: false,
        ),
        body: TabBarView(
            children: widget.sections
                .map((e) => ListView.builder(
                      itemCount: e.products.length,
                      itemBuilder: (context, index) {
                        return ProductListItemContainer(
                          product: e.products[index],
                          currentSectionID: e.id,
                          listSimilarProductListItem: e.products,
                        );

                        /* ListTile(
                          title: Text(e.products[index].name),
                        ); */
                      },
                    ))
                .toList()),
      ),
    );
  }
}


