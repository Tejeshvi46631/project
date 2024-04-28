import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/constant/routeGenerator.dart';
import 'package:egrocer/core/model/homeScreenData.dart';
import 'package:egrocer/core/provider/sliderImagesProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SliderImageWidget extends StatefulWidget {
  final List<Sliders> sliders;
  final List<Sections> sections;
  final List<Category>? category;

  // final int? categoryId;

  const SliderImageWidget({
    Key? key,
    required this.sliders,
    required this.sections,
    this.category,
  }) : super(key: key);

  @override
  State<SliderImageWidget> createState() => _SliderImageWidgetState();
}

class _SliderImageWidgetState extends State<SliderImageWidget> {
  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      if (mounted) {
        Timer.periodic(Duration(seconds: 3), (timer) {
          if (context.read<SliderImagesProvider>().currentSliderImageIndex <
              (widget.sliders.length - 1)) {
            context.read<SliderImagesProvider>().setSliderCurrentIndexImage(
                (context.read<SliderImagesProvider>().currentSliderImageIndex +
                    1));
          } else {
            context.read<SliderImagesProvider>().setSliderCurrentIndexImage(0);
          }
          _pageController.animateToPage(
              context.read<SliderImagesProvider>().currentSliderImageIndex,
              duration: Duration(milliseconds: 600),
              curve: Curves.easeInOut);
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SliderImagesProvider>(
      builder: (context, sliderImagesProvider, child) {
        return Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.28,
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                itemCount: widget.sliders.length,
                itemBuilder: (context, index) {
                  Sliders sliderData = widget.sliders[index];
                  return GestureDetector(
                    onTap: () async {
                      if (mounted) {
                        if (widget
                                .sliders[sliderImagesProvider
                                    .currentSliderImageIndex]
                                .type ==
                            "slider_url") {
                          if (await canLaunchUrl(Uri.parse(widget
                              .sliders[
                                  sliderImagesProvider.currentSliderImageIndex]
                              .sliderUrl))) {
                            await launchUrl(
                                Uri.parse(widget
                                    .sliders[sliderImagesProvider
                                        .currentSliderImageIndex]
                                    .sliderUrl),
                                mode: LaunchMode.externalApplication);
                          } else {
                            throw 'Could not launch ${widget.sliders[sliderImagesProvider.currentSliderImageIndex].sliderUrl}';
                          }
                        } else if (widget
                                .sliders[sliderImagesProvider
                                    .currentSliderImageIndex]
                                .type ==
                            "category") {
                          Navigator.pushNamed(context, productListScreenV2,
                              arguments: [
                                widget
                                    .sliders[sliderImagesProvider
                                        .currentSliderImageIndex]
                                    .typeName,
                                widget.sections,
                                widget.sections.first.title,
                              ]);
                        } else if (widget
                                .sliders[sliderImagesProvider
                                    .currentSliderImageIndex]
                                .type ==
                            "product") {
                          Navigator.pushNamed(context, productDetailScreen,
                              arguments: [
                                widget
                                    .sliders[sliderImagesProvider
                                        .currentSliderImageIndex]
                                    .typeId
                                    .toString(),
                                widget
                                    .sliders[sliderImagesProvider
                                        .currentSliderImageIndex]
                                    .typeName,
                                null
                              ]);
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: ClipRRect(
                        borderRadius: Constant.borderRadius10,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: CachedNetworkImage(
                          imageUrl: sliderData.imageUrl,
                          filterQuality: FilterQuality.low,
                          placeholder: (context, url) =>
                              Image.asset("assets/images/photoEmpty.jpg"),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),

                        // Image.network(
                        //   sliderData.imageUrl,
                        //   errorBuilder: (context, error, stackTrace) {
                        //     return Icon(Icons.image);
                        //   },
                        //   fit: BoxFit.cover,
                        // ),

                        /* Widgets.setNetworkImg(
                          image: Uri.parse(sliderData.imageUrl).toString(),
                          boxFit: BoxFit.cover,
                        ), */
                      ),
                    ),
                  );
                },
                onPageChanged: (value) {
                  sliderImagesProvider.setSliderCurrentIndexImage(value);
                },
              ),
            ),
            Widgets.getSizedBox(
              height: Constant.size2,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.sliders.length,
                  (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      height: Constant.size8,
                      width:
                          sliderImagesProvider.currentSliderImageIndex == index
                              ? 20
                              : 8,
                      margin: EdgeInsets.symmetric(horizontal: Constant.size2),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: sliderImagesProvider.currentSliderImageIndex ==
                                  index
                              ? Theme.of(context).primaryColor
                              : ColorsRes.mainTextColor,
                          shape: BoxShape.rectangle),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
