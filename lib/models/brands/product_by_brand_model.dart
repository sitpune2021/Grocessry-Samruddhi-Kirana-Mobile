import 'dart:convert';

ProductByBrandModel productByBrandModelFromJson(String str) =>
    ProductByBrandModel.fromJson(json.decode(str));

String productByBrandModelToJson(ProductByBrandModel data) =>
    json.encode(data.toJson());

class ProductByBrandModel {
  final bool status;
  final String message;
  final Brands brand;
  final List<Product> data;

  const ProductByBrandModel({
    required this.status,
    required this.message,
    required this.brand,
    required this.data,
  });

  factory ProductByBrandModel.fromJson(Map<String, dynamic> json) {
    return ProductByBrandModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      brand: Brands.fromJson(json['brand'] ?? {}),
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
    'brand': brand.toJson(),
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
  final double basePrice;
  final double retailerPrice;
  final double mrp;
  final double gstPercentage;
  final int stock;
  final int discountPercentage;
  final String discountLabel;
  final List<String> imageUrls;
  final List<String> productImageUrls;

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
    required this.discountPercentage,
    required this.discountLabel,
    required this.imageUrls,
    required this.productImageUrls,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      brandId: json['brand_id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      name: json['name'] ?? '',
      basePrice: double.parse(json['base_price'].toString()),
      retailerPrice: double.parse(json['retailer_price'].toString()),
      mrp: double.parse(json['mrp'].toString()),
      gstPercentage: double.parse(json['gst_percentage'].toString()),
      stock: json['stock'] ?? 0,
      discountPercentage: json['discount_percentage'] ?? 0,
      discountLabel: json['discount_label'] ?? '',
      imageUrls:
          (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      productImageUrls:
          (json['product_image_urls'] as List<dynamic>?)
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
    'discount_percentage': discountPercentage,
    'discount_label': discountLabel,
    'image_urls': imageUrls,
    'product_image_urls': productImageUrls,
  };
}
