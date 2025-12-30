import 'dart:convert';

/// Decode JSON string to model
ProductDetailsModel productDetailsModelFromJson(String str) =>
    ProductDetailsModel.fromJson(json.decode(str));

/// Encode model to JSON string
String productDetailsModelToJson(ProductDetailsModel data) =>
    json.encode(data.toJson());

class ProductDetailsModel {
  final bool status;
  final String message;
  final Data data;

  const ProductDetailsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: Data.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.toJson(),
  };
}

class Data {
  final int id;
  final String name;
  final String description;
  final String sku;
  final Pricing pricing;
  final int stock;
  final dynamic expiryDate;
  final List<String> images;
  final Brand category;
  final SubCategory subCategory;
  final Brand brand;

  const Data({
    required this.id,
    required this.name,
    required this.description,
    required this.sku,
    required this.pricing,
    required this.stock,
    required this.expiryDate,
    required this.images,
    required this.category,
    required this.subCategory,
    required this.brand,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      sku: json['sku'] ?? '',
      pricing: Pricing.fromJson(json['pricing'] ?? {}),
      stock: json['stock'] ?? 0,
      expiryDate: json['expiry_date'],
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      category: Brand.fromJson(json['category'] ?? {}),
      subCategory: SubCategory.fromJson(json['sub_category'] ?? {}),
      brand: Brand.fromJson(json['brand'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'sku': sku,
    'pricing': pricing.toJson(),
    'stock': stock,
    'expiry_date': expiryDate,
    'images': images,
    'category': category.toJson(),
    'sub_category': subCategory.toJson(),
    'brand': brand.toJson(),
  };
}

class Brand {
  final int id;
  final String name;

  const Brand({required this.id, required this.name});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class Pricing {
  final String basePrice;
  final String retailerPrice;
  final String mrp;
  final String gstPercentage;

  const Pricing({
    required this.basePrice,
    required this.retailerPrice,
    required this.mrp,
    required this.gstPercentage,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      basePrice: json['base_price'] ?? '',
      retailerPrice: json['retailer_price'] ?? '',
      mrp: json['mrp'] ?? '',
      gstPercentage: json['gst_percentage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'base_price': basePrice,
    'retailer_price': retailerPrice,
    'mrp': mrp,
    'gst_percentage': gstPercentage,
  };
}

class SubCategory {
  final int id;
  final String name;
  final int categoryId;

  const SubCategory({
    required this.id,
    required this.name,
    required this.categoryId,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      categoryId: json['category_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category_id': categoryId,
  };
}
