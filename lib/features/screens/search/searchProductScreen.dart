import 'dart:async';

import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/provider/productSearchProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/search/function/call_search_api.dart';
import 'package:egrocer/features/screens/search/function/search_scroll_listener.dart';
import 'package:egrocer/features/screens/search/function/search_text_listener.dart';
import 'package:egrocer/features/screens/search/ui/search_stack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ProductSearchScreen extends StatefulWidget {
  ProductSearchScreen({Key? key}) : super(key: key);

  @override
  State<ProductSearchScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductSearchScreen> {
  // search provider controller
  final TextEditingController edtSearch = TextEditingController();
  final SpeechToText speechToText = SpeechToText();

  //give delay to live search
  Timer? delayTimer;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
    edtSearch.addListener(
        searchTextListener);
    scrollController.addListener(
        scrollListener);
    //fetch productList from api
    Future.delayed(Duration.zero).then((value) async {
      SearchApi.callApi(isReset: true, context: context, edtSearch: edtSearch);
    });
  }

  @override
  void dispose() {
    speechToText.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: getAppBar(
          context: context,
          title: Text(
              getTranslatedValue(
                context,
                "lblSearch",
              ),
              softWrap: true,
              //style: TextStyle(color: ColorsRes.mainTextColor)
          ),
          actions: [
            setCartCounter(context: context),
            setNotificationCounter(context: context)
          ]),
      body: SearchStackWidget(speechToText: speechToText, edtSearch: edtSearch, scrollController: scrollController)
    );
  }

  void searchTextListener() {
    if (edtSearch.text.isEmpty) {
      delayTimer?.cancel();
    }

    if (delayTimer?.isActive ?? false) delayTimer?.cancel();

    delayTimer = Timer(const Duration(milliseconds: 300), () {
      if (edtSearch.text.isNotEmpty) {
        if (edtSearch.text.length !=
            context.read<ProductSearchProvider>().searchedTextLength) {
          SearchApi.callApi(isReset: true, context: context, edtSearch: edtSearch);
          //
          context.read<ProductSearchProvider>().setSearchLength(edtSearch.text);
        }
      } else {
        context.read<ProductSearchProvider>().setSearchLength("");
        SearchApi.callApi(isReset: true, context: context, edtSearch: edtSearch);
      }
    });
  }

  scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (context.read<ProductSearchProvider>().hasMoreData) {
        Map<String, String> params = await Constant.getProductsDefaultParams();

        params[ApiAndParams.search] = edtSearch.text.trim();

        await context
            .read<ProductSearchProvider>()
            .getProductSearchProvider(context: context, params: params);
      }
    }
  }

  voiceToTextResult(String text) {
    edtSearch.text = text;
  }
}
