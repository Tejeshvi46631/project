import 'dart:io' as io;
import 'dart:typed_data';

import 'package:egrocer/core/model/order.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/trackMyOrderButton.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/constant/apiAndParams.dart';
import '../../../../core/provider/orderInvoiceProvider.dart';

class OSOrderStatusContainer extends StatelessWidget {
  final Order order;

  const OSOrderStatusContainer({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String getStatusCompleteDate(int currentStatus) {
      if (order.status.isNotEmpty) {
        final statusValue = order.status.where((element) {
          return element.first.toString() == currentStatus.toString();
        }).toList();

        if (statusValue.isNotEmpty) {
          //[2, 04-10-2022 06:13:45am] so fetching last value
          return statusValue.first.last;
        }
      }

      return "";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text(
                  getTranslatedValue(context, "lblOrder"),
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    "#${order.id}",
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.black),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${getTranslatedValue(context, "lblPlacedOrderOn")} ${GeneralMethods.formatDate(DateTime.parse(order.createdAt))}",
                    style: TextStyle(
                      fontSize: 12.5,
                      color: ColorsRes.mainTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${getTranslatedValue(context, "lblPaymentMethod")}: ${order.paymentMethod}",
                    style: TextStyle(
                      fontSize: 12.5,
                      color: ColorsRes.mainTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: Colors.black),
          Center(
            child: Text(
              getTranslatedValue(context, "lblOrderTracking"),
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: ColorsRes.mainTextColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: LayoutBuilder(
              builder: (context, boxConstraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TrackMyOrderButton(
                      status: order.status,
                      width: boxConstraints.maxWidth * 0.4,
                      orderID: order.items.first.tracking_id,
                      iconAssetPath: 'assets/images/tracking_order.png',
                    ),
                    SizedBox(width: 20), // Adjust spacing between buttons
                    ElevatedButton(
                      onPressed: () async {
                        var invoiceProvider = Provider.of<OrderInvoiceProvider>(context, listen: false);




                        Uint8List? htmlContent = await invoiceProvider.getOrderInvoiceApiProvider(params: {ApiAndParams.orderId: order.id.toString()}, context: context);

                        try {
                          if (htmlContent != null) {
                            final appDocDirPath = io.Platform.isAndroid
                                ? (await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS))
                                : (await getApplicationDocumentsDirectory()).path;

                            final targetFileName =
                                "${getTranslatedValue(context, "lblAppName")}-${getTranslatedValue(context, "lblInvoice")}#${order.id.toString()}.pdf";

                            io.File file = io.File("$appDocDirPath/$targetFileName");

                            // Write down the file as bytes from the bytes got from the HTTP request.
                            await file.writeAsBytes(htmlContent, flush: true);
                            if (await file.exists()) {
                              print('File successfully written at: ${file.path}');
                            } else {
                              print('Failed to write file at: ${file.path}');
                              return;
                            }

                            if (!await io.Directory(appDocDirPath).exists()) {
                              print('Directory does not exist: $appDocDirPath');
                              return;
                            }

                            if (await file.exists()) {
      // Proceed to open the file
      print("File Path : $file.path");
      OpenFilex.open(file.path).catchError((e) {
        print('Failed to open file: $e');
      });
    }
                            // Show snackbar with option to open the saved file
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                action: SnackBarAction(
                                  label: getTranslatedValue(context, "lblShowFile"),
                                  onPressed: () {
                                    print('Opening file: ${file.path}');
                                    OpenFilex.open(file.path).catchError((e) {
                                      print('Failed to open file: $e');
                                    });
                                  },
                                ),
                                content: Text(
                                  getTranslatedValue(context, "lblFileSavedSuccessfully"),
                                  softWrap: true,
                                  style: TextStyle(color: ColorsRes.mainTextColor),
                                ),
                                duration: const Duration(seconds: 5),
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              ),
                            );
                          }
                        } catch (e) {
                          print('Error saving or opening file: $e');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsRes.appColor,
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        getTranslatedValue(context, "lblGetInvoice"),
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}