import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GetDeliveryShimmer extends StatelessWidget {
  const GetDeliveryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Constant.size10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: CustomShimmer(
                  height: 20,
                  borderRadius: 7,
                ),
              ),
              Widgets.getSizedBox(
                width: Constant.size10,
              ),
              const Expanded(
                child: CustomShimmer(
                  height: 20,
                  width: 80,
                  borderRadius: 7,
                ),
              )
            ],
          ),
          Widgets.getSizedBox(
            height: Constant.size7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: CustomShimmer(
                  height: 20,
                  borderRadius: 7,
                ),
              ),
              Widgets.getSizedBox(
                width: Constant.size10,
              ),
              const Expanded(
                child: CustomShimmer(
                  height: 20,
                  borderRadius: 7,
                ),
              )
            ],
          ),
          Widgets.getSizedBox(
            height: Constant.size7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: CustomShimmer(
                  height: 22,
                  borderRadius: 7,
                ),
              ),
              Widgets.getSizedBox(
                width: Constant.size10,
              ),
              const Expanded(
                child: CustomShimmer(
                  height: 22,
                  borderRadius: 7,
                ),
              )
            ],
          ),
          Widgets.getSizedBox(
            height: Constant.size7,
          ),
        ],
      ),
    );
  }
}
