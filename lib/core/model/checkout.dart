class Checkout {
  Checkout({
    required this.status,
    required this.message,
    required this.total,
    required this.data,
  });

  late final String status;
  late final String message;
  late final String total;
  late final DeliveryChargeData data;

  Checkout.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'].toString();
    total = json['total'].toString();
    data = DeliveryChargeData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final itemData = <String, dynamic>{};
    itemData['status'] = status;
    itemData['message'] = message;
    itemData['total'] = total;
    itemData['data'] = data.toJson();
    return itemData;
  }
}

class DeliveryChargeData {
  DeliveryChargeData({
    required this.isCodAllowed,
    required this.productVariantId,
    required this.quantity,
    required this.deliveryCharge,
    required this.totalAmount,
    required this.subTotal,
    required this.savedAmount,
  });

  late final String isCodAllowed;
  late final String productVariantId;
  late final String quantity;
  late final DeliveryCharge deliveryCharge;
  late final String totalAmount;
  late final String subTotal;
  late final String savedAmount;

  DeliveryChargeData.fromJson(Map<String, dynamic> json) {
    isCodAllowed = json['cod_allowed'].toString();
    productVariantId = json['product_variant_id'].toString();
    quantity = json['quantity'].toString();
    deliveryCharge = DeliveryCharge.fromJson(json['delivery_charge']);
    totalAmount = json['total_amount'].toString();
    subTotal = json['sub_total'].toString();
    savedAmount = json['saved_amount'].toString();
  }
  Map<String, dynamic> toJson() {
    final itemData = <String, dynamic>{};
    itemData['cod_allowed'] = isCodAllowed;
    itemData['product_variant_id'] = productVariantId;
    itemData['quantity'] = quantity;
     itemData['delivery_charge'] = deliveryCharge.toJson();

    itemData['total_amount'] = totalAmount;
    itemData['sub_total'] = subTotal;
    itemData['saved_amount'] = savedAmount;
    return itemData;
  }
}

class DeliveryCharge {
  DeliveryCharge({
    required this.totalDeliveryCharge,
    required this.sellersInfo,
  });
  late final String totalDeliveryCharge;
  late final List<SellersInfo> sellersInfo;

  DeliveryCharge.fromJson(Map<String, dynamic> json) {
    totalDeliveryCharge = json['total_delivery_charge'].toString();
    sellersInfo = List.from(json['sellers_info']).map((e) => SellersInfo.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final itemData = <String, dynamic>{};
    itemData['total_delivery_charge'] = totalDeliveryCharge;
    itemData['sellers_info'] = sellersInfo.map((e) => e.toJson()).toList();
    return itemData;
  }
}

class SellersInfo {
  SellersInfo({
    required this.sellerName,
    required this.deliveryCharge,
    required this.distance,
    required this.duration,
  });

  late final String sellerName;
  late final String deliveryCharge;
  late final String distance;
  late final String duration;

  SellersInfo.fromJson(Map<String, dynamic> json) {
    sellerName = json['seller_name'];
    deliveryCharge = json['delivery_charge'].toString();
    distance = json['distance'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final itemData = <String, dynamic>{};
    itemData['seller_name'] = sellerName;
    itemData['delivery_charge'] = deliveryCharge;
    itemData['distance'] = distance;
    itemData['duration'] = duration;
    return itemData;
  }
}
