import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

// Check if the image path is an asset, network SVG, Lottie, or a network image
dynamic getImageWidget(String image, {double height = 25, double width = 25}) {
  if (image.startsWith('assets/')) {
    // Handle asset images
    return SvgPicture.asset(
      image,
      width: width,
      height: height,
      fit:BoxFit.contain,
    );
  } else if (image.endsWith('.svg')) {
    // Handle SVG images
    return SvgPicture.network(
      image,
      height: height,
      width: width,
      fit:BoxFit.contain,
    );
  } else if (image.endsWith('.json')) {
    // Handle Lottie animations
    return Lottie.network(
      image,
      height: height,
      width: width,
      fit: BoxFit.contain,
    );
  } else {
    // Default fallback for network images
    return Image.network(
      image,
      height: height,
      width: width,
      fit:BoxFit.contain,
    );
  }
}
