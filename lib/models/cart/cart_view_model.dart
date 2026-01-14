// To parse this JSON data, do
//
// final cartViewModel = cartViewModelFromJson(jsonString);

import 'dart:convert';

CartViewModel cartViewModelFromJson(String str) =>
    CartViewModel.fromJson(json.decode(str));

String cartViewModelToJson(CartViewModel data) => json.encode(data.toJson());

/// ================= CART VIEW MODEL =================
class CartViewModel {
  final bool status;
  final List<CartItem> data;

  CartViewModel({required this.status, required this.data});

  factory CartViewModel.fromJson(Map<String, dynamic> json) => CartViewModel(
    status: json["status"],
    data: List<CartItem>.from(json["data"].map((x) => CartItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

/// ================= CART ITEM =================
class CartItem {
  final int id;
  final int userId;
  final int productId;
  final int quantity;
  final double? price;
  final double subtotal;
  final double discount;
  final double total;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Product product;

  CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    this.price,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json["id"],
    userId: json["user_id"],
    productId: json["product_id"],
    quantity: json["quantity"],
    price: json["price"] != null
        ? double.parse(json["price"].toString())
        : null,
    subtotal: double.parse(json["subtotal"]),
    discount: double.parse(json["discount"]),
    total: double.parse(json["total"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    product: Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "product_id": productId,
    "quantity": quantity,
    "price": price,
    "subtotal": subtotal.toStringAsFixed(2),
    "discount": discount.toStringAsFixed(2),
    "total": total.toStringAsFixed(2),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "product": product.toJson(),
  };
}

/// ================= PRODUCT =================
class Product {
  final int id;
  final int warehouseId;
  final int categoryId;
  final int subCategoryId;
  final int brandId;
  final String name;
  final int? expiryDays;
  final String sku;
  final String description;
  final double basePrice;
  final double retailerPrice;
  final double mrp;
  final String? discountType;
  final double discountValue;
  final int? taxId;
  final double gstPercentage;
  final int stock;
  final List<String> productImages;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Product({
    required this.id,
    required this.warehouseId,
    required this.categoryId,
    required this.subCategoryId,
    required this.brandId,
    required this.name,
    this.expiryDays,
    required this.sku,
    required this.description,
    required this.basePrice,
    required this.retailerPrice,
    required this.mrp,
    this.discountType,
    required this.discountValue,
    this.taxId,
    required this.gstPercentage,
    required this.stock,
    required this.productImages,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    warehouseId: json["warehouse_id"],
    categoryId: json["category_id"],
    subCategoryId: json["sub_category_id"],
    brandId: json["brand_id"],
    name: json["name"],
    expiryDays: json["expiry_days"],
    sku: json["sku"],
    description: json["description"],
    basePrice: double.parse(json["base_price"]),
    retailerPrice: double.parse(json["retailer_price"]),
    mrp: double.parse(json["mrp"]),
    discountType: json["discount_type"],
    discountValue: double.parse(json["discount_value"]),
    taxId: json["tax_id"],
    gstPercentage: double.parse(json["gst_percentage"]),
    stock: json["stock"],
    productImages: List<String>.from(jsonDecode(json["product_images"])),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"] != null
        ? DateTime.parse(json["deleted_at"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "warehouse_id": warehouseId,
    "category_id": categoryId,
    "sub_category_id": subCategoryId,
    "brand_id": brandId,
    "name": name,
    "expiry_days": expiryDays,
    "sku": sku,
    "description": description,
    "base_price": basePrice.toStringAsFixed(2),
    "retailer_price": retailerPrice.toStringAsFixed(2),
    "mrp": mrp.toStringAsFixed(2),
    "discount_type": discountType,
    "discount_value": discountValue.toStringAsFixed(2),
    "tax_id": taxId,
    "gst_percentage": gstPercentage.toStringAsFixed(2),
    "stock": stock,
    "product_images": jsonEncode(productImages),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt?.toIso8601String(),
  };
}
