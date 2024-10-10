import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/provider/productSearchProvider.dart';
import 'package:egrocer/core/repository/firebase_analytics.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/utils/styles/designConfig.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/search/function/call_search_api.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SearchWidget extends StatefulWidget {
  SpeechToText speechToText;
  TextEditingController edtSearch;
  SearchWidget({super.key,required this.speechToText,required this.edtSearch});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.symmetric(
          horizontal: Constant.size10, vertical: Constant.size10),
      child: Row(children: [
        Expanded(
            child: Container(
              decoration: DesignConfig.boxDecoration(
                  Theme.of(context).scaffoldBackgroundColor, 10),
              child: ListTile(
                title: TextField(
                  autofocus: true,
                  controller: widget.edtSearch,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: getTranslatedValue
                      (
                      context,
                      "lblProductSearchHint",
                    ),
                  ),
                  onChanged: (value) {
                    FirebaseAnalyticsService().logSearch(searchTerm: value);
                  },
                ),
                contentPadding: const EdgeInsetsDirectional.only(start: 10),
                trailing: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Consumer<ProductSearchProvider>(
                    builder: (context, productSearchProvider, _) {
                      return Icon(/*context
                          .watch<ProductSearchProvider>()
                          .searchedTextLength ==
                          0
                          ?*/ Icons.search
                          /*: Icons.cancel*/);
                    },
                  ),
                  onPressed: () async {
                   /* _initSpeech(widget.speechToText);

                    PermissionStatus status = await Permission.microphone.status;
                    Future.delayed(Duration(milliseconds: 500)).then((value) {
                      if (status == PermissionStatus.granted) {
                        if (widget.edtSearch.text.toString().isNotEmpty) {
                          widget.edtSearch.clear();
                        }
                        SearchApi.callApi(isReset: true, context: context, edtSearch: widget.edtSearch);
                      } else {
                       // Permission.microphone.request();
                      }
                    });*/
                  },
                ),
              ),
            )),
        /*SizedBox(width: Constant.size10),
        Consumer<ProductSearchProvider>(
          builder: (context, productSearchProvider, child) {
            return GestureDetector(
              onTap: () {
                productSearchProvider.enableDisableSearchByVoice(true);
              },
              child: Container(
                decoration: DesignConfig.boxPrimary(10),
                padding: EdgeInsets.symmetric(
                    horizontal: Constant.size14, vertical: Constant.size14),
                child: Widgets.defaultImg(
                  image: "voice_search_icon",
                  iconColor: Colors.white,
                ),
              ),
            );
          },
        )*/
      ]),
    );
  }

  Future<void> _initSpeech(SpeechToText speechToText) async {
    await speechToText.initialize();
    setState(() {});
  }

}
