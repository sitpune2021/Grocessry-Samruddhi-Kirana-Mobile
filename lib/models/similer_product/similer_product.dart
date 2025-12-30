import 'dart:convert';

/// Decode JSON string to model
SimilerProductModel similerProductModelFromJson(String str) =>
    SimilerProductModel.fromJson(json.decode(str));

/// Encode model to JSON string
String similerProductModelToJson(SimilerProductModel data) =>
    json.encode(data.toJson());

class SimilerProductModel {
  final bool status;
  final String message;
  final String productId;
  final List<SimilerProduct> data;

  const SimilerProductModel({
    required this.status,
    required this.message,
    required this.productId,
    required this.data,
  });

  factory SimilerProductModel.fromJson(Map<String, dynamic> json) {
    return SimilerProductModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      productId: json['product_id']?.toString() ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => SimilerProduct.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'product_id': productId,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class SimilerProduct {
  final int id;
  final int categoryId;
  final int subCategoryId;
  final int brandId;
  final String name;
  final dynamic expiryDays;
  final String sku;
  final String description;
  final String basePrice;
  final String retailerPrice;
  final String mrp;
  final String gstPercentage;
  final int stock;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final List<String> imageUrls;

  const SimilerProduct({
    required this.id,
    required this.categoryId,
    required this.subCategoryId,
    required this.brandId,
    required this.name,
    required this.expiryDays,
    required this.sku,
    required this.description,
    required this.basePrice,
    required this.retailerPrice,
    required this.mrp,
    required this.gstPercentage,
    required this.stock,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.imageUrls,
  });

  factory SimilerProduct.fromJson(Map<String, dynamic> json) {
    return SimilerProduct(
      id: json['id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      subCategoryId: json['sub_category_id'] ?? 0,
      brandId: json['brand_id'] ?? 0,
      name: json['name'] ?? '',
      expiryDays: json['expiry_days'],
      sku: json['sku'] ?? '',
      description: json['description'] ?? '',
      basePrice: json['base_price'] ?? '',
      retailerPrice: json['retailer_price'] ?? '',
      mrp: json['mrp'] ?? '',
      gstPercentage: json['gst_percentage'] ?? '',
      stock: json['stock'] ?? 0,
      createdAt:
          DateTime.tryParse(json['created_at'] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt:
          DateTime.tryParse(json['updated_at'] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      deletedAt: json['deleted_at'],
      imageUrls:
          (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'category_id': categoryId,
    'sub_category_id': subCategoryId,
    'brand_id': brandId,
    'name': name,
    'expiry_days': expiryDays,
    'sku': sku,
    'description': description,
    'base_price': basePrice,
    'retailer_price': retailerPrice,
    'mrp': mrp,
    'gst_percentage': gstPercentage,
    'stock': stock,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'deleted_at': deletedAt,
    'image_urls': imageUrls,
  };
}
