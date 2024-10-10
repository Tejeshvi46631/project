class Order {
  Order({
    required this.id,
    required this.userId,
    required this.transactionId,
    required this.otp,
    required this.mobile,
    required this.orderNote,
    required this.total,
    required this.deliveryCharge,
    this.codServicesFee,
    required this.taxAmount,
    required this.taxPercentage,
    required this.walletBalance,
    required this.discount,
    required this.promoCode,
    required this.promoDiscount,
    required this.finalTotal,
    required this.paymentMethod,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.deliveryTime,
    required this.activeStatus,
    required this.orderFrom,
    required this.pincodeId,
    required this.addressId,
    required this.areaId,
    required this.bankTransferMessage,
    required this.bankTransferStatus,
    required this.userName,
    required this.discountRupees,
    required this.items,
    required this.createdAt,
    required this.status,
    required this.orderStatus,
    required this.shippedStatus,
    required this.shippedItems,
    required this.itemsCount, // New Field
    required this.user, // New Field
  });

  late final String id;
  late final List<List> status;
  late final String userId;
  late final String transactionId;
  late final String otp;
  late final String mobile;
  late final String orderNote;
  late final String total;
  late final String deliveryCharge;
  String? codServicesFee;
  late final String taxAmount;
  late final String taxPercentage;
  late final String walletBalance;
  late final String discount;
  late final String promoCode;
  late final String promoDiscount;
  late final String finalTotal;
  late final String paymentMethod;
  late final Address address; // Updated Field
  late final String latitude; // Consider removing if redundant with Address
  late final String longitude; // Consider removing if redundant with Address
  late final String deliveryTime;
  late final String activeStatus;
  late final String orderFrom;
  late final String pincodeId;
  late final String addressId;
  late final String areaId;
  late final String bankTransferMessage;
  late final String bankTransferStatus;
  late final String userName;
  late final String discountRupees;
  late final String createdAt;
  late final List<OrderItem> items;

  // New Fields
  late final String orderStatus;
  late final String shippedStatus;
  late final List<ShippedItem> shippedItems;
  late final int itemsCount; // New Field
  late final User user; // New Field

  Order copyWith({
    List<OrderItem>? orderItems,
    String? updatedActiveStatus,
    String? updatedOrderStatus,
    String? updatedShippedStatus,
    List<ShippedItem>? updatedShippedItems,
    int? updatedItemsCount, // New Field
    User? updatedUser, // New Field
  }) {
    return Order(
      id: id,
      userId: userId,
      transactionId: transactionId,
      otp: otp,
      mobile: mobile,
      orderNote: orderNote,
      total: total,
      deliveryCharge: deliveryCharge,
      codServicesFee: codServicesFee,
      taxAmount: taxAmount,
      taxPercentage: taxPercentage,
      walletBalance: walletBalance,
      discount: discount,
      promoCode: promoCode,
      promoDiscount: promoDiscount,
      finalTotal: finalTotal,
      paymentMethod: paymentMethod,
      address: address, // Assuming Address is immutable
      latitude: latitude,
      longitude: longitude,
      deliveryTime: deliveryTime,
      activeStatus: updatedActiveStatus ?? activeStatus,
      orderFrom: orderFrom,
      pincodeId: pincodeId,
      addressId: addressId,
      areaId: areaId,
      bankTransferMessage: bankTransferMessage,
      bankTransferStatus: bankTransferStatus,
      userName: userName,
      discountRupees: discountRupees,
      items: orderItems ?? items,
      createdAt: createdAt,
      status: status,
      orderStatus: updatedOrderStatus ?? orderStatus,
      shippedStatus: updatedShippedStatus ?? shippedStatus,
      shippedItems: updatedShippedItems ?? shippedItems,
      itemsCount: updatedItemsCount ?? itemsCount, // New Field
      user: updatedUser ?? user, // New Field
    );
  }

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    createdAt = json['created_at'].toString();
    userId = json['user_id'].toString();
    transactionId = json['transaction_id']?.toString() ?? '';
    otp = json['otp']?.toString() ?? '';
    mobile = json['mobile']?.toString() ?? '';
    orderNote = json['order_note']?.toString() ?? '';
    total = json['total']?.toString() ?? '0';
    deliveryCharge = json['delivery_charge']?.toString() ?? '0';
    codServicesFee = json['cod_service_fee']?.toString();
    taxAmount = json['tax_amount']?.toString() ?? '0';
    taxPercentage = json['tax_percentage']?.toString() ?? '0';
    walletBalance = json['wallet_balance']?.toString() ?? '0';
    discount = json['discount']?.toString() ?? '0';
    promoCode = json['promo_code']?.toString() ?? '';
    promoDiscount = json['promo_discount']?.toString() ?? '0';
    finalTotal = json['final_total']?.toString() ?? '0';
    paymentMethod = json['payment_method']?.toString() ?? '';

    // Parse Address Object
    address = Address.fromJson(json['address'] ?? {});

    // If you decide to keep latitude and longitude separate
    // latitude = json['latitude']?.toString() ?? '0';
    // longitude = json['longitude']?.toString() ?? '0';

    deliveryTime = json['delivery_time']?.toString() ?? '';
    activeStatus = json['active_status']?.toString() ?? '';
    orderFrom = json['order_from']?.toString() ?? '';
    pincodeId = json['pincode_id']?.toString() ?? '';
    addressId = json['address_id']?.toString() ?? '';
    areaId = json['area_id']?.toString() ?? '';
    bankTransferMessage = json['bank_transfer_message']?.toString() ?? '';
    bankTransferStatus = json['bank_transfer_status']?.toString() ?? '';
    userName = json['user_name']?.toString() ?? '';
    discountRupees = json['discount_rupees']?.toString() ?? '';

    // New Fields from JSON
    orderStatus = json['order_status']?.toString() ?? '';
    shippedStatus = json['shipped_status']?.toString() ?? '';
    shippedItems = ((json['shipped_items'] ?? []) as List)
        .map((item) => ShippedItem.fromJson(item))
        .toList();

    status = ((json['status'] ?? []) as List)
        .map((orderStatus) => List.from(orderStatus))
        .toList();

    items = ((json['items'] ?? []) as List)
        .map((orderItem) => OrderItem.fromJson(Map<String, dynamic>.from(orderItem)))
        .toList();

    // New Fields Parsing
    itemsCount = json['items_count'] ?? 0;
    user = User.fromJson(json['user'] ?? {});
  }
}

