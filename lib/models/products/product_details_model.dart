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
  final int discountPercentage;
  final String discountLabel;
  final int stock;
  final int maxQuantity;
  final int quantity;
  final dynamic expiryDate;
  final List<String> images;
  final Categories category;
  final SubCategory subCategory;
  final Brand brand;

  const Data({
    required this.id,
    required this.name,
    required this.description,
    required this.sku,
    required this.pricing,
    required this.discountPercentage,
    required this.discountLabel,
    required this.stock,
    required this.maxQuantity,
    required this.quantity,
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
      discountPercentage: json['discount_percentage'] ?? 0,
      discountLabel: json['discount_label'] ?? '',
      stock: json['stock'] ?? 0,
      maxQuantity: json['max_quantity'] ?? 0,
      quantity: json['quantity'] ?? 0,
      expiryDate: json['expiry_date'],
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      category: Categories.fromJson(json['category'] ?? {}),
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
    'discount_percentage': discountPercentage,
    'discount_label': discountLabel,
    'stock': stock,
    'max_quantity': maxQuantity,
    'quantity': quantity,
    'expiry_date': expiryDate,
    'images': images,
    'category': category.toJson(),
    'sub_category': subCategory.toJson(),
    'brand': brand.toJson(),
  };
}

class Pricing {
  // final int basePrice;
  // final int retailerPrice;
  // final int finalPrice;
  // final int mrp;
  // final int gstPercentage;
  final double basePrice;
  final double retailerPrice;
  final double finalPrice;
  final double mrp;
  final double gstPercentage;

  const Pricing({
    required this.basePrice,
    required this.retailerPrice,
    required this.finalPrice,
    required this.mrp,
    required this.gstPercentage,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    // return Pricing(
    //   basePrice: json['base_price'] ?? 0,
    //   retailerPrice: json['retailer_price'] ?? 0,
    //   finalPrice: json['final_price'] ?? 0,
    //   mrp: json['mrp'] ?? 0,
    //   gstPercentage: json['gst_percentage'] ?? 0,
    // );
    return Pricing(
      basePrice: (json['base_price'] ?? 0).toDouble(),
      retailerPrice: (json['retailer_price'] ?? 0).toDouble(),
      finalPrice: (json['final_price'] ?? 0).toDouble(),
      mrp: (json['mrp'] ?? 0).toDouble(),
      gstPercentage: (json['gst_percentage'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'base_price': basePrice,
    'retailer_price': retailerPrice,
    'final_price': finalPrice,
    'mrp': mrp,
    'gst_percentage': gstPercentage,
  };
}

class Categories {
  final int id;
  final String name;

  const Categories({required this.id, required this.name});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class SubCategory {
  final int id;
  final String name;

  const SubCategory({required this.id, required this.name});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
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
