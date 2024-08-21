import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GetDeliveryShimmer extends StatelessWidget {
  const GetDeliveryShimmer({super.key});

  Widget _buildShimmerRow({required double height, double width = double.infinity}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomShimmer(
            height: height,
            width: width,
            borderRadius: 7,
          ),
        ),
        Widgets.getSizedBox(width: Constant.size10),
        Expanded(
          child: CustomShimmer(
            height: height,
            width: width,
            borderRadius: 7,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Constant.size10),
      child: Column(
        children: [
          _buildShimmerRow(height: 20),
          Widgets.getSizedBox(height: Constant.size7),
          _buildShimmerRow(height: 20),
          Widgets.getSizedBox(height: Constant.size7),
          _buildShimmerRow(height: 22),
          Widgets.getSizedBox(height: Constant.size7),
        ],
      ),
    );
  }
}
