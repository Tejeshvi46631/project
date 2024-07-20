import 'package:egrocer/core/model/productListItem.dart';

class HomeScreenData {
  HomeScreenData({
    required this.category,
    required this.sliders,
    required this.offers,
    required this.sections,
  });

  late final List<Category> category;
  late final List<Sliders> sliders;
  late final List<Offers> offers;
  late final List<Sections> sections;
  late final List<BannerModel> topBanners;
  late final List<BannerModel> mixWithSliderBanners;

  HomeScreenData.fromJson(Map<String, dynamic> json) {
    category =
        List.from(json['category']).map((e) => Category.fromJson(e)).toList();
    sliders =
        List.from(json['sliders']).map((e) => Sliders.fromJson(e)).toList();
    offers = List.from(json['offers']).map((e) => Offers.fromJson(e)).toList();
    sections =
        List.from(json['sections']).map((e) => Sections.fromJson(e)).toList();
    topBanners =
        List.from(json['top_banners']).map((e) => BannerModel.fromJson(e)).toList();
    mixWithSliderBanners = List.from(json['mix_with_slider_banners'])
        .map((e) => BannerModel.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final itemData = <String, dynamic>{};
    itemData['category'] = category.map((e) => e.toJson()).toList();
    itemData['sliders'] = sliders.map((e) => e.toJson()).toList();
    itemData['offers'] = offers.map((e) => e.toJson()).toList();
    itemData['sections'] = sections.map((e) => e.toJson()).toList();
    return itemData;
  }
}

class Category {
  Category(
      {required this.id,
      required this.name,
      required this.subtitle,
      required this.hasChild,
      required this.imageUrl,
      required this.allActiveChilds});

  late final String id;
  late final String name;
  late final String subtitle;
  late final bool hasChild;
  late final String imageUrl;
  late final List allActiveChilds;

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    subtitle = json['subtitle'].toString();
    hasChild = json['has_active_child'];
    imageUrl = json['image_url'].toString();
    allActiveChilds = json["all_active_childs"] != null
        ? List.from(json["all_active_childs"]!.map((x) => x))
        : [];
  }

  Map<String, dynamic> toJson() {
    final itemData = <String, dynamic>{};
    itemData['id'] = id;
    itemData['name'] = name;
    itemData['subtitle'] = subtitle;
    itemData['has_active_child'] = hasChild;
    itemData['image_url'] = imageUrl;
    itemData["all_active_childs"] = itemData["all_active_childs"] != null
        ? List.from(allActiveChilds.map((x) => x))
        : [];
    return itemData;
  }
}

class Sliders {
  Sliders({
    required this.id,
    required this.type,
    required this.typeId,
    required this.sliderUrl,
    required this.typeName,
    required this.imageUrl,
  });

  late final String id;
  late final String type;
  late final String typeId;
  late final String sliderUrl;
  late final String typeName;
  late final String imageUrl;

  Sliders.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    type = json['type'].toString();
    typeId = json['type_id'].toString();
    sliderUrl = json['slider_url'].toString();
    typeName = json['type_name'].toString();
    imageUrl = json['image_url'].toString();
  }

  Map<String, dynamic> toJson() {
    final itemData = <String, dynamic>{};
    itemData['id'] = id;
    itemData['type'] = type;
    itemData['type_id'] = typeId;
    itemData['slider_url'] = sliderUrl;
    itemData['type_name'] = typeName;
    itemData['image_url'] = imageUrl;
    return itemData;
  }
}

class Offers {
  Offers({
    required this.id,
    required this.position,
    required this.sectionPosition,
    required this.imageUrl,
  });

  late final String id;
  late final String position;
  late final String sectionPosition;
  late final String imageUrl;

  Offers.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    position = json['position'].toString();
    sectionPosition = json['section_position'].toString();
    imageUrl = json['image_url'].toString();
  }

  Map<String, dynamic> toJson() {
    final itemData = <String, dynamic>{};
    itemData['id'] = id;
    itemData['position'] = position;
    itemData['section_position'] = sectionPosition;
    itemData['image_url'] = imageUrl;
    return itemData;
  }
}

class Sections {
  Sections({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.productType,
    required this.products,
  });

  late final String id;
  late final String title;
  late final String shortDescription;
  late final String productType;
  late final String categoryid;
  late final List<ProductListItem> products;

  Sections.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    title = json['title'].toString();
    shortDescription = json['short_description'].toString();
    productType = json['product_type'].toString();
    categoryid = json['category_ids'].toString();
    products = List.from(json['products'])
        .map((e) => ProductListItem.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final itemData = <String, dynamic>{};
    itemData['id'] = id;
    itemData['title'] = title;
    itemData['short_description'] = shortDescription;
    itemData['product_type'] = productType;
    itemData['products'] = products;
    return itemData;
  }
}

