import 'dart:convert';

/// Decode JSON string to model
ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

/// Encode model to JSON string
String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  final bool status;
  final String message;
  final Subcategory subcategory;
  final List<Product> data;

  const ProductModel({
    required this.status,
    required this.message,
    required this.subcategory,
    required this.data,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      subcategory: Subcategory.fromJson(json['subcategory']),
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
    'subcategory': subcategory.toJson(),
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class Product {
  final int id;
  final int categoryId;
  final int subCategoryId;
  final String name;
  final String basePrice;
  final String retailerPrice;
  final String mrp;
  final String gstPercentage;
  final int stock;
  final List<String> imageUrls;

  const Product({
    required this.id,
    required this.categoryId,
    required this.subCategoryId,
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
      categoryId: json['category_id'] ?? 0,
      subCategoryId: json['sub_category_id'] ?? 0,
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
    'category_id': categoryId,
    'sub_category_id': subCategoryId,
    'name': name,
    'base_price': basePrice,
    'retailer_price': retailerPrice,
    'mrp': mrp,
    'gst_percentage': gstPercentage,
    'stock': stock,
    'image_urls': imageUrls,
  };
}

class Subcategory {
  final int id;
  final String name;

  const Subcategory({required this.id, required this.name});

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
