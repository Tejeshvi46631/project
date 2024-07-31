import 'package:cached_network_image/cached_network_image.dart';
import 'package:egrocer/core/model/trackOrdersModel.dart';
import 'package:egrocer/core/provider/orderInvoiceProvider.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/orderTrackingHistoryBottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrackMyOrderButton extends StatelessWidget {
  final double width;
  final List<List<dynamic>> status;
  final String? orderID;
  final String? iconAssetPath;

  TrackMyOrderButton({
    Key? key,
    required this.status,
    required this.width,
    this.orderID,
    this.iconAssetPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (orderID != 'null') {
          TrackOrderModel? trackOrderModel = await context
              .read<OrderInvoiceProvider>()
              .getOrderTrackingDetailsProvider(params: {
            "tracking_id": orderID,
          }, context: context);
          print("Tracking Orders Api Response===================>");
          print(trackOrderModel);

          showModalBottomSheet(
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            context: context,
            builder: (context) => OrderTrackingHistoryBottomsheet(
              listOfStatus: [9, 18, 17, 7],
              trackingData: trackOrderModel?.data.first.trackingData,
            ),
          );
        } else {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            builder: (context) => OrderTrackingHistoryBottomsheet(
              listOfStatus: [9, 18, 17, 7],
              trackingData: TrackingData(
                trackStatus: 1,
                shipmentStatus: 9,
                shipmentTrack: [],
                shipmentTrackActivities: [],
                trackUrl: 'https://shiprocket.co/tracking/624414538',
                etd: DateTime.now(),
                qcResponse: QcResponse(
                  qcImage: '',
                  qcFailedReason: '',
                ),
              ),
            ),
          );
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: width,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconAssetPath != null) ...[
              CachedNetworkImage(
                imageUrl: iconAssetPath ?? 'assets/images/tracking_order.png', // Provide a fallback image URL if needed
                width: 24,
                height: 24,
                color: Colors.black,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              const SizedBox(width: 5),
            ],
            Text(
              getTranslatedValue(
                context,
                "lblTrackMyOrder",
              ),
              softWrap: true,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
