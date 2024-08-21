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
    this.isCodAllowed,
    this.productVariantId,
    this.quantity,
    this.deliveryCharge,
    this.totalAmount,
    this.subTotal,
    this.taxSubTotal,
    this.savedAmount,
    this.shippingFee,
    this.platformFee,
    this.codServicesFee,
  });

  String? isCodAllowed;
  String? productVariantId;
  String? quantity;
  DeliveryCharge? deliveryCharge;
  String? totalAmount;
  String? subTotal;
  String? taxSubTotal;
  String? savedAmount;
  String? shippingFee;
  String? platformFee;
  String? codServicesFee;

  DeliveryChargeData.fromJson(Map<String, dynamic> json) {
    isCodAllowed = json['cod_allowed']?.toString();
    productVariantId = json['product_variant_id']?.toString();
    quantity = json['quantity']?.toString();
    deliveryCharge = json['delivery_charge'] != null ? DeliveryCharge.fromJson(json['delivery_charge']) : null;
    totalAmount = json['total_amount']?.toString();
    subTotal = json['sub_total']?.toString();
    taxSubTotal = json['tax_sub_total']?.toString();
    savedAmount = json['saved_amount']?.toString();
    shippingFee = json['shipping_fee']?.toString();
    platformFee = json['platform_fee']?.toString();
    codServicesFee = json['cod_service_fee']?.toString();
  }

  Map<String, dynamic> toJson() {
    final itemData = <String, dynamic>{};
    itemData['cod_allowed'] = isCodAllowed;
    itemData['product_variant_id'] = productVariantId;
    itemData['quantity'] = quantity;
    itemData['delivery_charge'] = deliveryCharge?.toJson();
    itemData['total_amount'] = totalAmount;
    itemData['sub_total'] = subTotal;
    itemData['tax_sub_total'] = taxSubTotal;
    itemData['saved_amount'] = savedAmount;
    itemData['shipping_fee'] = shippingFee;
    itemData['platform_fee'] = platformFee;
    itemData['cod_service_fee'] = codServicesFee;
    return itemData;
  }
}

class DeliveryCharge {
  DeliveryCharge({
    this.totalDeliveryCharge,
    this.sellersInfo,
  });

  String? totalDeliveryCharge;
  List<SellersInfo>? sellersInfo;

  DeliveryCharge.fromJson(Map<String, dynamic> json) {
    totalDeliveryCharge = json['total_delivery_charge']?.toString();
    sellersInfo = json['sellers_info'] != null
        ? List.from(json['sellers_info']).map((e) => SellersInfo.fromJson(e)).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final itemData = <String, dynamic>{};
    itemData['total_delivery_charge'] = totalDeliveryCharge;
    itemData['sellers_info'] = sellersInfo?.map((e) => e.toJson()).toList();
    return itemData;
  }
}


class SellersInfo {
  SellersInfo({
    this.sellerName,
    this.deliveryCharge,
    this.distance,
    this.duration,
  });

  String? sellerName;
  int? deliveryCharge;
  int? distance;
  int? duration;

  SellersInfo.fromJson(Map<String, dynamic> json) {
    sellerName = json['seller_name'];
    deliveryCharge = json['delivery_charge']?.toInt();
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

