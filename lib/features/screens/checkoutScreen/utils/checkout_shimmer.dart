import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GetCheckoutShimmer extends StatelessWidget {
  const GetCheckoutShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomShimmer(
          margin: EdgeInsetsDirectional.all(Constant.size10),
          borderRadius: 7,
          width: double.maxFinite,
          height: 150,
        ),
        const CustomShimmer(
          width: 250,
          height: 25,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              10,
                  (index) {
                return const CustomShimmer(
                  width: 50,
                  height: 80,
                  borderRadius: 10,
                  margin: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 10),
                );
              },
            ),
          ),
        ),
        const CustomShimmer(
          width: double.maxFinite,
          height: 45,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        const CustomShimmer(
          width: double.maxFinite,
          height: 45,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        const CustomShimmer(
          width: 250,
          height: 25,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        const CustomShimmer(
          width: double.maxFinite,
          height: 45,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        const CustomShimmer(
          width: double.maxFinite,
          height: 45,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        const CustomShimmer(
          width: double.maxFinite,
          height: 45,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
      ],
    );
  }
}
