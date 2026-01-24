import 'dart:convert';

ViewCartModel viewCartModelFromJson(String str) =>
    ViewCartModel.fromJson(json.decode(str));

class ViewCartModel {
  final bool status;
  final Data? data;

  ViewCartModel({required this.status, required this.data});

  factory ViewCartModel.fromJson(Map<String, dynamic> json) {
    return ViewCartModel(
      status: json["status"] ?? false,
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }
}

// ================= DATA =================
class Data {
  final int id;
  final int userId;
  final int? productId;
  final int quantity;
  final String? price;
  final String subtotal;
  final String taxTotal;
  final String discount;
  final String total;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Item> items;

  Data({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.taxTotal,
    required this.discount,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? 0,
      productId: json["product_id"],
      quantity: json["quantity"] ?? 0,
      price: json["price"]?.toString(),
      subtotal: json["subtotal"]?.toString() ?? "0",
      taxTotal: json["tax_total"]?.toString() ?? "0",
      discount: json["discount"]?.toString() ?? "0",
      total: json["total"]?.toString() ?? "0",
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      items: json["items"] == null
          ? []
          : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    );
  }
}

// ================= ITEM =================
class Item {
  final int id;
  final int cartId;
  final int productId;
  final int? batchId;
  final int qty;
  final String price;
  final String cgstAmount;
  final String sgstAmount;
  final String taxTotal;
  final String itemTotal;
  final String? lineTotal;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CartProduct product;

  Item({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.batchId,
    required this.qty,
    required this.price,
    required this.cgstAmount,
    required this.sgstAmount,
    required this.taxTotal,
    required this.itemTotal,
    required this.lineTotal,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json["id"] ?? 0,
      cartId: json["cart_id"] ?? 0,
      productId: json["product_id"] ?? 0,
      batchId: json["batch_id"],
      qty: json["qty"] ?? 0,
      price: json["price"]?.toString() ?? "0",
      cgstAmount: json["cgst_amount"]?.toString() ?? "0",
      sgstAmount: json["sgst_amount"]?.toString() ?? "0",
      taxTotal: json["tax_total"]?.toString() ?? "0",
      itemTotal: json["item_total"]?.toString() ?? "0",
      lineTotal: json["line_total"]?.toString(),
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      product: CartProduct.fromJson(json["product"]),
    );
  }
}

// ================= PRODUCT =================
class CartProduct {
  final int id;
  final int categoryId;
  final int subCategoryId;
  final int brandId;
  final int unitId;
  final String unitValue;
  final String name;
  final String sku;
  final String description;
  final String basePrice;
  final String retailerPrice;
  final String mrp;
  final String gstPercentage;
  final String gstAmount;
  final String finalPrice;
  final int stock;
  final List<String> productImages;
  final List<String> productImageUrls;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final Tax tax;

  CartProduct({
    required this.id,
    required this.categoryId,
    required this.subCategoryId,
    required this.brandId,
    required this.unitId,
    required this.unitValue,
    required this.name,
    required this.sku,
    required this.description,
    required this.basePrice,
    required this.retailerPrice,
    required this.mrp,
    required this.gstPercentage,
    required this.gstAmount,
    required this.finalPrice,
    required this.stock,
    required this.productImages,
    required this.productImageUrls,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.tax,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      id: json["id"] ?? 0,
      categoryId: json["category_id"] ?? 0,
      subCategoryId: json["sub_category_id"] ?? 0,
      brandId: json["brand_id"] ?? 0,
      unitId: json["unit_id"] ?? 0,
      unitValue: json["unit_value"]?.toString() ?? "",
      name: json["name"] ?? "",
      sku: json["sku"] ?? "",
      description: json["description"] ?? "",
      basePrice: json["base_price"]?.toString() ?? "0",
      retailerPrice: json["retailer_price"]?.toString() ?? "0",
      mrp: json["mrp"]?.toString() ?? "0",
      gstPercentage: json["gst_percentage"]?.toString() ?? "0",
      gstAmount: json["gst_amount"]?.toString() ?? "0",
      finalPrice: json["final_price"]?.toString() ?? "0",
      stock: json["stock"] ?? 0,
      productImages: json["product_images"] == null
          ? []
          : List<String>.from(json["product_images"]),
      productImageUrls: json["product_image_urls"] == null
          ? []
          : List<String>.from(json["product_image_urls"]),
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      deletedAt: json["deleted_at"],
      tax: Tax.fromJson(json["tax"]),
    );
  }
}

// ================= TAX =================
class Tax {
  final int id;
  final String name;
  final double cgst;
  final double sgst;
  final double igst;
  final double gst;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Tax({
    required this.id,
    required this.name,
    required this.cgst,
    required this.sgst,
    required this.igst,
    required this.gst,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tax.fromJson(Map<String, dynamic> json) {
    return Tax(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      cgst: (json["cgst"] ?? 0).toDouble(),
      sgst: (json["sgst"] ?? 0).toDouble(),
      igst: (json["igst"] ?? 0).toDouble(),
      gst: (json["gst"] ?? 0).toDouble(),
      isActive: json["is_active"] ?? false,
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }
}