class ActiveChildsData {
  final int id;
  final int rowOrder;
  final String name;
  final dynamic slug;
  final String subtitle;
  final String image;
  final int status;
  final int productRating;
  final String webImage;
  final int parentId;
  final int priority;
  final String imageUrl;
  final bool hasChild;
  final bool hasActiveChild;
  final List<dynamic> allActiveChilds;

  ActiveChildsData({
    required this.id,
    required this.rowOrder,
    required this.name,
    required this.slug,
    required this.subtitle,
    required this.image,
    required this.status,
    required this.productRating,
    required this.webImage,
    required this.parentId,
    required this.priority,
    required this.imageUrl,
    required this.hasChild,
    required this.hasActiveChild,
    required this.allActiveChilds,
  });

  factory ActiveChildsData.fromJson(Map<String, dynamic> json) =>
      ActiveChildsData(
        id: json["id"],
        rowOrder: json["row_order"],
        name: json["name"],
        slug: json["slug"],
        subtitle: json["subtitle"],
        image: json["image"],
        status: json["status"],
        productRating: json["product_rating"],
        webImage: json["web_image"],
        parentId: json["parent_id"],
        priority: json["Priority"],
        imageUrl: json["image_url"],
        hasChild: json["has_child"],
        hasActiveChild: json["has_active_child"],
        allActiveChilds: json["all_active_childs"] != null
            ? List<ActiveChildsData>.from(
                json["all_active_childs"].map((x) => x))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "row_order": rowOrder,
        "name": name,
        "slug": slug,
        "subtitle": subtitle,
        "image": image,
        "status": status,
        "product_rating": productRating,
        "web_image": webImage,
        "parent_id": parentId,
        "Priority": priority,
        "image_url": imageUrl,
        "has_child": hasChild,
        "has_active_child": hasActiveChild,
        "all_active_childs": allActiveChilds != null
            ? List<ActiveChildsData>.from(allActiveChilds.map((x) => x))
            : [],
      };
}

class AllActiveChild {
  final int id;
  final int rowOrder;
  final String name;
  final dynamic slug;
  final String subtitle;
  final String image;
  final int status;
  final int productRating;
  final String webImage;
  final int parentId;
  final int priority;
  final String imageUrl;
  final bool hasChild;
  final bool hasActiveChild;
  final List<dynamic> allActiveChilds;

  AllActiveChild({
    required this.id,
    required this.rowOrder,
    required this.name,
    required this.slug,
    required this.subtitle,
    required this.image,
    required this.status,
    required this.productRating,
    required this.webImage,
    required this.parentId,
    required this.priority,
    required this.imageUrl,
    required this.hasChild,
    required this.hasActiveChild,
    required this.allActiveChilds,
  });

  factory AllActiveChild.fromJson(Map<String, dynamic> json) => AllActiveChild(
        id: json["id"],
        rowOrder: json["row_order"],
        name: json["name"],
        slug: json["slug"],
        subtitle: json["subtitle"],
        image: json["image"],
        status: json["status"],
        productRating: json["product_rating"],
        webImage: json["web_image"],
        parentId: json["parent_id"],
        priority: json["Priority"],
        imageUrl: json["image_url"],
        hasChild: json["has_child"],
        hasActiveChild: json["has_active_child"],
        allActiveChilds:
            List<dynamic>.from(json["all_active_childs"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "row_order": rowOrder,
        "name": name,
        "slug": slug,
        "subtitle": subtitle,
        "image": image,
        "status": status,
        "product_rating": productRating,
        "web_image": webImage,
        "parent_id": parentId,
        "Priority": priority,
        "image_url": imageUrl,
        "has_child": hasChild,
        "has_active_child": hasActiveChild,
        "all_active_childs": List<dynamic>.from(allActiveChilds.map((x) => x)),
      };
}

class BannerModel {
  final String alt;
  final int id;
  final String imageUrl;
  final String? navigateUrl;
  final String? type;
  BannerModel({
    required this.alt,
    required this.id,
    required this.imageUrl,
    this.navigateUrl,
    this.type,
  });

  BannerModel copyWith({
    String? alt,
    int? id,
    String? imageUrl,
    String? navigateUrl,
    String? type,
  }) {
    return BannerModel(
      alt: alt ?? this.alt,
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      navigateUrl: navigateUrl ?? this.navigateUrl,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alt': alt,
      'id': id,
      'image_url': imageUrl,
      'navigate_url': navigateUrl,
      'type': type,
    };
  }

  factory BannerModel.fromJson(Map<String, dynamic> map) {
    return BannerModel(
      alt: map['alt'] ?? '',
      id: map['id']?.toInt() ?? 0,
      imageUrl: map['image_url'] ?? '',
      navigateUrl: map['navigate_url'],
      type: map['type'],
    );
  }

  @override
  String toString() {
    return 'Banner(alt: $alt, id: $id, imageUrl: $imageUrl, navigateUrl: $navigateUrl, type: $type)';
  }
}
