
import 'package:egrocer/core/model/trackOrdersModel.dart';
import 'package:egrocer/core/provider/orderInvoiceProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/orderTrackingHistoryBottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrackMyOrderButton extends StatelessWidget {
  final double width;
  final List<List<dynamic>> status;
  String? orderID;

  TrackMyOrderButton(
      {Key? key, required this.status, required this.width, this.orderID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (orderID != 'null') {
          TrackOrderModel? trackOrderModel = await context
              .read<OrderInvoiceProvider>()
              .getOrderTrackingDetailsProvider(params: {
            "tracking_id": orderID
            //  "7706965304"
          }, context: context);
          print("Tracking Orders Api Response===================>");
          print(trackOrderModel);

          showModalBottomSheet(
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              context: context,
              builder: (context) => OrderTrackingHistoryBottomsheet(
                    listOfStatus: [9, 18, 17, 7],
                    trackingData: trackOrderModel?.data.first.trackingData,
                  ));
        } else {
          showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
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
                        )),
                  ));
          /* 
              Container(
                  alignment: Alignment.center,
                  height: 300,
                  child: Text(
                    "Your Order Is Under Process",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ))
                  
                  
                  
                  ); */
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: width,
        child: Text(
          getTranslatedValue(
            context,
            "lblTrackMyOrder",
          ),
          softWrap: true,
          style: TextStyle(color: ColorsRes.appColor),
        ),
      ),
    );
  }
}
