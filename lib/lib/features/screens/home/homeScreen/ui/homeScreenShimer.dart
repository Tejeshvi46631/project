import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomeScreenShimmer{
  static Widget getHomeScreenShimmer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: Constant.size10, horizontal: Constant.size10),
      child: Column(
        children: [
          CustomShimmer(
            height: MediaQuery.of(context).size.height * 0.26,
            width: MediaQuery.of(context).size.width,
          ),
          Widgets.getSizedBox(
            height: Constant.size10,
          ),
          CustomShimmer(
            height: Constant.size10,
            width: MediaQuery.of(context).size.width,
          ),
          Widgets.getSizedBox(
            height: Constant.size10,
          ),
          getCategoryShimmer(
              context: context, count: 6, padding: EdgeInsets.zero),
          Widgets.getSizedBox(
            height: Constant.size10,
          ),
          Column(
            children: List.generate(5, (index) {
              return Column(
                children: [
                  const CustomShimmer(height: 50),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(5, (index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Constant.size10,
                              horizontal: Constant.size5),
                          child: CustomShimmer(
                            height: 210,
                            width: MediaQuery.of(context).size.width * 0.4,
                          ),
                        );
                      }),
                    ),
                  )
                ],
              );
            }),
          )
        ],
      ),
    );
  }
}