class Address {
  Address({
    required this.id,
    required this.type,
    required this.name,
    required this.mobile,
    required this.alternateMobile,
    required this.address,
    required this.landmark,
    required this.area,
    required this.pincode,
    required this.cityId,
    required this.city,
    required this.state,
    required this.country,
    required this.isDefault,
    required this.latitude,
    required this.longitude,
  });

  final int id;
  final String type;
  final String name;
  final String mobile;
  final String alternateMobile;
  final String address;
  final String landmark;
  final String area;
  final String pincode;
  final String cityId;
  final String city;
  final String state;
  final String country;
  final bool isDefault;
  final String latitude;
  final String longitude;

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      alternateMobile: json['alternate_mobile'] ?? '',
      address: json['address'] ?? '',
      landmark: json['landmark'] ?? '',
      area: json['area'] ?? '',
      pincode: json['pincode'] ?? '',
      cityId: json['city_id'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      isDefault: json['is_default'] == 1,
      latitude: json['latitude'] ?? '0',
      longitude: json['longitude'] ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'mobile': mobile,
      'alternate_mobile': alternateMobile,
      'address': address,
      'landmark': landmark,
      'area': area,
      'pincode': pincode,
      'city_id': cityId,
      'city': city,
      'state': state,
      'country': country,
      'is_default': isDefault ? 1 : 0,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}


class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
  });

  final int id;
  final String name;
  final String email;
  final String mobile;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
    };
  }
}


// Define the ShippedItem class based on the structure of shipped_items in JSON
class ShippedItem {
  ShippedItem({
    required this.id,
    required this.userId,
    required this.orderId,
    required this.trackingId,
    required this.orderSource,
    required this.orderStatus,
    required this.order,
  });

  final int id;
  final int userId;
  final int orderId;
  final String trackingId;
  final String orderSource;
  final String orderStatus;
  final List<OrderItem> order;

