import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/order.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/material.dart';

class BillDetails extends StatelessWidget {
  final Order order;

  const BillDetails({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              getTranslatedValue(
                context,
                "lblBillingDetails",
              ),
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      getTranslatedValue(
                        context,
                        "lblPaymentMethod",
                      ),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Text(order.paymentMethod),
                  ],
                ),
                SizedBox(
                  height: Constant.size10,
                ),
                order.transactionId.isEmpty
                    ? const SizedBox()
                    : Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                getTranslatedValue(
                                  context,
                                  "lblTransactionId",
                                ),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              Text(
                                order.transactionId,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Constant.size10,
                          ),
                        ],
                      ),
                Row(
                  children: [
                    Text(
                      getTranslatedValue(
                        context,
                        "lblTotal",
                      ),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Text(
                        GeneralMethods.getCurrencyFormat(
                            double.parse(order.finalTotal)),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: ColorsRes.appColor)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
