
import 'package:egrocer/core/model/productDetail.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ProductDescriptionView extends StatelessWidget {
  final ProductData product;
  final BuildContext context;

  const ProductDescriptionView({Key? key, required this.context, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        HtmlWidget(
          product.description,
          enableCaching: true,
          renderMode: RenderMode.column,
          buildAsync: false,
          textStyle: TextStyle(color: ColorsRes.mainTextColor),
        ),

      ],
    );
  }

  getHtmlWidget() {
    return HtmlWidget(
      product.description,
      enableCaching: true,
      renderMode: RenderMode.column,
      buildAsync: false,
      textStyle: TextStyle(color: ColorsRes.mainTextColor),
    );
  }
}
