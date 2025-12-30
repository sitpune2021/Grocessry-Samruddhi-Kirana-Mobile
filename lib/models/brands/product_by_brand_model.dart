import 'dart:convert';

/// Decode JSON string to model
ProductByBrandModel productByBrandModelFromJson(String str) =>
    ProductByBrandModel.fromJson(json.decode(str));

/// Encode model to JSON string
String productByBrandModelToJson(ProductByBrandModel data) =>
    json.encode(data.toJson());

class ProductByBrandModel {
  final bool status;
  final String message;
  final Brands brands;
  final List<Product> data;

  const ProductByBrandModel({
    required this.status,
    required this.message,
    required this.brands,
    required this.data,
  });

  factory ProductByBrandModel.fromJson(Map<String, dynamic> json) {
    return ProductByBrandModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      brands: Brands.fromJson(json['brand'] ?? {}),
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => Product.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'brand': brands.toJson(),
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class Brands {
  final int id;
  final String name;

  const Brands({required this.id, required this.name});

  factory Brands.fromJson(Map<String, dynamic> json) {
    return Brands(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class Product {
  final int id;
  final int brandId;
  final int categoryId;
  final String name;
  final String basePrice;
  final String retailerPrice;
  final String mrp;
  final String gstPercentage;
  final int stock;
  final List<String> imageUrls;

  const Product({
    required this.id,
    required this.brandId,
    required this.categoryId,
    required this.name,
    required this.basePrice,
    required this.retailerPrice,
    required this.mrp,
    required this.gstPercentage,
    required this.stock,
    required this.imageUrls,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      brandId: json['brand_id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      name: json['name'] ?? '',
      basePrice: json['base_price'] ?? '',
      retailerPrice: json['retailer_price'] ?? '',
      mrp: json['mrp'] ?? '',
      gstPercentage: json['gst_percentage'] ?? '',
      stock: json['stock'] ?? 0,
      imageUrls:
          (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'brand_id': brandId,
    'category_id': categoryId,
    'name': name,
    'base_price': basePrice,
    'retailer_price': retailerPrice,
    'mrp': mrp,
    'gst_percentage': gstPercentage,
    'stock': stock,
    'image_urls': imageUrls,
  };
}
