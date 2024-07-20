class ProductListItem {
  ProductListItem({
    required this.id,
    required this.name,
    required this.taxId,
    required this.brandId,
    required this.slug,
    required this.categoryId,
    required this.indicator,
    required this.manufacturer,
    required this.madeIn,
    required this.isUnlimitedStock,
    required this.totalAllowedQuantity,
    required this.taxIncludedInPrice,
    required this.isFavorite,
    required this.variants,
    required this.imageUrl,
  });

  late final String id;
  late final String name;
  late final String taxId;
  late final String brandId;
  late final String slug;
  late final String categoryId;
  late final String indicator;
  late final String manufacturer;
  late final String madeIn;
  late final String isUnlimitedStock;
  late final String totalAllowedQuantity;
  late final String taxIncludedInPrice;
  bool? isFavorite;
  late final List<Variants> variants;
  late final String imageUrl;

  ProductListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    taxId = json['tax_id'].toString();
    brandId = json['brand_id'].toString();
    slug = json['slug'].toString();
    categoryId = json['category_id'].toString();
    indicator = json['indicator'].toString();
    manufacturer = json['manufacturer'].toString();
    madeIn = json['made_in'].toString();
    isUnlimitedStock = json['is_unlimited_stock'].toString();
    totalAllowedQuantity = json['total_allowed_quantity'].toString();
    taxIncludedInPrice = json['tax_included_in_price'].toString();
    isFavorite = json['is_favorite'] ?? false;
    variants =
        List.from(json['variants']).map((e) => Variants.fromJson(e)).toList();
    imageUrl = json['image_url'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['tax_id'] = taxId;
    data['brand_id'] = brandId;
    data['slug'] = slug;
    data['category_id'] = categoryId;
    data['indicator'] = indicator;
    data['manufacturer'] = manufacturer;
    data['made_in'] = madeIn;
    data['is_unlimited_stock'] = isUnlimitedStock;
    data['total_allowed_quantity'] = totalAllowedQuantity;
    data['tax_included_in_price'] = taxIncludedInPrice;
    data['is_favorite'] = isFavorite;
    data['variants'] = variants.map((e) => e.toJson()).toList();
    data['image_url'] = imageUrl;
    return data;
  }
}

class Variants {
  Variants({
    required this.id,
    required this.type,
    required this.measurement,
    required this.price,
    required this.discountedPrice,
    required this.stock,
    required this.stockUnitName,
    required this.cartCount,
    required this.status,
    required this.taxableAmount,
  });

  late final String id;
  late final String type;
  late final String measurement;
  late final String price;
  late final String discountedPrice;
  late final String stock;
  late final String stockUnitName;
  late final String cartCount;
  late final String status;
  late final String taxableAmount;

  Variants.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    type = json['type'].toString();
    measurement = json['measurement'].toString();
    price = json['price'].toString();
    discountedPrice = json['discounted_price'].toString();
    stock = json['stock'].toString();
    stockUnitName = json['stock_unit_name'].toString();
    cartCount = json['cart_count'].toString();
    status = json['status'].toString();
    taxableAmount = json['taxable_amount'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['measurement'] = measurement;
    data['price'] = price;
    data['discounted_price'] = discountedPrice;
    data['stock'] = stock;
    data['stock_unit_name'] = stockUnitName;
    data['cart_count'] = cartCount;
    data['status'] = status;
    data['taxable_amount'] = taxableAmount;
    return data;
  }
}
