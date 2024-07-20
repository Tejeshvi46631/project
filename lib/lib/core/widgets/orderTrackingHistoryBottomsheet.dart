import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/trackOrdersModel.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderTrackingHistoryBottomsheet extends StatelessWidget {
  final List<int> listOfStatus;
  TrackingData? trackingData;

  OrderTrackingHistoryBottomsheet(
      {Key? key, required this.listOfStatus, this.trackingData})
      : super(key: key);

  bool isStatusSelected(int currentStatus) {
    if (listOfStatus.indexOf(currentStatus) > 0) {
      return true;
    }
    // if (listOfStatus.isNotEmpty) {
    //   final statusValue = listOfStatus.where(
    //       (element) => element.first.toString() == currentStatus.toString());

    //   return statusValue.isNotEmpty;
    // }

    return false;
  }

  String getStatusCompleteDate(int currentStatus) {
    // if (listOfStatus.isNotEmpty) {
    //   final statusValue = listOfStatus.where((element) {
    //     return element.first.toString() == currentStatus.toString();
    //   }).toList();

    //   if (statusValue.isNotEmpty) {
    //     //[2, 04-10-2022 06:13:45am] so fetching last value
    //     return statusValue.first.last;
    //   }
    // }

    return "";
  }

  Widget _buildDottedLineContainer({required bool isSelected}) {
    return Transform.translate(
      offset: const Offset(5.0, -20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            color: !isSelected
                ? ColorsRes.subTitleMainTextColor
                : ColorsRes.appColor,
            width: 3.5,
            height: 12,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            color: !isSelected
                ? ColorsRes.subTitleMainTextColor
                : ColorsRes.appColor,
            width: 3.5,
            height: 12,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            color: !isSelected
                ? ColorsRes.subTitleMainTextColor
                : ColorsRes.appColor,
            width: 3.5,
            height: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(
      {required String statusValue,
      required bool isSelected,
      required String date}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 7.5,
          backgroundColor:
              isSelected ? ColorsRes.appColor : ColorsRes.subTitleMainTextColor,
        ),
        SizedBox(
          width: Constant.size10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              statusValue,
              softWrap: true,
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              date,
              softWrap: true,
              style: TextStyle(color: ColorsRes.subTitleMainTextColor),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * (0.75),
        // maxHeight: MediaQuery.of(context).size.height * (0.90),
      ),
      padding: const EdgeInsets.symmetric(vertical: 15),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            getTranslatedValue(
              context,
              "lblOrderTracking",
            ),
            softWrap: true,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          const Divider(),
          const SizedBox(
            height: 15,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child:
                  _getStatusBuild() /*  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                _buildStatusIndicator(
                  // isSelected: isStatusSelected(3),
                  isSelected: isStatusSelected(trackingData!.shipmentStatus),
                  date: getStatusCompleteDate(3),
                  statusValue: getTranslatedValue(
                    context,
                    "lblOrderConfirmed",
                  ),
                ),

                //Order shipped status is 4
                _buildDottedLineContainer(
                    isSelected: isStatusSelected(trackingData!.shipmentStatus)
                    // isStatusSelected(4)
                    ),
                _buildStatusIndicator(
                  isSelected: isStatusSelected(trackingData!.shipmentStatus),
                  // isSelected: isStatusSelected(4),
                  date: getStatusCompleteDate(4),
                  statusValue: getTranslatedValue(
                    context,
                    "lblOrderShipped",
                  ),
                ),

                //5 status is for out for delivery
                _buildDottedLineContainer(
                    isSelected: isStatusSelected(trackingData!.shipmentStatus)
                    // isStatusSelected(5)
                    ),
                _buildStatusIndicator(
                  isSelected: isStatusSelected(trackingData!.shipmentStatus),
                  // isSelected: isStatusSelected(5),
                  date: getStatusCompleteDate(5),
                  statusValue: getTranslatedValue(
                    context,
                    "lblOrderOutForDelivery",
                  ),
                ),

                //6 status is for delivered
                _buildDottedLineContainer(
                    isSelected:
                        // false
                        isStatusSelected(trackingData!.shipmentStatus)),
                _buildStatusIndicator(
                  isSelected: isStatusSelected(trackingData!.shipmentStatus),
                  // isSelected: false, //isStatusSelected(6),
                  date: getStatusCompleteDate(6),
                  statusValue: getTranslatedValue(
                    context,
                    "lblOrderDelivered",
                  ),
                ),
              ],
            ), */
              /* Expanded(
                flex: 9,
                // height: 800,
                child: ListView(
                  // physics: NeverScrollableScrollPhysics(),
                  // shrinkWrap: true,
                  children: trackingData!.shipmentTrackActivities.map((e) {
                    return ListTile(
                      leading: Icon(
                        Icons.check_box_rounded,
                        color: Colors.green,
                      ),
                      title: Text(e.srStatusLabel),
                      // subtitle: Text("Location : ${e.location}"),
                    );
                  }).toList(),
                ),
              )
               */
              )
        ],
      ),
    );
  }

  _getStatusBuild() {
    bool orderConfirm = false,
        shipped = false,
        orderDispatch = false,
        orderDeliverd = false;
    switch (trackingData!.shipmentStatus) {
      case 9:
        orderConfirm = true;
        break;
      case 18:
        orderConfirm = true;
        shipped = true;
        break;
      case 17:
        orderConfirm = true;
        shipped = true;
        orderDispatch = true;
        break;
      case 7:
        orderConfirm = true;
        shipped = true;
        orderDispatch = true;
        orderDeliverd = true;
        break;
    }

    return Column(
      children: [
        StatusLabelWidget(
          statusText: "Order Confirm",
          isCheck: orderConfirm,
        ),
        SizedBox(
          height: 10,
        ),
        StatusLabelWidget(
          statusText: "Shipped",
          isCheck: shipped,
        ),
        SizedBox(
          height: 10,
        ),
        StatusLabelWidget(
          statusText: "Order Dispatch",
          isCheck: orderDispatch,
        ),
        SizedBox(
          height: 10,
        ),
        StatusLabelWidget(
          statusText: "Delivered",
          isCheck: orderDeliverd,
        ),
        SizedBox(
          height: 30,
        ),
        if (shipped == true)
          TextButton(
              onPressed: () {
                launchUrl(Uri.parse(trackingData!.trackUrl));
              },
              child: Text("Track My Order",
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 14.0)))
      ],
    );
  }
}

class StatusLabelWidget extends StatelessWidget {
  StatusLabelWidget(
      {super.key, required this.isCheck, required this.statusText});

  bool isCheck;

  String statusText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isCheck ? Icons.check_circle : Icons.check_circle_outline_outlined,
          size: 30,
          weight: 20,
          color: isCheck ? Colors.green : Colors.grey,
        ),
        SizedBox(
          width: 10,
        ),
        Text(statusText,
            style:
                const TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
      ],
    );
  }
}
