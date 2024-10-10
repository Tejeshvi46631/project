import 'package:flutter/material.dart';
import 'package:egrocer/core/model/order.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';

class DeliveryInformationContainer extends StatelessWidget {
  final Order order;

  const DeliveryInformationContainer({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getTranslatedValue(
                context,
                "lblDeliveryInformation",
              ),
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.person, color: Theme.of(context).primaryColor),
              title: Text(
                order.address.name,
                style: TextStyle(
                  color: ColorsRes.subTitleMainTextColor,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.location_on, color: Theme.of(context).primaryColor),
              title: Text(
                '${order.address.address +" "+ order.address.landmark +" "+ order.address.area +" "+ order.address.city +" "+ order.address.state + '-' + order.address.pincode}',
                style: TextStyle(
                  color: ColorsRes.subTitleMainTextColor,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.phone, color: Theme.of(context).primaryColor),
              title: Text(
                order.address.mobile,
                style: TextStyle(
                  color: ColorsRes.subTitleMainTextColor,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
