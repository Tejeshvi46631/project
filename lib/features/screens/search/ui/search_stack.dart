import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/provider/cartListProvider.dart';
import 'package:egrocer/core/provider/productChangeListingProvider.dart';
import 'package:egrocer/core/provider/productSearchProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/utils/styles/designConfig.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/search/function/call_search_api.dart';
import 'package:egrocer/features/screens/search/ui/SearchProductWidget.dart';
import 'package:egrocer/features/screens/search/ui/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SearchStackWidget extends StatefulWidget {
  SpeechToText speechToText;
  TextEditingController edtSearch;
  ScrollController scrollController;

  SearchStackWidget(
      {super.key, required this.speechToText, required this.edtSearch,required this.scrollController});

  @override
  State<SearchStackWidget> createState() => _SearchStackWidgetState();
}

class _SearchStackWidgetState extends State<SearchStackWidget> {
  @override
  Widget build(BuildContext context) {
    List lblSortingDisplayList = [
      getTranslatedValue(context, "lblSortingDisplayListDefault"),
      getTranslatedValue(context, "lblSortingDisplayListNewestFirst"),
      getTranslatedValue(context, "lblSortingDisplayListOldestFirst"),
      getTranslatedValue(context, "lblSortingDisplayListPriceHighToLow"),
      getTranslatedValue(context, "lblSortingDisplayListPriceLowToHigh"),
      getTranslatedValue(context, "lblSortingDisplayListDiscountHighToLow"),
      getTranslatedValue(context, "lblSortingDisplayListPopularity"),
    ];
    return Stack(
      children: [
        Column(
          children: [
            SearchWidget(
                speechToText: widget.speechToText, edtSearch: widget.edtSearch),
            Widgets.getSizedBox(
              height: Constant.size5,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Constant.size5),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          shape: DesignConfig.setRoundedBorderSpecific(20,
                              istop: true),
                          builder: (BuildContext context1) {
                            return Wrap(
                              children: [
                                Container(
                                  padding: EdgeInsetsDirectional.only(
                                      start: Constant.size15,
                                      end: Constant.size15,
                                      top: Constant.size15,
                                      bottom: Constant.size15),
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          PositionedDirectional(
                                            child: GestureDetector(
                                              onTap: () =>
                                                  Navigator.pop(context),
                                              child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Widgets.defaultImg(
                                                  image: "ic_arrow_back",
                                                  iconColor:
                                                  ColorsRes.mainTextColor,
                                                  height: 15,
                                                  width: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              getTranslatedValue(
                                                context,
                                                "lblSortBy",
                                              ),
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .merge(
                                                const TextStyle(
                                                  letterSpacing: 0.5,
                                                  fontSize: 18,
                                                  fontWeight:
                                                  FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Widgets.getSizedBox(height: 10),
                                      Column(
                                        children: List.generate(
                                          ApiAndParams
                                              .productListSortTypes.length,
                                              (index) {
                                            return GestureDetector(
                                              onTap: () async {
                                                Navigator.pop(context);
                                                context
                                                    .read<
                                                    ProductSearchProvider>()
                                                    .products = [];

                                                context
                                                    .read<
                                                    ProductSearchProvider>()
                                                    .offset = 0;

                                                context
                                                    .read<
                                                    ProductSearchProvider>()
                                                    .currentSortByOrderIndex =
                                                    index;

                                                SearchApi.callApi(isReset: true,
                                                    context: context,
                                                    edtSearch: widget
                                                        .edtSearch);
                                              },
                                              child: Container(
                                                padding:
                                                EdgeInsetsDirectional.all(
                                                    10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    context
                                                        .read<
                                                        ProductSearchProvider>()
                                                        .currentSortByOrderIndex ==
                                                        index
                                                        ? Icon(
                                                      Icons
                                                          .radio_button_checked,
                                                      color: ColorsRes
                                                          .appColor,
                                                    )
                                                        : Icon(
                                                      Icons
                                                          .radio_button_off,
                                                      color: ColorsRes
                                                          .appColor,
                                                    ),
                                                    Widgets.getSizedBox(
                                                        width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        lblSortingDisplayList[
                                                        index],
                                                        softWrap: true,
                                                        style:
                                                        Theme
                                                            .of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .merge(
                                                          const TextStyle(
                                                            letterSpacing:
                                                            0.5,
                                                            fontSize:
                                                            16,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Card(
                          color: Theme
                              .of(context)
                              .cardColor,
                          elevation: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Widgets.defaultImg(
                                  image: "sorting_icon",
                                  height: 17,
                                  width: 17,
                                  padding: const EdgeInsetsDirectional.only(
                                      top: 7, bottom: 7, end: 7),
                                  iconColor: Theme
                                      .of(context)
                                      .primaryColor),
                              Text(
                                getTranslatedValue(
                                  context,
                                  "lblSortBy",
                                ),
                                softWrap: true,
                              )
                            ],
                          )),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context
                            .read<ProductChangeListingTypeProvider>()
                            .changeListingType();
                      },
                      child: Card(
                          color: Theme
                              .of(context)
                              .cardColor,
                          elevation: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Widgets.defaultImg(
                                  image: context
                                      .watch<
                                      ProductChangeListingTypeProvider>()
                                      .getListingType() ==
                                      false
                                      ? "grid_view_icon"
                                      : "list_view_icon",
                                  height: 17,
                                  width: 17,
                                  padding: const EdgeInsetsDirectional.only(
                                      top: 7, bottom: 7, end: 7),
                                  iconColor: Theme
                                      .of(context)
                                      .primaryColor),
                              Text(
                                context
                                    .watch<
                                    ProductChangeListingTypeProvider>()
                                    .getListingType() ==
                                    false
                                    ? getTranslatedValue(
                                  context,
                                  "lblGridView",
                                )
                                    : getTranslatedValue(
                                  context,
                                  "lblListView",
                                ),
                                softWrap: true,
                              )
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: setRefreshIndicator(
                refreshCallback: () async {
                  context
                      .read<ProductSearchProvider>()
                      .offset = 0;
                  context
                      .read<ProductSearchProvider>()
                      .products = [];

                  SearchApi.callApi(isReset: true,
                      context: context,
                      edtSearch: widget
                          .edtSearch);
                },
                child: ListView(
                  controller: widget.scrollController,
                  children: [
                    SearchProductWidget()
                  ],
                ),
              ),
            ),
          ],
        ),
        Consumer<CartListProvider>(
          builder: (context, cartListProvider, child) {
            return cartListProvider.cartListState == CartListState.loading
                ? PositionedDirectional(
              top: 0,
              end: 0,
              start: 0,
              bottom: 0,
              child: Container(
                  color: Colors.black.withOpacity(0.2),
                  child:
                  const Center(child: CircularProgressIndicator())),
            )
                : const SizedBox.shrink();
          },
        ),
        Consumer<ProductSearchProvider>(
          builder: (context, productSearchProvider, child) {
            return productSearchProvider.isSearchingByVoice == true
                ? Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              color: Colors.transparent,
              alignment: AlignmentDirectional.center,
              child: Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 40, horizontal: 10),
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.8,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.6,
                decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .cardColor
                      .withOpacity(0.9),
                  borderRadius: BorderRadius.circular(Constant.size10),
                ),
                alignment: AlignmentDirectional.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  /*  Container(
                      alignment: AlignmentDirectional.topEnd,
                      child: IconButton(
                        splashRadius: 0.1,
                        onPressed: () {
                          setState(() {
                            context
                                .read<ProductSearchProvider>()
                                .enableDisableSearchByVoice(false);
                          });
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              getTranslatedValue(
                                context,
                                "lblVoiceSearchProductMessage",
                              ),
                              softWrap: true,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleLarge),
                          Widgets.getSizedBox(
                            height: Constant.size20,
                          ),
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: ColorsRes.appColor,
                            child: GestureDetector(
                              onLongPress: () async {
                                if (await Permission
                                    .microphone.status.isGranted) {
                                  _initSpeech(widget.speechToText).then(
                                          (value) => _startListening(widget.speechToText));
                                } else {
                                  Permission.microphone.request();
                                }
                              },
                              onLongPressUp: () {
                                _stopListening(widget.speechToText);
                              },
                              child: Icon(
                                Icons.mic_rounded,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    )*/
                  ],
                ),
              ),
            )
                : const SizedBox.shrink();
          },
        )
      ],
    );
  }

  /// This has to happen only once per app


  /// Each time to start a speech recognition session
  void _startListening(SpeechToText _speechToText) async {
    await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 60),
        cancelOnError: true,
        listenMode: ListenMode.search);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening(SpeechToText _speechToText) async {
    await _speechToText.stop();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      widget.edtSearch.text = result.recognizedWords;
      context.read<ProductSearchProvider>().enableDisableSearchByVoice(false);
    });
  }

  Future<void> _initSpeech(SpeechToText speechToText) async {
    await speechToText.initialize();
    setState(() {});
  }
}
