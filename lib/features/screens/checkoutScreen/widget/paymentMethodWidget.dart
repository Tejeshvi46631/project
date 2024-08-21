import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/paymentMethods.dart';
import 'package:egrocer/core/provider/checkoutProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/checkoutScreen/widget/get_image_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget paymentMethodItem({
  required BuildContext context,
  required String paymentMethod,
  required String image,
  required String label,
  required bool isAvailable,
  required VoidCallback onTap,
}) {
  final isSelected = context.read<CheckoutProvider>().selectedPaymentMethod == paymentMethod;
  return GestureDetector(
    onTap: isAvailable ? onTap : null,
    child: Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.symmetric(vertical: Constant.size5),
      decoration: BoxDecoration(
        color: isSelected
            ? (Constant.session.getBoolData(SessionManager.isDarkTheme)
            ? ColorsRes.appColorWhite
            : ColorsRes.appColorWhite)
            : Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
        borderRadius: Constant.borderRadius7,
        border: Border.all(
          width: isSelected ? 1 : 0.3,
          color: isSelected ? ColorsRes.appColor : ColorsRes.grey,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(start: Constant.size10),
            child: getImageWidget(image, width: 20, height: 20 ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(start: Constant.size10),
            child: Text(label),
          ),
          const Spacer(),
          Radio<String>(
            value: paymentMethod,
            groupValue: context.read<CheckoutProvider>().selectedPaymentMethod,
            activeColor: ColorsRes.appColor,
            onChanged: isAvailable
                ? (String? newValue) {
              if (newValue != null) {
                context.read<CheckoutProvider>().setSelectedPaymentMethod(newValue);
              }
            }
                : null,
          ),
        ],
      ),
    ),
  );
}

Widget getPaymentMethods(PaymentMethodsData? paymentMethodsData, BuildContext context) {
  final checkoutProvider = context.read<CheckoutProvider>();
  final isSubtotalLessThan249 = checkoutProvider.subTotalAmount < 249;
  final isCODSelected = checkoutProvider.selectedPaymentMethod == 'COD';

  if (paymentMethodsData == null) return const SizedBox.shrink();

  final paymentMethods = [
    {
      'paymentMethod': 'Gpay/PhonePe/Paytm',
      'image': "https://th.bing.com/th/id/OIP.pKKpNogUNRPh_KEo3Cc77gHaB9?w=310&h=92&c=7&r=0&o=5&dpr=1.3&pid=1.7",
      'label': 'Gpay/PhonePe/Paytm',
      'available': true,
    },
    {
      'paymentMethod': 'Razorpay',
      'image': "https://th.bing.com/th/id/OIP.d0px8rOiJV_05QPderuBUAHaHa?pid=ImgDet&w=1000&h=1000&rs=1",
      'label': 'Card Payment',
      'available': true,
    },
    {
      'paymentMethod': 'Net Banking',
      'image': "https://cdn.iconscout.com/icon/free/png-256/free-netbanking-credit-debit-card-bank-transaction-32302.png",
      'label': 'Net Banking',
      'available': true,
    },
    {
      'paymentMethod': 'COD',
      'image': "assets/svg/ic_cod.svg",
      'label': getTranslatedValue(context, "lblCashOnDelivery"),
      'available': !isSubtotalLessThan249,
    },
  ];

  return Card(
    color: Theme.of(context).cardColor,
    elevation: 0,
    child: Padding(
      padding: EdgeInsets.all(Constant.size10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorsRes.buttoncolor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.symmetric(vertical: 11.0),
            child: Center(
              child: Text(
                getTranslatedValue(context, "lblPaymentMethod"),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Widgets.getSizedBox(height: Constant.size5),
          Divider(color: ColorsRes.grey, height: 1, thickness: 0.1),
          Widgets.getSizedBox(height: Constant.size5),
          ...paymentMethods.map((method) => paymentMethodItem(
            context: context,
            paymentMethod: method['paymentMethod'] as String,
            image: method['image'] as String,
            label: method['label'] as String,
            isAvailable: method['available'] as bool,
            onTap: () => checkoutProvider.setSelectedPaymentMethod(method['paymentMethod'] as String),
          )),
          Divider(color: ColorsRes.grey, height: 1, thickness: 0.1),
          Widgets.getSizedBox(height: Constant.size5),
          if (isSubtotalLessThan249)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'COD not available for order value below ₹250 and FESTIVE KITS',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
            ),
          if (isCODSelected)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'For COD orders: ₹46 COD Service Charge Applicable',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
        ],
      ),
    ),
  );
}

