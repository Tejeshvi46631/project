
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactinfoScreen extends StatefulWidget {
  final ScrollController scrollController;
  const ContactinfoScreen({
    super.key,
    required this.scrollController,
  });

  @override
  State<ContactinfoScreen> createState() => _ContactinfoScreenState();
}

class _ContactinfoScreenState extends State<ContactinfoScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _openWhatsApp() async {
    String whatsappNumber = "+919420920320";
    String url = "https://wa.me/$whatsappNumber";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        showBackButton: false,
        title: Text(
          getTranslatedValue(
            context,
            "lblContactUs",
          ),
          //style: TextStyle(color: ColorsRes.mainTextColor),
        ),
        actions: [
          setCartCounter(context: context),
          setNotificationCounter(context: context),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Phone # 9420920320 \n\nEmail: sales@chhayakart.com",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium!.merge(
                      const TextStyle(
                        letterSpacing: 0.5,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    _openWhatsApp();
                  },
                  icon: SvgPicture.asset(
                    "assets/svg/info_contact_icon.svg",
                    // width: width,
                    // height: height,
                    // colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    fit: BoxFit.fill,
                  ),
                  label: Text("Chat With Us")),
            ],
          ),
        ),
      ),
    );
  }
}