  factory ShippedItem.fromJson(Map<String, dynamic> json) {
    return ShippedItem(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      trackingId: json['tracking_id'] ?? '',
      orderSource: json['order_source'] ?? '',
      orderStatus: json['order_status'] ?? '',
      order: (json['order'] as List<dynamic>? ?? [])
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}


class OrderItem {
  OrderItem({
    this.id,
    this.userId,
    this.orderId,
    this.productName,
    this.variantName,
    this.productVariantId,
    this.quantity,
    this.price,
    this.discountedPrice,
    this.taxAmount,
    this.discount,
    this.subTotal,
    this.orderStatus,
    this.status,
    this.activeStatus,
    this.sellerId,
    this.variantId,
    this.name,
    this.manufacturer,
    this.madeIn,
    this.measurement,
    this.unit,
    this.imageUrl,
    this.cancelStatus,
    this.returnStatus,
    this.sellerName,
    this.tillStatus,
    this.trackingId,
    this.product,
  });

  int? id;
  int? userId;
  int? orderId;
  String? productName;
  String? variantName;
  int? productVariantId;
  int? quantity;
  int? price;
  int? discountedPrice;
  double? taxAmount;
  int? discount;
  double? subTotal;
  String? orderStatus;
  String? status;
  String? activeStatus;
  int? sellerId;
  int? variantId;
  String? name;
  String? manufacturer;
  String? madeIn;
  String? measurement;
  Unit? unit;
  String? imageUrl;
  String? cancelStatus;
  String? returnStatus;
  String? sellerName;
  String? tillStatus;
  String? trackingId;
  Product? product;

  OrderItem updateStatus(String itemActiveStatus) {
    return OrderItem(
      id: id,
      userId: userId,
      orderId: orderId,
      productName: productName,
      variantName: variantName,
      productVariantId: productVariantId,
      quantity: quantity,
      price: price,
      discountedPrice: discountedPrice,
      taxAmount: taxAmount,
      discount: discount,
      subTotal: subTotal,
      orderStatus: orderStatus,
      status: status,
      activeStatus: itemActiveStatus,
      sellerId: sellerId,
      variantId: variantId,
      name: name,
      manufacturer: manufacturer,
      madeIn: madeIn,
      measurement: measurement,
      unit: unit,
      imageUrl: imageUrl,
      cancelStatus: cancelStatus,
      returnStatus: returnStatus,
      sellerName: sellerName,
      tillStatus: tillStatus,
      trackingId: trackingId,
      product: product,
    );
  }

  OrderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderId = json['order_id'];
    productName = json['product_name'];
    variantName = json['variant_name'];
    productVariantId = json['product_variant_id'];
    quantity = json['quantity'];
    price = json['price'];
    discountedPrice = json['discounted_price'];
    taxAmount = (json['tax_amount'] as num?)?.toDouble();
    discount = json['discount'];
    subTotal = (json['sub_total'] as num?)?.toDouble();
    orderStatus = json['order_status'];
    status = json['status'];
    activeStatus = json['active_status'];
    sellerId = json['seller_id'];
    variantId = json['variant_id'];
    name = json['name'];
    manufacturer = json['manufacturer'];
    madeIn = json['made_in'];
    measurement = json['measurement'];
    unit = Unit.fromJson(json['unit'] ?? {});
    imageUrl = json['image_url'];
    cancelStatus = json['cancelable_status'];
    returnStatus = json['return_status'];
    tillStatus = json['till_status'];
    sellerName = json['seller_name'];
    trackingId = json['tracking_id'];
    product= Product.fromJson(json['product'] ?? {});
  }
}

class Product {
  Product({
    required this.name,
    required this.categoryId,
    required this.image,
    this.otherImages,
    required this.codAllowed,
    required this.totalAllowedQuantity,
    required this.taxIncludedInPrice,
    required this.laravelThroughKey,
    required this.imageUrl,
  });

  late final String name;
  late final int categoryId;
  late final String image;
  late final dynamic otherImages; // Adjust the type based on actual data
  late final int codAllowed;
  late final int totalAllowedQuantity;
  late final int taxIncludedInPrice;
  late final int laravelThroughKey;
  late final String imageUrl;

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    categoryId = json['category_id'] ?? 0;
    image = json['image'] ?? '';
    otherImages = json['other_images'];
    codAllowed = json['cod_allowed'] ?? 0;
    totalAllowedQuantity = json['total_allowed_quantity'] ?? 0;
    taxIncludedInPrice = json['tax_included_in_price'] ?? 0;
    laravelThroughKey = json['laravel_through_key'] ?? 0;
    imageUrl = json['image_url'] ?? '';
  }
}

class Unit {
  Unit({
    required this.name,
    required this.laravelThroughKey,
  });

  final String name;
  final int laravelThroughKey;

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      name: json['name'] ?? '',
      laravelThroughKey: json['laravel_through_key'] ?? 0,
    );
  }
}


