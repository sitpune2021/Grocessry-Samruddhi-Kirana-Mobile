import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

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
  final int quantity;
  final int maxQuantity;
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
    required this.quantity,
    required this.maxQuantity,
    required this.imageUrls,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: _toInt(json['id']),
      categoryId: _toInt(json['category_id']),
      subCategoryId: _toInt(json['sub_category_id']),
      name: json['name']?.toString() ?? '',
      basePrice: json['base_price']?.toString() ?? '0',
      retailerPrice: json['retailer_price']?.toString() ?? '0',
      mrp: json['mrp']?.toString() ?? '0',
      gstPercentage: json['gst_percentage']?.toString() ?? '0',
      stock: _toInt(json['stock']),
      quantity: _toInt(json['quantity']),
      maxQuantity: _toInt(json['max_quantity']),
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
    'quantity': quantity,
    'max_quantity': maxQuantity,
    'image_urls': imageUrls,
  };

  // 🔑 SAFE PARSER
  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }
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
