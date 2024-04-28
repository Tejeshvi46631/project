import 'package:egrocer/core/model/productDetail.dart';
import 'package:egrocer/core/provider/productDetailProvider.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ProductDetailFunction {
  static getProductDetailShimmer({required BuildContext context}) {
    return CustomShimmer(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
    );
  }



  static setOtherImages(int currentIndex, ProductData product,int currentImage,List<String> images,BuildContext context) {
    currentImage = 0;
    images = [];
    images.add(product.imageUrl);
    if (product.variants[currentIndex].images.isNotEmpty) {
      images.addAll(product.variants[currentIndex].images);
    } else {
      images.addAll(product.images);
    }
    context.read<ProductDetailProvider>().notify();
  }

  static setOtherVideo(int currentIndex, ProductData product,int currentVideos,List<String> videos,BuildContext context) {
    currentVideos = 0;
    videos = [];
    videos.addAll(product.videos);
    // images.add(product.imageUrl);
    // if (product.variants[currentIndex].images.isNotEmpty) {
    //   images.addAll(product.variants[currentIndex].images);
    // } else {
    //   images.addAll(product.images);
    // }
    context.read<ProductDetailProvider>().notify();
  }

  static Widget getVideoWidget(String Urls) {
    return FutureBuilder<Uint8List>(
      future: getThumbnail(Urls),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Image.memory(snapshot.data!);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  static Future<Uint8List> getThumbnail(String videoUrl) async {
    final String videoPath =
        videoUrl; //'path_to_your_video.mp4'; // Replace with the actual path to your video
    final uint8list = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128, // Adjust the width as needed
      quality: 25, // Adjust the quality as needed
    );
    return uint8list!;
  }

  static YoutubePlayerController getcontroller(String Url) {
    return YoutubePlayerController(
      initialVideoId: Url.getYouTubeVideoId(),
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }
}
